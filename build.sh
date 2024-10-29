#!/bin/bash
set -e

API="https://api.github.com/repos"

function Public() {
  USR=$1
  REPO=$2
  NUM=$3
  curl -sL $API/$USR/$REPO/releases \
  | jq ".[0].assets" | jq ".[$NUM].browser_download_url" \
  | xargs -I {} curl -sL {} -o $REPO.zip
  echo -e "$USR $REPO $NUM" 
}

function Public0() {
  USR=$1
  REPO=$2
  curl -sL $API/$USR/$REPO/releases \
  | jq ".[0].assets" | jq ".[0].browser_download_url" \
  | xargs -I {} curl -sL {} -o $REPO.zip
  echo -e "$USR $REPO"
}

function Release() {
  USR=$1
  REPO=$2
  curl -sL -H "Authorization: token ${{ secrets.TOKEN }}" -sL $API/$USR/$REPO/releases/latest \
  | jq '.assets' | jq '.[0].url' \
  | xargs -I {} curl -sL {} -H "Authorization: token ${{ secrets.TOKEN }}" -H 'Accept:application/octet-stream' \
  -o REPO.zip
  echo -e "$USR $REPO"
}

function PreRelease() {
  USR=$1
  REPO=$2
  ASSET_ID=$3
  curl -sL -H "Accept: application/octet-stream" -H "Authorization: Bearer ${{ secrets.TOKEN }}" "$API/$USR/$REPO/releases/assets/$ASSET_ID" -o $REPO.zip
  echo -e "$USR $REPO $ASSET_ID"
}

function bulkMy0() {
  for param in "$@"; do
    Release "wei2ard" ${param}
  done
}

repos=(
# AIO
#Magic-Suite

# .packages
# ────────────────────────────────────
pkgs-Settings
#pkgs-Updater #未完成
pkgs-R2Config
pkgs-Guides
pkgs-Magic

# .overlays
# ────────────────────────────────────
ovls-Arcane
ovls-EdiZon
ovls-FPSLocker
#ovls-FanControl #未完成
ovls-ReverseNX-RT
ovls-Status-Monitor
ovls-sys-clk-oc
nros-JKSV

# .sys
# ────────────────────────────────────
sys-sigpatches
)

bulkMy0 ${repos[@]}
