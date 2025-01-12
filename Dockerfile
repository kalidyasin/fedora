FROM fedora:latest

# Install required packages and clean up
RUN dnf install -y git zsh curl chsh which vim && dnf clean all

# Add a user without a password
RUN useradd -m -s $(which zsh) codeopshq
RUN passwd -d codeopshq
RUN usermod -aG wheel codeopshq

# Switch to the new user
USER codeopshq

# Set the working directory
WORKDIR /home/codeopshq

# Install oh-my-zsh non-interactively (if needed)
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zinit
RUN bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Copy vim configuration
COPY .vimrc /home/codeopshq/.vimrc

# Copy custom zsh configuration files or plugins if needed
COPY .zshrc /home/codeopshq/.zshrc

# Initialize Zinit plugins
RUN zsh -c "source ~/.zshrc && zinit update && zinit self-update"

COPY .p10k.zsh /home/codeopshq/.p10k.zsh

# Ensure proper ownership of copied files
# RUN chown -R codeopshq:codeopshq /home/codeopshq


# Set the entrypoint to zsh
CMD ["zsh"]
