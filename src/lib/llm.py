import typing as t
from openai import OpenAI
from vllm import LLM, SamplingParams

from lib.prompt import PROMPT
from lib.utils import parse_qa_output
from settings import settings


def get_client() -> LLM | OpenAI:
    match settings.ENVIRONMENT:
        case "dev":
            model = OpenAI(api_key="API", base_url=settings.CLIENT_URL)
        case "prod":
            model = LLM(
                model=settings.LLM_MODEL,
                dtype=settings.DTYPE,
                # gpu_memory_utilization=0.95,
                task="generate",
                seed=42,
                enforce_eager=False,
                max_model_len=settings.CTX_WINDOW,
                max_num_seqs=2,
                enable_chunked_prefill=True,
            )
        case _:
            raise ValueError("env should be dev | prod")
    return model


def generate(prompt: str, llm: LLM | OpenAI, model_params: dict = {}) -> str:
    assert prompt, "A prompt must be provided!"
    assert len(prompt) // 4 < settings.CTX_WINDOW, "Prompt too large!!"

    match settings.ENVIRONMENT:
        case "prod":
            assert isinstance(llm, LLM), "LLM should be an instance of LLM class"
            sampling_params = SamplingParams(
                max_tokens=model_params.get("max_tokens", 100),
                temperature=model_params.get("temperature", 0.25),
                top_p=model_params.get("top_p", 0.95),
                frequency_penalty=model_params.get("frequency_penalty", 0.5),
                presence_penalty=model_params.get("presence_penalty", 1.2),
                repetition_penalty=model_params.get("repetition_penalty", 1.2),
                stop=["\nQuestion:", "\n\n", "---"],
            )
            outputs = llm.generate(prompt, sampling_params)
            return outputs[0].outputs[0].text
        case "dev":
            assert isinstance(llm, OpenAI), "LLM should be and instance of OpenAI class"
            params = {
                "max_tokens": model_params.get("max_tokens", 100),
                "temperature": model_params.get("temperature", 0.25),
                "top_p": model_params.get("top_p", 0.95),
                "frequency_penalty": model_params.get("frequency_penalty", 0.5),
                "presence_penalty": model_params.get("presence_penalty", 1.2),
                "stop": ["\nQuestion:", "\n\n", "---"],
            }
            response = llm.completions.create(
                model=settings.LLM_MODEL,
                prompt=prompt,
                **params,
            )
            return response.choices[0].text
        case _:
            raise ValueError("Correctly configure the env to be dev | prod")


llm = get_client()


def generate_qa(
    type_q: t.Literal["factual", "multihop"], context: str
) -> tuple[str, str] | None:
    match type_q:
        case "factual":
            prompt = PROMPT["factual_qa_pair"].format(context=context)

    qa_output = generate(prompt=prompt, llm=llm)
    return parse_qa_output(qa_output)
