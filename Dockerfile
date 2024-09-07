# Use a base image that fits your project (like Ubuntu, Python, etc.)
FROM ubuntu:20.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libx11-dev \
    libgtk-3-dev \
    && rm -rf /var/lib/apt/lists/*
    

RUN pip install cmake
RUN pip install dlib

# Copy your application code
COPY . /app

# Set the working directory
WORKDIR /app

RUN pip install -r requirements.txt


# Add any additional commands (e.g., installing Python dependencies, etc.)

# Specify the command to run your app (modify as needed)
CMD ["uvicorn app:app --reload"]
