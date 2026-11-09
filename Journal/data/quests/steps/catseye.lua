local Q = {}

Q.STEPS = {
    catseye_featherweight = {
        'このクエストは日本時間の0時を過ぎるごとに再受注できます。',
        '北の中庭2階にいるYagudo Outlawを見つけます。*マップ2のF出口*',
        '彼から七結節のキープスと十三結節のキープスの両方をリトリーブするように要求されます。これは初回のみ必要です。',
        'それらをヤグードに渡してクエストを完了すると、メリファト山地にあるヤグードアリーナへの進入権を得られます。',
        'Yagudo Outlaw に 獣人銀貨を4枚トレードすると、たたかえに参加できるようになります。500ギルを受け取ります。 これは入場ごとに支払う必要があります。',
        'レベル50制限のたたかえでたたかえを行うため、メリファト山地 (K-8) に仲間を集め、適切にギア族してください。このたたかえはアライアンスで戦うことができます。',
        'NMのグループが出現します（敵は毎回ランダムに選ばれます。CatsEyeXI Content/Crystal 戦士の Yagudo Arena セクションを参照してください）。',
        '3体の敵をすべて倒した後、光る場所を再度調べてコッファーを出現させ、報酬を受け取ります。',
    },

    catseye_rock_cooking = {
        '(E-5)にあるDusty Footprintを調べます。',
        '獣人貨を12個トレードするとクエストが完了します。 これは初回のみの支払いです。',
        'Smolderoqが火成岩を焼き、中にどんな宝石がワスかを確認してくれるようになります。',
    },

    catseye_thread_bare = {
        '大統領補佐官室（大統領執務室の右側）にいるMathiasに話しかけると、共和国の布資材不足についてラメントします。もう一度話しかけて「For the Republic!」を選択すると、調査を行えばクロウラーの巣が適切な供給源になるかもしれないと提案してきます。',
        'マップ1の(J-9)にあるVantage Pointを調べます。',
        'Mathiasのところに戻ります。',
    },

    catseye_clink_to_the_past = {
        'Dadaroonは アーモンド x12を要求しています。これは北のナシュモ出口の外にいるMarsh Murreから集めることができます。',
        'アーモンドをトレードした後、Dadaroonはさらに アトルガン黄金貨 x5を要求します。皇国金貨はアトルガン白門 (G-9) にいるUgrihdから皇国軍戦績1000点で購入できます。',
    },

    catseye_broken_bones = {
        'Felynaと話した後、カルゴナルゴ城砦〔Ｓ〕へ向かいます。',
        '城砦に入り、西出口へ進みます。',
        '(E-8)の南端にある崖の最も北側の部分まで走ります。',
        'Buried Noteを調べて丸めたメモを受け取ります。',
        'マウラのFelynaのところに戻るとクエスト完了です。',
    },

    catseye_here_be_dragons = {
        'セルビナの羊飼いの宿舎にいるKhartesと話すとクエストが開始します。',
        'テリガン岬のエリア境界からグスタフの洞門へ移動します。',
        '(D-11)にある\'\'\'Miner\'s Helmet\'\'\'を調べると、ワイバーン族のノートリアスモンスターであるOre Melterが出現します。 たたかえはレベル制限がありませんが、Lv60なら容易に討伐できます。 HPは約1250です。',
        'ワイバーン族を倒した後、Khartesのところに戻るとクエスト完了となります。',
        '真界にいるCrystal Guideと話すと、グスタフの洞門での採掘が解放されます。',
    },

    catseye_goblin_s_gambit = {
        'This quest is repeatable Daily (JP Midnight).',
        'More info on the Crystal Warrior Content page',
        'Travel to Oldton Movalpolos and talk with Bagatrix.',
        'Trade Gold Beastcoin x4 to them. At minimum one person in the party needs to trade the coins to start the fight. Anyone not trading coins will receive a Dragon Chronicles as their reward.',
        'At minimum one person in the party needs to trade the coins to start the fight. Anyone not trading coins will receive a Dragon Chronicles as their reward.',
        'The party will be drawn in to a fight against two goblins (WHM and BST) and a pet bat. Suggested Order: Bat -> BST (Hog) -> WHM (Long) WHM will use benediction and cast Cure VI. He can be Silenced and Slept. BST will not charm, nor resummon pet. Can be Slept. All goblins use debuff dice. Prepare to wake party with Divine Waltz/Curaga.',
        'Suggested Order: Bat -> BST (Hog) -> WHM (Long)',
        'WHM will use benediction and cast Cure VI. He can be Silenced and Slept.',
        'BST will not charm, nor resummon pet. Can be Slept.',
        'All goblins use debuff dice. Prepare to wake party with Divine Waltz/Curaga.',
        'Once victorious talk with Bagatrix again and choose a reward from one of the three chests.',
        'The contents of each chest changes each Vanadiel day. Coordination between party members may be required to sus out which chest holds what type of loot. One chest contains 1x spell scroll, an augmented weapon, and some miscellaneous items. Another chest contains 1x trust cipher, an augmented weapon, and some miscellaneous items. The other chest contains 1x PUP attachment , an augmented weapon, and some miscellaneous items.',
        'One chest contains 1x spell scroll, an augmented weapon, and some miscellaneous items.',
        'Another chest contains 1x trust cipher, an augmented weapon, and some miscellaneous items.',
        'The other chest contains 1x PUP attachment , an augmented weapon, and some miscellaneous items.',
    },

    catseye_finding_nemosyne = {
        '魔法屋にいるLethebに2回話しかけ、依頼を受けます。',
        '龍のねぐらへ行き、(G-7)にあるウォータを回収します。（最初の池の部屋を通り過ぎないでください。通り過ぎてしまうと最初からやり直すことになります！）',
        'Lethebのもとに戻ると報酬を受け取れます。',
        'Nemosyneはジュノ上層の大聖堂にいます。',
    },

    catseye_digging_up_dirt = {
        'ジュノ下層 (I-7) の天晶堂前文机にいるSebastianに話しかけます。',
        'バルガの舞台（ギデアス）のBCNM部屋へ向かいます。部屋の中に隠されているDirtを調べます。',
        'ジュノ下層のSebastianのもとに戻ります。',
        'ワールンの祠（パルブロ鉱山）のBCNM部屋へ向かいます。部屋の中に隠されているDirtを調べます。',
        'ジュノ下層のSebastianのもとに戻ります。',
        'ホルレーの岩峰（ゲルスバ）のBCNM部屋へ向かいます。部屋の中に隠されているDirtを調べます。',
        'ジュノ下層のSebastianのもとに戻るとクエストクリアとなります。',
        '以後、Domenic (J-7) に話しかけることで、ゲルスバ野営陣、ホルレーの岩峰、ワールンの祠、バルガの舞台、ク・ビアの闘技場のBCNMへのテレポが利用可能になります。',
    },

    catseye_up_up_and_away = {
        'Disarmed Knightは1階のCの扉へ向かう通路にいます。階段は上がらないでください。',
        '訓練物資（Training supplies）はデルクフの塔上層のマップ1、10階(I-9)の、NM「Porphyrion」およびエレベーターと同じ部屋にあります。隠しチェストの奥にある場合があります。',
        'エレベーターを利用する場合は、上がる前にフェイスを呼び出しておくことができます。',
        'Disarmed Knightに話しかけるとクエスト完了となります。',
    },

    catseye_boxed_up = {
        'Bring Rusty Hammer one each of Phoenix Feather , Mahogany Log , Rosewood Log , Ebony Log . All items can be logged in Bibiki Bay ( custom HELM ).',
        'All items can be logged in Bibiki Bay ( custom HELM ).',
        'After trading the four logs, Rusty Hammer will request additional materials from Carpenters\' Landing : a piece from a crooked trunk, next to a collapsed bridge.',
        'Travel to Carpenters\' Landing using the western Jugner Forest (E-6) entrance, and find the Crooked Trunk at (G-9)',
        'Prepare a small group for a level 40 capped fight against a Treant.',
        'After the fight inspect the Crooked Trunk.',
        'Return to Rusty Hammer in Northern San d\'Oria .',
    },

    catseye_gobbie_travels = {
        'Speak to Portalix (Inside Muckvix\'s Junk Shop) to flag this quest.',
        'Collect the requested items, available off of beastmen connected to each region. Meriphitaud Mountains Yagudo for Astrum, Quadavs in Pashhow Marshlands for Luna and Orcs in Jugner Forest for Lux.',
        'Meriphitaud Mountains Yagudo for Astrum, Quadavs in Pashhow Marshlands for Luna and Orcs in Jugner Forest for Lux.',
        'Once you have collected all 3, return to Portalix for your rewards.',
    },

    catseye_out_of_stock = {
        'Shady Dealerに話しかけます。',
        '彼に 火打石を12個トレードします。',
        '再びShady Dealerに話しかけます。',
        '彼に 甲虫の甲殻を1個トレードします。',
        'Shady Dealerに話しかけます。',
        '彼に 銅鉱を1個トレードします。',
    },

    catseye_near_death_experience = {
        'タブナジア地下壕 (I-5)の上層出口から出るか、サバイバルガイド/Outpost デジョンを利用します。 ルフェーゼ野へ行くにはプロマシアの呪縛 1-3 母なる石をクリアしている必要があります。',
        'ルフェーゼ野 (E-8)の Andrus に話しかけます。',
        'Andrus から失くしたページを探すよう頼まれ、まずは1枚目を持ってくるように言われます。 次のページを探す前に、ページを見つけるたびに Andrus の元へ戻る必要はありません。',
    },

    catseye_blast_to_the_past = {
        'バタリア丘陵 (S) (H-5) にいる Ash に話しかけます。周辺にいるLv60以上のゴブリンに注意してください。',
        'Ash から失くしたページを探すよう頼まれ、まずは1枚目を持ってくるように言われます。 次のページを入手する前に、ページを見つけるたびに Ash の元へ戻る必要はありません。',
    },

    catseye_a_crystal_prelude_san_d_oria = {
        '東ロンフォール経由で龍王ランペールの墓に入ります。',
        '(J-6)の中央東側に行くと、隅に Robineaux が立っています。',
        '...',
    },

    catseye_ring_around_the_roses = {
        '北サンドリア (I-8) の噴水の隣の花壇を調べる。',
        '南サンドリア (M-8) の Aeolia に戻る。',
    },

    catseye_hungry_customer = {
        '南サンドリアの宿屋「ライオン Springs」(K-6) にいる Couquillard に、野兎の肉を3つ渡す。繰り返しできる。',
    },

    catseye_in_sheep_s_clothing = {
        'Chilly Wolfが 大羊の毛皮 x3を求めています。',
        'このクエストは繰り返し可能で、彼は渡された羊皮の数を記録しています。',
    },

    catseye_hatchet_job = {
        '野兎のグリル を入手します。（野兎の塩焼き と間違えないように注意してください！） サンドリア港 の「 Rusty Anchor 」にいる Antreneau に 野兎の肉 を5個トレードし、クエスト「小公望」をクリアすることでも1個入手できます。',
        '東ロンフォール の (I-7)（北西の角、木の後ろ）にいる Aesculian に話しかけます。',
        'Aesculian に 野兎のグリル をトレードします。',
        '真界 にある Crystal Guide book に話しかけて フィールドチュニカ を受け取ります。 Mining My Business と Reaping Rewards もクリアしていると フィールドチュニカ が報酬として受け取れます。これは Provinence にある Crystal Guide Book で行われます。',
    },

    catseye_fleeing_daylight = {
        'Phoenix Perch Inn の中にいる Tenebraux に話しかけます。',
        'リーチ族から 鳥の血 を6個ドロップで入手します。',
        'Tenebraux に 死鳥族 をトレードします。',
    },

    catseye_on_guard = {
        'Somnelius is located in the watchtower via exit 3 from Northern San d\'Oria.',
    },

    catseye_on_watch = {
        'Somnelius は 北サンドリア の3番出口から行ける監視塔にいます。',
        '西ロンフォール の (F-5) へ向かいます。',
        '坂道にある光る Orcish Marking を見つけます。',
        'それを調べると レベル10制限がかかり 、NMの Orcish Watcher が出現します。 少なくともアームブロックを使用します。 HPは約170です。 スキルと装備が整ったモ/シであれば、「百烈拳」なしでも簡単にソロ討伐できます。',
        '戦闘後、再び Orcish Marking を調べます。',
        'Somneliusのところに戻り、報酬を受け取ります。',
    },

    catseye_counting_lost_sheep = {
        '南サンドリア (E-7) にいるFrerehnに話しかけます。',
        '東ロンフォール (J-6) にあるWool Clumpを調べます。',
        '東ロンフォール (G-8/G-9) にあるWool Clumpを調べます。',
        '東ロンフォール (J-10) にあるWool Clumpを調べると、屍犬族のNMが出現します。',
        'レベル無制限のたたかえでFaarwulv NMを倒します。HPは180未満です。',
        'Frerehnのところに戻ります。',
    },

    catseye_staying_afloat = {
        '西または東ロンフォールで伐採またはマイチョコボ掘りを行い、どんぐりを12個入手します。',
        'Archimedesはこれまでに納品したどんぐりの数を記録しています。',
    },

    catseye_rambling_around = {
        'Glendaに2回話しかけてクエストを受けます。 Glendaはローゼルの防具店内にいます。',
        '西ロンフォールの南 H-11へ向かいます。',
        '光る大羊族（ラム） Woolを調べてWild 大羊族（ラム）を出現させ、倒します。 レベル制限はありません。 Wild 大羊族（ラム）のHPは約474です。 Wild 大羊族（ラム）は大咆哮を使用できます。 夜間は聴覚感知のTainted 屍犬族がいるため注意してください。',
        'Glendaのところに戻ります。',
    },

    catseye_rambling_around_ii = {
        'Glendaから ラノリン 2個を要求されます。',
        'このクエストは繰り返し可能で、彼女は納品された数を記録しています。',
    },

    catseye_saving_my_hide = {
        '革細工ギルドのバルコニーにいるAlutanie（D-8）に話しかけます。 クエストを受領するにはもう一度話しかける必要があります。チャットログにクエスト受領が表示されます。',
        'ジャグナー森林の湖の端にある（I-6）へ行き、「剣虎族 Tracks」を見つけます。',
        'しじをさせろになったら足跡を調べ、「はい」を選択してたたかえを開始します。',
        'Greater 剣虎族が出現します。レベル制限はなく、フェイスを使用できます。*HPは約500です*',
        '剣虎族を倒したら、もう一度足跡を調べて「a かくれる of the greater 剣虎族」を入手します。',
        '（D-8）のAlutanieのところへ戻り、報酬を受け取ります。',
    },

    catseye_a_matter_of_trust_san_d_oria = {
        'サンドリア港の（G-8、さびた錨亭内）にいるKeenajaquesに話しかけます。',
        'レベル10制限のたたかえでCrystal Weaponとたたかえする準備をします。Crystal WeaponのHPは約265です。',
        'ラテーヌ高原の（L-8/L-9）にある、ホラの岩の裏のサーメット構造物付近で「Crystal Anomaly」を調べます。選択肢を選んでたたかえを開始します。',
        'Crystal Weaponを倒した後、再び「Crystal Anomaly」を調べるとイベントが発生します。',
        'Keenajaquesのところへ戻ると、最初のフェイス枠とフェイス: クリルラを受け取れます。',
    },

    catseye_a_matter_of_trust_ii_san_d_oria = {
        'サンドリア港の（G-8）にいるKeenajaquesに話しかけます。',
        'ラテーヌ高原 (F-7) から オルデール鍾乳洞 に入り、最初のマップの (I-3) へ移動して Vertiumaix を探します。',
        'しじをさせろ 状態でフェイスを呼び出し、Vertumaix に話しかけると Snoring Somatix というゴブリンが出現します。*HPは約400です*',
        'Somatix を倒した後、再び Vertiumaix に話しかけます。 たたかえ の後、Vertiumaix が消滅している場合があります。50ヤルム離れるかエリアチェンジをして再出現させてください。',
        '彼女の目の前にある光るポイントを調べるよう言われますので、調べて「岩盤の破片」を入手します。',
        'Keenajaques のところに戻って話しかけ、岩盤を渡すとクエスト完了です。',
    },

    catseye_a_matter_of_trust_iii_san_d_oria = {
        'Speak with Keenajaques again and he will ask that you acquire Sunsand x1 from Valkurm Dunes. Inspect the boat at H-9 during earth weather to get the sunsand.',
        'Inspect the boat at H-9 during earth weather to get the sunsand.',
        'Trade the sunsand to Keenajaques, and he will ask you to go to Davoi.',
        'Inspect the Rendezvous Point on the top of the cliff at H-9. This will spawn two bat trio NM\'s which must be defeated in a level 40 sync\'d fight. The path up to the point is highly dangerous. A significant number of level 45-49 orcs spawn around the rendezvous point, which should be killed before starting the battle. Consider bringing enough friends to make an alliance -- the quest can be completed in one go by an alliance, as everyone gets credit. One possible strategy is to start at the bridge at I-10 and clear orcs up to the rendezvous point one or two at a time.',
        'The path up to the point is highly dangerous. A significant number of level 45-49 orcs spawn around the rendezvous point, which should be killed before starting the battle. Consider bringing enough friends to make an alliance -- the quest can be completed in one go by an alliance, as everyone gets credit.',
        'One possible strategy is to start at the bridge at I-10 and clear orcs up to the rendezvous point one or two at a time.',
        'Once the bats are defeated, inspect the point again to start a brief cutscene.',
        'Return to Keenajaques for your rewards.',
    },

    catseye_chasing_the_light = {
        'Speak to Megasolus in the cathedral basement of Northern San d\'Oria (M-8).',
        'Travel to Sea Serpent Grotto , and past the Gold Door at (I-14), Map 1.',
        'Proceed to Charybdis \' room at (H-11), Map 4 and investigate the Thief\'s Tracks .',
        'Talk once more to Megasolus .',
        'Visit Misareaux Coast and use the Vortex at (G-5). Note : This requires having beaten Dynamis Lord before.',
        'Note : This requires having beaten Dynamis Lord before.',
        'Investigate the Thief\'s Tracks next to Dremi at (H-10) in Escha - Ru\'Aun .',
        'Examine the Crystal Casing at (I-10) to spawn the Eschan Gorger .',
        'Return to Megasolus after defeating the Eschan Gorger for your reward.',
    },

    catseye_a_crystal_prelude_bastok = {
        'Walkthrough information needed! Be the first!',
    },

    catseye_running_rings_around = {
        'Talk to Julberg west in Carmelide\'s Jewelry store @ (I-8) > Then return to Verona, do this back and forth multiple times until you get the ring',
    },

    catseye_bug_report = {
        'Return Insect Wing x4. Bardus seems to keep score of how many you\'ve turned in.',
    },

    catseye_birdsearch = {
        'After talking to Neavias he requests 4 bird feathers. Trade him 4 for 400g.',
    },

    catseye_mining_my_business = {
        'ツェールン鉱山 (J-9)の北西の角にいるIron Diggerに話しかけます。スィートリザードを1個持ってくるように頼まれます。 この材料はGulldagoのチュートリアル中に簡単に入手できます。',
        '彼にスィートリザードをトレードすると、36個のつるはしを受け取れます。',
        'すでに まさかり Job と Reaping Rewards をクリアしている場合は、真界にあるCrystal Guideの本に話しかけると フィールドチュニカを入手できます。',
    },

    catseye_earthen_echoes = {
        '路地にいる Rumbling Valley に話しかけます。',
        'さまざまな方法で 火打石を60個入手します。 龍王ランペールの墓 (H-6)および(K-6/7)のRock Eaterはドロップ率が100%で、24%の確率で2個目の火打石もドロップします。',
        '火打石を Rumbling Valley にトレードします。',
    },

    catseye_buzz_off = {
        '最上階にいるSinister Moonに話しかけます。',
        '彼に 蜂の一刺しをトレードします。',
    },

    catseye_buzz_kill = {
        '南グスタベルグのVomp Hill 3層目（全4層）へ向かいます。',
        '(I-8)へ行き、木の根元にある光るSickly Sapを見つけます。',
        'それを調べると レベル10制限 がかかり、NMのHorrid Hornetが出現します。 少なくとも花粉を使用してきます。 HPは約175です。 百烈拳がなくても、スキルを上げて装備を整えたモ/戦であればソロで簡単に倒せます。',
        '戦闘後、再びSickly Sapを調べます。',
        'Sinister Moonのところへ戻り、報酬を受け取ります。',
    },

    catseye_a_little_courage = {
        'バストゥーク鉱山区 (I-7)の最上階にいるZorvahに話しかけます。',
        '南グスタベルグ (H-9)、ヴォンプの丘への南坂のふもとにあるTiny Breadcrumを調べます。',
        '南グスタベルグ (J-8)、次の階層への坂のふもとにあるTiny Breadcrumを調べます。',
        '南グスタベルグ (G-8)の丘の頂上にあるTiny Breadcrumを調べると、クゥダフ族のNMが出現します。',
        'レベル制限のないたたかえでDuadav Dougherを倒します。HPは180未満です。',
        '再度Tiny Breadcrumを調べます。',
    },

    catseye_chasing_tails = {
        'Galkachemistから トカゲの尻尾を12個持ってくるよう頼まれます。',
        'このクエストは再受注可能で、渡した尻尾の合計数が記録されます。',
    },

    catseye_that_s_all_folks = {
        'Head to South Gustaberg (D-8) The Fumaroles and examine the Hare Tracks. A Gustaberg Hare will spawn(Appx 100-120hp). Return to Conchata for your reward.',
    },

    catseye_in_a_bucket = {
        'Conchata-Potata will pay you * 1800 Gil for every three Crab Shell you deliver to him. He keeps track of the total amount delivered.',
    },

    catseye_wanting_ore = {
        'Ferredec（鍛冶ギルド内 - 1階）に2回話しかけ、「Let\'s get wet」を選択してクエストを受けます。',
        'パシュハウ沼の(I-7)へ向かい、池の端にある「Soft Spot」を探します。',
        'その場所を調べると、高い防御力と典型的なクラブ族のアビリティを持つNM クラブ族「Swamp Scylla」が出現します。',
        'Swamp Scyllaを倒した後、再度その場所を調べて沼鉄鉱の塊を入手します。',
        'Ferredecのところへ戻ると、報酬を受け取れます。',
    },

    catseye_a_matter_of_trust_bastok = {
        'Reisleに話しかけてクエストを開始します。コンシュタット高地での手助けを頼まれます。',
        'メサの裏手、K-5とL-6の境界（南-東側）にあるサーメット構造物の側面のCrystal Anomalyを調べると、Crystal WeaponのNMが出現します。 その場所から遠くない位置に通常のポルターガイストがいるため、魔法を使用する際はご注意ください。',
        '勝利後に再度その場所を調べると、短いカットシーンが始まります。',
        'バストゥークのReisleのところへ戻るとクエスト完了です。',
    },

    catseye_a_matter_of_trust_ii_bastok = {
        'Travel to Gusgen Mines and inspect the Upturned Minecart at J-7 to spawn skeleton NM Fear Apparition. After defeating the NM, inspect the cart again and return to Reisle.',
    },

    catseye_a_matter_of_trust_iii_bastok = {
        'Reisleにもう一度話しかけると、 ダングルフの奇岩石 1個をリトリーブするよう頼まれます。',
        '彼にストーンをトレードすると、ベドーにある見張り小屋を調査するよう頼まれます。見張り小屋は上層のE-7にあります。',
        'Guard Houseを調べると、レベル40制限のたたかえでクゥダフ族のNMが2体出現します。このたたかえではフェイスを呼び出せません。仲間をたくさん連れて行きましょう。',
        'たたかえの後に短いイベントが発生し、Reisleが再び現れます。最後にバストゥークにいる彼のもとへ戻ると、報酬を受け取ることができます。',
    },

    catseye_a_crystal_prelude_windurst = {
        'Erudu-Faluduに話しかけてクエストを開始します。Crystal 戦士のクエストは移動制限なしでテキストが進行するため、話しかけても何も起きていないように見える場合があります。',
        '彼から 草刈鎌を受け取ります。これを大理石の扉を通った西の部屋にある Dangling Roots に使用（トレード）してください。 左側にすぐ見え、ターゲットできます。',
        '手に入れた Revival Tree Rootを Erudu-Faludu にトレードすると、ジョブ専用の初期武器がもらえます。',
        'その後、再び Erudu-Faludu に話しかけて本を探す手伝いを引き受けます。',
        '部屋の周りにある本を調べると、やがてたたかえすべき 薄汚れた書物 が出現します。',
        '討伐後に Erudu-Faludu に話しかけると、トレード用の Adventurer Couponを渡されて東サルタバルタへデジョンされます。 ウィンダス森の区 (F-8)にいるJack of Spadesにそれをトレードしてください。',
    },

    catseye_give_me_a_ring = {
        'ウィンダス森の区 (K-11) の Moyeyo に話しかける。',
        'ウィンダス石の区 (I-4) の Dim Sparkle を調べる。スロープを下りた House of Heroes のそば、ウォータの近く。',
        'Moyeyo に戻る。',
        'ホームポイントの近く (H-9) にいる Abu Dabudabu に会う。',
    },

    catseye_only_the_dose = {
        '蜂族から入手した 蜂の一刺しをPerah Celehsiに渡します。',
    },

    catseye_reaping_rewards = {
        'Fha Mhakyaaは(G-9)の崖の上にいます。坂の登り口は(G-6)、(G-7)あたりにあります。',
        '彼女からハニーエッグのかすめとるを要求されますので、合成で作成する必要があります。調理スキル上限3のレシピで、水のクリスタル、蜂蜜、鳥の卵が必要です。 これらのアイテムはSeleleの初期課題をクリアすることで簡単に入手できます。',
        'すでに Mining My Business と まさかり Job をクリアしている場合は、真界のCrystal Guideに話しかけると フィールドチュニカを入手できます。',
    },

    catseye_rustling_feathers = {
        'Puluki-Culukiから、ヤグードを懲らしめて Yagudo Feathersを4個持ってくるよう頼まれます。',
    },

    catseye_down_to_earth = {
        '目の院（Optistery）西側の屋根の上にいるHermin-Harmonに話しかけます。 ここはウィンダス水の区の北マップにあります。',
        'Starfall Hillock でCrawlerを倒して入手した隕石を彼にトレードします。',
        '彼が隕石から金属を抽出して渡してくれ、クエストクリアとなります。',
    },

    catseye_say_peas = {
        'Peraraに ララブのしっぽ を5個渡します。',
    },

    catseye_get_cracking = {
        '西サルタバルタ の (H-8) へ向かい、木の下にある落ちた巣を調べます。',
        'これによりパーティのレベルが10にシンクされ、レベル10のAngry 死鳥族 が出現します。',
        '怒った鳥を倒し、再度巣を調べて卵を リトリーブ したら、Peraraの元へ戻って渡します。',
    },

    catseye_slowing_down = {
        'Temimi に話しかけます。',
        'Yagudo Initiateから スカルローカスト を4個入手します。',
        'Temimi に Skull Locustをトレードします。',
    },

    catseye_fowl_tales = {
        'ウィンダス石の区 (E-7) の コルモル の邸宅の上にいる Hoi-Boi に話しかけます。',
        'ウィンダス水の区 (K-4) の アコライトホステルの裏にいる Doi-Boi に話しかけます。',
        'ウィンダス森の区 (G-9) の 魔動兵研究所の前の草むらにいる Loi-Boi に話しかけます。',
        'ギデアス (F-4) にある Buried Treasure を調べると、ヤグードNMが出現します。',
        'レベル制限のない たたかえ で Yagudo Pilferer NM を倒します。HPは180未満です。',
        'Buried Treasure を調べて金貨の袋を入手します。',
        'Hoi-Boi の元へ戻ります。',
    },

    catseye_neck_and_neck = {
        'ダルメルについて思いを巡らせているErbelieに話しかけ、大戦前に北サルタバルタを歩き回っていた動物の証拠を探すのを手伝うことに同意します。',
        '西サルタバルタの(I-4/5)へ向かい、木の隣にあるダルメル族 Bonesを見つけます。',
        'これによりゴースト族 ダルメル族が出現します。',
        'Erbelieの元に戻ると報酬を受け取れます。',
    },

    catseye_neck_and_neck_ii = {
        'Erbelie: A dhalmel\'s favorite treat is papaka grass. Collect three springs and I\'ll pay.',
    },

    catseye_feather_forecast = {
        'Speak with Pennana and agree to help her. She will mention that there is a bird with fabulous feathers due in Meriphataud Mountains. "Look for something shiny to lure outaru the bird-wirdy."',
        '"Look for something shiny to lure outaru the bird-wirdy."',
        'Travel to G-10 in Meriphataud Mountains and inspect the Shiny Rock. Because you are, in fact, a bird, you must not only take the shiny object, but also fight a Shrill Jubub for it.',
        'Inspect the rock again after the fight, and return to Pennana with it.',
    },

    catseye_a_matter_of_trust_windurst = {
        'Talk to Sharara near the Jeuno consulate.',
        'You will receive the message in your log you have accepted the quest.',
        'Talk to Sharara again to get a prompt to accept the quest.',
        'Travel to the Crag of Mea in Tahrongi Canyon, and investigate the Crystal Anomaly on the north side of the crag, in I-5. This will spawn a Crystal Weapon NM, which must be defeated.',
        'Investigate the Anomaly again to get a cutscene.',
        'Return to Sharara to complete the quest.',
    },

    catseye_a_matter_of_trust_ii_windurst = {
        'Shararaに再度話しかけて協力を申し出てください。選択肢で「Certainly!」を選びます。奇妙な放射の測定値を収集するためにシャクラミの地下迷宮へ向かうことになります。',
        'タロンギ大峡谷を通ってシャクラミの地下迷宮に入ります。マップ1のF-8にあるOdd Emanationを調べ、放射の発生源から身を守ってください。',
        'NMを撃破したら、再度そのポイントを調べて測定値を収集します。',
        'Shararaのもとに戻ります。',
    },

    catseye_a_matter_of_trust_iii_windurst = {
        'Shararaに再度話しかけて手伝いに同意します。',
        '西サルタバルタのTwinkle Treeから 流星の涙を入手して持ってきます。 木と取引するためには、クエスト「 星降る丘 」を開始しておく必要があります。',
        'その後、Shararaはオズトロヤ城の地下へ行きたがります。',
    },

    catseye_leg_day = {
        'Pedroに話しかけ、彼の研究助手になることを引き受けます。',
        'ダボイの川岸から土のサンプルを採取してくるよう頼まれます。',
        '川岸（River Bank）はJ-11にあります。',
    },

    catseye_leg_day_ii = {
        '今回はPedroからベドーへ行くよう指示されます。',
        'ベドー SludgeはG-7にあります。',
    },

    catseye_leg_day_iii = {
        '予想通り、Pedroからオズトロヤ城のサンプルを要求されます。',
        '砂利のサンプル（Gravel Sample）はマップ5のI-8にあります。 NMのQuu Domi the Gallantと同じ部屋です。',
    },

    catseye_leg_work = {
        '次に、Pedroからクフィム島へ行くよう指示されます。',
        'G-6にあるクフィム Sourceを見つけ、装置を設置した際に引き寄せられるドール族を倒します。',
    },

    catseye_leg_work_ii = {
        'クフィムそのものでは不十分なため、塔の中へ向かいます。',
        'デルクフの塔に入り、最初の角を左に曲がって階段を上がります。',
        'マップ2のE-8へ行き、Delkfutt\'s Sourceをクリックします。',
        '召喚されたツボを倒します。',
        'Pedroのところへ戻ります。',
    },

    catseye_decrypting_antiquity = {
        'Lectilasに話しかけ、手伝うことを引き受けます。',
        '羊皮紙を入手し、エルディーム古墳の碑文を写します。 羊皮紙は合成するか、マウラのPikini-Mikiniから購入できます。',
        'バタリア丘陵の(I-10)にある古墳の正面入り口へ向かいます。',
        '古墳に入り、(J-8)にあるAncient Textに羊皮紙をトレードします。',
        'Lectilasの元に戻ります。',
    },

    catseye_decrypting_antiquity_ii = {
        '再びエルディーム古墳へデルヴし、 古代魔法のパピルスを1個入手します。',
        'それをLectilasにトレードすると、魔法スクロールをランダムで1個受け取れます。',
        'Ephemeral Box/Gramateusまたはマイバッグに対象のスクロールを所持している場合、Lectilasからその同じスクロールを受け取ることはなくなります。',
    },

    catseye_harboring_fugitives = {
        'このクエストは毎日（日本時間0時）再受領可能です。',
        'Agent M97に話しかけると、ズヴァール城外郭にいるDafoeを探すよう頼まれます。',
        'Dafoeはズヴァール城外郭(E-8)のズヴァール城内郭エリア境界にいます。',
        'Dafoeを調べると、レベル50制限のクゥダフ族「Excision M-72」が出現し、強化効果とフェイスが消去されます。',
        'Excision M-72を倒した後、Dafoeをもう一度調べます。 Dafoeが再出現しない場合は、50ヤルム離れてから戻るか、階段の上でエリアチェンジして戻ってください。 確認メッセージは曖昧ですが、「I... can\'t... go on much longer...」と表示されるはずです。',
        'アーティファクト防具クエスト素材が欲しいジョブに着替えてAgent M-97のところへ戻り、2回話しかけます。',
        '静寂の誓約に「はい」と答え、Treasure コッファーを調べます。',
        'アーティファクト防具クエスト素材やランペール戦記を受け取ることができます。手に入るのは合成のアイテムのみです。',
    },

    catseye_empty_handed = {
        '指定された順序（ホラ、デム、メア）で各プロミヴォンエリアを訪れます。',
        '各エリアでEchoを調べます。 ホラ：1階(H-6)南西の角 デム：1階(K-12)木の裏 メア：1階(F-4)',
        '出現したNMを倒します。 ホラ：シンカー族NM「Dwelling Memory」 デム：ゴージャー族NM「Bursting Memory」 メア：クレイヴァー族NM「Piercing Memory」',
        '再度Echoを調べます。',
    },

    catseye_imperial_vault = {
        '4つのアイテムを集めます。 ??? Incursion で入手 ??? Incursion で入手 アラパゴ暗礁域 Incursion で入手 いずれかの Imperial Incursion で入手',
        '4つのアイテムを Vault Keeper にトレードします。',
    },

    catseye_insult_to_gingery = {
        'Gordo-Bordo は 茗荷 を4個求めています。「T0313」または「T0314」での収穫によりごく稀に入手できます。',
    },

    catseye_pecking_battles = {
        'Vermali: この鳥たちを退治してください！ コブリの嘴を6個渡してくれたら報酬を支払います。',
        'Vermali: 十分な数を渡してくれれば、特別なご褒美をあげますよ！ ハハ…',
        '初回納品時の報酬は1800ギルです。',
        '嘴を合計100個納品すると ウィヴルマスク を受け取れます。',
    },

    catseye_the_purse_strings = {
        '開始時は からくり士 である必要がありますが、Carlo に話しかけた後はジョブを変更しても問題ありません。',
        'Carlo から、「T0321」の Decorative Bronze Gate 付近にいるトロールから金を ぬすむ してくるよう頼まれます。',
        'バフラウ段丘 (F-8) の Entrance 2 から ハルブーン に入ります。 バフラウおよび ハルブーン を通り抜けて移動するため、「T0322」と インビジ が必要になります。',
        'ハルブーンの(L-5)にあるDecorative Bronze Gate付近のTroll Cacheを調べると、Troll Treasurerが出現します。 これはレベル10制限のたたかえで、出現時にフェイスは消滅します。 たたかえの難易度は低く、Troll TreasurerのHPは約100〜150です。',
        'たたかえの終了後、再度Troll Cacheを調べます。',
        'Carloのところへ戻ると、オートマトンフレーム用アイテムを選択して受け取れます。 注：もらえるのはアイテムのみであり、皇国軍戦績や貨幣ではありません。 新規プレイヤーへの注：クエスト「天駆ける剣」で最初のレベル30アップグレードに十分な皇国軍戦績と金貨1枚が手に入り、その後の関連クエストで40/50ヘッド用の貨幣も十分に手に入ります。',
    },

    catseye_x_marks_the_spot = {
        'Speak with Captain Farrell in Nashmau as a 75 Corsair to start quest. Speak to him again and accept the quest. You may change to any other job after starting it.',
        'Speak to him again and accept the quest.',
        'You may change to any other job after starting it.',
        'Proceed Arrapago Reef and to retrieve a map. Located on Map 2 (G-8). The Illrusi Atoll Staging Point is is recommended.',
        'The Illrusi Atoll Staging Point is is recommended.',
        'Return to Captain Farrell and speak with them again.',
        'Proceed to Talacca Cove (Caedarva Mire HP) and inspect the coffer there to spawn a Lamia NM. There is no map for the zone, follow the right path along the water.',
        'There is no map for the zone, follow the right path along the water.',
        'After defeating the NM inspect the coffer again.',
        'Return to Captain Farrell to obtain the Caster\'s Die .',
    },

    catseye_x_marks_the_spot_ii = {
        'Speak to Captain Farrell as a 75 Corsair. Speak to him again and accept the quest. Once again a job change is fine.',
        'Speak to him again and accept the quest.',
        'Once again a job change is fine.',
        'Take the boat from Mhaura to Al Zahbi .',
        'Inspect the the artifact at the bow of the boat to spawn a Kraken NM.',
        'Inspect the artifact again after defeating the NM.',
        'Return to Captain Farrell to obtain the Bolter\'s Die .',
    },

    catseye_the_way_of_wadi = {
        'ダングルフの涸れ谷 (I-12)［部屋の南西の角］にあるGalka Footprintを調べてPassing Sunrise（NPC）と話し、クエストを開始します。',
        '(H-11)［同じ部屋の北西の角］にあるSunken Junkを調べるとWeary クラブ族が出現します。討伐後に調べるとShattered Swordを入手できます。 Passing Sunriseのところに戻ると、さらに破片を探すよう言われます。',
        '(H-13)［部屋から南へ続く通路］にあるDamaged Debrisを調べるとWeary Hareが出現します。討伐後に調べるとhaggard hiltを入手できます。 hiltを持ってPassing Sunriseのところに戻ります。探索を継続します。',
        '(J-13)［部屋の中央］にあるDusty Rustを調べるとWeary ワーム族が出現します。討伐後に調べるとbroken bladeを入手できます。 Galka Footprintに戻るとGobby Grindaloxが出現します。 もう一度Galka Footprintを調べると、Passing Sunriseから大工房のBrave Fangへ持っていくためのオニオンソードを受け取れます。',
        '大工房の黒鉄工房(G-9)にいるBrave Fangに話しかけると、最終的な報酬であるオーグメント付きデーゲンを受け取れます。',
    },

    catseye_soup_of_the_day = {
        'Cokhe-Lokheに話しかけてクエストを開始します。',
        '彼に 陸ガニのふんどしをトレードすると、500ギルを受け取れます。',
        'このクエストは再受領が可能です。',
    },

    catseye_head_first = {
        'コンシュタット高地 (L-8)にある Hume Footprint を調べます。',
        'グスゲン鉱山のGhoulから 呪われたサレコウベを入手します。',
        'コンシュタット高地 (L-8)にある Hume Footprint に 呪われたサレコウベをトレードします。',
    },

    catseye_likely_tails = {
        '足跡を調べるとミスラの Shu Rhuli が一時的に出現します。彼女は Wild ウサギ族 Tailsを探しているものの、ブブリム半島は危険すぎると嘆いています。',
        'ブブリム半島へ行き、Mighty Rarabをたたかえして 野兎の尻尾を入手します。',
        'Mithra Tracks に戻り、尻尾をトレードします。',
    },

    catseye_helping_hands = {
        'Manusiel（Shepherd\'s Muster内）に話しかけると、ガガンボの腹虫を要求されます。 注: 彼にガガンボの腹虫をトレードすると、インベントリから失われます。',
        'ワーム族を受け取ると、Manusielはダムジルフライの卵を要求してきます。 これらはバルクルム砂丘の(G-7)、北側の壁沿いにある小さなくぼみ（ゴブリンたちの後ろ）で見つかります。',
        'フェイスを呼び出し、卵を調べると特殊なダムジルフライが3体出現します。',
        'フライを倒して再度卵を調べるとサンプルを入手できます。その後Manusielのもとに戻ると報酬を受け取れます。',
    },

    catseye_rolling_with_punches = {
        'Raving Fistに話しかけると、 ダルメルの唾液を持ってくるよう頼まれます。',
        '(I-7)のMating Groundを調べるとダルメルが3体出現し、周囲のダルメルとリンクします。近くのゴブリンにも注意してください。',
        'ダルメルを倒した後、 Mating Ground を調べてから Raving Fist のところに戻ります。',
    },

    catseye_running_on_the_range = {
        'ラングモント峠のエリア境界のすぐ隣にいるNPCのNefariに話しかけます。 Roasted Remains を見つけて戦闘能力があることを証明するように求められます。',
        'Roasted Remains は東ロンフォール（ラングモントではありません）の(K-5)にあり、マス目の右下（角）にあります。',
        'Roasted Remains を調べると The Malignant ワーム族 が出現します。これはフェイスを出したレベル30であれば簡単に倒せるワーム族族のNMです。倒したらNefariの元へ戻ります。',
        'Nefari からラングモント峠にある5つのアーティファクトを入手してくるよう頼まれます。1つずつ入手し、その都度Nefariの元へ戻る必要があります。',
    },

    catseye_searching_the_citadel = {
        '第1魔防門のすぐ後ろにいるCrampに話しかけます。 マップ1の(G-8)で程よい重さの石を入手します。これがあれば魔防門を一人で開けられるようになります。',
        '彼女からソロムグ原野のNMであるラプトル族を倒すよう頼まれます。NMは(I-9)にあるCreature Tracksに出現します。 仲間を連れて行くことを検討してください。サンダーボルトのブレス攻撃は、レベル50のクリルラのフェイスに500以上のダメージを与えることがあります。',
        'Crampから、探している防具のパーツが要塞内のあちこちにあるScrap Pileに散らばっていることを教えてもらえます。パーツを届けるたびに、次の場所の手がかりを教えてくれます。各パーツを見つけるごとに彼女のところへ戻って次の手がかりを聞かないと、次のパーツを回収することはできません。',
        '1つ目はマップ4の(I-8)にあります。（Serketの部屋）',
        '2つ目はマップ3の(F-8)、第2魔防門のすぐ後ろにあります。',
        '3つ目はマップ2の(G-6)、第3魔防門のすぐ後ろにあります。',
        '4つ目はマップ2の(I-7)にあります。',
        '5つ目は裏口から出た外のソロムグ原野(J-10)にあります。',
        'Crampのところへ戻ります。彼女はレリックがボロボロすぎて自分ではリペアーできないと判断します。',
        'セルビナの裁縫ギルド販売所内にいるRenovioのところへ向かいます。',
        '彼は装備をリペアーするためにいくつかの素材を要求します： シアークラウン -- 骨くず x2 シアーチュニック -- 木綿布 x1 シアーミトン -- サルタ綿花 x2 シアーズボン -- 草布 x1 シアーパンプス -- 草糸 x1',
    },

    catseye_navigating_the_nest = {
        '注意 : Bella に話しかけるとすぐに、Lv40制限のたたかえで Larping Larzy という名前のトカゲ族NMとの戦闘になり、複数のトカゲがリンクする可能性が高いです。 NM自体は非常に簡単ですが、トカゲは手ごわいです。',
        'NMを倒したら、再び Bella に話しかけます。 セット装備の破損したパーツ5個を1つずつ集めて、Bellaのところへ持ち帰る必要があります。 1個渡すごとに新しい手がかりが得られます。 各ポイントの名称はアイテム名にちなんでいます。',
        '1つ目 （Buried beret）は、 Bella の北にあるサソリ族の部屋（I-7とJ-7の間）にあります。スニーク状態であれば絡まれません。',
        '2つ目 （Buried グローブ）は、2枚目マップの段差下（I-8）にある最初のトカゲ族部屋にあります。 Bella の北西から2枚目のマップへ行けます。スニーク状態であれば絡まれません。',
        '3つ目 （Buried ブレー）は、グローブを入手したトカゲ族部屋の北にある甲虫族部屋（H-7）の段差下にあります。 カブトムシは視覚感知で絡んでくるため、ここでインビジを切るのは非常に危険です。素早く調べてインビジをかけ直してください。',
        '4つ目 （Buried boots）は、甲虫族部屋のすぐ南西にある兵隊クロウラー族部屋の段差下（G-7）にあります。スニーク状態であれば絡まれません。',
        '5つ目 （Buried ダブレット）は、洞窟の奥を抜けた外のロランベリー耕地にあります。 出口は、他のアイテムがあった3つの段差部屋の北東にあります。 調べるポイントは湖のそば（D-11）にあります。 調べるとNM Misurgh との戦闘が発生します。 パーティにレベル50以上のメンバーがいれば極めて簡単で、おそらくレベル30前後のNMです。最後のアイテムを回収してください。',
        '最後のアイテムを持って Bella のところへ戻ります。洞窟に戻ればGoV本からスニーク/インビジを受けることができます。 彼女からセルビナにいる Renovio のところへ行くよう言われます。素材を持っていくとギア族をリペアーしてくれます。',
        '必要素材（合計）: 2 マイチョコボ Feather, 10 亜麻, 5 サルタ綿花, 3 大羊のなめし革',
        'ベレー: 2 マイチョコボ Feather, 2 亜麻',
        'ダブレット: 3 サルタ綿花, 1 大羊のなめし革',
        'グローブ: 2 サルタ綿花, 2 亜麻',
        'ブレー: 6 亜麻',
        'ゲートル: 2 大羊のなめし革',
    },

    catseye_negotiating_the_necropolis = {
        'I-10にあるエルディーム古墳の正面入り口へ向かいます。',
        'Alettaに話しかけた後、外のバタリア丘陵へ戻って彼女の恋人を捜します。',
        'J-11の海岸にあるScarred Remainsを調べます。蜂族NMのOsuが出現しますので討伐します。HPは約700で、たたかえの制限はありません。',
        '勝利後、再度遺骸を調べてからAlettaの元へ戻ります。',
        '彼女から地下都市に散らばった防具のパーツを集めてくるよう依頼されます。1つ届けるごとに次の場所の手がかりを教えてくれます。',
        '1つ目の破損したサリットは、H-9の南東にある燭台の部屋にあります。',
        '2つ目の破損したガントレットは、F-9の南西にある燭台の部屋にあります。',
        '3つ目の破損したホーズは、F-7の北西にある燭台の部屋にあります。',
        '4つ目の破損したグリーヴは、H-7の北東にある燭台の部屋にあります。',
        '最後の破片である損傷した胸甲は、(G-8)の中央の落とし穴Aの下の部屋にあります。 中央の落とし穴へ行くには、扉を開けるのを手伝ってくれるもう1人のプレイヤーか、ウィンダス水の区(北)(F-8)の目の院の建物屋上にいるNPC Churano-Shuranoから10,000ギルで購入できるだいじなもの「魔法の天文盤」のいずれかが必要です。',
        '最後の一つをAlettaに届けると、修理してもらうためにマウラの鍛冶ギルド販売処にいるSteel Teethのところへ行くよう言われます。 アイゼンシャレルには 鉄鉱 2個が必要です。 アイゼンブルストには 火打石 3個が必要です。 アイゼンヘンツェには 錆びたバケツ 2個が必要です。 アイゼンディヒリンには にかわ 1個が必要です。 アイゼンシューには 木綿布 1個が必要です。',
    },

    catseye_horutoto_hakken = {
        '東サルタバルタ (J-7) から内ホルトト遺跡に入る。',
        '魔封門を通り抜ける。CatsEyeXIでは「魔封門の札」がなくても、誰でも開けられる。トライマライ水路のサバイバルガイドからホルトトへワープすると早い。',
        'タルタルの調査員 Gan-Ban に話しかける。破片を1つ集めるごとに、Gan-Ban のところへ戻る。',
        '1つ目の破片は、甲虫族の巣窟 (D-12) にある。',
        '2つ目の破片は、同じマップの (F-9)、Maltha の出現地点の近くにある。',
        '3つ目の破片は、同じマップの (G-8)、マホガニーの扉のそばにある。',
        '4つ目と5つ目の破片は、バラの塔の北マップにある土の扉の奥にある。扉には鍵が2つ必要で、1つ目は Gan-Ban が持っている。2つ目は、バラの塔北マップ (G-7) のサンダーの扉の前を調べると出るフォモル族の黒魔道士（レベル27、レベル制限なし）を倒して手に入れる。',
        'Gan-Ban に戻ると、土の扉 (I-7) を開けられる。小部屋のスイッチを操作すると、カーディアン族の敵（レベル30、レベル制限なし）が出る。倒すと、最後の2つの破片を入手できる。',
        'Gan-Ban に戻り、セルビナの織工ギルド (H-9) にいる Renovio を訪ねる。',
        '破片と素材を Renovio に渡して、装備を直してもらう。鉢巻は亜麻糸x2、衣は亜麻糸x1と草糸x2、手甲はラワン材x2、下ばきは毛糸x1、脚絆は木綿糸x2。',
    },

    catseye_all_thine_heart = {
        '大聖堂の扉を調べると、扉の奥からの声にバタリア丘陵の洞窟に住む隠者を探すよう依頼されます。',
        '隠者は(K-7)の洞窟の中に隠れています。',
        '隠者から、ダボイにある本をリトリーブしてくるよう頼まれます。Abandoned Campsiteは(H-8)の川沿いにあります。そこにあるHiding Spotを調べてください。',
        '隠者の元へ本を持ち帰るとカットシーンが再生され、防具と、サンドリア大聖堂へ届けるための本を受け取ることができます。',
        '再び扉の奥の声に話しかけると翼を受け取り、クエスト完了となります。',
    },

    catseye_runic_insurrection = {
        'いずれかのLv75以上のジョブでバストゥーク商業区 (F-10)（ドラゴン族のクローの上）にいる Octavien に話しかけます。ドラギーユ城 (H-9)の摂政の部屋にいる Hetfield を訪ねるよう指示されます。',
        'Hetfield と話すと、ファイアフラワー（fireflowers）を取ってくるよう ギルド桟橋 へ向かうことを命じられます（ 北サンドリア Entrance -> ギルド桟橋 (H-7)）。',
        'Fireflowersを調べると、 ディアボロス召喚 Minion という名前のサンドウォーム族NMが出現します。 レベル制限なしのたたかえで、フェイスは消滅しません。',
        'NM ディアボロス召喚 Minion を倒した後、Hetfieldのところに戻ります。',
        'カルゴナルゴ城砦〔Ｓ〕へ向かい、屋外の(J-8)右上にあるSun Gateを探すよう指示されます。',
        'Sun Gateを調べると、NM ディアボロス召喚 Zealot が出現します。 レベル制限なしのたたかえで、フェイスは消滅しません。',
        'NM ディアボロス召喚 Zealot を倒した後に再度Sun Gateを調べると、「ドラギーユ城のHetfieldに報告に戻るべきです」というメッセージが表示されます。',
        '戻って Hetfield に話しかけます。',
        'かえれの摂政の部屋の扉を調べると、 ソビロクレイモア、 フォイル (スクロール)、ジョブエモーション：魔導剣士を入手できます。 注: 以前に他の手段で ソビロクレイモアを入手していた場合は、この手順を完了する前にそれを捨てる必要があります。',
    },

    catseye_forged_in_frost_and_flame = {
        '魔導剣士Lv40以上でバストゥーク商業区 (F-10)（ドラゴン族のクローの上）にいる Octavien に話しかけます。',
        '大工房 (F-8) 1階のHP2付近にいる Yestin-Ovestin に話しかけます。',
        '炎の石印を入手し、イフリートの釜へ向かいます（クエストを進行する全員が炎の石印を所持している必要があります）。',
        'マップ 7 の(E-7)（「H」の近く）にあるMolten Riftを探します。ラプトル族エリアを回り込み、炎の噴出孔を通り抜ける必要があります。Molten Riftに炎の石印をトレードします（クエストを進行する全員がこの手順を行う必要があります。そうしないと再度たたかえを行うことになります）。',
        '全員がイベントを完了したら、Molten Riftを調べて、ユニークで珍しいタイプの炎の敵を出現させます。敵は範囲のファイア魔法やアビリティを使用してきます。 敵のレベルはプレイヤーのレベルに応じて変動するようです。',
        'たたかえ中、グレートソードのウェポンスキルフリーズバイトまたはフロストバイトを使用して敵をひるませます。これにより敵のブレイズスパイクが解除され、防御力が低下するようです。2回目のフリーズバイト使用では再びひるませることはできませんでした。WS使用後、たたかえ ワス非常に簡単になります。',
        '再度Molten Riftを調べて宝石をリトリーブします。',
        '大工房の Yestin-Ovestin のところへ戻ります。',
        'Octavien のところへ戻り、報酬を受け取ります。',
    },

    catseye_the_way_of_the_blade = {
        'Lv50以上の魔導剣士で、ジュノ下層(H-10)（Gems by Kshama内）にいる Vaulrien に話しかけます。',
        'Bladedancer グリーヴを製作するために、以下のアイテムを持ってくるよう頼まれます。 Runic Ingot ダークインゴット クァールの毛皮 x2',
        'アイテムをトレードしてBladedancer グリーヴを受け取ります。',
        'Vaulrien に話しかけてクエストの次のパートを開始します。Bladedancer ガントレットを製作するために、以下のアイテムを持ってくるよう頼まれます。 Runic Ingot ダークインゴット 金糸',
        'アイテムをトレードしてBladedancer ガントレットを受け取ります。',
        'Vaulrien に話しかけてクエストの次のパートを開始します。ザルカバードへ行き、Rune Wraithを倒すよう頼まれます。 ザルカバードの(F-8)へ向かい、 Runic Gate を調べてRune Wrathを出現させます。 このたたかえは、Lv60魔導剣士とフェイス2体であれば非常に簡単です。',
        'Rune Wraith を倒した後、Vaulrien のところに戻るとブレードダンサーヘルムを受け取れます。',
        'Vaulrien に話しかけるとクエストの続きが始まります。ブレードダンサークウィスを製作するため、以下のアイテムを持ってくるよう頼まれます。 ルニックインゴット x2 ダークインゴット 賢者のストーン',
        'アイテムをトレードするとブレードダンサークウィスを受け取れます。',
        'Vaulrien に話しかけるとクエストの続きが始まります。Demon Hexbinder を倒すためにズヴァール城外郭へ行くよう頼まれます。 ズヴァール城外郭のマップ2にある (H-7) へ向かいます。 Runic Circle を調べると Demon Hexbinder が出現します。 このたたかえは、レベル60の魔導剣士とフェイス2体で簡単に倒せます。',
        'Demon Hexbinder を倒した後、Vaulrien のところに戻るとブレードダンサーブレストプレートを受け取ることができ、クエスト達成となります。',
        'マイバッグが満杯でアイテムを受け取れなかったワスは、空きを1つ作り、エリアチェンジしてから再度 Vaulrien に話しかけてください。',
    },

    catseye_the_unnamed_way = {
        'Speak with Master Lao as any lv75 job in Windurst Waters (South), (K-8), Home Point #3. Located at the end of the dock behind the Rhinostery. At the far-east side of the map (close to Blacktea River).',
        'Located at the end of the dock behind the Rhinostery.',
        'At the far-east side of the map (close to Blacktea River).',
        'Trade Master Lao the Turtle Shell .',
        '"Listen to the sound..." to spawn and defeat elemental NMs in Uncapped fights in the following order:',
        'Investigate Scorched Earth of the Cauldron in Ifrit\'s Cauldron at (G-9) (Lindwurm Map; Map-5), at the lava pit. Quickest route (have sneak & invisible): Survival Guide > then map reference points K > L > (G-9). Clear the area then spawn and defeat Baelfyr [resistant to Silence].',
        'Quickest route (have sneak & invisible): Survival Guide > then map reference points K > L > (G-9).',
        'Clear the area then spawn and defeat Baelfyr [resistant to Silence].',
        'Dry crumbled earth of Western Altepa Desert (E-9) north of the Oasis of Hubol. Quickest route: Use Eastern Altepa Survival Guide and zone into Western Altepa at (E-9). Make your way to (E-9) in the South-West part of Western Altepa Desert . Spawn and defeat Byrgen.',
        'Quickest route: Use Eastern Altepa Survival Guide and zone into Western Altepa at (E-9). Make your way to (E-9) in the South-West part of Western Altepa Desert .',
        'Spawn and defeat Byrgen.',
        'Investigate Frozen earth of Uleguerand (D-8)(E-8) border. Can enter from Xarcabard and take tunnel in lower left. Do not need to go all the way around. Spawn and defeat Gefyrst [resistant to Silence and Paralyze].',
        'Can enter from Xarcabard and take tunnel in lower left. Do not need to go all the way around.',
        'Spawn and defeat Gefyrst [resistant to Silence and Paralyze].',
        'Investigate Scattered Earth of Cape Teriggan on the Southwest corner of (G-6) before the tunnel to Frostmane . Quickest route: Home Point #1 > (It is G-6 but may help to say NW corner of G-7) Spawn and defeat Ungeweder. Can open with Sleep II.',
        'Quickest route: Home Point #1 > (It is G-6 but may help to say NW corner of G-7)',
        'Spawn and defeat Ungeweder.',
        'Can open with Sleep II.',
        'Return to Master Lao Rewarded with Matre Bell , Indi-Poison , Job gesture: geomancer , & Luopan. Note: If you had obtained the Matre Bell by other means before, you need to drop it before being able to complete this step.',
        'Rewarded with Matre Bell , Indi-Poison , Job gesture: geomancer , & Luopan.',
        'Note: If you had obtained the Matre Bell by other means before, you need to drop it before being able to complete this step.',
    },

    catseye_the_earth_holds_its_breath = {
        'The quest will send players to confront a noxious threat... which becomes much less deadly with the help of a geo- or indi-enfeeble.',
        'Speak with Master Lao as Geomancer lv40+ in Windurst Waters (South), (K-8), Home Point #3. Present day not the past.',
        'Head to Norg and talk to Vestavius . He\'s standing on the platform leading to the Captain\'s Hallway.',
        'Obtain a Silver Beastcoin at AH and head to Sea Serpent Grotto .',
        'Go past the Silver Door to the small room at K-10. Click the Corrupted Earth to spawn Deranged Morbol . The Morbol will use an instant-kill breath move during the fight unless it is under the effect of a geomancer enfeeble.',
        'The Morbol will use an instant-kill breath move during the fight unless it is under the effect of a geomancer enfeeble.',
        'Note: The fight scales based on your level. I went as 75 Whm/Geo for Indi-Poison . At level 75 with 5 trusts it was an easy fight.',
        '(Optional) Go back to Norg and talk to Vestavius for a short dialog.',
        'Go back to Master Lao for your two rewards.',
    },

    catseye_echoes_of_the_earth = {
        'Lv50以上の風水士で、ジュノ下層 (H-9)（オソン洋品店内）の Nahele に話しかけます。',
        'Tellurist Bootsを仕立てるため、以下のアイテムを持ってくるよう頼まれます。 Geoweave Thread x2 絹布 サーメットチップス',
        'アイテムをトレードすると、Tellurist Bootsを受け取れます。',
        'Nahele に話しかけると、クエストの次の段階が始まります。Tellurist グローブを仕立てるため、以下のアイテムを持ってくるよう頼まれます。 Geoweave Thread x2 ビロード 金糸',
        'アイテムをトレードすると、Tellurist グローブを受け取れます。',
        'Nahele に話しかけると、クエストの次の段階が始まります。聖地ジ・タへ行ってStormtalonを倒すよう頼まれます。',
        'Stormtalonを倒した後、Naheleのところに戻るとTellurist スロップスを受け取れます。',
        'Nahele に話しかけると、クエストの次の段階が始まります。Tellurist サークレットを仕立てるため、以下のアイテムを持ってくるよう頼まれます。 Geoweave Thread x2 絹布 カーネリアン',
        'アイテムをトレードすると、Tellurist サークレットを受け取れます。',
        'Nahele に話しかけると、クエストの次の段階が始まります。ロ・メーヴへ行ってPetrified Spiritを倒すよう頼まれます。',
        'Petrified Spiritを倒した後、Naheleのところに戻るとTellurist ローブを受け取り、クエスト完了となります。',
    },

    catseye_daddy_issues = {
        'ジュノ上層にいるBrittanyに話しかけると、踊り子\'s Testimonyをトレードするよう要求されます。',
        '彼女に踊り子\'s Testimonyをトレードすると、話を聞かせてくれます。',
        'ジャグナー森林〔Ｓ〕(K-9) に移動してMindyに話しかけます。彼女はワイドスキャン上ではCoyote コッファーとして表示される場合があります。',
        'やがて彼女からしじをさせろであるかどうか尋ねられ、準備が整うとDaddyという名前のモルボル族NMとのたたかえに突入します。',
        'たたかえの後に、もう一度彼女に話しかけます。',
        'ジュノ上層 (G-7) のBrittanyに再度話しかけて報酬を受け取ります。レベル上限が75に引き上げられます。',
    },

    catseye_immortal_kombat = {
        'アトルガン白門にいるNandiyahに話しかけます。',
        '彼に偉大な青魔道士の証をトレードします。',
        'エジワ蘿洞のマップ7 (F-11) に移動します。 ワジャーム樹林 (9) (F-11) から進入します。',
        'Razhudに話しかけます。',
        '再度Razhudに話しかけてたたかえを開始します。',
        'たたかえの後に、もう一度Razhudに話しかけます。',
        'Nandiyahのもとに戻ります。',
    },

    catseye_master_of_puppets = {
        'バストゥーク商業区にいるKirkに話しかけます。',
        '彼に偉大な絡繰士の証をトレードします。',
        'カダーバの浮沼 マップ1 (K-5)へ移動します。 ここへ到達するにはアラパゴ暗礁域 マップ1の (J-6) から出ます。 カダーバの浮沼の (I-6) のエリア境界から入ります。',
    },

    catseye_missing_rum = {
        'Interact with Jacquotte in Aht Urhgan Whitegate',
        'Trade him a Cor. Testimony',
        'Travel to Arrapago Reef Map #5 (H-8)',
        'Talk to Morgan',
        'Talk to Morgan again to start a fight',
        'Talk to Morgan again after the fight',
        'Return to Jacquotte',
    },

    catseye_revenge_of_the_nerds = {
        'Interact with Lewis in The Eldieme Necropolis (S)',
        'Trade him a Sch. Testimony',
        'Travel to Pashhow Marshlands (S) (H-5) Enter through hidden passage at the corner of G5/6',
        'Enter through hidden passage at the corner of G5/6',
        'Talk to Poindexter',
        'Talk to Poindexter again to start a fight He will spawn a book which: Does physical attacks for 50-70 Has a TP move that does massive damage for 400-500, so don\'t get too low. He can silence. Bring echoes. First buff up, you\'ll definitely want stoneskin, blink and aquaveil, high interuption when hit To beat him it required 2 hour, Kaustra him off the bat, then Embrava yourself After that just cycle through your nukes with Alacrity',
        'He will spawn a book which: Does physical attacks for 50-70 Has a TP move that does massive damage for 400-500, so don\'t get too low. He can silence. Bring echoes.',
        'Does physical attacks for 50-70',
        'Has a TP move that does massive damage for 400-500, so don\'t get too low.',
        'He can silence. Bring echoes.',
        'First buff up, you\'ll definitely want stoneskin, blink and aquaveil, high interuption when hit',
        'To beat him it required 2 hour, Kaustra him off the bat, then Embrava yourself',
        'After that just cycle through your nukes with Alacrity',
        'Talk to Poindexter again after the fight',
        'Return to Lewis',
    },

}

return Q
