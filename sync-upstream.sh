#!/usr/bin/env bash
# Синхронизация форка Stratarium с апстримом Niko1221/Strata.
# Быстрый ff; если у форка есть свои коммиты — merge-коммит «sync: ...».
# Конфликт = выход с кодом 2 и сообщением (ручное разрешение).
set -uo pipefail
cd "$(dirname "$0")"
git fetch upstream --tags || { echo "fetch upstream не удался (сеть?)"; exit 1; }
BEHIND=$(git rev-list --count main..upstream/main)
if [ "$BEHIND" -eq 0 ]; then echo "апстрим не уходил вперёд — ничего делать не нужно"; exit 0; fi
echo "апстрим вперёд на $BEHIND коммитов"
if ! git merge --ff-only upstream/main; then
  git merge -m "sync: upstream $(git rev-parse --short upstream/main)" upstream/main || { echo "КОНФЛИКТ — разрешить вручную"; exit 2; }
fi
git push origin main --tags && echo "СИНХРОНИЗИРОВАНО: $(git log --oneline -1)"
