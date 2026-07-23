#!/bin/bash
# Portable build helper — paths are relative to this repo's tools/ folder.
# Usage: build_roms.sh [enhanced]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export PATH="$SCRIPT_DIR/bin:$SCRIPT_DIR/wla-dx:/usr/bin:/bin:$PATH"
export MAKE=make
export CC=wla-gb
export LD=wlalink

MODE="${1:-}"
MAKE_ARGS=()
if [[ "$MODE" == "enhanced" ]]; then
  # Must be a make command-line variable (not only an env var) so Windows
  # make reliably sees it and passes -D BUILD_ENHANCED to wla-gb.
  MAKE_ARGS+=(BUILD_ENHANCED=1)
  echo "Mode: ENHANCED (single-slot Biggoron)"
else
  MAKE_ARGS+=(BUILD_ENHANCED=)
  echo "Mode: VANILLA (stock dual-slot Biggoron)"
fi

cd "$ROOT"

echo "make:    $(command -v make)"
echo "wla-gb:  $(command -v wla-gb)"
echo "wlalink: $(command -v wlalink)"
echo "python3: $(command -v python3 || command -v python)"
echo "root:    $ROOT"
echo "make args: ${MAKE_ARGS[*]}"
echo

if ! command -v python3 >/dev/null 2>&1; then
  if command -v python >/dev/null 2>&1; then
    mkdir -p "$SCRIPT_DIR/bin"
    printf '#!/bin/bash\nexec python "$@"\n' > "$SCRIPT_DIR/bin/python3"
    chmod +x "$SCRIPT_DIR/bin/python3"
  else
    echo "ERROR: python3/python not found on PATH"
    exit 1
  fi
fi

exec make -j"$(nproc 2>/dev/null || echo 4)" "${MAKE_ARGS[@]}"
