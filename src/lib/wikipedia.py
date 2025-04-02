from functools import cache

import wikipediaapi as wiki

from lib.types import Article, Chunk


def get_wikipedia_article(
    title: str, langs: str | list[str] = "en", max_chunk_size: int = 2000
) -> list[Article] | None:
    """Fetch and chunk a Wikipedia article"""
    langs = [langs] if isinstance(langs, str) else langs

    page = _get_wikipedia_page(title, lang="en")
    pages: list[wiki.WikipediaPage] = [page] if page.exists() else []

    for lang in filter(lambda x: x != "en", langs):
        lang_page = page.langlinks.get(lang)
        if lang_page:
            pages.append(lang_page)

    articles = [
        Article(
            title=page.title,
            source=page.fullurl or "unknow",
            language=page.language,
            chunks=_get_chunks(page.sections),
            summary=page.summary,
        )
        for page in pages
    ]
    return articles


@cache
def _get_wikipedia_page(title: str, lang: str) -> wiki.WikipediaPage:
    w = wiki.Wikipedia(user_agent="WikiQA (merlin@example.com)", language=lang)
    page = w.page(title)
    return page


def _get_chunks(
    sections: list[wiki.WikipediaPageSection], level: int = 0
) -> list[Chunk]:
    chunks: list[Chunk] = []
    for section in sections:
        chunks.append(
            {"heading": section.title, "level": level + 1, "content": section.text}
        )
        subsections = _get_chunks(section.sections, level + 1)
        chunks.extend(subsections)
    return chunks
