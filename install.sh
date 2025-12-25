#!/bin/bash
# Web3 Ops Center Installer for macOS and Linux
# Usage: curl -fsSL https://raw.githubusercontent.com/peak-xiong/web3-ops-center-releases/main/install.sh | bash

set -e

# Configuration
REPO="peak-xiong/web3-ops-center-releases"
APP_NAME="Web3 Ops Center"
INSTALL_DIR="/Applications" # macOS default, will be adjusted for Linux

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_banner() {
	echo -e "${BLUE}"
	echo "╔═══════════════════════════════════════╗"
	echo "║       Web3 Ops Center Installer       ║"
	echo "╚═══════════════════════════════════════╝"
	echo -e "${NC}"
}

print_step() {
	echo -e "${GREEN}▶${NC} $1"
}

print_error() {
	echo -e "${RED}✖ Error:${NC} $1"
	exit 1
}

print_warning() {
	echo -e "${YELLOW}⚠${NC} $1"
}

print_success() {
	echo -e "${GREEN}✔${NC} $1"
}

# Detect OS and architecture
detect_platform() {
	OS="$(uname -s)"
	ARCH="$(uname -m)"

	case "${OS}" in
	Darwin)
		PLATFORM="mac"
		if [[ ${ARCH} == "arm64" ]]; then
			ARCH_SUFFIX="arm64"
		else
			ARCH_SUFFIX="x64"
		fi
		EXTENSION="dmg"
		;;
	Linux)
		PLATFORM="linux"
		if [[ ${ARCH} == "x86_64" ]]; then
			ARCH_SUFFIX="x64"
		elif [[ ${ARCH} == "aarch64" ]]; then
			ARCH_SUFFIX="arm64"
		else
			print_error "Unsupported architecture: ${ARCH}"
		fi
		# Check for package manager
		if command -v apt-get &>/dev/null; then
			EXTENSION="deb"
		elif command -v dnf &>/dev/null || command -v yum &>/dev/null; then
			EXTENSION="rpm"
		else
			EXTENSION="AppImage"
		fi
		;;
	*)
		print_error "Unsupported operating system: ${OS}"
		;;
	esac

	print_step "Detected: ${OS} (${ARCH})"
}

# Get latest release version from GitHub
get_latest_version() {
	print_step "Fetching latest version..."

	LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

	if [[ -z ${LATEST_RELEASE} ]]; then
		print_warning "Could not fetch latest release, using 'latest'"
		LATEST_RELEASE="latest"
	else
		print_success "Latest version: ${LATEST_RELEASE}"
	fi
}

# Download the installer
download_installer() {
	print_step "Downloading ${APP_NAME}..."

	# Map platform and architecture to file naming convention
	# Actual files: Web3.Ops.Center-{macOS|Linux|Windows}-{arm64|x64|amd64|x86_64}.{ext}
	local FILE_PLATFORM=""
	local FILE_ARCH=""

	case "${PLATFORM}" in
	mac)
		FILE_PLATFORM="macOS"
		FILE_ARCH="${ARCH_SUFFIX}" # arm64 or x64
		;;
	linux)
		FILE_PLATFORM="Linux"
		if [[ ${EXTENSION} == "deb" ]]; then
			FILE_ARCH="amd64"
		elif [[ ${EXTENSION} == "AppImage" ]]; then
			FILE_ARCH="x86_64"
		else
			FILE_ARCH="${ARCH_SUFFIX}"
		fi
		;;
	esac

	# Construct filename: Web3.Ops.Center-{Platform}-{Arch}.{ext}
	local FILE_NAME="Web3.Ops.Center-${FILE_PLATFORM}-${FILE_ARCH}.${EXTENSION}"

	# Construct download URL
	if [[ ${LATEST_RELEASE} == "latest" ]]; then
		DOWNLOAD_URL="https://github.com/${REPO}/releases/latest/download/${FILE_NAME}"
	else
		DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${LATEST_RELEASE}/${FILE_NAME}"
	fi

	# Create temp directory
	TEMP_DIR=$(mktemp -d)
	INSTALLER_PATH="${TEMP_DIR}/installer.${EXTENSION}"

	echo "  Downloading from: ${DOWNLOAD_URL}"

	if ! curl -fsSL -o "${INSTALLER_PATH}" "${DOWNLOAD_URL}"; then
		print_error "Failed to download installer. Please check if releases are available at:\n  https://github.com/${REPO}/releases"
	fi

	print_success "Downloaded successfully"
}

# Install on macOS
install_macos() {
	print_step "Installing on macOS..."

	# Mount DMG
	MOUNT_POINT=$(hdiutil attach "${INSTALLER_PATH}" -nobrowse -quiet | grep -o '/Volumes/.*')

	if [[ -z ${MOUNT_POINT} ]]; then
		print_error "Failed to mount DMG"
	fi

	# Find and copy .app
	APP_PATH=$(find "${MOUNT_POINT}" -name "*.app" -maxdepth 1 | head -1)

	if [[ -z ${APP_PATH} ]]; then
		hdiutil detach "${MOUNT_POINT}" -quiet
		print_error "Could not find .app in DMG"
	fi

	# Copy to Applications
	cp -R "${APP_PATH}" "${INSTALL_DIR}/"

	# Unmount
	hdiutil detach "${MOUNT_POINT}" -quiet

	print_success "Installed to ${INSTALL_DIR}"
}

# Install on Linux
install_linux() {
	print_step "Installing on Linux..."

	case "${EXTENSION}" in
	deb)
		sudo dpkg -i "${INSTALLER_PATH}" || sudo apt-get install -f -y
		;;
	rpm)
		if command -v dnf &>/dev/null; then
			sudo dnf install -y "${INSTALLER_PATH}"
		else
			sudo yum install -y "${INSTALLER_PATH}"
		fi
		;;
	AppImage)
		chmod +x "${INSTALLER_PATH}"
		INSTALL_PATH="${HOME}/.local/bin/web3-ops-center"
		mkdir -p "${HOME}/.local/bin"
		mv "${INSTALLER_PATH}" "${INSTALL_PATH}"
		print_success "Installed to ${INSTALL_PATH}"
		print_warning "Make sure ~/.local/bin is in your PATH"
		return
		;;
	esac

	print_success "Installation complete"
}

# Cleanup
cleanup() {
	if [[ -n ${TEMP_DIR} ]] && [[ -d ${TEMP_DIR} ]]; then
		rm -rf "${TEMP_DIR}"
	fi
}

# Main
main() {
	print_banner

	# Set trap for cleanup
	trap cleanup EXIT

	detect_platform
	get_latest_version
	download_installer

	case "${PLATFORM}" in
	mac)
		install_macos
		;;
	linux)
		install_linux
		;;
	esac

	echo ""
	print_success "${APP_NAME} has been installed successfully!"
	echo ""

	if [[ ${PLATFORM} == "mac" ]]; then
		echo "  You can now open it from Applications or run:"
		echo "    open -a '${APP_NAME}'"
	else
		echo "  You can now run: web3-ops-center"
	fi
	echo ""
}

main "$@"
