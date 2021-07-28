# Aliases
command -v bat >/dev/null 2>&1 && alias cat="bat"
alias n='nvr --servername $(cat $NVR_GRAB_FILE)'
alias svim='sudo -E $EDITOR'
alias dw="cd $HOME/Downloads"
alias pj="cd $HOME/Projects"
alias cdC="cd $HOME/.dotfiles"
alias la='ls --color=auto -al'
alias d='dirs -v'
alias p='pushd -q'
alias o='popd -q '
alias pu='own_push -'
alias pd='own_push +'
alias ou='own_pop -'
alias od='own_pop +'
alias eZC="$EDITOR $HOME/.zshrc"
alias eZE="$EDITOR $HOME/.zshenv"
alias eVC="$EDITOR $XDG_CONFIG_HOME/nvim/init.vim"
alias eVP="$EDITOR $XDG_CONFIG_HOME/nvim/config/plugins.vim"
alias -g WC='| wc -l'
alias -g G='| grep -i'
alias -g RG='| rg '
alias -g X='| xargs '
alias -g SED='| sed -E'
alias -g AWK='| awk '
alias -s txt="$EDITOR"
alias -s html="$BROWSER"
alias -s pdf="zathura"
alias cl='clear'
alias lo='cd .. && l'
alias li='cd_in'
alias gpgupd='gpg-connect-agent updatestartuptty /bye'
alias ssh="TERM=xterm ssh"
alias gpw='gopass'

# This command is used a LOT both below and in daily life
alias k='kubectl'

# Execute a kubectl command against all namespaces
alias kca='_kca(){ kubectl "$@" --all-namespaces;  unset -f _kca; }; _kca'

# Apply a YML file
alias kaf='kubectl apply -f'

# Drop into an interactive terminal on a container
alias keti='kubectl exec -ti'

# Manage configuration quickly to switch contexts between local, dev ad staging.
alias kcuc='kubectl config use-context'
alias kcsc='kubectl config set-context'
alias kcdc='kubectl config delete-context'
alias kccc='kubectl config current-context'

# List all contexts
alias kcgc='kubectl config get-contexts'

# General aliases
alias kdel='kubectl delete'
alias kdelf='kubectl delete -f'

# Pod management.
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='kubectl edit pods'
alias kdp='kubectl describe pods'
alias kdelp='kubectl delete pods'

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'

# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='kubectl get svc'
alias kgsa='kubectl get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='kubectl edit svc'
alias kds='kubectl describe svc'
alias kdels='kubectl delete svc'

# Ingress management
alias kgi='kubectl get ingress'
alias kgia='kubectl get ingress --all-namespaces'
alias kei='kubectl edit ingress'
alias kdi='kubectl describe ingress'
alias kdeli='kubectl delete ingress'

# Namespace management
alias kgns='kubectl get namespaces'
alias kens='kubectl edit namespace'
alias kdns='kubectl describe namespace'
alias kdelns='kubectl delete namespace'
# alias kcn='kubectl config set-context $(kubectl config current-context) --namespace'

# ConfigMap management
alias kgcm='kubectl get configmaps'
alias kgcma='kubectl get configmaps --all-namespaces'
alias kecm='kubectl edit configmap'
alias kdcm='kubectl describe configmap'
alias kdelcm='kubectl delete configmap'

# Secret management
alias kgsec='kubectl get secret'
alias kgseca='kubectl get secret --all-namespaces'
alias kdsec='kubectl describe secret'
alias kdelsec='kubectl delete secret'

# Deployment management.
alias kgd='kubectl get deployment'
alias kgda='kubectl get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='kubectl edit deployment'
alias kdd='kubectl describe deployment'
alias kdeld='kubectl delete deployment'
alias ksd='kubectl scale deployment'
alias krsd='kubectl rollout status deployment'
kres(){
    kubectl set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Replicaset management
alias kgrs='kubectl get replicaset'
alias kgrsw='kubectl get replicaset --watch'
alias kgrswide='kubectl get replicaset -o wide'
alias kers='kubectl edit replicaset'
alias kdrs='kubectl describe replicaset'
alias kers='kubectl edit replicaset'
alias kdelrs='kubectl delete replicaset'

# Rollout management.
alias krh='kubectl rollout history'
alias kru='kubectl rollout undo'

# Statefulset management.
alias kgss='kubectl get statefulset'
alias kgssa='kubectl get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='kubectl edit statefulset'
alias kdss='kubectl describe statefulset'
alias kdelss='kubectl delete statefulset'
alias ksss='kubectl scale statefulset'
alias krsss='kubectl rollout status statefulset'

# Port forwarding
alias kpf="kubectl port-forward"

# Tools for accessing all information
alias kga='kubectl get all'
alias kgaa='kubectl get all --all-namespaces'

# Logs
alias kl='kubectl logs'
alias kl1h='kubectl logs --since 1h'
alias kl1m='kubectl logs --since 1m'
alias kl1s='kubectl logs --since 1s'
alias klf='kubectl logs -f'
alias klf1h='kubectl logs --since 1h -f'
alias klf1m='kubectl logs --since 1m -f'
alias klf1s='kubectl logs --since 1s -f'

# File copy
alias kcp='kubectl cp'

# Node Management
alias kgno='kubectl get nodes'
alias kgnowide='kubectl get nodes -owide'
alias keno='kubectl edit node'
alias kdno='kubectl describe node'
alias kdelno='kubectl delete node'

# PV management.
alias kgpv='kubectl get pv'
alias kgpva='kubectl get pv --all-namespaces'
alias kgpvw='kgpv --watch'
alias kepv='kubectl edit pv'
alias kdpv='kubectl describe pv'
alias kdelpv='kubectl delete pv'

# PVC management.
alias kgpvc='kubectl get pvc'
alias kgpvca='kubectl get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='kubectl edit pvc'
alias kdpvc='kubectl describe pvc'
alias kdelpvc='kubectl delete pvc'

# Service account management.
alias kgsa="kubectl get sa"
alias kdsa="kubectl describe sa"
alias kdelsa="kubectl delete sa"

# DaemonSet management.
alias kgds='kubectl get daemonset'
alias kgdsw='kgds --watch'
alias keds='kubectl edit daemonset'
alias kdds='kubectl describe daemonset'
alias kdelds='kubectl delete daemonset'

# Job management.
alias kgj='kubectl get job'
alias kgja='kubectl get job --all-namespaces'
alias kgjw='kgj --watch'
alias kgjwide='kgj -o wide'
alias kej='kubectl edit job'
alias kdj='kubectl describe job'
alias kdelj='kubectl delete job'

# CronJob management.
alias kgcj='kubectl get cronjob'
alias kecj='kubectl edit cronjob'
alias kdcj='kubectl describe cronjob'
alias kdelcj='kubectl delete cronjob'

# Istio gateway management.
alias kggw='kubectl get gw'
alias kggwa='kubectl get gw --all-namespaces'
alias kggww='kggw --watch'
alias kegw='kubectl edit gw'
alias kdgw='kubectl describe gw'
alias kdelgw='kubectl delete gw'

# Istio VirtualService.
alias kgvs='kubectl get vs'
alias kgvsa='kubectl get vs --all-namespaces'
alias kgvsw='kgvs --watch'
alias kevs='kubectl edit vs'
alias kdvs='kubectl describe vs'
alias kdelvs='kubectl delete vs'

# Istio ServiceEntry.
alias kgse='kubectl get se'
alias kgsea='kubectl get se --all-namespaces'
alias kgsew='kgse --watch'
alias kese='kubectl edit se'
alias kdse='kubectl describe se'
alias kdelse='kubectl delete se'

alias -g KN='-oyaml | kubectl neat | yh '
alias -g YQ='-oyaml | yq r -'
alias -g OY='-oyaml'
alias -g OJ='-ojson'
alias -g OJP='f() { echo "-ojsonpath=$1"; };f'
alias -g SL='--show-labels'
alias -g B64D='| base64 -d'

kj(){ kubectl "$@" -o json | jq; }
ky(){ kubectl "$@" -o yaml | yq -C -P r -; }
kcx(){ [ $# -ge 1 ] && kubectl ctx $1 || kubectl ctx $(kubectl ctx | fzf --preview={} --preview-window=:hidden)  }
kns(){ [ $# -ge 1 ] && kubectl ns $1 || kubectl ns $(kubectl ns | fzf --preview={} --preview-window=:hidden)  }