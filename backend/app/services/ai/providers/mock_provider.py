from app.services.ai.providers.base import AIProvider, AIMessage, AIResponse


class MockAIProvider(AIProvider):
    def __init__(self, response_text: str = "AI analysis complete."):
        self._response = response_text
        self._call_count = 0
        self._last_messages: list[AIMessage] = []

    def is_available(self) -> bool:
        return True

    async def generate_response(
        self,
        messages: list[AIMessage],
        temperature: float = 0.3,
        max_tokens: int = 2000,
    ) -> AIResponse:
        self._call_count += 1
        self._last_messages = messages
        return AIResponse(
            content=self._response,
            model="mock-model",
            tokens_used=100,
            finish_reason="stop",
        )
