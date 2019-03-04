export SPARK_HOME="/usr/bin/spark"
export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
export PYSPARK_PYTHON=python3

function add2PATH {
  case ":$PATH:" in
    *":$1:"*) :;; # already there
    *) PATH="$1:$PATH";; # or PATH="$PATH:$1"
  esac
}

function add2PYTHONPATH {
  case ":$PYTHONPATH:" in
    *":$1:"*) :;; # already there
    *) PYTHONPATH="$1:$PYTHONPATH";; # or PATH="$PATH:$1"
  esac
}


if [[ $PYTHONPATH == "" ]]; then
  export PYTHONPATH="$SPARK_HOME/python:$SPARK_HOME/python/build:$SPARK_HOME/python/lib/py4j-0.10.1-src.zip"
else
  add2PYTHONPATH "$SPARK_HOME/python:$SPARK_HOME/python/build:$SPARK_HOME/python/lib/py4j-0.10.1-src.zip"
fi

add2PATH "$SPARK_HOME:$SPARK_HOME/bin:$PYTHONPATH"
