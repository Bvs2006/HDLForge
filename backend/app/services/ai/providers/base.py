from abc import ABC, abstractmethod
from dataclasses import dataclass, field


@dataclass
class AIMessage:
    role: str
    content: str


@dataclass
class AIResponse:
    content: str
    model: str = ""
    tokens_used: int = 0
    finish_reason: str = ""


class AIProvider(ABC):
    @abstractmethod
    async def generate_response(
        self,
        messages: list[AIMessage],
        temperature: float = 0.3,
        max_tokens: int = 2000,
    ) -> AIResponse:
        ...

    @abstractmethod
    def is_available(self) -> bool:
        ...
