FROM fedora:latest

# Install required packages
RUN dnf upgrade --refresh -y
RUN dnf install -y git zsh curl chsh which vim fzf bat && dnf clean all

# Add a user without a password
RUN useradd -m -s $(which zsh) codeopshq
RUN passwd -d codeopshq
RUN usermod -aG wheel codeopshq

# Set the working directory for the new user
WORKDIR /home/codeopshq

# Switch back to root temporarily to set permissions
COPY .vimrc /home/codeopshq/.vimrc
COPY .zshrc /home/codeopshq/.zshrc
COPY .p10k.zsh /home/codeopshq/.p10k.zsh
RUN chown -R codeopshq:codeopshq /home/codeopshq

# Switch to the new user
USER codeopshq

# Install Zinit non-interactively
RUN sh -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Initialize Zinit plugins during the build process
RUN zsh -lc "source ~/.zshrc"

# Set the entrypoint to zsh
CMD ["zsh"]
