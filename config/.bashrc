#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.bash_completion/alacritty

EDITOR=vim
COLORTERM=truecolor

alias ls='ls --color=auto'


alias pythonv='python -m venv env'
alias pythonva='source env/bin/activate'
alias python='python3'
alias pip='pip3'

export PY_USER_BIN=$(python3 -c 'import site; print(site.USER_BASE + "/bin")')
export PATH=$PY_USER_BIN:$PATH