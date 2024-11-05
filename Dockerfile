FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

## disable interactive functions
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# install python and pip
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3-pip \
    git \
    build-essential \
    && python3 -m pip install --upgrade pip \
    && apt-get clean

# Set up environment variables
ENV PATH /opt/conda/bin:$PATH

# Install dependencies for Conda and Python
RUN apt-get update && \
    apt-get install -y wget bzip2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

# Add Conda to PATH
ENV PATH="/opt/conda/bin:${PATH}"

# Install mamba for faster dependency resolution
RUN conda install -n base -c conda-forge mamba

# Copy the environment.yml file to the Docker container
COPY environment.yml /app/environment.yml

# Create the Conda environment using mamba
RUN mamba env create -f /app/environment.yml

# Activate the environment by default
ENV PATH /opt/conda/envs/DMIDetection/bin:$PATH

# create a directory for the app
WORKDIR /app


# how to build the image
# docker build -t dmi-detection .

# how to run the image
#                                                      the source file path                                                  the dataset path
# docker run  --ipc=host --gpus all -it -v /media/newdriver/storage_v1/backup/newdriver/Work/DMimageDetection:/app  -v /media/newdriver/storage_v1/ml_dataset/CNNDetection/dataset:/app/dataset dmi-detection /bin/bash