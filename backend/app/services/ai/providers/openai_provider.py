import logging

from app.core.config import settings
from app.services.ai.providers.base import AIProvider, AIMessage, AIResponse

logger = logging.getLogger(__name__)


class OpenAIProvider(AIProvider):
    def __init__(self):
        self._client = None

    def _get_client(self):
        if self._client is None:
            try:
                import openai
                self._client = openai.AsyncOpenAI(api_key=settings.AI_API_KEY)
            except ImportError:
                logger.warning("openai package not installed")
                return None
        return self._client

    def is_available(self) -> bool:
        return bool(settings.AI_API_KEY and settings.AI_ENABLED)

    async def generate_response(
        self,
        messages: list[AIMessage],
        temperature: float = 0.3,
        max_tokens: int = 2000,
    ) -> AIResponse:
        client = self._get_client()
        if client is None:
            raise RuntimeError("AI provider not available")

        api_messages = [{"role": m.role, "content": m.content} for m in messages]

        response = await client.chat.completions.create(
            model=settings.AI_MODEL,
            messages=api_messages,
            temperature=temperature,
            max_tokens=min(max_tokens, settings.AI_MAX_OUTPUT_TOKENS),
        )

        choice = response.choices[0]
        usage = response.usage

        return AIResponse(
            content=choice.message.content or "",
            model=response.model,
            tokens_used=usage.total_tokens if usage else 0,
            finish_reason=choice.finish_reason or "",
        )
