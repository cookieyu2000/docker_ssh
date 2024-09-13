# AIIA Docker Environment

This project sets up a Docker environment based on NVIDIA's CUDA 11.8 with cuDNN 8 and Ubuntu 22.04. The environment is configured with Python, PyTorch, and essential machine learning libraries. It also includes SSH access and restrictions on the ability to modify passwords.

## Prerequisites

- Docker installed on your machine
- GPU support for Docker (NVIDIA Docker support)

## How to Use

Follow the steps below to set up and run the Docker container:

### 1. Pull the Base CUDA Image

First, pull the base CUDA image from Docker Hub:

```bash
docker pull nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
```

### 2. Build the Docker Image

Build the Docker image from the provided Dockerfile. Replace `aiia_docker` with your desired image name:

```bash
docker build -t aiia_docker .
```

### 3. Run the Docker Container

Once the image is built, you can run the Docker container. This command runs the container with GPU support, limits the CPU usage to 5 cores, and exposes port 2222 for SSH access:

```bash
docker run -d -p 2222:22 --gpus all --cpus='5' --name aiia_pc aiia_docker
```

### 4. Access the Container via SSH

After the container is running, you can access it via SSH using the following command. Make sure to replace `your_ip_address` with the correct IP address:

The default password for the `aiialab` user is `00000000`. Root login is also enabled with the password `t3-csie-420`.

```bash
ssh aiialab@your_ip_address -p 2222
```

### 5. Stop the Container

To stop the running container, use the following command:

```bash
docker stop aiia_pc
```

### 6. Restart the Container

If you need to restart the container, use the command below:

```bash
docker start aiia_pc
```

## Notes

* This setup restricts the `aiialab` user from changing their own password.
* SSH access is enabled for both the `root` and `aiialab` users.
* The container is configured with the following Python libraries:
  * numpy
  * pandas
  * matplotlib
  * scikit-learn
  * tqdm
  * scipy
  * PyTorch (torch, torchvision, torchaudio)
