# 使用別人建立好的環境，並在此基礎上進行修改
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# 更新系統套件並安裝必要工具和數學庫
RUN apt-get update && apt-get install -y \
    openssh-server \
    python3-pip \
    python3-dev \
    vim \
    wget \
    sudo \
    build-essential \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    && rm -rf /var/lib/apt/lists/*

# 創建 SSH 目錄
RUN mkdir /var/run/sshd

# 設置 root 密碼
RUN echo 'root:t3-csie-420' | chpasswd

# 允許 root 使用 SSH 登入
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 禁止 PAM (Pluggable Authentication Modules) 限制
RUN sed -i 's@session    required   pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# 設置 SSH 端口
EXPOSE 22

# 升級 pip
RUN pip install --upgrade pip

# 安裝 Python 套件
RUN pip install \
    numpy \
    pandas \
    matplotlib \
    scikit-learn \
    tqdm \
    scipy

# 安裝 PyTorch 和相關庫
RUN pip install torch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 --index-url https://download.pytorch.org/whl/cu118

# 創建一個普通用戶 (aiialab) 並賦予 sudo 權限，設置主目錄為 /home/aiialab
RUN useradd -ms /bin/bash aiialab && echo "aiialab:00000000" | chpasswd && adduser aiialab sudo

# 限制 aiialab 使用 sudo passwd 修改自己的密碼
RUN echo "aiialab ALL=(ALL) NOPASSWD: ALL, !/usr/bin/passwd, !/usr/sbin/chpasswd" >> /etc/sudoers

# 解鎖 aiialab 使用者的密碼，確保可以登入
RUN passwd -u aiialab

# 限制所有普通用戶使用 passwd，僅 root 可以使用
RUN chmod 700 /usr/bin/passwd

# 或者使用 chattr 來鎖定 passwd 命令，防止任何人修改
# RUN chattr +i /usr/bin/passwd

# 自動切換到 /home/aiialab 目錄（對 root 也生效）
RUN echo "cd /home/aiialab" >> ~/.bashrc

# 下載並安裝完整版本的 Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.07-1-Linux-x86_64.sh -O /tmp/anaconda.sh && \
    bash /tmp/anaconda.sh -b -p /opt/anaconda && \
    rm /tmp/anaconda.sh

# 配置 Anaconda 環境變數
ENV PATH=/opt/anaconda/bin:$PATH

# 初始化 Conda
RUN /opt/anaconda/bin/conda init bash

# 切換到 root 用戶生成 SSH 主機密鑰並啟動 SSH 服務
CMD ["/bin/bash", "-c", "ssh-keygen -A && /usr/sbin/sshd -D"]
