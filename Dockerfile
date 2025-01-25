# Use the official Ubuntu 22.04 base image
FROM ubuntu:22.04

# Set non-interactive mode for apt to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    gnupg \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Add the NVIDIA CUDA repository keyring and repository
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | gpg --dearmor -o /usr/share/keyrings/cuda-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" > /etc/apt/sources.list.d/cuda.list

# Update package list and install CUDA toolkit
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-toolkit-12-6 \
    && rm -rf /var/lib/apt/lists/*

# Install necessary libraries and development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    #libucs0 \
    # libucx-dev \
    # librivermax1 \
    # libtritonserver-dev \
    python3-pip \
    libssl3 \
    libssl-dev \
    libgles2-mesa-dev \
    libgstreamer1.0-0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstreamer-plugins-base1.0-dev \
    libgstrtspserver-1.0-0 \
    libjansson4 \
    libyaml-cpp-dev \
    libjsoncpp-dev \
    protobuf-compiler \
    gcc \
    make \
    git \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Pre-requisite for DeepStream
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnvinfer10 \
    libnvinfer-dev \
    libnvonnxparsers10 \
    libnvonnxparsers-dev \
    libnvinfer-plugin10 \
    libnvinfer-plugin-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional dependencies for DeepStream
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-base1.0-dev \
    libpangocairo-1.0-0 \
    libyaml-cpp-dev \
    libgles2-mesa-dev \
    && rm -rf /var/lib/apt/lists/*

# Install JupyterLab using pip
RUN pip install --no-cache-dir jupyterlab

RUN apt-get update && apt-get install -y --no-install-recommends nvidia-driver-535

# Install NVIDIA DeepStream SDK 7.1
RUN wget --content-disposition 'https://api.ngc.nvidia.com/v2/resources/nvidia/deepstream/versions/7.1/files/deepstream-7.1_7.1.0-1_amd64.deb' -O deepstream-7.1_7.1.0-1_amd64.deb 
RUN dpkg -i deepstream-7.1_7.1.0-1_amd64.deb && \
    rm deepstream-7.1_7.1.0-1_amd64.deb

# Expose default JupyterLab port
EXPOSE 8888

# Set the entrypoint for running JupyterLab
ENTRYPOINT ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
