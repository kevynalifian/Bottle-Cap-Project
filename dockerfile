FROM python:3.10-slim

# set workdir
WORKDIR /app

# system deps (jika perlu)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git && rm -rf /var/lib/apt/lists/*

# copy project files
COPY pyproject.toml .
COPY requirements.txt .
COPY src/ src/
COPY configs/ configs/

# install dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# create user (opsional)
RUN useradd -m appuser
USER appuser

ENTRYPOINT ["bsort"]
CMD ["--help"]
