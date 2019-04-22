# Set path
export PATH="$PYENV_ROOT/shims:$HOME/.local/bin/:$HOME/.yarn/bin:$PATH"
[ "$(uname -s)" = "Darwin" ] && export PATH="$(brew --prefix coreutils)/libexec/gnubin/:/usr/local/bin:$PATH"
