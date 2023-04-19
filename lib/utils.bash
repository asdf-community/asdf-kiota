#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/microsoft/kiota"
TOOL_NAME="kiota"
TOOL_TEST="kiota --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kiota is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if kiota has other means of determining installable versions.
	list_github_tags
}

get_download_link() {
	local version
	version="$1"

	# seems like version can come as full download url or just the version
	if [[ ${version} = https* ]]; then
		(echo "${version}/" | sed 's|/tag/|/download/|')
	else
		(echo "${GH_REPO}/releases/download/v${version}/")
	fi
}

get_version() {
	local version
	version="$1"

	# seems like version can come as full download url or just the version
	if [[ ${version} = https* ]]; then
		(echo "${version//${GH_REPO}\/releases\/tag\/v/}")
	else
		(echo "${version}")
	fi
}

download_release() {
	local version filename url base_url
	version="$1"
	filename="$2"

	local platform

	case "$OSTYPE" in
	darwin*) platform="osx" ;;
	linux*) platform="linux" ;;
	msys*) platform="win" ;;
	cygwin*) platform="win" ;;
	*) fail "Unsupported platform" ;;
	esac

	local architecture

	case "$(uname -m)" in
	aarch64* | arm64) architecture="arm64" ;;
	x86_64*) architecture="x64" ;;
	*) fail "Unsupported architecture" ;;
	esac

	base_url="$(get_download_link "${version}")"
	url="${base_url}${platform}-${architecture}.zip"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

sanitize_path() {
	local path
	path="$1"

	echo "${path//${GH_REPO}\/releases\/tag\/v/}"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"
	install_path="$(sanitize_path "$install_path")"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$(sanitize_path "$ASDF_DOWNLOAD_PATH")"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
