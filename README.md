# UseUpCosme

コスメ（化粧品）の使用期限を管理するiOSアプリです。  
使い切り日を記録してリスト表示し、期限が近いコスメを一目で確認できます。

## 機能

- **ユーザー認証** — サインアップ・サインイン
- **コスメ登録** — 商品名・カテゴリー・使用開始日・使い切り期限日・画像を登録
- **一覧表示** — 残り日数をカウント表示（期限が近いほど色が変化）
- **カテゴリーフィルタ** — カテゴリーで絞り込み
- **詳細・編集** — 登録内容の確認・編集
- **使い切り記録** — 使い切ったコスメをアーカイブへ移動
- **アーカイブ** — 使い切り済みコスメの履歴一覧

## 技術スタック

- **言語**: Swift
- **UIフレームワーク**: UIKit
- **ローカルDB**: [RealmSwift](https://github.com/realm/realm-swift) — データの永続化
- **ライブラリ**:
  - [KRProgressHUD](https://github.com/krimpedance/KRProgressHUD) — ローディングインジケーター
  - [NYXImagesKit](https://github.com/Nyx0uf/NYXImagesKit) — 画像リサイズ処理

## アーキテクチャ

クリーンアーキテクチャをベースにしたレイヤー構成を採用しています。

```
UseUpCosme/App/
├── Core/
│   ├── Domain/
│   │   ├── Entities/       # CosmeModel, CosmeCategory
│   │   └── Protocols/      # ドメイン層のインターフェース定義
│   └── Application/
│       ├── Services/       # AddService, CosmesListService, EditService
│       └── Protocols/      # ユースケース層のインターフェース定義
├── Infrastructure/
│   └── RealmManager.swift  # Realm を使ったデータアクセス実装
├── UI/
│   ├── ViewControllers/    # 各画面の ViewController
│   └── TableViewCells/     # カスタムセル
├── View/
│   ├── StoryBoard/         # Storyboard ファイル
│   ├── Views/              # カスタムビュー
│   └── Protocols/          # ビュー層のプロトコル
└── Extension/              # Date, UIColor, UIViewController などの拡張
```

## セットアップ

### 前提条件

- Xcode 14 以降
- CocoaPods

### 手順

1. リポジトリをクローン

```bash
git clone https://github.com/Asady1113/UseUpCosme.git
cd UseUpCosme
git checkout feature_refactor_architecture
```

2. CocoaPods でライブラリをインストール

```bash
pod install
```

3. `UseUpCosme.xcworkspace` を Xcode で開く

4. シミュレーターまたは実機でビルド・実行
