# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

#append to the history file, don't overwr
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
#export JAVA_HOME=/usr/lib/jvm/jdk-10
export PATH=$PATH:$JAVA_HOME/bin

export IAM_HOME=/home/josh/iam
export PATH=$PATH:$IAM_HOME

export M2_HOME=/home/josh/uportal/maven
export M2=$M2_HOME/bin
export PATH=$PATH:$M2

export ANT_HOME=/home/josh/uportal/ant
export PATH=$PATH:$ANT_HOME/bin

#export CATALINA_HOME=/home/josh/uportal/tomcat
export CATALINA_HOME=/home/josh/uportal/uportal-start/.gradle/tomcat
export PATH=$PATH:$CATALINA_HOME

export GECKO_HOME=/home/josh/Downloads/geckodriver
export PATH=$PATH:$GECKO_HOME

export VUE_HOME=/usr/local/bin/vue
export PATH=$PATH:$VUE_HOME
export JAVA_OPTS="-server -XX:MaxPermSize=512m -Xms1024m -Xmx2048m"

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export PORTAL_HOME=~/uportal/
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"
export SDKMAN_DIR="/home/josh/.sdkman"
[[ -s "/home/josh/.sdkman/bin/sdkman-init.sh" ]] && source "/home/josh/.sdkman/bin/sdkman-init.sh"

cd() {
   builtin cd "$@";
   ls;
}

[[ $- != *i* ]] && return

colors() {
        local fgc bgc vals seq0

        printf "Color escapes are %s\n" '\e[${value};...;${value}m'
        printf "Values 30..37 are \e[33mforeground colors\e[m\n"
        printf "Values 40..47 are \e[43mbackground colors\e[m\n"
        printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

        # foreground colors
        for fgc in {30..37}; do
                # background colors
                for bgc in {40..47}; do
                        fgc=${fgc#37} # white
                        bgc=${bgc#40} # black

                        vals="${fgc:+$fgc;}${bgc}"
                        vals=${vals%%;}

                        seq0="${vals:+\e[${vals}m}"
                        printf "  %-9s" "${seq0:-(default)}"
                        printf " ${seq0}TEXT\e[m"
                        printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
                done
                echo; echo
        done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
        xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
                PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
                ;;
        screen*)
                PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
                ;;
esac

use_color=true

# My Tomcat Script
function t {
for i in "$@"; do
    if [[ $i == "start" ]]; then
        $CATALINA_HOME/bin/startup.sh
    elif [[ $i == "stop" ]]; then
        $CATALINA_HOME/bin/shutdown.sh
        sleep 5
    elif [[ $i == "restart" ]]; then
        $CATALINA_HOME/bin/shutdown.sh
        sleep 10
        $CATALINA_HOME/bin/startup.sh
    elif [[ $i == "clean" ]]; then
        rm -rf $CATALINA_HOME/webapps/*
        rm -rf $CATALINA_HOME/work/*
        rm -rf $CATALINA_HOME/temp/*
elif [[ $i == "cleanlogs" ]]; then
        rm -rf $CATALINA_HOME/logs/*
    elif [[ $i == "s" || $i == "status" ]]; then
        ps aux | grep 'tomcat'
    elif [[ $i == "tail" ]]; then
        tail -f $CATALINA_HOME/logs/catalina.out
    else
        echo "Try again..."
    fi
done
}

shopt -s histappend

function m2 {
for i in "$@"; do
if [[ $i == "clean" ]]; then
    rm -rf /home/josh/.m2/repository/*
fi
done
}

function gradleDeploy {
  find src/main/react/src -name "*.js" -exec prettier --single-quote --no-bracket-spacing --write --no-semi {} \;
  if gradle clean build -Dfilters=/home/$USER/uportal/uportal/filters/local.properties; then
    sleep 1
    WARPATH=`readlink -f $(find . -name '*.war' -type f)`
    cd ~/uportal/uportal
    sleep 1

    /home/josh/uportal/uportal/bin/webapp_cntl.sh stop bookmarks
    rm -rf ~/uportal/tomcat/webapps/bookmarks
    ant deployPortletApp -DportletApp=$WARPATH
    /home/josh/uportal/uportal/bin/webapp_cntl.sh start bookmarks
    echo $WARPATH
    cd -
  fi
}

function gradleSoffitDeploy {
  find src/main/react/src -name "*.js" -exec prettier --write --no-semi {} \;
  if gradle clean build -Dfilters=/home/$USER/uportal/uportal/filters/local.properties; then
    sleep 1

    WARPATH=`readlink -f $(find . -name '*.war' -type f)`
    cd ~/uportal/uportal
    sleep 1
    java -Dcatalina.home=build -Dserver.port=8090 -jar $WARPATH
    echo $WARPATH
    cd -
  fi
}

HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more les
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less
alias ll='ls -alF'
alias LS='ls'
alias la='ls -A'
alias sl='sl -alFe'
alias l='ls -CF'
alias apt='sudo apt'
alias c='clear'
alias ..='cd ../..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias webapp=~/uportal/uportal/bin/webapp_cntl.sh
alias antinit='ant clean initportal'
alias cdup='cd ~/uportal/uportal'
alias mclean='rm -rf ~/.m2/repository'
alias gclean='rm -rf ~/.gradle'
alias deploy='~/deploy.sh'
alias lock='sh ~/lock'
alias glock='sh ~/glock'
alias mi='mvn clean install -e'
alias mp='mvn clean package -e'
alias tlog="cd ${CATALINA_HOME}/logs/"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!


#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# better yaourt colors
