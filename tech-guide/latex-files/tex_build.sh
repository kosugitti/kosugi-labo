#!/bin/bash
# LaTeX コンパイルスクリプト
# 使い方: ./build.sh ファイル名.tex

if [ $# -eq 0 ]; then
    echo "使い方: ./build.sh ファイル名.tex"
    exit 1
fi

FILENAME=$1
BASENAME=${FILENAME%.tex}

echo "=== LuaLaTeX 1回目 ==="
lualatex "$FILENAME"
if [ $? -ne 0 ]; then
    echo "エラー: LuaLaTeX 1回目で失敗しました"
    exit 1
fi

echo "=== Biber ==="
biber "$BASENAME"
if [ $? -ne 0 ]; then
    echo "警告: Biberでエラーが発生しました（引用がない場合は正常）"
fi

echo "=== LuaLaTeX 2回目 ==="
lualatex "$FILENAME"

echo "=== LuaLaTeX 3回目 ==="
lualatex "$FILENAME"

echo "=== 中間ファイル削除 ==="
rm -f "${BASENAME}.aux"
rm -f "${BASENAME}.bbl"
rm -f "${BASENAME}.bcf"
rm -f "${BASENAME}.blg"
rm -f "${BASENAME}.toc"
rm -f "${BASENAME}.run.xml"
rm -f "${BASENAME}.out"

echo "=== 完了 ==="
echo "${BASENAME}.pdf が生成されました"
