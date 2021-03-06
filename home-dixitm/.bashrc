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

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

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


# >>> my export init >>>

    export iam="$(whoami)"
    # export wsliam="$(whoami)"
    # In case your user directory name under : C:/Users has different name than WSL username
    export wsliam="Manish"

    # for UNIX/LINUX machine below can be used
    # export myhome="/home/${iam}"
    # for WSL something like below will be used
    export myhome="/mnt/c/Users/${wsliam}"

    export mywrk="${myhome}/my-workspace"
    [[ -d "${mywrk}" ]] || mkdir "${mywrk}"

    export mygit="${myhome}/git-workspace"
    [[ -d "${mygit}" ]] || mkdir "${mygit}"
    
    export ZEPPELIN_HOME="/home/${iam}/tools/zeppelin/current"
    export ZEPPELIN_PORT='8099'
    [[ ":${PATH}:" != *":${ZEPPELIN_HOME}/bin:"* ]] && export PATH="${ZEPPELIN_HOME}/bin:${PATH}"

    export CONDA_HOME="/home/${iam}/anaconda3"
    [[ ":${PATH}:" != *":${CONDA_HOME}/bin:"* ]] && export PATH="${CONDA_HOME}/bin:${PATH}"
    
    # >>> wsl.conf init >>>
        # -------------------------------------------------------------------------------------------
        # ADD BELOW LINES(del # > from below lines and the copy) TO FILE: "/etc/wsl.conf" 
        #                       FOR STOPPING WINDOWS PATH LIST BEING APPENDED TO WSL PATH VARIABLE:
        # -------------------------------------------------------------------------------------------
        # ># Ref Page Url: https://docs.microsoft.com/en-us/windows/wsl/wsl-config
        # >[interop]
        # ># enabled = true
        # >appendWindowsPath = false

        # Below variables of this section (until : # <<< wsl.conf init <<<) are needed only in WSL
        # Without below PATH appends the command such as code,conde-insiders will not work
        export VSCODE_HOME="/mnt/c/Program Files/Microsoft VS Code"
        [[ ":${PATH}:" != *":${VSCODE_HOME}/bin:"* ]] && export PATH="${PATH}:${VSCODE_HOME}/bin"

        export VSCODE_INSIDERS_HOME="/mnt/c/Program Files/Microsoft VS Code Insiders"
        [[ ":${PATH}:" != *":${VSCODE_INSIDERS_HOME}/bin:"* ]] && export PATH="${PATH}:${VSCODE_INSIDERS_HOME}/bin"

        __WINDOWS_IMPORTANT_APPEND_PATH_LIST="/mnt/c/Windows:/mnt/c/Windows/System32:/mnt/c/Users/Manish/AppData/Local/Microsoft/WindowsApps"
        [[ ":${PATH}:" != *":${__WINDOWS_IMPORTANT_APPEND_PATH_LIST}:"* ]] && export PATH="${PATH}:${__WINDOWS_IMPORTANT_APPEND_PATH_LIST}"
        unset __WINDOWS_IMPORTANT_APPEND_PATH_LIST
    # <<< wsl.conf init <<<

    export TERM=xterm-256color

# <<< my export init <<<


# >>> my alias init >>>

    alias myhome="cd ${myhome}"
    alias mywrk="cd ${mywrk}"
    alias mygit="cd ${mygit}"

    alias zepstart='zeppelin-daemon.sh start'
    alias zepstop='zeppelin-daemon.sh stop'
    alias zepstatus='zeppelin-daemon.sh status'

    alias cdi='code-insiders .'

    alias jpn='jupyter notebook'
    alias jpl='jupyter lab'

# <<< my alias init <<<


# >>> conda init >>>

    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("/home/${iam}/anaconda3/bin/conda" shell.bash hook 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/${iam}/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/${iam}/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/${iam}/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup

# <<< conda init <<<


# >>> sdkman init >>>

    # THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
    export SDKMAN_DIR="/home/${iam}/.sdkman"
    [[ -s "/home/${iam}/.sdkman/bin/sdkman-init.sh" ]] && source "/home/${iam}/.sdkman/bin/sdkman-init.sh"

# <<< sdkman init <<<


# >>> my spark init >>>

    if [[ ${SPARK_HOME+X} ]]; then
        __spark_pythondir="${SPARK_HOME}/python"
        __spark_py4jfile="${SPARK_HOME}/python/lib/$(ls "${SPARK_HOME}/python/lib" | grep 'py4j.*zip' | tail -l)"
        __spark_pysparkfile="${SPARK_HOME}/python/lib/$(ls "${SPARK_HOME}/python/lib" | grep 'pyspark.*zip' | tail -l)"
        __spark_path_list="${__spark_pythondir}:${__spark_py4jfile}:${__spark_pysparkfile}"
        
        #[[ "${PYTHONPATH:-NA}" == "NA" ]] && PYTHONPATH="$(which python)"
        #[[ ":${PYTHONPATH}:" != *":${__spark_path_list}:"* ]] && PYTHONPATH="${__spark_path_list}:${PYTHONPATH}"
        
        [[ ":${PYTHONPATH}:" != *":${__spark_path_list}:"* ]] && PYTHONPATH="${__spark_path_list}${PYTHONPATH+:}${PYTHONPATH}"
        export PYTHONPATH

        # export PYSPARK_DRIVER_PYTHON="jupyter"
        # export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
        # export PYSPARK_PYTHON=python3

        unset __spark_pythondir
        unset __spark_py4jfile
        unset __spark_pysparkfile
        unset __spark_path_list
    fi

# <<< my spark init <<<


# <<< direnv init <<<

    # Ref Url: https://github.com/direnv/direnv/wiki/Python
    show_conda_env() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "($(basename $CONDA_DEFAULT_ENV)) "
    fi
    }

    export -f show_conda_env
    # TURN OFF CONDA PROMPT CHANGE IF USING BELOW PROMPT
    # USE THE FOLLOWING COMMAND TO TURN OFF CONDA PROMPT: conda config --set changeps1 False
    PS1='$(show_conda_env)'$PS1

    eval "$(direnv hook bash)"

# <<< direnv init <<<

