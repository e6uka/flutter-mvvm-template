#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: tool/rename.sh --package my_app --bundle-id com.company.myapp --name \"My App\""
  exit 1
}

NEW_PACKAGE="" NEW_BUNDLE="" NEW_NAME=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --package) NEW_PACKAGE="$2"; shift 2 ;;
    --bundle-id) NEW_BUNDLE="$2"; shift 2 ;;
    --name) NEW_NAME="$2"; shift 2 ;;
    *) usage ;;
  esac
done
[[ -z "$NEW_PACKAGE" || -z "$NEW_BUNDLE" || -z "$NEW_NAME" ]] && usage
[[ "$NEW_PACKAGE" =~ ^[a-z][a-z0-9_]*$ ]] || { echo "--package must be snake_case"; exit 1; }
[[ "$NEW_BUNDLE" =~ ^[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)+$ ]] || { echo "--bundle-id must look like com.company.myapp (letters and digits only)"; exit 1; }

cd "$(dirname "$0")/.."

OLD_PACKAGE=$(sed -n 's/^name: *//p' pubspec.yaml)
OLD_BUNDLE=$(sed -n 's/.*applicationId = "\(.*\)".*/\1/p' android/app/build.gradle.kts)
OLD_NAME=$(grep -A1 '<key>CFBundleDisplayName</key>' ios/Runner/Info.plist \
  | sed -n 's/.*<string>\(.*\)<\/string>.*/\1/p')

echo "package   : $OLD_PACKAGE -> $NEW_PACKAGE"
echo "bundle id : $OLD_BUNDLE -> $NEW_BUNDLE"
echo "name      : $OLD_NAME -> $NEW_NAME"

FILES=$(grep -rlI --exclude-dir={.git,.dart_tool,build,.fvm,Pods,.symlinks,.idea} \
  -e "$OLD_PACKAGE" -e "$OLD_BUNDLE" -e "$OLD_NAME" . | grep -v '^./tool/rename.sh$' || true)

for f in $FILES; do
  OLD_BUNDLE="$OLD_BUNDLE" NEW_BUNDLE="$NEW_BUNDLE" \
  OLD_PACKAGE="$OLD_PACKAGE" NEW_PACKAGE="$NEW_PACKAGE" \
  OLD_NAME="$OLD_NAME" NEW_NAME="$NEW_NAME" \
  perl -pi -e 's/\Q$ENV{OLD_BUNDLE}\E/$ENV{NEW_BUNDLE}/g; s/\Q$ENV{OLD_PACKAGE}\E/$ENV{NEW_PACKAGE}/g; s/\Q$ENV{OLD_NAME}\E/$ENV{NEW_NAME}/g' "$f"
done

KOTLIN_ROOT=android/app/src/main/kotlin
OLD_DIR="$KOTLIN_ROOT/${OLD_BUNDLE//.//}"
NEW_DIR="$KOTLIN_ROOT/${NEW_BUNDLE//.//}"
if [[ "$OLD_DIR" != "$NEW_DIR" && -d "$OLD_DIR" ]]; then
  mkdir -p "$NEW_DIR"
  mv "$OLD_DIR"/* "$NEW_DIR"/
  find "$KOTLIN_ROOT" -type d -empty -delete
fi

echo "Done. Next: update lib/constants/app_brand.dart and lib/theme/brand_palette.dart, then run 'make clean'."
