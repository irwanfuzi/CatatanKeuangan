#!/bin/bash
set -e

echo "=== [MyKas CI/CD] Preparing Flutter SDK for Vercel Runner ==="

# 1. Download Flutter SDK versi Stable jika belum ada
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 2. Tambahkan biner Flutter ke PATH sistem Vercel
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Verifikasi instalasi SDK
flutter --version

echo "=== [MyKas CI/CD] Fetching Dependencies & Compiling PWA Web ==="
flutter pub get

# 4. Build Flutter Web dengan base-href root ("/") khusus Vercel
flutter build web --release --base-href "/" --no-tree-shake-icons

echo "=== [MyKas CI/CD] Build Succeeded! Output ready in build/web ==="
