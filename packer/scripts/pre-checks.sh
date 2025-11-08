#!/usr/bin/env bash
set -e

echo "=== PRE-CHECKS ==="

# Verify Packer
if ! command -v packer &>/dev/null; then
  echo "Installing Packer..."
  sudo dnf install -y packer || {
    echo "Failed to install Packer"
    exit 1
  }
else
  packer version
fi

# Verify QEMU
if ! command -v qemu-system-x86_64 &>/dev/null; then
  echo "Installing QEMU/KVM..."
  sudo dnf install -y qemu-kvm qemu-img libvirt libvirt-daemon-driver-qemu
  sudo ln -sf /usr/libexec/qemu-kvm /usr/bin/qemu-system-x86_64
fi

echo "Checking KVM availability..."
if [ ! -e /dev/kvm ]; then
  echo "⚠️  /dev/kvm not found. Nested virtualization may be disabled."
else
  echo "✅ KVM is enabled."
fi

echo "=== PRE-CHECKS COMPLETE ==="
