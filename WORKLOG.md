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
