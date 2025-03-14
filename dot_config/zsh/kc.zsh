#!/bin/zsh

usage() {
  local SELF
  SELF="kc"

  cat <<EOF
USAGE:
  $SELF                       : list the configs
  $SELF <NAME>                : switch to config <NAME>
  $SELF -c, --current         : show the current context name
  $SELF -u, --unset           : unset the current kubeconfig

  $SELF -h,--help             : show this message
EOF
}

exit_err() {
   echo >&2 "${1}"
   exit 1
}

current_context() {
  kubectl config view -o=jsonpath='{.current-context}'
}

get_configs() {
  #kubectl config get-contexts -o=name | sort -n
  \ls -p --color=never -1 $HOME/.kube | \grep -v '/$'
}

list_configs() {
  set -u pipefail
  local cur ctx_list
  cur="$(current_context)" || exit_err "error getting current context"
  ctx_list=$(get_configs) || exit_err "error getting context list"

  local yellow darkbg normal
  yellow=$(tput setaf 3 || true)
  darkbg=$(tput setab 0 || true)
  normal=$(tput sgr0 || true)

  local cur_ctx_fg cur_ctx_bg
  cur_ctx_fg=${KUBECTX_CURRENT_FGCOLOR:-$yellow}
  cur_ctx_bg=${KUBECTX_CURRENT_BGCOLOR:-$darkbg}

  for c in $ctx_list; do
  if [[ -n "${_KUBECTX_FORCE_COLOR:-}" || \
       -t 1 && -z "${NO_COLOR:-}" ]]; then
    # colored output mode
    if [[ "${c}" = "${cur}" ]]; then
      echo "${cur_ctx_bg}${cur_ctx_fg}${c}${normal}"
    else
      echo "${c}"
    fi
  else
    echo "${c}"
  fi
  done
}

choose_context_interactive() {
  local choice
  choice="$(get_configs | _KUBECTX_FORCE_COLOR=1 fzf --ansi --no-preview || true)"
  if [[ -z "${choice}" ]]; then
    echo 2>&1 "error: you did not choose any of the options"
    exit 1
  else
    set_context "${choice}"
  fi
}

set_context() {
  export KUBECONFIG="$HOME/.kube/${1}"
}

unset_context() {
  unset KUBECONFIG
}

kc() {
  if [[ "$#" -eq 0 ]]; then
    if [[ -t 1 &&  -z "${KUBECTX_IGNORE_FZF:-}" && "$(type fzf &>/dev/null; echo $?)" -eq 0 ]]; then
      choose_context_interactive
    else
      list_configs
    fi
  elif [[ "$#" -gt 1 ]]; then
    echo "error: too many arguments" >&2
    usage
    exit 1
  elif [[ "$#" -eq 1 ]]; then
    if [[ "${1}" == '-c' || "${1}" == '--current' ]]; then
      kubectl config current-context
    elif [[ "${1}" == '-u' || "${1}" == '--unset' ]]; then
      unset_context
    elif [[ "${1}" == '-h' || "${1}" == '--help' ]]; then
      usage
    elif [[ "${1}" =~ ^-(.*) ]]; then
      echo "error: unrecognized flag \"${1}\"" >&2
      usage
      exit 1
    else
      set_context "${1}"
    fi
  else
    usage
    exit 1
  fi
}
