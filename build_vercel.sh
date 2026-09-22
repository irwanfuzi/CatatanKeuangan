#!/bin/bash
set -e

echo "=== [MyKas CI/CD] Installing Flutter SDK on Vercel Runner ==="

# Clone Flutter SDK versi stable (Depth 1 untuk mempercepat unduhan)
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# Injeksi biner Flutter ke variabel PATH lingkungan Vercel
export PATH="$PATH:`pwd`/flutter/bin"

# Verifikasi instalasi Flutter SDK
flutter --version

echo "=== [MyKas CI/CD] Fetching Dependencies & Building Web ==="
flutter pub get

# Jalankan kompilasi Flutter Web dengan base-href root untuk Vercel
flutter build web --release --base-href "/" --no-tree-shake-icons

echo "=== [MyKas CI/CD] Build Completed Successfully ==="

