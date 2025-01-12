FROM fedora:latest

# Install required packages
RUN dnf upgrade --refresh -y
RUN dnf install -y git zsh curl chsh which vim fzf bat && dnf clean all

# Add a user without a password
RUN useradd -m -s $(which zsh) codeopshq
RUN passwd -d codeopshq
RUN usermod -aG wheel codeopshq

# Switch to the new user
USER codeopshq

# Set the working directory for the new user
WORKDIR /home/codeopshq

# Set up Zinit
RUN mkdir -p ~/.local/share/zinit && \
    git clone https://github.com/zdharma-continuum/zinit.git ~/.local/share/zinit/zinit.git

# Switch back to root temporarily to set permissions
COPY .vimrc /home/codeopshq/.vimrc
COPY .zshrc /home/codeopshq/.zshrc
COPY .p10k.zsh /home/codeopshq/.p10k.zsh
# RUN chown -R codeopshq:codeopshq /home/codeopshq

# Switch to the new user
# USER codeopshq

# Install Zinit non-interactively
# RUN sh -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Initialize Zinit plugins during the build process
# RUN zsh -c "source ~/.zshrc"

# Initialize Zinit plugins
RUN zsh -c "ZINIT_HOME='${HOME}/.local/share/zinit/zinit.git' && \
            source '${HOME}/.local/share/zinit/zinit.git/zinit.zsh' && \
            zinit self-update && zinit update"

# install zinit plugins
RUN zsh -c "ZINIT_HOME='${HOME}/.local/share/zinit/zinit.git' && \
            source '${HOME}/.local/share/zinit/zinit.git/zinit.zsh' && \
	    zinit ice depth=1; zinit light romkatv/powerlevel10k && \
	    zinit light zsh-users/zsh-autosuggestions && \
	    zinit light zsh-users/zsh-syntax-highlighting && \
	    zinit light zsh-users/zsh-completions"

# Set the entrypoint to zsh
CMD ["zsh"]
