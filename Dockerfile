FROM fedora:latest

# Install required packages and clean up
# RUN dnf install -y git zsh curl chsh which vim && dnf clean all
RUN dnf install -y git zsh curl chsh which vim fzf && dnf clean all

# Add a user without a password
RUN useradd -m -s $(which zsh) codeopshq
RUN passwd -d codeopshq
RUN usermod -aG wheel codeopshq

# USER root
# RUN chsh -s /bin/zsh codeopshq

# Switch to the new user
USER codeopshq

# Set the working directory
WORKDIR /home/codeopshq

# Install oh-my-zsh non-interactively
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zinit
# Run bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Copy vim configuration
COPY .vimrc /home/codeopshq/.vimrc

# Set zsh as the default shell for the user
# SHELL ["/bin/zsh", "-c"]
# RUN chsh -s $(which zsh)

# Optional: Copy custom zsh configuration files or plugins if needed
COPY .zshrc /home/codeopshq/.zshrc

# zinit update && zinit self-update

RUN exec zsh

# RUN zsh -c "zinit update"

COPY .p10k.zsh /home/codeopshq/.p10k.zsh

# RUN zinit update



# Set the entrypoint to zsh
CMD ["zsh"]
