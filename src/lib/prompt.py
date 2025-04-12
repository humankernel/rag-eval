import typing as t


class Prompt(t.TypedDict):
    factual_qa_pair: str


PROMPT: t.Final[Prompt] = {
    "factual_qa_pair": (
        # What you are?
        "Your task is creating factual question-answer pairs based *strictly* and *solely* on the provided text. The question and answer must be generated in the same language as the input text. Do not use any outside knowledge or infer information not explicitly stated in the text.\n\n"
        # Rules
        "- Create ONE factual question about specific information (e.g., names, dates, lists, definitions, quantities) explicitly mentioned in the text.\n"
        "- **If the question *cannot* be answered directly from the text, output exactly 'Answer: Information not found in the provided text.'**\n"
        "- **Output Format:** Start with 'Question:', followed by the question, then 'Answer:', followed by the answer.\n"
        "- **Important:** The output must be in the same language as the input text. For example, if the input text is in Spanish, both the question and answer must be in Spanish.\n"
        # Example 1
        "--- Example 1 (Answerable) ---\n"
        "Text: The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France. It is named after the engineer Gustave Eiffel, whose company designed and built the tower from 1887 to 1889.\n\n"
        "Question: Who is the Eiffel Tower named after?\n"
        "Answer: The Eiffel Tower is named after the engineer Gustave Eiffel.\n\n"
        # Example 2
        "--- Example 2 (Answerable) ---\n"
        "Text: Photosynthesis is a process used by plants and other organisms to convert light energy into chemical energy that, through cellular respiration, can later be released to fuel the organisms' activities. This chemical energy is stored in carbohydrate molecules, such as sugars and starches.\n\n"
        "Question: What type of molecules store the chemical energy produced during photosynthesis?\n"
        "Answer: The chemical energy is stored in carbohydrate molecules, such as sugars and starches.\n\n"
        # Example 3
        "--- Example 3 (Unanswerable from text) ---\n"
        "Text: Automatic parallelization has had only limited success. Mainstream parallel programming languages remain either explicitly parallel or partially implicit.\n\n"
        "Question: What are the specific reasons for the limited success of automatic parallelization?\n"
        "Answer: Information not found in the provided text.\n\n"
        "--- Task ---\n"
        "Text: {context}\n\n"
    )
}
