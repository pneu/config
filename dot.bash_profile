# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi


test -s ~/.alias && . ~/.alias || true

# User specific environment and startup programs
#PATH=$PATH:$HOME/bin
#PATH=$PATH:/usr/local/teTeX/bin
## should cons before current environment variable.
PATH="$HOME/bin:$PATH"
PATH="/usr/local/teTeX/bin:$PATH"
export PATH
unset USERNAME

export LC_NUMERIC=C
export LC_TIME=C
export LC_MESSAGES=C
# PAGER='lv -c'
export WWW_HOME='www.google.com'
export PAGER='lv -c'

