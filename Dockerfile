FROM python:3.9-alpine

# Define build arguments with default values
ARG DEV=True

# Set environment variable to ensure logs are immediately written to standard output
# Add python venv to PATH environment
ENV PYTHONUNBUFFERED=1 \
    PATH="/py/bin:$PATH" \
    DEV=${DEV}

WORKDIR /app

# Install system dependencies first to leverage Docker cache
RUN apk add --no-cache \
    bash \
    jpeg-dev \
    zlib-dev \
    freetype-dev \
    lcms2-dev \
    openjpeg-dev \
    tiff-dev \
    harfbuzz-dev \
    fribidi-dev \
    libimagequant-dev \
    libxcb-dev

# Install build dependencies, create venv, and install Python dependencies
COPY ./requirements.txt /tmp/requirements.txt
RUN apk add --no-cache --virtual .build-deps build-base && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" != "True" ]; then \
        /py/bin/pip install gunicorn==20.1.0; \
    fi && \
    rm -rf /tmp/* && \
    apk del .build-deps

# Copy application code and entrypoint script after installing dependencies
COPY ./babyshop_app /app
COPY ./entrypoint.sh /entrypoint.sh

RUN adduser -D appuser && \
    mkdir -p /vol/web/static /vol/web/media /database && \
    chown -R appuser:appuser /vol /app /database && \
    chmod -R 755 /vol /database && \
    chmod +x /entrypoint.sh

# Expose the port that the app runs on
EXPOSE 8000

# Switch to the non-root user
USER appuser

# Start application via entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]