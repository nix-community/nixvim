#!/usr/bin/env bash

: "${NIXVIM_NIX_COMMAND:=nix}"
if [[ -z ${NIXVIM_SYSTEM+x} ]]; then
  NIXVIM_SYSTEM=$(nix eval --raw --impure --expr "builtins.currentSystem")
fi

help() {
  cat <<EOF
Usage: tests [OPTIONS] [tests...]

If tests are passed on the command line only these will be launched

Options:
	-h, --help: Display this help message and exit
	-l, --list: Display the list of tests and exit
	-s, --system <system>: Launch checks for "<system>" instead of "${NIXVIM_SYSTEM}".
	-i, --interactive: Pick interactively the tests. Can't be supplied if tests where passed.
EOF
}

if ! OPTS=$(getopt -o "hlis:" -l "help,list,interactive,system:" -- "$@"); then
  echo "Invalid options" >&2
  help
  exit 1
fi

eval set -- "$OPTS"

system=${NIXVIM_SYSTEM}
specified_tests=()
interactive=false

mk_test_list() {
  nix eval ".#checks.${system}" --apply builtins.attrNames --json |
    jq -r 'map(select(startswith("test-")))[]'
}

while true; do
  case "$1" in
  -h | --help)
    help
    exit 0
    ;;
  -l | --list)
    mk_test_list
    exit 0
    ;;
  -i | --interactive)
    interactive=true
    shift
    ;;
  -s | --system)
    system=$2
    shift 2
    ;;
  --)
    shift
    specified_tests=("$@")
    break
    ;;
  esac
done

run_tests() {
  # Add the prefix "checks.${system}." to each argument
  if ! "${NIXVIM_NIX_COMMAND}" build --no-link --file . "${@/#/checks.${system}.}"; then
    echo "Test failure" >&2
    exit 1
  fi
}

if [[ $interactive == true && ${#specified_tests[@]} -ne 0 ]]; then
  echo "Can't use --interactive with tests on the command line" >&2
  exit 1
fi

if [[ $interactive == true ]]; then
  test_name=$(mk_test_list | fzf) || exit $?
  specified_tests+=("$test_name")
fi

if [[ ${#specified_tests[@]} -eq 0 ]]; then
  readarray -t complete_test_list < <(mk_test_list)
  run_tests "${complete_test_list[@]}"
else
  echo "Running ${#specified_tests[@]} tests: ${specified_tests[*]}" >&2
  run_tests "${specified_tests[@]}"
fi
