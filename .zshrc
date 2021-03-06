# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/adrianbalcan/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="sorin"

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
ENABLE_CORRECTION="true"

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
plugins=(git)

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

######################################################################
# Custom

export PATH="$PATH:/Users/adrianbalcan/istio-0.2.12/bin"
#autoload -Uz compinit
#compinit
#source /usr/local/bin/aws_zsh_completer.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
declare -x VISUAL=vim
declare -x EDITOR=vim

alias k="kubectl"
alias t="terraform"
alias khelm="~/.kube/khelm.py get images"
alias awsblu="yes | cp ~/.aws/blugento.config ~/.aws/config && yes | cp ~/.aws/blugento.credentials ~/.aws/credentials"
function kncos {
  gcloud container clusters get-credentials $( cat ~/.kube/ncos | fzf )
}
alias kblu="export KOPS_STATE_STORE=s3://kube01-kops && kops export kubecfg kube01.blugento.eu"
alias k_dev_global="cp ~/.kube/dev-global ~/.kube/config"
alias k_prod_global="cp ~/.kube/prod-global ~/.kube/config"
alias myshell="kubectl run my-shell-adrian --rm -i --tty --image ubuntu -- bash"
export PATH="/usr/local/opt/curl/bin:$PATH"
function kconf {
  cp ~/.kube/$(ls ~/.kube | grep .conf | fzf) ~/.kube/config
}
function kdep {
  kubectl set image deployment/$1 $1=gcr.io/camversity-183908/$1:$2 --record=true
}
function kpods {
    kubectl get pods | less
}
function kpod {
    kubectl get pods | fzf
}
function kexec {
  if [ -z $1 ]
  then
    NS=$(kubectl get ns | fzf | awk "{print \$1}")
  else
    NS=$1
  fi
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  CONTAINERS=$(kubectl get pods $POD -n $NS -o jsonpath='{.spec.containers[*].name}')
  COUNT_CONTAINERS=$(echo $CONTAINERS | wc -w | tr -d ' ')
  if [ "$COUNT_CONTAINERS" -gt "1" ]
  then
    kubectl exec -it $POD -c $(echo $CONTAINERS | tr " " "\n" | fzf) -n $NS -- sh
  else
    kubectl exec -it $POD -n $NS -- sh
  fi
}
function klogs {
  if [ -z $1 ]
  then
    NS=$(kubectl get ns | fzf | awk "{print \$1}")
  else
    NS=$1
  fi
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  CONTAINERS=$(kubectl get pod $POD -n $NS -o jsonpath='{.spec.containers[*].name}')
  INITCONTAINERS=$(kubectl get pod $POD -n $NS -o jsonpath='{.spec.initContainers[*].name}')
  COUNT_CONTAINERS=$(echo $CONTAINERS | wc -w | tr -d ' ')
  if [ "$COUNT_CONTAINERS" -gt "1" ]
  then
    kubectl logs $POD -c $(echo -e "$INITCONTAINERS\n$CONTAINERS" | tr " " "\n" | fzf) -n $NS -f
  else
    kubectl logs $POD -n $NS -f
  fi
}
function kdel {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  kubectl delete pod $POD -n $NS
}
function kdescribe {
  if [ -z $1 ]
  then
    NS=$(kubectl get ns | fzf | awk "{print \$1}")
  else
    NS=$1
  fi
  POD=$(kubectl get pods -n $NS | fzf | awk "{print \$1}")
  kubectl describe pod $POD -n $NS
}
function kdescribepod {
  kubectl describe $(kubectl get pods -o name | fzf)
}
function kdescribenode {
  kubectl describe $(kubectl get nodes -o name | fzf)
}
function kedit {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  DEPLOY=$(kubectl get deploy -n $NS | fzf | awk "{print \$1}")
  kubectl edit deploy $DEPLOY -n $NS
}
function kimg {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  DEPLOY=$(kubectl get deploy -n $NS | fzf | awk "{print \$1}")
  echo "initContainers:"
  kubectl get deployments $DEPLOY -n $NS -o json | jq .spec.template.spec.initContainers | grep '"image":'
  echo "Containers:"
  kubectl get deployments $DEPLOY -n $NS -o json | jq .spec.template.spec.containers | grep '"image":'
}
function wkp {
  NS=$(kubectl get ns | fzf | awk "{print \$1}")
  watch "kubectl get pods -o wide -n $NS && printf '%20s\n' | tr ' ' - && kubectl get hpa -n $NS"
}
#  kubectl get pods --field-selector=metadata.name=
#  kubectl get pods POD_NAME_HERE -o jsonpath='{.spec.containers[*].name}'

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
