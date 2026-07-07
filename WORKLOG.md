# kosugi-labo WORKLOG

## 2026-05-22

### tech-guide に「Git で困った時の対処」を新設

- `tech-guide/git-trouble.qmd` 新規。エラー3パターン (CONFLICT / rejected / would be overwritten) と成功3パターン (Fast-forward / Already up to date / Push) を RStudio 実画面スクショで解説。
- `tech-guide/img/` に7枚配置: `git-trouble-conflict.png`, `git-trouble-rejected.png`, `git-trouble-overwrite.png`, `git-success-pull.png`, `git-success-uptodate.png`, `git-success-push.png`, `git-setup-divergent.png`。
- スクショ撮影用デモは kosugi-labo 外 (`~/Dropbox/Git/Zemi/git-trouble-demo/`) に置いた。kosugi-labo 側にはスクショ成果物 (PNG) のみ。

### tech-guide/github-setup.qmd の再構成

- 「基本的なワークフロー」の直後に「よくあるエラーとその対策」セクションを新設。
- divergent branches fatal (`fatal: Need to specify how to reconcile divergent branches.`) を「設定がまだ終わってないサイン」として実画面スクショ + テキスト引用 + `system("git config --global pull.rebase false")` の対策を明記。
- 他のエラー (CONFLICT, rejected, would be overwritten) は `git-trouble.html` へのリンクで誘導。

### SOS の宛先変更 (git-trouble.qmd)

- 旧: 「Discord の `#質問` か `Thesis/MeetingMemo.md` の『相談』」
- 新: 3つの選択肢を併記
  - ゼミの Discord チャンネル
  - ゼミの AI BOT「ラマヌジャン」 (24時間反応)
  - リポジトリ直下の `Labo-note.Rmd` (**4年生も卒論メモではなく `Labo-note.Rmd` に書く**)

### commit chain

`2314812e` (qmd 初版) → `93d7a60b` (画像+成功例) → `75739238` (divergent スクショ追加) → `516e0ebd` (github-setup 再構成) → `9c0d2ea9` (SOS 宛先変更)。GitHub Pages 反映済み。

## 2026-07-04 GitHub Pages デプロイ失敗の恒久対策 + 監視の自動クローズ

### 背景
- `pages build and deployment`（legacy 自動デプロイ）の失敗メールが 15〜30 分おきに連発。
- 原因: Pages が legacy モード（main /docs）で、すべての push でデプロイが走る仕様。サーバ状況の自動コミット（Al-Khwa cron が 15 分ごとに `data/server_status.json` のみ更新・docs 外）でも毎回 docs 全体を再デプロイし、間隔が詰まると GitHub 側で衝突し `Deployment failed, try again later.` で失敗していた。サイト自体は正常（次実行が再公開）で実害はメールのみ。
- server-status ページは `data/server_status.json` を raw.githubusercontent.com からクライアント fetch する設計 → 状況更新に docs 再デプロイは本来不要。

### 対策（deploy-pages.yml 新設）
- `.github/workflows/deploy-pages.yml` を追加。`paths: docs/**` で docs 変更時のみ起動、`concurrency: group pages / cancel-in-progress false` で直列化。
- Pages を `gh api -X PUT .../pages -f build_type=workflow` で legacy → GitHub Actions モードに切替。カスタムドメイン labo.kosugitti.net は保持。
- 検証: 新 workflow が push/手動起動とも成功、サイト HTTP 200、09:00 の状況コミット（data/ のみ）でデプロイ run ゼロを実機確認。commit 396bc1df2。

### サーバ健全性確認
- `data/server_status.json` は数分おきに更新継続、6 台すべて online（Al-Khwarizumi/Shimura/Taniyama/Seki/Gauss/RaspberryPi）。負荷・GPU 温度正常。監視パイプラインは生存。

### 監視の自動クローズ追加（monitor-servers.yml）
- 5/26〜6/5 の更新停止インシデントのアラート issue #3 が復旧後も 1 か月開きっぱなし（自動クローズ機能なし）→ 手動クローズ。
- `monitor-servers.yml` に「Close alert issues if recovered」ステップを追加（stale=false の回に開いている server-alert issue へ復旧コメント + close）。手動起動で success 確認。commit 1ad944ed4。

## CLAUDE.mdからの退避 (2026-07-07)

CLAUDE.mdのダイエットに伴い、過去の経緯・旧構想を一字一句そのまま以下に退避。

### コンテンツ構成案（旧: 改訂予定）

- Part 1: 基礎の基礎（Rの基本操作）
- Part 2: データを読み込んで眺める
- Part 3: 可視化ギャラリー巡り
- Part 4: 図を描いてみよう（基礎編）
- Part 5: データを整形する（tidyverse入門）
- Part 6: 整形 → 可視化の連携
- Part 7: 高度な可視化への挑戦
- Part 8: 自由課題

※ 上記はユニット設計により再構成予定

## 進捗管理システム構想（2026-02-14）

### 基本方針

学生ごとのGitHubリポジトリ（`~/Dropbox/Git/Zemi/StudentName/`）を活用し、学習進捗を可視化・管理する。

### システム構成

```
学生リポジトリ/
├── progress.yml              # 進捗データ（自動生成）
├── submissions/              # コード提出フォルダ
│   ├── U8/
│   │   ├── 8-B-1.R
│   │   ├── 8-B-2.R
│   │   └── ...
│   ├── U7/
│   └── ...
├── dashboard.qmd             # Quartoダッシュボード
├── .github/workflows/
│   └── render-dashboard.yml  # 自動レンダリング
└── docs/
    ├── index.html            # ダッシュボード（双六風マップ）
    └── input.html            # 進捗入力フォーム
```

### 学生の作業フロー

1. **課題を解く**: kosugi-laboのRドリルで学習
2. **コード提出**: ランクBの課題は`submissions/U8/8-B-1.R`にコードを保存
3. **進捗入力**: `docs/input.html`（GitHub Pages）でチェックボックスにチェック
4. **commit/push**: Gitでリポジトリに反映
5. **自動更新**: GitHub Actionsがダッシュボードを再レンダリング

### 進捗入力フォーム（input.html）

- **ランクC**: チェックボックスのみ（webexercisesで自己採点済み）
- **ランクB**: チェックボックス + **コードファイルアップロード必須**
- **ランクA**: チェックボックス + AIとの対話ログ・スクリーンショット（optional）
- 送信ボタン → GitHub API経由で`progress.yml`更新 + `submissions/`にファイル保存

### ダッシュボード（dashboard.qmd）

**可視化要素:**
- **双六風スキルツリーマップ**: visNetworkで24ユニットを階層表示
  - 完了ユニット: 緑
  - 進行中: 黄色
  - 未着手: 灰色
  - クリックでkosugi-laboの該当ページへリンク
- **ランク別進捗率**: C/B/Aの達成度を棒グラフ表示
- **次のマイルストーン**: 現在地と次の目標課題を表示
- **⚠️ 警告表示**: 「完了とマークされているがコードが提出されていない」課題をリストアップ

**信頼性チェック:**
```r
# progress.ymlで完了マークがあるが、submissions/にコードがない場合は警告
check_code_submission <- function(unit, rank, number) {
  code_file <- glue("submissions/{unit}/{unit}-{rank}-{number}.R")
  file.exists(code_file)
}
```

### 先生側の管理

- 各学生のリポジトリはprivate → 先生と当該学生のみアクセス可能
- GitHub Pages URL（`https://{student}.github.io/...`）でダッシュボード確認
- ゼミ中に「今どこ？」と聞くとき、学生がダッシュボードを画面共有
- 全学生の進捗を一括確認するスクリプト（optional）:
  ```r
  # Zemi/collect_progress.R
  students <- dir("~/Dropbox/Git/Zemi/", pattern = "^[A-Z]")
  all_progress <- map_dfr(students, ~{
    read_yaml(glue("~/Dropbox/Git/Zemi/{.x}/progress.yml"))
  })
  ```

### 技術スタック

- **GitHub Pages**: ホスティング（サーバ不要）
- **Quarto**: ダッシュボード生成
- **visNetwork (R)**: スキルツリーの可視化
- **GitHub Actions**: 自動レンダリング
- **Vanilla JS**: 進捗入力フォームのフロントエンド
- **GitHub API**: progress.yml更新、ファイルアップロード

### 未解決課題

- [ ] 進捗入力フォームでGitHub APIを叩く認証方法（Personal Access Token? GitHub App?）
- [ ] ファイルアップロードのサイズ制限・形式チェック
- [ ] ランクAの評価基準（コード提出なし、自己評価のみでOK？）
- [ ] スキルツリーの双六風デザイン（vis.jsのレイアウト調整 or 手描きSVG?）

### 将来の拡張案

- 学生間の匿名平均進捗率を表示（モチベーション向上）
- 所要時間トラッキング（各課題にどれくらい時間がかかったか）
- バッジ・実績システム（「全Cランククリア」「初のAランク達成」等）
- ゼミ全体のヒートマップ（どのユニットで詰まる学生が多いか）
