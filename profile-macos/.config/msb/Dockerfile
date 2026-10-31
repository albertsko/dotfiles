FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        bash-completion bind9-dnsutils build-essential ca-certificates curl file git gnupg htop \
        iproute2 iputils-ping jq less lsof nano openssh-client procps rsync socat sudo tmux tree \
        unzip vim wget xz-utils zip \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && . /etc/os-release \
    && printf '%s\n' \
        'Types: deb' \
        'URIs: https://download.docker.com/linux/ubuntu' \
        "Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}" \
        'Components: stable' \
        "Architectures: $(dpkg --print-architecture)" \
        'Signed-By: /etc/apt/keyrings/docker.asc' \
        >/etc/apt/sources.list.d/docker.sources \
    && apt-get update \
    && apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

RUN usermod --login dev --home /home/dev --move-home --append --groups docker ubuntu \
    && groupmod --new-name dev ubuntu \
    && printf 'dev ALL=(ALL) NOPASSWD: ALL\n' >/etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && install -d -o dev -g dev /home/dev/dev /home/linuxbrew/.linuxbrew \
        /home/dev/.config/opencode /home/dev/.local/share/opencode /home/dev/.local/state \
    && ln -s /home/linuxbrew/.linuxbrew/var/msbdev/homebrew /home/dev/.homebrew

ENV LANG=C.UTF-8 \
    HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

USER dev
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# The runner mounts a shared prefix over /home/linuxbrew/.linuxbrew, so keep a seed copy.
USER root
RUN mv /home/linuxbrew/.linuxbrew /opt/linuxbrew \
    && install -d -o dev -g dev /home/linuxbrew/.linuxbrew

COPY entrypoint.sh /usr/local/bin/msbdev-entrypoint

WORKDIR /home/dev/dev
ENTRYPOINT ["/usr/local/bin/msbdev-entrypoint"]
CMD ["/bin/bash", "-l"]
