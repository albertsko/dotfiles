FROM ubuntu:24.04

ARG USERNAME=dotfiles
ARG USER_UID=10001
ARG USER_GID=10001

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
	&& apt-get install -y --no-install-recommends bash ca-certificates sudo \
	&& rm -rf /var/lib/apt/lists/*

RUN groupadd --gid "$USER_GID" "$USERNAME" \
	&& useradd --uid "$USER_UID" --gid "$USER_GID" --create-home --shell /bin/bash "$USERNAME" \
	&& printf '%s ALL=(ALL) NOPASSWD:ALL\n' "$USERNAME" >"/etc/sudoers.d/$USERNAME" \
	&& chmod 0440 "/etc/sudoers.d/$USERNAME"

RUN mkdir -p /home/linuxbrew/.linuxbrew "/home/$USERNAME/.cache" \
	&& chown -R "$USERNAME:$USERNAME" /home/linuxbrew "/home/$USERNAME/.cache"

USER $USERNAME
WORKDIR /home/$USERNAME/dotfiles/ubuntu

CMD ["bash", "./_install.sh"]
