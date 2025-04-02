import json
import re
import tempfile
import typing as t

from lib.types import Chunk


def format_context(context: list[Chunk]) -> str:
    context_str = ""
    for chunk in context:
        content = chunk["content"]  # clean it
        context_str += f"Heading: {chunk['heading']} \n\n {content} \n"
    return context_str


def create_json_file(data: t.Any, prefix: str = "data_") -> str:
    with tempfile.NamedTemporaryFile(
        mode="w+", suffix=".json", prefix=prefix, delete=False, encoding="utf-8"
    ) as temp_f:
        json.dump(data, temp_f, indent=2, ensure_ascii=False)
        return temp_f.name


def parse_qa_output(llm_output: str) -> tuple[str, str] | None:
    """
    Parses the LLM output string to extract the Question and Answer.

    Args:
        llm_output: The raw string output from the Language Model.

    Returns:
        A dictionary with 'question' and 'answer' keys if parsing is successful,
        otherwise None.
    """
    # --- Regex Explanation ---
    # r"..." : Raw string to avoid issues with backslashes
    # Question: : Matches the literal "Question:" label.
    # \s* : Matches zero or more whitespace characters (spaces, tabs, newlines).
    #       Handles potential spaces/newlines after the label.
    # (.*?) : Capturing Group 1 (The Question)
    #   . : Matches any character (except newline by default)
    #   * : Matches the previous character zero or more times
    #   ? : Makes the '*' non-greedy, so it stops matching as soon
    #       as the next part of the pattern (Answer:) is found.
    # \s* : Matches whitespace between the end of the question and the Answer label.
    # Answer: : Matches the literal "Answer:" label.
    # \s* : Matches whitespace after the Answer label.
    # (.*) : Capturing Group 2 (The Answer)
    #   . : Matches any character (including newline because of re.DOTALL)
    #   * : Matches zero or more times (greedy - takes rest of the string)
    # re.IGNORECASE : Makes "Question:" and "Answer:" matching case-insensitive.
    # re.DOTALL : Makes the '.' character match newlines as well. Crucial if the
    #             question or (more likely) the answer spans multiple lines.

    if not llm_output:
        print("`llm_output` should be defined.")
        return None

    pattern = r"Question:\s*(.*?)\s*Answer:\s*(.*)"
    match = re.search(pattern, llm_output, re.IGNORECASE | re.DOTALL)

    if match:
        question = match.group(1).strip()
        answer = match.group(2).strip()
        return question, answer

    else:
        # Handle cases where the pattern wasn't found at all
        print(f"Warning: Could not parse Q/A structure from: {llm_output}")
        return None
