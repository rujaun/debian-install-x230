#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias reboot="systemctl reboot"
alias shutdown="systemctl poweroff"

EDITOR=vim
COLORTERM=truecolor

alias pythonv='python -m venv env'
alias pythonva='source env/bin/activate'
alias python='python3'
alias pip='pip3'
alias pipclean='pip freeze | xargs pip uninstall -y'
alias pipfreeze='pip freeze > requirements.txt'

export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH

# source "$HOME/.cargo/env"
# source /home/rujaun/Compiled/alacritty/extra/completions/alacritty.bash

# eval "$(starship init bash)"
