FROM ubuntu
RUN apt-get update && apt-get install -y \
  git \
  curl \ 
  sudo \ 
  python3 \
  python3-pip \
  python-is-python3
RUN curl -fsSL https://code-server.dev/install.sh | sh
ADD https://raw.githubusercontent.com/term-world/world-container/main/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
WORKDIR /home/$VS_USER
ENTRYPOINT /entrypoint.sh