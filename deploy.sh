#!/bin/sh
# 重新部署到 CloudBase 国内站静态托管
# 用法：./deploy.sh [envId]
# 前置：npm i -g @cloudbase/cli && tcb login
set -e

ENV_ID="${1:-inland-mandrill-d4ffh2w8c1643875}"

if ! command -v tcb >/dev/null 2>&1; then
  echo "未找到 tcb 命令，请先执行：npm i -g @cloudbase/cli && tcb login" >&2
  exit 1
fi

cd "$(dirname "$0")"

# 只上传这三个上线文件，避免把 .git / .DS_Store / README 传上去
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

FILES="index.html token.txt"
for f in auto.html autoOpen.html; do
  [ -f "$f" ] && FILES="$FILES $f"
done

cp $FILES "$STAGE/"

tcb hosting deploy "$STAGE" -e "$ENV_ID" --verify
