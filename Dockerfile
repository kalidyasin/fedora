FROM fedora:latest

# Install required packages
RUN dnf install -y git zsh curl chsh which vim fzf && dnf clean all

# Add a user without a password
RUN useradd -m -s $(which zsh) codeopshq
RUN passwd -d codeopshq
RUN usermod -aG wheel codeopshq

# Switch to the new user
USER codeopshq

# Set the working directory
WORKDIR /home/codeopshq

# Install Zinit non-interactively
RUN sh -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Copy vim and zsh configuration files
COPY .vimrc /home/codeopshq/.vimrc
COPY .zshrc /home/codeopshq/.zshrc
COPY .p10k.zsh /home/codeopshq/.p10k.zsh

# Ensure proper ownership and permissions
RUN chown -R codeopshq:codeopshq /home/codeopshq

# Initialize Zinit plugins during the build process
RUN zsh -lc "source ~/.zshrc && zinit update && zinit self-update"

# Set the entrypoint to zsh
CMD ["zsh"]
