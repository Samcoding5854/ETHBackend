# Stage 1: Builder
FROM python:3-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    cmake \
    openblas-dev \
    lapack-dev \
    libx11-dev \
    gtk+3.0-dev \
    python3-dev

WORKDIR /app

# Set up a virtual environment
RUN python3 -m venv venv
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install dlib -vvv
RUN pip install cmake 
RUN pip install face_recognition

# Stage 2: Runner
FROM python:3-alpine AS runner

WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /app/venv venv
COPY main.py main.py

# Set up the virtual environment for the runner stage
ENV VIRTUAL_ENV=/app/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Expose the necessary port
EXPOSE 8000

# Start the application
CMD [ "uvicorn", "--host", "0.0.0.0", "--port", "8000", "app:app" ]
