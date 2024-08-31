NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
YELLOW="\[\e[1;33m\]"
BLUE="\[\e[1;34m\]"
PURPLE="\[\e[1;35m\]"
CYAN="\[\e[1;36m\]"
WHITE="\[\e[1;37m\]"

if [ "$USER" = root ]; then
  COLOR="$RED"
elif [ "$USER" = postgres ]; then
  COLOR="$PURPLE"
else
  COLOR="$GREEN"
fi

export PS1="$COLOR\n ┌── \D{%Y-%m-%d %H:%M:%S} $COLOR\u$BROWN@$CYAN\h$COLOR ── $NORMAL\w$COLOR ─$NORMAL\n$COLOR └─\\$ $NORMAL"
