#!/usr/bin/env bash

: "${NIXVIM_NIX_COMMAND:=nix}"
if [[ -z ${NIXVIM_SYSTEM+x} ]]; then
  NIXVIM_SYSTEM=$(nix eval --raw --impure --expr "builtins.currentSystem")
fi

help() {
  cat <<EOF
Usage: tests [OPTIONS] [tests...] -- [NIX OPTIONS...]

If tests are passed on the command line only these will be launched

All arguments after '--' starting with '-' will be passed to 'nix build'.
For example to debug a failing test you can append '-- --show-trace'.

Options:
	-h, --help: Display this help message and exit
	-l, --list: Display the list of tests and exit
	-s, --system <system>: Launch checks for "<system>" instead of "${NIXVIM_SYSTEM}".
	-g, --group-size N: The maximum number of tests to build at once. Default 20.
	-i, --interactive: Pick interactively the tests. Can't be supplied if tests where passed.
	-a, --attr: Print full attrpath of the tests, instead of running them.
EOF
}

if ! OPTS=$(getopt -o "hlis:g:a" -l "help,list,interactive,system:,group-size:,attr" -- "$@"); then
  echo "Invalid options" >&2
  help
  exit 1
fi

eval set -- "$OPTS"

system=${NIXVIM_SYSTEM}
specified_tests=()
nix_args=()
interactive=false
group_size=20
print_attrpath=false

mk_test_list() {
  jq -r 'keys[]' "${NIXVIM_TESTS}"
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
  -g | --group-size)
    group_size=$2
    shift 2
    ;;
  -s | --system)
    system=$2
    shift 2
    ;;
  -a | --attr)
    print_attrpath=true
    shift 1
    ;;
  --)
    shift
    for arg in "$@"; do
      if [[ $arg == -* ]]; then
        nix_args+=("$arg")
      else
        specified_tests+=("$arg")
      fi
    done
    break
    ;;
  esac
done

get_tests() {
  # Convert bash array to jq query
  # e.g. (foo bar baz) => ."foo",."bar",."baz"
  readarray -t queries < <(
    for test in "$@"; do
      echo '."'"$test"'"'
    done
  )
  query=$(
    IFS=,
    echo "${queries[*]}"
  )
  for test in $(jq -r "${query}" "${NIXVIM_TESTS}"); do
    echo "checks.${system}.${test}"
  done
}

build_group() {
  if ! "${NIXVIM_NIX_COMMAND}" build "${nix_args[@]}" --no-link --file . "$@"; then
    echo "Test failure" >&2
    return 1
  fi
}

build_in_groups() {
  # Count failures
  failures=0

  # $@ is weird and sometimes includes the script's filename, othertimes doesn't.
  # Copying it to a normal array results in a consistent behaviour.
  tests=("$@")
  test_count=${#tests[@]}

  # Calculate how many groups we need
  if ((group_size > test_count)); then
    group_size=$test_count
  fi
  group_count=$((test_count / group_size))

  for ((group_idx = 0; group_idx <= group_count; group_idx++)); do
    # The index pointing to the start of the group slice
    start_idx=$((group_idx * group_size))

    if ((group_idx == group_count)); then
      group_slice=("${tests[@]:start_idx}")
    else
      group_slice=("${tests[@]:start_idx:group_size}")
    fi

    if ((group_count > 1)); then
      echo "Building group $group_idx of $group_count"
    fi

    if ! build_group "${group_slice[@]}"; then
      ((++failures))
    fi
  done

  ((failures == 0))
}

run_tests() {
  readarray -t test_list < <(get_tests "$@")
  if [[ $print_attrpath == true ]]; then
    echo
    echo "Full attr paths:"
    for test in "${test_list[@]}"; do
      echo "- $test"
    done
  elif ! build_in_groups "${test_list[@]}"; then
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
  verb="Running"
  if [[ $print_attrpath == true ]]; then
    verb="Printing"
  fi
  echo "$verb ${#specified_tests[@]} tests: ${specified_tests[*]}" >&2
  run_tests "${specified_tests[@]}"
fi
