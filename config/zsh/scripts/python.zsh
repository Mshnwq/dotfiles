function pyvenv() {
  if [[ $1 == "." ]]; then
    if [[ -f ".venv/bin/activate" ]]; then
      source ".venv/bin/activate"
      echo "Activated virtual environment '.venv'"
    else
      echo "No virtual environment found at .venv"
      return 1
    fi
  else
    local env_name=${2:-.venv}
    pyenv shell $1
    python -m venv $env_name
    echo "Virtual environment '$env_name' created using Python $1"
  fi
}
