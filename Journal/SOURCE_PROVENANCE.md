# GPL source provenance

2026-11-08: 上流 Journal 0.3.4 は、利用者が渡したアーカイブの内容を取り込む。そのアーカイブの Journal/LICENSE は Kxteel 氏の MIT で、改変と再配布を認め、著作権表示を残す条件です。Nexus の公開欄とは文面が違うため、ここでは ZIP に入っている許諾に従う。作者から別の同意を得たとは書きません。座標データは従来どおり LandSandBoat の GPLv3 です。未使用の calibri.ttf と desktop.ini は取り込んでいません。

- data/npc_positions.lua: LandSandBoat data/zones/*/npcs.yamlから、data/npcs.luaにある名前の位置を抽出したと元ヘッダが明記。
- data/zone_links.lua: data/zones/*/zone.yamlのzonelines由来。徒歩リンクで船/飛空艇等を除外したと元ヘッダが明記。
- 2ファイルとも元ヘッダ/完全な編集可能Luaソースをそのまま保持。日本語版でこの2テーブル自体は変更していません。
- Verified commit e13548e: https://github.com/LandSandBoat/server/commit/e13548e95bc3e9246eea18318fa53714adc38784
- Verified commit 204a64c: https://github.com/LandSandBoat/server/commit/204a64cb80cfcf11edae06a4b628739839bc4cae

元アドオンは変換ジェネレータを含まないと説明しています。本配布物はバイナリではなく、そのまま編集して使用するLuaソースです。上流サーバのソースは上記の固定コミットから取得できます。サーバの一部だけを改変したプログラムを隠しているものではありません。

両固定コミットのLICENSE本文を公式GitHub読み取りAPIで確認し、同梱COPYINGのGPL version3本文と一致しています。
