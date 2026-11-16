### STAGE 1: Build
FROM python:3.11-slim AS builder

WORKDIR /build

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

### STAGE 2: Runtime
FROM python:3.11-slim

LABEL maintainer="mbrhard@gmail.com"
LABEL description="Diplom Flask Application"

# Создаём non-root пользователя
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /sbin/nologin appuser

WORKDIR /app

# Копируем зависимости из builder-стадии
COPY --from=builder /install /usr/local

# Копируем приложение
COPY app.py .

# Меняем владельца на non-root
RUN chown -R appuser:appuser /app
USER appuser

# Переменные окружения по умолчанию
ENV PORT=5000 \
    APP_VERSION=unknown \
    APP_ENV=production

# Health check (Kubernetes)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

EXPOSE 5000

# Запуск через gunicorn (production WSGI-сервер)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "app:app"]
