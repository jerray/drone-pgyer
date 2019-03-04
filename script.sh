#!/bin/sh

# Plugin environments
# PLUGIN_RELEASE_PATH
# PLUGIN_FILENAME
# PLUGIN_OS android | ios
# PLUGIN_API_KEY

COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[0;34m'
COLOR_GREEN='\033[0;32m'
COLOR_ORANGE='\033[0;33m'
COLOR_NONE='\033[0m'

function colorful() {
	echo -e ${1}${2}${COLOR_NONE}
}

if [ -d "${PLUGIN_RELEASE_PATH}" ]; then
    cd ${PLUGIN_RELEASE_PATH}
fi

function android_release_file() {
    local ANDROID_RELEASE_OUTPUT=output.json
    if [ ! -e ${ANDROID_RELEASE_OUTPUT} ]; then
        colorful $COLOR_RED "Android release file not found: ${ANDROID_RELEASE_OUTPUT}"
        exit 1
    fi
    jq -r '.[0].path' ${ANDROID_RELEASE_OUTPUT}
}

# TODO
function ios_release_file() {
    echo ""
}

FILENAME=${PLUGIN_FILENAME}
if [ -z ${FILENAME} ]; then
    case $PLUGIN_OS in
        android)
            FILENAME=$(android_release_file)
            ;;
        ios)
            FILENAME=$(ios_release_file)
            ;;
        *)
            colorful $COLOR_RED "Unknown os ${PLUGIN_OS}"
            exit 2
    esac
fi

if [ -z "${FILENAME}" ];then
    colorful $COLOR_RED "Release file name is required, abort!"
    exit 1
fi

if [ ! -e ${FILENAME} ]; then
    colorful $COLOR_RED "Release file not found: ${FILENAME}"
    exit 1
fi

echo -e "Uploading file ${COLOR_BLUE}${FILENAME}${COLOR_NONE}"

curl \
    -F "file=@${FILENAME}" \
    -F "_api_key=${PLUGIN_API_KEY}" \
    https://www.pgyer.com/apiv2/app/upload |\
    jq '.'
