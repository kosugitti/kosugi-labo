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
