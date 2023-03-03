#!/bin/bash -eux
env

if [[ ${VERSION} == "latest" ]]; then
	curl -s "https://api.github.com/repos/prodvana/pvnctl/releases/${VERSION}"
	VERSION=$(curl -s "https://api.github.com/repos/prodvana/pvnctl/releases/${VERSION}" | jq -r ".tag_name")
fi

case $(uname) in
Linux) PLATFORM="linux" ;;
Darwin) PLATFORM="darwin" ;;
*)
	echo "unsupported platform"
	exit 1
	;;
esac

case $(uname -m) in
x86_64) ARCH="amd64" ;;
i386) ARCH="386" ;;
arm64) ARCH="arm64" ;;
aarch64) ARCH="arm64" ;;
*)
	echo "unsupported architecture $(uname -m)"
	exit 1
	;;
esac

ARCHIVE_NAME="pvnctl_${VERSION}_${PLATFORM}_${ARCH}.tar.gz"

curl -Ls -o checksums.txt "https://github.com/prodvana/pvnctl/releases/download/${VERSION}/checksums.txt"
curl -Ls -o "${ARCHIVE_NAME}" "https://github.com/prodvana/pvnctl/releases/download/${VERSION}/${ARCHIVE_NAME}"

# validate checksum
grep "${ARCHIVE_NAME}" checksums.txt | sha256sum --check

tar xf "${ARCHIVE_NAME}"
rm "${ARCHIVE_NAME}" checksums.txt

[[ -w /usr/local/bin ]] && SUDO="" || SUDO=sudo

${SUDO} chmod +x ./pvnctl
${SUDO} mv ./pvnctl /usr/local/bin/pvnctl
