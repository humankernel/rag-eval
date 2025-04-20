import wikipediaapi as wiki

from lib.types import Article, Chunk
from lib.utils import clean_text, split_text

wk = wiki.Wikipedia(user_agent="WikiQA (merlin@example.com)", language="en")


def get_wikipedia_article(
    title: str, langs: str | list[str] = "en", max_chunk_size: int = 2000
) -> list[Article]:
    """Fetch and chunk a Wikipedia article"""
    langs = [langs] if isinstance(langs, str) else langs

    # Theres only needed to fetch the en version
    page = wk.page(title)
    pages = [page] if page.exists() else []

    for lang in filter(lambda x: x != "en", langs):
        lang_page = page.langlinks.get(lang)
        if lang_page:
            pages.append(lang_page)

    return [
        Article(
            title=page.title,
            source=page.fullurl or "unknow",
            language=page.language,
            chunks=_get_chunks(page.sections, max_chunk_size),
            summary=clean_text(page.summary),
        )
        for page in pages
    ]


def _get_chunks(
    sections: list[wiki.WikipediaPageSection],
    max_chunk_size: int = 300,
    level: int = 0,
) -> list[Chunk]:
    chunks: list[Chunk] = []
    for section in sections:
        cleaned_text = clean_text(section.text)
        if len(cleaned_text) == 0:
            continue
        if len(cleaned_text) > max_chunk_size:
            chunk_parts = split_text(cleaned_text, max_chunk_size)
            for part in chunk_parts:
                chunks.append({
                    "heading": section.title,
                    "level": level + 1,
                    "content": part,
                })
        else:
            chunks.append({
                "heading": section.title,
                "level": level + 1,
                "content": cleaned_text,
            })
        subsections = _get_chunks(section.sections, level + 1)
        chunks.extend(subsections)
    return chunks
