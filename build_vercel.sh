#!/bin/bash
set -e

echo "=== [MyKas CI/CD] Installing Flutter SDK on Vercel ==="

# Download Flutter SDK Stable versi ringkas jika belum ada
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Daftarkan biner Flutter ke PATH Vercel
export PATH="$PATH:`pwd`/flutter/bin"

# Cek status Flutter
flutter --version

echo "=== [MyKas CI/CD] Compiling Flutter Web (Root Base-Href) ==="
flutter pub get
flutter build web --release --base-href "/" --no-tree-shake-icons

echo "=== [MyKas CI/CD] Build Succeeded! ==="
