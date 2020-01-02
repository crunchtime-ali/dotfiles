# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$GOPATH/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
export TERM="xterm-256color"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

#plugins=(git autojump zsh-nvm)
plugins=(git autojump zsh-autosuggestions)

# Load NVM only when a .nvmrc is present
autoload -U add-zsh-hook
load-nvmrc() {
  if [ -e "${PWD}/.nvmrc" ]
  then
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  fi
}
add-zsh-hook chpwd load-nvmrc
[ -e "${PWD}/.nvmrc" ] && load-nvmrc

ZSH_DISABLE_COMPFIX=true

export NVM_DIR="$HOME/.nvm"

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Kubernetes Current Context/Namespace
custom_prompt_kubecontext() {
  local kubectl_version="$(kubectl version --client 2>/dev/null)"

  if [[ -n "$kubectl_version" ]]; then
    # Get the current Kuberenetes context
    local cur_ctx=$(kubectl config view -o=jsonpath='{.current-context}')
    cur_namespace="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
    # If the namespace comes back empty set it default.
    if [[ -z "${cur_namespace}" ]]; then
      cur_namespace="default"
    fi

    local k8s_final_text="$cur_ctx/$cur_namespace"

    local color='%F{black}'
    [[ $cur_ctx == "prod" ]] && color='%F{196}'
    echo -n "%{$color%}\U2388  $k8s_final_text%{%f%}" # \U2388 is Kubernetes Icon

    #"$1_prompt_segment" "$0" "$2" "magenta" "black" "$k8s_final_text" "KUBERNETES_ICON"
  fi
}

# Powerlevel9k configuration
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_CUSTOM_KUBECONTEXT="custom_prompt_kubecontext"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs kubecontext)
POWERLEVEL9K_CONTEXT_TEMPLATE="%n"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status node_version root_indicator background_jobs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_NODE_VERSION_FOREGROUND='black'
POWERLEVEL9K_CUSTOM_KUBECONTEXT_BACKGROUND='075'

export GPG_TTY=$(tty)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for Netlify's Git Credential Helper.
if [ -f '$HOME/.netlify/helper/path.zsh.inc' ]; then source '$HOME/.netlify/helper/path.zsh.inc'; fi

export GO111MODULE=on
export GOPATH="${HOME}/go"
export HELM_TILLER_STORAGE=configmap

alias k='kubectl'
alias kctx='kubectx'
alias kns='kubens'
alias tf='terraform'
alias mo='molecule'
alias ll='exa -l'
alias open='open -a Forklift'
alias gl='open "$(git config remote.origin.url)" -a "Google Chrome.app"'
alias ydl='youtube-dl -f m4a -o "%(title)s.%(ext)s" --embed-thumbnail --add-metadata  --metadata-from-title "%(artist)s - %(title)s"'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
