FROM python:3.15-slim@sha256:65a65fc7b30b06cb6df4930fd4650697cb23f4c2698ab81fc87e4b031bc36928
# Patch zlib from Debian security: CVE-2026-85091 is fixed in Debian but not yet
# in the official Python image (as at 14 Nov 2026). Remove once the base has it.
RUN apt-get update \
    && apt-get install -y --no-install-recommends --only-upgrade zlib1g \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --require-hashes -r requirements.txt
COPY app/ ./app/
RUN useradd --uid 10001 --no-create-home appuser  
USER 10001                                         
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
