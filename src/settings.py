import os
from typing import Literal

import torch
from dotenv import load_dotenv
from pydantic import BaseModel, computed_field

load_dotenv()


class Settings(BaseModel):
    LLM_MODEL: str = os.getenv("LLM_MODEL", "deepseek-ai/DeepSeek-R1-Distill-Qwen-7B")
    DTYPE: str = os.getenv("DTYPE", "float16")
    CTX_WINDOW: int = 2048
    TORCH_DEVICE: Literal["cuda", "cpu"] | None = None
    ENVIRONMENT: str | Literal["dev", "prod"] = os.getenv("ENVIRONMENT", "prod")
    CLIENT_URL: str = os.getenv("CLIENT_URL", "http://localhost:8000/v1")

    @computed_field
    @property
    def DEVICE(self) -> Literal["cuda", "cpu"]:
        if self.TORCH_DEVICE:
            return self.TORCH_DEVICE
        if torch.cuda.is_available():
            return "cuda"
        return "cpu"


settings = Settings()
