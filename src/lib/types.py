from pydantic import BaseModel


class Chunk(BaseModel):
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
