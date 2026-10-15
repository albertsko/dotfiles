ARG BASE_IMAGE=ubuntu:26.04
FROM ${BASE_IMAGE}

RUN apt-get update \
    && apt-get install --yes --no-install-recommends build-essential ca-certificates curl file git jq locales procps stow sudo \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && usermod --login dev --home /home/dev --move-home ubuntu \
    && groupmod --new-name dev ubuntu \
    && printf 'dev ALL=(ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && install -d -o dev -g dev /home/linuxbrew/.linuxbrew

USER dev
ENV HOME=/home/dev \
    PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/dev/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    DOTFILES_HOME=/home/dev/.local/state/dotfiles \
    DOTFILES_PROFILE=msb \
    HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_AUTO_UPDATE=1 \
    LANG=C.UTF-8

WORKDIR /home/dev
RUN git clone --depth=1 https://github.com/albertsko/dotfiles.git "$DOTFILES_HOME" \
    && mkdir -p /home/dev/dev /home/dev/.cache/Homebrew /home/dev/.config/homebrew

COPY --chown=dev:dev msb/ /home/dev/.local/state/dotfiles/msb/
COPY --chown=dev:dev shared/ /home/dev/.local/state/dotfiles/shared/
COPY --chown=dev:dev install.sh /home/dev/.local/state/dotfiles/install.sh
RUN rm -f /home/dev/.bashrc /home/dev/.profile \
    && bash "$DOTFILES_HOME/shared/.local/bin/git.sh" \
    && bash "$DOTFILES_HOME/shared/.local/bin/stow.sh" --override

WORKDIR /home/dev/dev
CMD ["/bin/bash", "-l"]
