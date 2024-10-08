# Use the official Ubuntu image as the base image
FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

# Set the DEBIAN_FRONTEND environment variable to noninteractive to disable interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set the system timezone to America/New_York
RUN echo "America/New_York" > /etc/timezone

# Update the package lists for upgrades and new package installations, then install the listed packages
RUN apt-get update && apt-get install -y \
  jq \
  git \
  curl \ 
  nano \
  sudo \
  tree \ 
  wget \
  tzdata \ 
  python3 \
  sqlite3 \
  nfs-common \
  python3-dev \
  python3-pip \
  libcairo2-dev \
  python-is-python3 

# Install the listed Python packages using pip
RUN python -m pip install \
  rich \
  typer \
  pillow \
  pyyaml \
  openai \
  arglite \
  seaborn \
  requests \
  matplotlib \
  gatorgrader \
  python-dotenv --break-system-packages

# Create a new cli directory, change into it, initialize a new repo, and add a new remote named "origin" with the URL of the "api-services" repository
RUN mkdir cli
RUN cd cli
RUN git init
RUN git remote add -f origin https://github.com/term-world/api-services.git

# Enable the sparse checkout feature in Git, which allows you to checkout only a part of a repository
RUN git config core.sparseCheckout true

# Add "cli/" to the sparse-checkout file, pull from the main branch, change into cli and install the python packages
RUN echo "cli/" >> .git/info/sparse-checkout
RUN git pull origin main
RUN ls
RUN cd cli && python -m pip install . --break-system-packages

# Define an argument for the GitHub CDN URL (world-container)
ARG GITHUB_CDN=https://raw.githubusercontent.com/term-world/world-container/main

# Download a script from the GitHub CDN and append it to the bashrc file, download and execute a script from the GitHub CDN
RUN curl -fsSL $GITHUB_CDN/scripts/direvents.sh | cat >> /etc/bash.bashrc
RUN curl -fsSL $GITHUB_CDN/scripts/gginstall.sh | sh

# Download the latest release of the "term-world-theme" and "term-launcher" repositories
RUN curl -fsSl https://api.github.com/repos/term-world/term-launcher/releases/latest | wget $(jq -r ".assets[].browser_download_url")

RUN wget $GITHUB_CDN/scripts/motd

# Copy the "motd" file to the "/etc/motd" path
RUN cp motd /etc/motd

# Append a command to display the contents of the "motd" file to the bashrc file
RUN echo "cat /etc/motd" >> /etc/bash.bashrc

# Install and setup 
RUN sudo -E apt -y -qq install krb5-user
RUN curl -fsSL $GITHUB_CDN/scripts/krb5.conf | cat > /etc/krb5.conf

# Set up NFS services
RUN sudo update-rc.d rpcbind enable
RUN sudo update-rc.d nfs-common enable
RUN sudo mkdir /dungeon
RUN sudo mkdir -p /run/sendsigs.omit.d

RUN sudo echo "api.chompe.rs:/world/dungeon /dungeon nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab

# Setup call to omnipresence to register new users; update old
RUN echo "presence" >> /etc/bash.bashrc

# Setup Python not to write __pycache__
RUN export PYTHONDONTWRITEBYTECODE=1

# Add the "entrypoint.sh" file from the Docker build context to the image, and make the "entrypoint.sh" file executable
ADD entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

# Set the "entrypoint.sh" script as the entrypoint of the container (this script will be executed when a container is run from the image)
ENTRYPOINT /entrypoint.sh
