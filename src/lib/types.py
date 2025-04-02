import typing as t

from pydantic import BaseModel


class Chunk(t.TypedDict):
    """Represent a section of an Article"""

    heading: str
    level: int
    content: str


class Article(BaseModel):
    """Wikipedia Article in WikiText format"""

    title: str
    source: str
    language: str
    chunks: list[Chunk]
    summary: str

    def to_json(self) -> dict:
        return self.__dict__


class QA(BaseModel):
    """Question / Answer Pair"""

    id: int
    type: str
    language: str
    article_title: str
    chunks: list[int]
    question: str
    answer: str

    def to_json(self) -> dict:
        return self.__dict__
