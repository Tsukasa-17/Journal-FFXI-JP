# GPL source provenance
- data/npc_positions.lua: LandSandBoat data/zones/*/npcs.yamlから、data/npcs.luaにある名前の位置を抽出したと元ヘッダが明記。
- data/zone_links.lua: data/zones/*/zone.yamlのzonelines由来。徒歩リンクで船/飛空艇等を除外したと元ヘッダが明記。
- 2ファイルとも元ヘッダ/完全な編集可能Luaソースをそのまま保持。日本語版でこの2テーブル自体は変更していません。
- Verified commit e13548e: https://github.com/LandSandBoat/server/commit/e13548e95bc3e9246eea18318fa53714adc38784
- Verified commit 204a64c: https://github.com/LandSandBoat/server/commit/204a64cb80cfcf11edae06a4b628739839bc4cae

元アドオンは変換ジェネレータを含まないと説明しています。本配布物はバイナリではなく、そのまま編集して使用するLuaソースです。上流サーバのソースは上記の固定コミットから取得できます。サーバの一部だけを改変したプログラムを隠しているものではありません。

両固定コミットのLICENSE本文を公式GitHub読み取りAPIで確認し、同梱COPYINGのGPL version3本文と一致しています。
