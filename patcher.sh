#!/bin/bash

###############################
# VARS
###############################

dsm_version=$(cat /etc.defaults/VERSION | grep productversion | sed 's/productversion=//' | tr -d '"')
repo_base_url="https://github.com/AlexPresso/mediaserver-ffmpeg-patcher"
version="1.0"
action="patch"
branch="main"
dependencies=("MediaServer" "ffmpeg")
wrappers=("ffmpeg")

ms_path=/var/packages/MediaServer/target
libsynovte_path="$ms_path/lib/libsynovte.so"

###############################
# UTILS
###############################

function log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2"
}
function info() {
  log "INFO" "$1"
}
function error() {
  log "ERROR" "$1"
}

function restart_packages() {
  info "Restarting MediaServer..."
  synopkg restart MediaServer
}

function check_dependencies() {
  for dependency in "${dependencies[@]}"; do
    if [[ ! -d "/var/packages/$dependency" ]]; then
      error "Missing $dependency package, please install it and re-run the patcher."
      exit 1
    fi
  done
}

################################
# PATCH PROCEDURES
################################

function patch() {
  info "====== Patching procedure (branch: $branch) ======"

  for filename in "${wrappers[@]}"; do
    if [[ -f "$ms_path/bin/$filename" ]]; then
      info "Saving current $filename as $filename.orig"
      mv -n "$ms_path/bin/$filename" "$ms_path/bin/$filename.orig"

      info "Downloading and installing $filename's wrapper..."
      wget -q -O - "$repo_base_url/blob/$branch/$filename-wrapper.sh?raw=true" > "$ms_path/bin/$filename"
      chown root:MediaServer "$ms_path/bin/$filename"
      chmod 750 "$ms_path/bin/$filename"
      chmod u+s "$ms_path/bin/$filename"
    fi
  done

  info "Saving current libsynovte.so as libsynovte.so.orig"
  cp -n "$libsynovte_path" "$libsynovte_path.orig"
  chown MediaServer:MediaServer "$libsynovte_path.orig"

  info "Enabling eac3, dts and truehd"
  sed -i -e 's/eac3/3cae/' -e 's/dts/std/' -e 's/truehd/dheurt/' "$libsynovte_path"

  restart_packages

  echo ""
  info "Done patching, you can now enjoy your movies ;) (please add a star to the repo if it worked for you)"
}

function unpatch() {
  info "====== Unpatch procedure ======"

  info "Restoring libsynovte.so"
  mv -T -f "$libsynovte_path.orig" "$libsynovte_path"

  find "$ms_path/bin" -type f -name "*.orig" | while read -r filename; do
    info "Restoring MediaServer $filename"
    mv -T -f "$filename" "${filename::-5}"
  done

  restart_packages

  echo ""
  info "unpatch complete"
}

################################
# ENTRYPOINT
################################
while getopts a:b: flag; do
  case "${flag}" in
    a) action=${OPTARG};;
    b) branch=${OPTARG};;
    *) echo "usage: $0 [-a patch|unpatch] [-b branch]" >&2; exit 1;;
  esac
done

check_dependencies

info "You're running DSM $dsm_version"

case "$action" in
  unpatch) unpatch;;
  patch) patch;;
esac
