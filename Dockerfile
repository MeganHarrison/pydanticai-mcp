FROM python:3.11-slim

# -----------------------------
# Install Node.js (includes npx)
# -----------------------------
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Set build-time and runtime env
# -----------------------------
ARG PORT=8001
ENV PORT=${PORT}
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1

WORKDIR /app

# -----------------------------
# Install Python dependencies
# -----------------------------
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# -----------------------------
# Copy application code
# -----------------------------
COPY . .

# -----------------------------
# Expose app port
# -----------------------------
EXPOSE ${PORT}

# -----------------------------
# Run the app
# -----------------------------
CMD ["uvicorn", "pydantic_mcp_agent_endpoint:app", "--host", "0.0.0.0", "--port", "8001"]
