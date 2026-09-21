FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 UV_LINK_MODE=copy
WORKDIR /app

ARG INSTALL_DEV=false

RUN pip install --no-cache-dir uv
COPY pyproject.toml ./
RUN if [ "$INSTALL_DEV" = "true" ]; then uv sync; else uv sync --no-dev; fi

COPY app ./app

EXPOSE 8000
EXPOSE 5678

HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:8000/health', timeout=2)"

CMD ["uv", "run", "--no-dev", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
