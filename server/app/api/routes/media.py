from __future__ import annotations

import io
import logging
import uuid
from pathlib import Path

from fastapi import APIRouter, Depends, HTTPException, UploadFile, status

from app.api.deps import get_current_user_dep, get_settings_dep
from app.core.config import Settings
from app.models import User
from app.schemas.media import MediaUploadResponse

logger = logging.getLogger(__name__)

COMPRESS_THRESHOLD = 500 * 1024  # 500 KB

router = APIRouter(prefix="/media", tags=["media"])

ALLOWED_CONTENT_TYPES = {
    "image/jpeg",
    "image/png",
    "image/jpg",
}
ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png"}
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5 MB


@router.post("/upload", response_model=MediaUploadResponse, status_code=status.HTTP_201_CREATED)
async def upload_media(
    file: UploadFile,
    user: User = Depends(get_current_user_dep),
    settings: Settings = Depends(get_settings_dep),
):
    # --- Validate content type ---
    if file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File type '{file.content_type}' not allowed. Accepted: jpg, jpeg, png.",
        )

    # --- Validate extension ---
    original = file.filename or "upload"
    ext = Path(original).suffix.lower()
    if ext not in ALLOWED_EXTENSIONS:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"File extension '{ext}' not allowed. Accepted: .jpg, .jpeg, .png.",
        )

    # --- Read and validate size ---
    contents = await file.read()
    size = len(contents)
    if size > MAX_FILE_SIZE:
        raise HTTPException(
            status_code=status.HTTP_413_REQUEST_ENTITY_TOO_LARGE,
            detail=f"File size {size} bytes exceeds maximum of {MAX_FILE_SIZE} bytes (5 MB).",
        )
    if size == 0:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Uploaded file is empty.",
        )

    # --- Compress large images ---
    if size > COMPRESS_THRESHOLD:
        try:
            from PIL import Image

            img = Image.open(io.BytesIO(contents))
            buf = io.BytesIO()
            save_format = "JPEG" if ext in (".jpg", ".jpeg") else "PNG"
            quality = 80
            if save_format == "JPEG":
                img = img.convert("RGB")
                img.save(buf, format=save_format, quality=quality, optimize=True)
            else:
                img.save(buf, format=save_format, optimize=True)
            compressed = buf.getvalue()
            if len(compressed) < size:
                logger.info("Compressed image from %d to %d bytes", size, len(compressed))
                contents = compressed
                size = len(contents)
        except Exception:
            logger.warning("Image compression failed, saving original", exc_info=True)

    # --- Generate unique filename and save ---
    unique_name = f"{uuid.uuid4().hex}{ext}"
    media_root = Path(settings.media_root)
    media_root.mkdir(parents=True, exist_ok=True)
    dest = media_root / unique_name
    dest.write_bytes(contents)

    # Relative path for DB storage; full URL for client consumption.
    relative_path = f"{unique_name}"
    url = f"{settings.media_base_url}/{unique_name}"

    return MediaUploadResponse(
        filename=unique_name,
        path=relative_path,
        url=url,
        content_type=file.content_type or "application/octet-stream",
        size=size,
    )
