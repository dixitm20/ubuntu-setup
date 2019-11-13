# ubuntu-setup

1) Install anaconda into ubuntu using the steps from the url : 
https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart

	cd /tmp
	curl -O https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh
	sha256sum Anaconda3-2019.03-Linux-x86_64.sh
	bash Anaconda3-2019.03-Linux-x86_64.sh

2) Create seperate conda environments for python 2.7 & 3.7 
	
	conda create -n py37 python=3.7 anaconda
	conda create -n py27 python=2.7 anaconda

3) Install sdkman using the steps from the url: https://sdkman.io/install

	Before running below command ensure you have zip & unzip installed (If not use command: sudo apt-get install zip unzip )
	curl -s "https://get.sdkman.io" | bash

4) Install below sdk using the following sdkman commands

	sdk install java 8.0.212-amzn
	sdk install scala
	sdk install gradle
	sdk install sbt
	sdk install spark
	sdk install maven
	sdk install groovy
	sdk install kotlin
	sdk install ant

5) Add below to the end of .bashrc file:

	# >>> my alias init >>>
	alias myhome='cd /mnt/c/Users/Manish'
	alias mywrk='cd /mnt/c/Users/Manish/my-workspace'
	# >>> my alias init >>>


	# >>> my export init >>>
	if [[ ${SPARK_HOME+X} ]]; then
		__spark_pythondir="${SPARK_HOME}/python"
		__spark_py4jfile="${SPARK_HOME}/python/lib/$(ls "${SPARK_HOME}/python/lib" | grep 'py4j.*zip' | tail -l)"
		__spark_pysparkfile="${SPARK_HOME}/python/lib/$(ls "${SPARK_HOME}/python/lib" | grep 'pyspark.*zip' | tail -l)"
		__spark_path_list="${__spark_pythondir}:${__spark_py4jfile}:${__spark_pysparkfile}"
		
		[[ "${PYTHONPATH:-NA}" == "NA" ]] && PYTHONPATH="$(which python)"
		[[ ":${PYTHONPATH}:" != *":${__spark_path_list}:"* ]] && PYTHONPATH="${__spark_path_list}:${PYTHONPATH}"
		export PYTHONPATH
		# export PYSPARK_DRIVER_PYTHON="jupyter"
		# export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
		# export PYSPARK_PYTHON=python3

		unset __spark_pythondir
		unset __spark_py4jfile
		unset __spark_pysparkfile
		unset __spark_path_list
	fi
	# >>> my export init >>>


	# >>> conda init >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/home/dixitm/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/home/dixitm/anaconda3/etc/profile.d/conda.sh" ]; then
			. "/home/dixitm/anaconda3/etc/profile.d/conda.sh"
		else
			export PATH="/home/dixitm/anaconda3/bin:$PATH"
		fi
	fi
	unset __conda_setup
	# <<< conda init <<<


	# >>> sdkman init >>>
	#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
	export SDKMAN_DIR="/home/dixitm/.sdkman"
	[[ -s "/home/dixitm/.sdkman/bin/sdkman-init.sh" ]] && source "/home/dixitm/.sdkman/bin/sdkman-init.sh"
	# <<< sdkman init <<<