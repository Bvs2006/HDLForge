import os

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    PROJECT_NAME: str = "HDLForge"
    API_V1_PREFIX: str = "/api"
    DEBUG: bool = False

    POSTGRES_USER: str = "hdlforge"
    POSTGRES_PASSWORD: str = "hdlforge"
    POSTGRES_HOST: str = "localhost"
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = "hdlforge"

    DATABASE_URL: str = ""

    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    HDL_EXECUTION_TIMEOUT: int = 5
    HDL_MEMORY_LIMIT: int = 256
    HDL_CPU_LIMIT: int = 5
    HDL_PROCESS_LIMIT: int = 64
    HDL_MAX_SOURCE_SIZE: int = 50000
    HDL_MAX_OUTPUT_SIZE: int = 100000
    HDL_MAX_WAVEFORM_SIZE: int = 5242880
    HDL_WAVEFORM_RETENTION_HOURS: int = 24
    HDL_USE_DOCKER: bool = True

    JWT_SECRET: str = "hdlforge-dev-secret-change-in-production"
    JWT_EXPIRY_HOURS: int = 72

    AI_ENABLED: bool = False
    AI_PROVIDER: str = "openai"
    AI_MODEL: str = "gpt-4o-mini"
    AI_API_KEY: str = ""
    AI_MAX_INPUT_TOKENS: int = 4000
    AI_MAX_OUTPUT_TOKENS: int = 2000
    AI_RATE_LIMIT_PER_HOUR: int = 30
    AI_RATE_LIMIT_PER_MINUTE: int = 5

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}

    def get_database_url(self) -> str:
        if self.DATABASE_URL:
            return self.DATABASE_URL
        return (
            f"postgresql://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}"
            f"@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"
        )


settings = Settings()
