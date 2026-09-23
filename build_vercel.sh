#!/bin/bash

if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/flutter/bin"

flutter doctor
flutter pub get
flutter build web --release --base-href "/" --no-tree-shake-icons
