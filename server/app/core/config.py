from functools import lru_cache

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    app_name: str = Field("ShareGo")
    timezone: str = Field("Asia/Karachi")
    currency: str = Field("PKR")
    env: str = Field("dev")

    db_url: str = Field("sqlite:///./sharego.db")

    jwt_secret: str = Field("change_me")
    jwt_alg: str = Field("HS256")
    jwt_expire_minutes: int = Field(60)

    otp_sender_email: str = Field("no-reply@sharego.local")
    otp_smtp_host: str = Field("localhost")
    otp_smtp_port: int = Field(1025)
    otp_smtp_user: str | None = Field(None)
    otp_smtp_pass: str | None = Field(None)
    otp_resend_seconds: int = Field(30)
    otp_max_attempts: int = Field(3)
    otp_ttl_seconds: int = Field(300)

    media_root: str = Field("./media")
    media_base_url: str = Field("/media")

    minio_endpoint: str | None = Field(None)
    minio_access_key: str | None = Field(None)
    minio_secret_key: str | None = Field(None)
    minio_bucket: str | None = Field(None)
    minio_secure: bool = Field(False)

    feature_escrow_sim: bool = Field(True)
    feature_ai_readonly: bool = Field(True)


@lru_cache
def get_settings() -> Settings:
    return Settings()
