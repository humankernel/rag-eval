from typing import Final, TypedDict


class Prompt(TypedDict):
    factual_qa_pair: str


PROMPT: Final[Prompt] = {
    "factual_qa_pair": (
        "Generate one factual question and answer in the text's language.\n"
        "Use only information from this text:\n"
        "{context}\n\n"
    )
}
