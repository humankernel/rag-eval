import re
from urllib.parse import quote

import requests

from lib.types import Article, Chunk


class WikipediaProcessor:
    def __init__(self):
        self.headers = {"User-Agent": "WikiProcessor/1.0"}
        self.base_params = {
            "format": "json",
            "action": "query",
            "prop": "revisions",
            "rvprop": "content"
        }

    def get_article(
        self, topic: str, lang: str, max_chunk_chars: int = 2000
    ) -> Article | None:
        """Fetch and chunk a Wikipedia article in JSON format"""
        # First get the English page ID to find interlanguage links
        en_page_id = self._get_page_id(topic, "en")
        if not en_page_id:
            return None

        # Get the translated title for the target language
        translated_title = self._get_lang_link(en_page_id, lang)
        if not translated_title:
            return None

        # Now use the translated title to get content in target language
        page_id = self._get_page_id(translated_title, lang)
        if not page_id:
            return None

        content = self._get_page_content(page_id, lang)
        if not content:
            return None

        sections = self._parse_sections(content)
        chunks = self._process_sections(sections, max_chunk_chars)

        return Article(
            title=self._get_page_title(page_id, lang) or "Unknown Title",
            source=f"https://{lang}.wikipedia.org/wiki/{quote(translated_title.replace(' ', '_'))}",
            language=lang,
            chunks=chunks,
        )

    def _get_page_id(self, topic: str, lang: str) -> int | None:
        """Get page ID from search"""
        params = {**self.base_params, "list": "search", "srsearch": topic, "srlimit": 1}
        try:
            response = requests.get(
                f"https://{lang}.wikipedia.org/w/api.php",
                params=params,
                headers=self.headers,
                timeout=5,
            )
            data = response.json()
            return data["query"]["search"][0]["pageid"]
        except (KeyError, IndexError, requests.RequestException):
            return None

    def _get_lang_link(self, source_page_id: int, target_lang: str) -> str | None:
        """Get the article title in target language using English page ID"""
        params = {
            "format": "json",
            "action": "query",
            "prop": "langlinks",
            "pageids": source_page_id,
            "lllang": target_lang,
            "lllimit": 1,
        }
        try:
            response = requests.get(
                "https://en.wikipedia.org/w/api.php",
                params=params,
                headers=self.headers,
                timeout=5,
            )
            data = response.json()
            langlinks = data["query"]["pages"][str(source_page_id)].get("langlinks", [])
            return langlinks[0]["*"] if langlinks else None
        except (KeyError, IndexError, requests.RequestException):
            return None

    def _get_page_content(self, page_id: int, lang: str) -> str | None:
        """Get raw wikitext content"""
        params = {
            **self.base_params,
            "pageids": page_id,
            "rvprop": "content",
            "rvslots": "main",
        }
        try:
            response = requests.get(
                f"https://{lang}.wikipedia.org/w/api.php",
                params=params,
                headers=self.headers,
                timeout=5,
            )
            data = response.json()
            return data["query"]["pages"][str(page_id)]["revisions"][0]["slots"][
                "main"
            ]["*"]
        except (KeyError, requests.RequestException):
            return None

    def _get_page_title(self, page_id: int, lang: str) -> str | None:
        """Get final page title"""
        params = {**self.base_params, "pageids": page_id, "prop": "info"}
        try:
            response = requests.get(
                f"https://{lang}.wikipedia.org/w/api.php",
                params=params,
                headers=self.headers,
            )
            data = response.json()
            return data["query"]["pages"][str(page_id)]["title"]
        except (KeyError, requests.RequestException):
            return None

    def _parse_sections(self, content: str) -> list[Chunk]:
        """Parse wikitext into structured sections with cleaned content"""
        sections = []
        current_section = None
        header_pattern = re.compile(r"^(=+)(.*?)\1$")  # Proper header detection

        for line in content.split("\n"):
            # Clean wikitext markup
            clean_line = re.sub(r"\{\{.*?\}\}", "", line)  # Remove templates
            clean_line = re.sub(
                r"\[\[(?:[^|\]]*\|)?([^\]]+)\]\]", r"\1", clean_line
            )  # Links
            clean_line = re.sub(r"'''''?(.*?)'''''?", r"\1", clean_line)  # Bold/italic
            clean_line = re.sub(r"<[^>]+>", "", clean_line)  # HTML tags
            clean_line = re.sub(r"^\s*[\*#;:]+", "", clean_line)  # List markers
            clean_line = clean_line.strip()

            # Skip empty lines after cleaning
            if not clean_line:
                continue

            # Detect section headers
            header_match = header_pattern.match(clean_line)
            if header_match:
                if current_section:  # Add previous section
                    sections.append(current_section)

                level = len(header_match.group(1)) - 1  # ==Header== → level 1
                heading = header_match.group(2).strip()
                current_section = {
                    "heading": heading,
                    "level": max(level, 1),  # Ensure minimum level 1
                    "content": [],
                }
            else:
                if not current_section:  # Handle content before first header
                    current_section = {
                        "heading": "Introduction",
                        "level": 1,
                        "content": [],
                    }
                current_section["content"].append(clean_line)

        # Add the final section
        if current_section and current_section["content"]:
            sections.append(current_section)

        return sections

    def _process_sections(self, sections: list, max_chars: int) -> list[Chunk]:
        """Process sections into chunks with size limits, creating multiple chunks per section if needed"""
        chunks = []
        for section in sections:
            if not section["content"]:
                continue

            # Join the content and split into parts
            full_text = "\n".join(section["content"])
            content_parts = self._split_text(full_text, max_chars)

            # Create a separate chunk for each content part
            for part in content_parts:
                chunks.append(
                    Chunk(
                        heading=section["heading"], level=section["level"], content=part
                    )
                )

        return chunks

    def _split_text(self, text: str, max_chars: int) -> list[str]:
        """Split text into chunks with maximum size, using iterative approach"""
        chunks = []
        remaining = text

        while len(remaining) > 0:
            # Try to find a natural split point first
            if len(remaining) <= max_chars:
                chunks.append(remaining)
                break

            # Look for last paragraph break within limit
            para_split = remaining.rfind("\n\n", 0, max_chars)
            if para_split != -1:
                chunk = remaining[:para_split].strip()
                remaining = remaining[para_split + 2 :].lstrip()
                chunks.append(chunk)
                continue

            # Look for last sentence boundary within limit
            sentence_split = max(
                (
                    match.end()
                    for match in re.finditer(r"[.!?] +", remaining[:max_chars])
                ),
                default=-1,
            )
            if sentence_split != -1:
                chunk = remaining[:sentence_split].strip()
                remaining = remaining[sentence_split:].lstrip()
                chunks.append(chunk)
                continue

            # Force split at max_chars if no natural break found
            chunk = remaining[:max_chars].strip()
            remaining = remaining[max_chars:].lstrip()
            chunks.append(chunk)

        return chunks


# processor = WikipediaProcessor()
# article = processor.get_article("Prime Numbers", "es", 1500)
# print(article)
