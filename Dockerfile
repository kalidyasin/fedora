FROM fedora:latest

# Install required packages in one RUN instruction
RUN dnf upgrade --refresh -y \
    && dnf install -y git zsh curl which vim fzf bat \
    && dnf clean all

# Create a non-root user with zsh as the default shell
RUN useradd -m -s $(which zsh) codeopshq \
    && passwd -d codeopshq \
    && usermod -aG wheel codeopshq

# Copy configuration files to the user's home directory
COPY .vimrc .zshrc .p10k.zsh /home/codeopshq/
COPY .config /home/codeopshq/.config/

# Ensure proper ownership of the copied files
RUN chown -R codeopshq:codeopshq /home/codeopshq

# Switch to the new user and set up their environment
USER codeopshq
WORKDIR /home/codeopshq

# set TERM environment variable
ENV TERM=xterm

# Set up zsh
RUN  zsh -c "source ~/.zshrc"

# Set default shell and entrypoint to zsh
CMD ["zsh"]
