FROM python:3.11-slim

# Prevent Python Cache files and enable inmediate container logs

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 

WORKDIR /app

#build-essential support packages that require compilation
# libgomp1 is commonly required for faiss-cpu

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for Docker Build caching
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# copy the complete project
COPY . .

EXPOSE 8501

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0", "-server.headless=true", "--browser.gatherUsageStats=false"]

