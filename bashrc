# Enviroment variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export EDITOR="vim"
export PAGER="less"
export BROWSER="lynx"
export SERVER_MODE=1
[ $(uname) = "Darwin" ] && export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# Trim long paths
PROMPT_DIRTRIM=2
# Allow global recursion
shopt -s globstar 2> /dev/null
# Case insensitive globbing
shopt -s nocaseglob
# Readline configuration
# Completion with ignore case
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns
bind "set show-all-if-ambiguous on"
# Add trailing slash of symlinks
bind "set mark-symlinked-directories on"
# Append to history, not overwrite
shopt -s histappend
# Multiline as one line
shopt -s cmdhist
# Record every line
PROMPT_COMMAND='history -a'
# Increase history
HISTSIZE=500000
HISTFILESIZE=100000
# Avoid duplicated entries
HISTCONTROL="erasedups:ignoreboth"
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"
# History time format
HISTTIMEFORMAT='%F %T '
# Prepend `cd` to directories
shopt -s autocd
# Correct spelling errors
shopt -s dirspell
shopt -s cdspell
# Define where `cd` looks for targets
CDPATH="."
# Bookmarking
shopt -s cdable_vars
# Enable vi mode
# set -o vi
bind "set editing-mode vi"
bind "set keymap vi-insert"
bind '"\C-n":next-history'
bind '"\C-p":previous-history'
bind '"\C-a":beginning-of-line'
bind '"\C-e":end-of-line'
bind '"\C-f":forward-char'
bind '"\C-b":backward-char'
bind "set show-mode-in-prompt on"
# bind "set vi-ins-mode-string \1\e[5 q\2"
# bind "set vi-cmd-mode-string \1\e[2 q\2"
# bind "set vi-ins-mode-string +"
# bind "set vi-cmd-mode-string :"
bind "set vi-cmd-mode-string \1\e[1;31m\2:\1\e[0m\2"
bind "set vi-ins-mode-string \1\e[1;31m\2>\1\e[0m\2"

mkcd() {
    mkdir -p "$1" && cd "$1" || return 1
}

own_pop() {
    updown="$1"
    shift
    popd -q "$updown$@"
}

own_push() {
    updown="$1"
    shift
    pushd -q "$updown$@"
}

# Color prompt
nonzero_return() {
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo ">${RETVAL}"
}

git_current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

git_current_repository() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo $(git remote -v | cut -d':' -f 2)
}
export PS1="\[\e[31m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\] \[\e[34m\]\w\[\e[m\]\[\e[31m\]\`nonzero_return\`\[\e[m\]\[\e[31m\]\\$\[\e[m\] "

# souce bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /usr/local/share/bash-completion/bash_completion ]; then
    . /usr/local/share/bash-completion/bash_completion
fi

# Aliases
alias cls='clear'
alias d='dirs -v'
alias diff='colordiff'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -al --color=auto'
alias l='ls -al --color=auto'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias dfc='df -hPT | column -t'
alias mountc='mount | column -t'
alias ports='netstat -tulanp'
alias header='curl -I'
alias headerc='curl -I --compress'
alias g='git'
alias gi='git init'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gap='git apply'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias grh="git reset --hard"
alias o='popd -q '
alias od='own_pop +'
alias ou='own_pop -'
alias p='pushd -q'
alias pd='own_push +'
alias pu='own_push -'
alias sc-cancel='sudo systemctl cancel'
alias sc-cat='systemctl cat'
alias sc-disable='sudo systemctl disable'
alias sc-disable-now='sc-disable --now'
alias sc-edit='sudo systemctl edit'
alias sc-enable='sudo systemctl enable'
alias sc-enable-now='sc-enable --now'
alias sc-help='systemctl help'
alias sc-is-active='systemctl is-active'
alias sc-is-enabled='systemctl is-enabled'
alias sc-isolate='sudo systemctl isolate'
alias sc-kill='sudo systemctl kill'
alias sc-link='sudo systemctl link'
alias sc-list-jobs='systemctl list-jobs'
alias sc-list-timers='systemctl list-timers'
alias sc-list-unit-files='systemctl list-unit-files'
alias sc-list-units='systemctl list-units'
alias sc-load='sudo systemctl load'
alias sc-mask='sudo systemctl mask'
alias sc-mask-now='sc-mask --now'
alias sc-preset='sudo systemctl preset'
alias sc-reenable='sudo systemctl reenable'
alias sc-reload='sudo systemctl reload'
alias sc-reset-failed='sudo systemctl reset-failed'
alias sc-restart='sudo systemctl restart'
alias sc-set-environment='sudo systemctl set-environment'
alias sc-show='systemctl show'
alias sc-show-environment='systemctl show-environment'
alias sc-start='sudo systemctl start'
alias sc-status='systemctl status'
alias sc-stop='sudo systemctl stop'
alias sc-try-restart='sudo systemctl try-restart'
alias sc-unmask='sudo systemctl unmask'
alias sc-unset-environment='sudo systemctl unset-environment'
alias scu-cancel='systemctl --user cancel'
alias scu-cat='systemctl --user cat'
alias scu-disable='systemctl --user disable'
alias scu-disable-now='scu-disable --now'
alias scu-edit='systemctl --user edit'
alias scu-enable='systemctl --user enable'
alias scu-enable-now='scu-enable --now'
alias scu-help='systemctl --user help'
alias scu-is-active='systemctl --user is-active'
alias scu-is-enabled='systemctl --user is-enabled'
alias scu-isolate='systemctl --user isolate'
alias scu-kill='systemctl --user kill'
alias scu-link='systemctl --user link'
alias scu-list-jobs='systemctl --user list-jobs'
alias scu-list-timers='systemctl --user list-timers'
alias scu-list-unit-files='systemctl --user list-unit-files'
alias scu-list-units='systemctl --user list-units'
alias scu-load='systemctl --user load'
alias scu-mask='systemctl --user mask'
alias scu-mask-now='scu-mask --now'
alias scu-preset='systemctl --user preset'
alias scu-reenable='systemctl --user reenable'
alias scu-reload='systemctl --user reload'
alias scu-reset-failed='systemctl --user reset-failed'
alias scu-restart='systemctl --user restart'
alias scu-set-environment='systemctl --user set-environment'
alias scu-show='systemctl --user show'
alias scu-show-environment='systemctl --user show-environment'
alias scu-start='systemctl --user start'
alias scu-status='systemctl --user status'
alias scu-stop='systemctl --user stop'
alias scu-try-restart='systemctl --user try-restart'
alias scu-unmask='systemctl --user unmask'
alias scu-unset-environment='systemctl --user unset-environment'
alias svim="sudo -E ${EDITOR}"
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias tkss='tmux kill-session -t'
alias tksv='tmux kill-server'
alias tl='tmux list-sessions'
alias ts='tmux new-session -s'

alias ga='git add'
alias gaa='git add --all'
alias gap='git apply'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gb='git branch'
alias gbD='git branch -D'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'
alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gca='git commit -v -a'
alias 'gca!'='git commit -v -a --amend'
alias gcam='git commit -a -m'
alias 'gcan!'='git commit -v -a --no-edit --amend'
alias 'gcans!'='git commit -v -a -s --no-edit --amend'
alias gcb='git checkout -b'
alias gcd='git checkout develop'
alias gcf='git config --list'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias 'gcn!'='git commit -v --no-edit --amend'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'
alias gcsm='git commit -s -m'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gdcw='git diff --cached --word-diff'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfg='git ls-files | grep'
alias gfo='git fetch origin'
alias gg='git gui citool'
alias gga='git gui citool --amend'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias ghh='git help'
alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
alias gl='git pull'
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glgp='git log --stat -p'
alias glo='git log --oneline --decorate'
alias glod='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'
alias glods='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'\'' --date=short'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --all'
alias glols='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --stat'
alias glum='git pull upstream master'
alias gm='git merge'
alias gma='git merge --abort'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'
alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias 'gpf!'='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpristine='git reset --hard && git clean -dfx'
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gpu='git push upstream'
alias gpv='git push -v'
alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase develop'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'
alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstall='git stash --all'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias gupv='git pull --rebase -v'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

source /Users/avazquez/Library/Preferences/org.dystroy.broot/launcher/bash/br
