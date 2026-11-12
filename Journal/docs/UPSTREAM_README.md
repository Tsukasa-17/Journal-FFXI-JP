# FFXI Journal

FFXI Journal is an Ashita addon for **Final Fantasy XI** focused on providing a unified in-game journal for missions and quests.

**Author:** Kxteel
**Version:** 0.3.7

It includes mission and quest progression tracking, organized quest categories, objective lists, detailed quest information, a pinned Tracker, and controller/keyboard navigation.

## Compass, alerts and arrows in the game world

**Compass.** "Point compass here" points the compass at the NPC of the current step of a quest or mission. The list of NPCs chosen with the search and the pins of the Tracker also show in it. When you get within 30 yalms of an NPC (kept up to 35) that starts a quest you can start, or that has a quest of yours in progress, the NPC is added to the compass by itself (at most 3 automatic ones, and the compass opens if it was closed); its quests are listed under it and a click opens them in the Journal.

**Alerts.** "Quest Nearby" (near an NPC) lists the quests you can start there. "Quest In Progress" (when you enter a zone) lists the quests you have in progress that belong to that zone, stays a little longer, and its quests open in the Journal with a click. A quest can be started when your main job has the level it needs and the quests it follows are completed; this is read from the requirements and from the text of the first step. Skill, job, mission and expansion pack requirements are not checked. Fame is checked for the quests of San d'Oria, Bastok, Windurst and Jeuno that say `Fame N`, once you have read the Fame of that nation.

**Arrows in the game world (prototype).** `/journal mark [on|off|debug]` (or the checkbox in Settings > Compass) draws arrows over the NPCs of the compass in the game, found with the camera of Direct3D. It is off by default.

- Yellow down arrow: the NPC has a quest you can start, or it is the target of the compass.
- Grey: every quest the NPC starts waits for a quest you have not completed.
- No arrow: every quest the NPC starts needs a level your main job has not reached (and quests not implemented on the server).
- Green circular arrow, turning: the NPC has a quest of yours in progress. NPCs that are not in the compass list get it only within 45 yalms (kept up to 50).
- An arrow at the edge of the screen points to an NPC that is out of view or behind the camera.
- Custom icons: put PNG files with a transparent background (for example 64x64) in `assets/arrows/` named `available.png` (yellow arrow), `locked.png` (grey arrow) and `progress.png` (green circular arrow). Each one replaces its arrow, drawn with its bottom on the NPC and a short bob. A missing or unreadable file leaves the arrow of triangles. The files are looked for when the addon loads (`/addon reload journal` after adding them). The arrow at the edge of the screen has no custom icon.
- Settings > Compass: arrow over the compass NPC, arrows over all the NPCs of the compass, green arrow over the NPC of each quest in progress, and arrow at the edge of the screen.
- `/journal mark debug` prints what the addon read from Direct3D, the combination of axes it chose, and how many arrows it draws. Positions of NPCs are the fixed ones of `data/npc_positions.lua`, so an NPC without a known position has no arrow.

## Credits

**Mission / XiQlog — Lexia**
Used as references for mission organization, quest organization, logging concepts, and presentation.

**Chronicle — Jintawk**
Used as a reference for mission and quest tracking, progression state handling, and tracker architecture.
https://github.com/jintawk/ffxi-chronicle

**BG-Wiki**
Used as a factual reference for FFXI missions, quests, NPCs, items, locations, requirements, objectives, and related gameplay information.

**Phoenix Wiki**
The guide for new adventurers follows its "New Player Guide" (https://wiki.phoenix-xi.com/New_Player_Guide).

**LandSandBoat**
The fixed positions of the NPCs used by the compass (`data/npc_positions.lua`) and the walking links between zones (`data/zone_links.lua`) come from its zone data (https://github.com/LandSandBoat/server, GPLv3).

FFXI Journal is an independent project and is not affiliated with Square Enix.

## Status

**Alpha** — the addon is actively being developed and tested.

## Versioning

Versions follow `0.MINOR.PATCH`. From **0.1.6** on, every release is listed in the changelog below, newest first, and the version in `journal.lua` (`addon.version`) matches the latest entry.

## Changelog

### 0.3.7

- General notes: a folder can have a color. Select the folder and pick one of the eight colors (or none) in the Color row; the folder and its notes get a bar of that color in the list.
- Toolbar of the Journal: the **Settings** button is gray with a bright border and sits at the right corner, next to the search box. The Settings window can be resized with its corner and remembers its size between sessions.
- New **menu** button (three lines) to the left of Settings. It opens a list with one row for each function (icon and name). It groups the new adventurer guide and the camps, whose own buttons are gone from the bar; the functions to come go in this list too.
- The **Active Now** button has a green border that pulses (brighter and thicker while its window is open).
- The **Missions** button uses the blue of the missions and the **Quests** button the yellow of the quests: solid when active, a dark shade when not.
- The text size of the Journal goes down to **50%** (before 80%). When the text size changes, the open windows (Journal, sheet, Progress, Active Now, Settings, guide, camps, general notes and help) grow or shrink by the same factor.
- **Items you have**: when a step of a quest or mission asks for an item ("Obtain Honey x5", "Trade the Black Tiger Fang x3 to ..."), a green V is drawn after the name if you have enough of it, and a counter such as (2/5) while you have some but not enough. It is shown in the steps of the Journal, in the quest sheet and in the Tracker. The count includes everything you own that the game lets the addon read: bag, mog safe, storage, locker, satchel, sack, case and the wardrobes (not the temporary items). Key items named by a step get the green V too when you have them. Items named as a reward ("... and receive X") are not marked. The names are read from the game resources in the first moments after the Journal is drawn, so the marks appear a second later. New file `inventory.lua`.
- **Fame** of the nations: the game does not send it to the client, but talking to a Fame Checker NPC (Namonutice in Southern San d'Oria, Flaco in Port Bastok, Zabirego-Hajigo in Windurst Waters or Ney Hiparujah in Kazham, Mendi in Lower Jeuno, Vaultimand in Norg, Waylea in Rabao) starts an event that says the level. The addon reads that event, saves the level for the character and shows it in the new Fame window, opened from the menu button (≡) next to Settings, resizable (the size is saved), with a line between nations and the Fame Checker names clickable to point the compass at them (their positions were added to `data/npc_positions.lua`) (San d'Oria, Bastok, Windurst, Jeuno, Norg, Selbina / Rabao) of the settings window ("Unknown" until you talk to the NPC; it only changes when you talk to the NPC again). `/journal fame debug [on|off]` writes every event packet of the server to the chat and to `fame_log.txt` (addon folder), to check what your server sends. New file `fame.lua`.
- **Quests locked by fame.** A quest that needs more Fame than you have (the `Fame N` requirement of the data, for San d'Oria, Bastok, Windurst and Jeuno) now shows the locked icon in the Journal and the sheet, and counts as locked for the compass arrows and the alerts. It only applies after you have read the Fame of that nation; with "Unknown" fame nothing is locked.
- **Fame of another nation.** A quest can say which nation's Fame it needs with `fame_area` in its data (two Bastok quests, Silence of the Rams and Faded Promises, need the Fame of Norg). Checked against the LandSandBoat scripts: *Ducal Hospitality* now says `Fame 4` (Jeuno) besides its mission requirement.
- **Fame added to quests that lacked it** (from the LandSandBoat scripts): Atelloune's Lament (Fame 2), All at Sea (3), Making Amends (2), Rock Racketeer (3) and, with the nation in `fame_area`, The Sand Charm and A Question of Taste, Everyone's Grudging, Trial by Fire, You Call That a Knife? (Windurst); It's Not Your Vault, Like Shining Leggings, Secret of the Damp Scroll, Stop Your Whining, The Sahagin's Stash (Norg); Under the Sea, The Kuftal Tour, The Missing Piece (Selbina/Rabao).
- **Icon of the Fame Checkers.** The NPCs that read the Fame (Namonutice, Flaco, Zabirego-Hajigo, Ney Hiparujah, Mendi, Vaultimand, Waylea) have their own icon (`assets/arrows/fame.png`, 128x128): over the NPC in the game world when it is in the compass list, before its name in the compass list and in the Fame window, and as the icon of the Fame entry of the menu. A missing file leaves the arrow (world), nothing (lists) or the drawn star (menu).
- **Fame Checkers in the automatic compass.** The NPCs that read the Fame are now found by the proximity radar like the NPCs that start quests: they enter the compass list by themselves when you are within 30 yalms and leave beyond 35 (same setting as the other NPCs, and they count in the limit of 3 automatic ones). They have no quests to list and no "Quest Nearby" banner.
- Alerts of a new quest or mission: the icon of the quest or mission (available) is drawn left of the name. The completed quest and mission alerts have their completed icon too. The "Pin" button is now small and gray, with a pin icon and the word "Pin" ("Fijar"), and the "No thanks" button is gone: the alert leaves by itself after 14 seconds if it is not pinned.
- **Rank and missions:** the addon reads the rank of your character in its own nation (packet 0x061; `/journal rank` shows it). The missions of your nation that need a higher rank show the *locked* icon. The ranks of the other two nations are not sent by the game, so their missions are only locked by the order of the chain.
- **Gate Guards:** the missions of the three nations name their Gate Guards (San d'Oria: Ambrotien, Endracion, Grilau; Bastok: Argus, Cleades, Malduc, Rashid; Windurst: Mokyokyo, Janshura-Rashura, Rakoh Buuma, Zokima-Rokima). They go to the automatic compass when you are close and carry the mission icon (available, in progress or not available).
- New icon `mission_progress.png` (assets/arrows) for a mission in progress: mission rows, Tracker pins and the mission Gate Guards. Without the file, the *available* icon is used.

### 0.3.6

- General notes: every note has a title (the list shows the title, or the first line of the text if it has none) and can be put in a folder. "New folder" creates one; click its name to rename or delete it (its notes are kept, without a folder), and the +/- button next to it collapses it. "New note" creates the note inside the selected folder; the Folder box of a note moves it to another one. The window can be resized with the corner and its size is saved with the notes. Files written by 0.3.5 are read as they are.

### 0.3.5

- General notes: a sticky-note button in the toolbar of the Journal (or `/journal notes`) opens a window with a list of free notes and a text box. The notes are shared by all your characters and are saved in `shared_notes.lua` (in Ashita's `config/addons/journal/` folder, or in the addon folder if that cannot be written). The list holds up to 100 notes of 2000 characters. Deleting a note asks for a second click.

### 0.3.4
- The mission lists show a flame-ring icon for the completed missions (`assets/arrows/mission_completed.png`), a padlock one for the ones that are not available yet (`mission_locked.png`), and a book one for the missions in progress and the available ones (`mission_available.png`). A mission is not available when it is not started and an earlier mission of the same story (nation, Zilart, CoP, ToAU, WotG, Adoulin, RoV, ACP, MKD, ASA, TVR) is not completed; the first one not completed is the next to take. It is deduced from the order of the data, so missions with branches may be shown as not available. Without the PNG files the dots stay.
- The quest lists (Journal list, search results, the quests of an area, and the Active Now window) show the quest icon instead of the blue and green dot: in progress, available, or locked. The completed ones show the completed icon (`assets/arrows/completed.png`), and the repeatable ones the repeatable icon; missions keep their dots. Without the PNG files the dots stay.
- The quests in the Tracker have their small icon at the start of the name (available, in progress, repeatable, locked or completed); the missions have the mission icons.
- The quest names in the "Quest in progress" and "Quest nearby" banners also have their small icon before the name (in progress or available).
- Each quest listed under an NPC in the compass window has its small icon before the name (available, in progress or repeatable), the same ones as over the NPC in the game world. Without the PNG files, no icon is drawn.
- The NPCs of the compass window are listed from the closest to the farthest (the ones in another zone go last).
- A click on a quest in the automatic compass or on the name of a quest in the Tracker now opens the **quest sheet** (not the Journal). The sheet can be resized by dragging its corner, and it remembers its size. The names in the banners ("Quest nearby" and "Quest in progress") open the sheet too.
- The automatic compass now adds NPCs from 30 yalms (kept up to 35, before 20 and 30).
- An NPC with a repeatable quest (in progress or completed) keeps the repeatable icon, unless it also has a quest that can be started (yellow) or another quest in progress (green). The automatic compass also lists NPCs whose repeatable quest is completed.

### 0.3.3
- NPCs whose quest is repeatable and already completed keep a blue "repeatable" icon (`assets/arrows/repeatable.png`; without it, a blue arrow).

### 0.3.2
- The custom icons are 30% bigger and sit lower, closer to the head of the NPC.

### 0.3.1

**Arrows in the game world**
- New: custom icons. PNG files in `assets/arrows/` (`available.png`, `locked.png`, `progress.png`) replace the yellow, grey and green arrows over the NPCs. If a file is missing or cannot be loaded, the arrow drawn with triangles is used. See "Compass, alerts and arrows in the game world".

### 0.3.0

First release of the 0.3 series. It brings together the work of 0.2.17 to 0.2.39: routes between zones, pins and NPCs in the compass, the global search, clickable NPCs, alerts for nearby quests and for quests in progress, the automatic compass, and the arrows over the NPCs in the game world (see "Compass, alerts and arrows in the game world" above). No change in the code beyond the version number.

### 0.2.39

**Alerts and compass**
- Changed: the "Quest In Progress" alert (when you enter a zone) stays 3 seconds longer, and a click on the name of a quest opens it in the Journal (a shaded box and a line under the name show it, and the alert goes away).
- Changed: the arrow over the NPC of a quest in progress that is not in the compass list appears only when you are within 45 yalms of the NPC (it stays until 50 so it does not blink at the limit). Before, it showed from the moment you entered the zone. The NPCs that are in the compass list, or are the target of the compass, keep their arrows.

### 0.2.38

**Alerts**
- Changed: the alert when you enter a zone now lists the **quests you have in progress** that belong to that zone (the quest is from that zone, or its NPC is in it), and its title is "Quest In Progress" ("Quest en curso..." in Spanish). Before it listed the quests not started. The alert when you get close to an NPC is still "Quest Nearby" and lists the quests you can start.
- New: "Test: Quest In Progress" button in the alert tests of the Settings; the checkbox is now "Alert when entering a zone: quests in progress there". Both alerts share the look chosen for "Quest nearby alerts".

### 0.2.37

**Alerts**
- Changed: the "Quest nearby" alerts (when you enter a zone, and when you get close to an NPC) now warn only about quests you **can start**: your main job has the level they need and the quests they follow are completed. Before, they warned about every quest not started. The level and the previous quests are read from the requirements and from the text of the first step of the quest; fame, skill, job, mission and expansion pack requirements are not checked. Quests marked as not implemented on the server are never announced.
- The same rule applies to the NPCs the automatic compass adds when you get close, and to the arrows (no arrow for a quest that needs a level you do not have, grey while it waits for another quest).
- The Settings text is now "Quest nearby alert (quests you can start in the zone)".

### 0.2.36

**Compass (prototype)**
- Changed: the arrow over the NPC of a quest in progress is no longer a green down arrow: it is now a **green circular arrow turning** over the NPC's head. Out of view it is still a green arrow at the edge of the screen.
- New: the automatic compass (NPCs within 20 yalms, kept up to 30) now also adds the NPCs of the quests you have **in progress**, not only the ones that start a quest you have not started. Their quests are listed under the NPC, the ones in progress first and in green; a click opens the quest in the Journal. The alert banner of nearby quests is unchanged (it is only for quests not started).

### 0.2.35

**Compass (prototype)**
- New: a **green arrow over the NPC that starts each quest you have in progress**, when that NPC is in the zone you are in (known position), even if it is not in the compass list. It is a checkbox in Settings > Compass ("Green arrow over the NPC of each quest in progress"), on by default; the arrows need `/journal mark` on.

### 0.2.34

**Compass (prototype)**
- Fixed: the grey arrow and the level rule only read the fields `req` and `prereq` of the quests, but many quests keep their requirements in the text of the first step. Now that text is read too: "You need to be level 15 or higher" (no arrow until then), and "This quest follows X", "You need to have finished X", "X must be completed before you are offered this quest", "Wait one day after X" (grey until X is completed). Sentences that talk about quests that clash ("if", "while", "cannot", "active", "zone first") are ignored. Example, Selbina: Abelard (level 15) and Isacio (level 18) have no arrow below those levels; Zaldon is grey until The Real Gift is completed, and Oswald until The Sand Charm is completed.
- Not read from the text: fame, skill, job, mission and expansion pack requirements.

### 0.2.33

**Compass (prototype)**
- New: the arrow is **green** over an NPC that has a quest in progress (a quest of that NPC that is active), and over the NPC of the current step of the quest you pointed the compass at or pinned in the Tracker, when that quest is in progress. A quest in progress wins over grey and over the level rule.

### 0.2.32

**Compass (prototype)**
- New: no arrow over an NPC (nor at the edge of the screen) while every quest it starts that you have not started needs a level (`Lv.N` in the requirements) above the level of your main job. The arrow appears once you reach it, grey if the quest still waits for another quest, yellow if it can be started. `/journal mark debug` shows how many NPCs are hidden and your level. Job, rank and key item requirements are not checked.

### 0.2.31

**Compass (prototype)**
- New: the arrow over an NPC (and the one at the edge of the screen) is **grey** when every quest the NPC starts that you have not started yet cannot be started, because each one names a quest in its prereq that is not completed. If the NPC has a quest that can be started or that is active, or no quest at all, the arrow stays yellow. Rank, level or key item requirements written in the prereq are not checked, only the quests named in it.

### 0.2.30

**Compass (prototype)**
- New: the arrow over the NPC in the game now also marks **all the NPCs of the compass** (the list chosen with the search and the pins of the Tracker) that are in the zone you are in, a little smaller than the one of the target.
- New: **arrow at the edge of the screen** pointing to the NPC when it is out of view (to the sides, above, or behind the camera).
- New: Settings > Compass has three checkboxes: arrow over the compass NPC, arrows over all the NPCs of the compass, and arrow at the edge of the screen. The last two are on by default; the first is still off until you turn it on (also with `/journal mark`).
- `/journal mark debug` shows how many NPCs have a position, how many arrows are over the NPC and how many are at the edge.

### 0.2.29

**Compass (prototype)**
- Changed: the calibration of the arrow over the NPC (`/journal mark`) no longer assumes how the game orders its axes or that a higher height goes up on the screen. It tries all 48 orders and signs of (x, y, height), keeps the one that puts the player closest to the middle of the screen and also moves a point above the player straight up or down, and learns which way the height goes. The size of the 3D scene is read from the Direct3D viewport (the size of the ImGui screen is the fallback).
- `/journal mark debug` now also shows the screen sizes, the chosen combination with its score, and the next best ones.

### 0.2.28

**Compass (prototype)**
- Fixed: the arrow over the NPC (`/journal mark`) read zeros. The Ashita wrapper of `GetTransform` takes only the kind of matrix and returns the matrix; the addon was passing a buffer that it ignores.
- Changed: the camera matrices are now also read during the drawing calls of the 3D pass (the interface is drawn last with flat matrices, which are discarded), and the events are listened to only while the arrow is on (before, the start of the scene was read millions of times even with the arrow off). `/journal mark debug` shows the events registered and heard, and each set of matrices as flat or perspective.

### 0.2.27

**Compass (prototype)**
- New: `/journal mark [on|off|debug]` puts a **yellow arrow over the NPC the compass points at**, in the game world, bobbing up and down. It is off until you turn it on. It needs the camera of the game, which cannot be checked outside the game: the addon reads the view and projection matrices of Direct3D, finds by itself which axes and order of multiplication put the player in front of the camera (a point above the player must go up on the screen), and draws nothing if it cannot. `/journal mark debug` prints what was read and chosen.
- Only the target of the compass ("Point compass here") for now, not the rest of the list.

### 0.2.26

**Journal**
- New: in the details of a quest, the **NPC that starts it is clickable** (the "NPC:" line). A click adds it to the compass list and opens the compass, as the NPC names in the steps do. When the data holds several names ("Waoud/Raubahn"), each one is its own link. The zone of the quest is used to pick the right NPC when the name is in several zones.

### 0.2.25

**Compass / alerts**
- Changed: the quests under an NPC in the compass (from the proximity alert) have a **shaded box and a line under the text**, brighter with the mouse over it, so they look clickable.
- Changed: the Spanish title of the "Quest Nearby" alert is now "Quest cerca...".

### 0.2.24

**Compass**
- New: the quests shown under an NPC added by the proximity alert are now **one line each and clickable**: a click opens the Journal on that quest. Up to 3 lines, then "+N more".

### 0.2.23

**Compass**
- Changed: the NPCs of the proximity alert now go to the compass list when you are within **20 yalms** (before 30), and leave it beyond 30. The banner of the alert still uses 30.
- New: an NPC added this way shows the **names of the quests it starts** under its name (clickable since 0.2.24).

### 0.2.22

**Compass**
- New: the NPCs of the proximity alert go to the **compass list automatically** when you are within 30 yalms, and leave it when you are more than 40 yalms away, when their quests are started, or when you change zone. At most 3 are automatic (the closest), so the list keeps room for the ones you pick. The x removes an automatic NPC and it is not added again in that zone. They are not saved. An NPC you add by hand is never removed. The compass window **opens by itself** when an NPC is added and it was closed (it is not closed again by itself). It can be turned off in Settings.

### 0.2.21

**Alerts**
- New: **proximity alert**. When you are within 30 yalms of an NPC who starts a quest you have not started, the "Quest Nearby" banner shows the NPC and the quest names. It appears once for each NPC in each visit to a zone. NPCs close to each other go in **one banner** (one line each, "NPC: first quest (+n)", the closest first, the zone name as the subtitle); one NPC alone shows its name and its quests. It uses the fixed NPC positions (LandSandBoat data), so an NPC that walks around may be a little off. Only the quest's own `npc` field is used (names separated by `/` are checked one by one); missions have no start NPC. It can be turned off in Settings, next to the other nearby alert.

### 0.2.20

**Journal**
- New: in the steps of a quest or mission (the details panel and the sheet window) the **NPC names are clickable**, as in the Tracker. A click adds the NPC to the compass list and opens the compass window; the name is underlined while the mouse is over it. With the list full (5) a message in the chat asks you to remove one first.
- Fixed: the zone chosen for the NPC. An NPC that is in several zones (Miageau is in an Abyssea zone and in Northern San d'Oria in the game data) went to the first zone of the table. Now it goes to the zone you are in if it is there; otherwise to the zone that the text of the step names ("... in Northern San d'Oria"); otherwise to the first of the table. This also applies to the click in the Tracker.

### 0.2.19

**Journal**
- Changed: the **search box now searches the whole Journal**. With a text in the box, the list is replaced by the results: every mission and every quest that has the text, from all the areas and categories, **whatever the filters of the lists** (completed, not started, favorites, repeatable). It looks in the name, the NPC, the places, the reward, the requirements, the type and **the text of the steps**. The words do not need to be together: "glenne ointment" finds the quest that has both. Under each result it says where it is and what matched (NPC, Place, Reward, Step 2...). The results come in two groups, Missions and Quests, with the best matches first (up to 200 of each; the count shows the total). It ignores capital letters, punctuation and accents ("mision" finds "misión"), and in Spanish it also looks in the Spanish steps.
- One click on a result opens it in the Journal (the box keeps the text, so you can go back to the results); a double click opens its sheet. To go back to the lists, clear the box with its x.
- Because of this, the search no longer hides rows in the normal lists.

**Compass**
- New: the item you point the compass at with "Point compass here" has a small **x** to stop pointing at it. If the item is pinned in the Tracker it does not come back as a row either; the pin stays in the Tracker.
- Fixed: unpinning an item and pinning it again shows it in the compass again, even if the compass window was closed in between.

### 0.2.18

**Journal**
- New: the **items pinned in the Tracker now show in the compass** by themselves, quests and missions alike. Each one gets a row with the NPC named in its current step, how far away it is (or the zone it is in, with the next zone on foot), and the name of the quest or mission under it. The row follows the step of the pin: when you move to another step the NPC changes, and a step that names no NPC has no row. The item you pointed the compass at with "Point compass here" is not repeated.
- New: a small **x** on each of those rows takes it off the compass. It does not unpin it from the Tracker. It stays off while the item stays pinned (it is remembered when you restart); if you unpin the item and pin it again, it shows again.

### 0.2.17

**Journal**
- New: the compass shows the **next zone on foot** when the NPC is in another zone. Under "In another zone:" a line says "Next: Valkurm Dunes" (for the NPC of a step and for each NPC of the search list). It updates when you change zone. The route follows the zone exits only: **boats and airships are not included**, so when the only way is by sea or air (or there is no way) the line does not appear. Data: `data/zone_links.lua` (484 links between 198 zones), built from the zonelines of LandSandBoat; the script that builds it is not part of the addon.

### 0.2.16

**Journal**
- New: click an **NPC name in the Tracker** to add it to the compass. The compass window opens, and the NPC joins the list (up to 5; with a full list a message in the chat asks you to remove one first). The name is underlined while the mouse is over it. The NPC goes in the zone you are in if it is there; otherwise in the first zone where the game data places it; an NPC without game data gets your current zone (it is found if it is close).

### 0.2.15

**Journal**
- Changed: the resize corner of the compass window is invisible until the mouse is over it (and lights up while you drag it).

### 0.2.14

**Journal**
- New: in the settings, section *Compass*, a **Text size** for the compass window (60% to 160%). The window fits its content again when you change it.
- New: in the same section, the option **Show the NPC search**. Turn it off to remove the search box from the compass window. The NPCs already in the list stay, and you can still remove them; the compass keeps following the quest or mission you point it at.

### 0.2.13

**Journal**
- Changed: the texts of the compass window have a soft black shadow, like the Tracker, so they read better over the game.
- Changed: with the background opacity of the compass at 0%, the window has no border and no frame lines at all, only the texts.

### 0.2.12

**Journal**
- Changed: the background opacity of the compass window can go down to **0%** (a fully transparent background; the text stays visible).
- Changed: the compass window has **no title bar and no close button** now. Move it by dragging it anywhere, resize it from its corner, and show or hide it with the compass button of the Journal or `/journal compass`.
- Changed: the button that removes an NPC from the compass is a **small, dim gray x** (lighter when the mouse is over it).

### 0.2.11

**Journal**
- Changed: the names of the NPCs in the compass window (the one of the quest step and the ones of the search list) use the same olive green as the NPC names in the Journal.

### 0.2.10

**Journal**
- Fixed: the compass window could not be resized with the mouse. It now fits its content when it opens and then leaves its size alone, so you can drag the corner. The size is saved when it changes. If you add NPCs and they do not fit, the window grows once to fit them (it never shrinks a window you made bigger).

### 0.2.9

**Journal**
- New: a **compass button** in the top bar of the Journal, next to the new adventurer guide and the camps. It shows or hides the compass window (it is lit while the window is open). Same as `/journal compass`.

### 0.2.8

**Journal**
- New: the compass window can be **resized** by dragging its corner. The size is saved with your settings. Until you resize it, it still fits its content by itself. If you make it smaller than its content, it scrolls. `/journal compass reset` puts it back to fitting its content.
- New: the **background opacity of the compass window** is in the settings, in a new *Compass* section (35% to 100%, like the Journal and the Tracker). It only fades the background; the text stays sharp.

### 0.2.7

**Journal**
- Changed: the compass shows distances in **meters** instead of yalms.
- New: the distance is colored and comes with a message. 0 to 10 meters is green ("It's right here!"), 11 to 25 is yellow ("You're very close.."), 26 to 35 is orange ("You're getting closer.."). Farther than that there is no message. It applies to the quest target and to every NPC of the search list. The old *Arrived* line is replaced by the green message.

### 0.2.6

**Journal**
- New: the compass window has an **NPC search box**. Type at least two letters and pick any NPC from the list to point the compass at it, without choosing a quest first. Up to 5 NPCs can be shown at once, each with its distance (or the zone, if it is somewhere else). Names that exist in several zones appear once per zone. Remove an NPC with the `x` button. The list is saved with your settings.

### 0.2.5

**Journal**
- Fixed: the compass window had a fixed height and, with the real font, the lines under the NPC name (the distance and the map square) were cut off. The width is fixed and the height now follows the content.

### 0.2.4

**Journal**
- Changed: the compass window now shows the **distance** in yalms at all times, also when the NPC is loaded near you. Under 10 yalms it has one decimal (for example `4.3 yalms`), and when you are within 5 yalms it adds *Arrived* below it. Before, *Arrived* replaced the number.
- Changed: the **arrow is off** and the window is shorter without it. The arrow depends on the heading of the player, which is not confirmed in the game yet. It can be turned on with `compass.config.arrow = true`; `/journal compass debug` shows the value.
- Confirmed in the game with Melyon (Selbina): the ground coordinates are the X and Y of the game (Z is the height), the zone id is read correctly, and the distance of the fixed position matches the live one.

### 0.2.3

**Journal**
- New: the compass now shows the **distance to the NPC even when the game has not loaded it**. It uses the fixed position of the NPC (new file `data/npc_positions.lua`, 706 names and 1,090 positions) and your position, and the window says *From the game data* under the distance. When the NPC is in another zone, it says *In another zone* and gives the name of the zone. When the NPC is loaded near you, the live position and the arrow are used as before.
- A name used by NPCs in several zones (Cid, for example) takes the one in the zone you are in, and the closest if there are several there. Some NPCs are not in the data (Gate Guard and others); for them the window says *Not in range*.
- `/journal compass debug` also prints the zone id, the three raw coordinates (X, Y, Z) of you and of the NPC, and the position that the table gives for the NPC, so that the table can be compared with the live position.

**Fixes and technical**
- Fixed: the compass read the wrong coordinate as the second one on the ground. The Z of the game is the height; the ground is X and Y. `compass.config.second_axis` holds this.
- Fixed: the entity index of the player is read every time, because it changes when you change zone. Before, the compass could read position 0, 0 after a zone change.
- The fixed positions come from LandSandBoat (https://github.com/LandSandBoat/server, GPLv3, `data/zones/*/npcs.yaml`). The names kept are the ones in `data/npcs.lua`. The script that builds the file is not part of the addon.

### 0.2.2

**Journal**
- New: the **compass**. A small window with an arrow that points at the NPC of the current step of a mission or quest, with the distance in yalms. In the details panel, the button *Point compass here* (under *Pin to Tracker*) makes the selected mission or quest the target; *Stop compass* takes it off. The arrow follows the current step, so it changes when you move on to the next one.
- New: `/journal compass` shows or hides the compass window, `/journal compass off` clears the target and closes it, and `/journal compass debug` prints the raw numbers (your position and heading, the NPC position, the distance and the angle) in the chat.
- The window shows the name of the target, the NPC of the step, the arrow, the distance (or *Arrived* when you are within 5 yalms) and the map square written in the step, such as `I-9`. It can be moved, it is saved with the other settings, and it is drawn with or without the Journal open.
- The compass can only follow an NPC that the game has loaded near you (about 50 yalms). The quest data has map squares, not world coordinates, so when the NPC is not loaded the window says *Not in range* and shows the map square, with no arrow. It also says so when the step names no NPC from the NPC list.
- All the new texts are translated to Spanish.

**Fixes and technical**
- New file: `compass.lua` (finds the NPC in the step text, reads the entities, computes distance and angle; saves the target, the window state and its position as `compass` in the settings file). `icons.lua` draws the arrow.
- The way the arrow turns depends on conventions of the game that could not be checked outside it (`z_sign`, `yaw_sign` and `yaw_offset` in `compass.config`). If the arrow points the wrong way, the output of `/journal compass debug` shows what to change.

### 0.2.1

**Journal**
- New: **notes**. A box under the objectives of every mission and quest (one line, up to 240 characters) saved as you type. The sheet (double click on a row) shows the note, and so does the Active Now window. Notes are kept when the mission or quest is completed.
- New: **favorites**. A star button beside *Pin to Tracker* in the details panel marks the mission or quest as a favorite. A star is drawn after its name in the lists (after the infinity sign when it is repeatable). There is room for 200 favorites; the Tracker still holds 8 pins.
- New: **Only favorites** filter. A star button at the right end of the first row of the lists (before the infinity button in the quests) shows only the favorites. One switch for the missions and one for the quests, both saved. A jump to something that is not a favorite (from a link or from the Active Now window) turns the filter off so the jump always arrives.
- New: the **Active Now** window. A button in the Journal toolbar (after Settings), `/journal active` and `/journal favorites` open it. It has two tabs, *Active* and *Favorites*, each with its count. Every row shows the name, the area or category, a thumbtack when the item is in the Tracker, the current step (`n/total`, the first step not done) and the note. A click on any line opens the item in the Journal. In *Favorites* a *Remove* button under each row takes it out, and an entry that is no longer in the data is marked "Not found in the Journal data" and can still be removed. Esc and the B button close this window before the Journal.
- Changed: the details panel has a note box above the pin button, and the pin button shares its row with the star button.

**Fixes and technical**
- New file: `personal.lua` (notes, favorites, the filters and the state of the Active Now window). `icons.lua` draws the star. They are saved in the settings file as `notes`, `favorites` and `favorite_filters`.
- Notes are saved with the characters `\`, `"` and `%` encoded, so a note can never break the settings file.
- While a note is being typed, the arrow keys and Enter belong to the text and do not move the lists.
- All the new texts are translated to Spanish (`data/ui_es.lua`). The chat messages are plain ASCII.

### 0.2.0

Release that groups every change made since 0.1.21 (listed below as steps, newest first): Quest Nearby alert, mission area types, numbered chapters and data for Zilart, Chains of Promathia, Treasures, Adoulin and Rhapsodies, quests grouped by zone, nation and expansion banners, ranks for the nation missions with the completed check, and the Jeuno banner.

#### Step 0.1.46

**Journal**
- New: the Jeuno banner is shown, centered and at double size, above the first Jeuno quest in the list of quests.

#### Step 0.1.45

**Journal**
- Changed: Rank 1 of the nation missions also gets the green check once Rank 2 is reached (when every Rank 1 mission is completed).

#### Step 0.1.44

**Journal**
- New: in the Windurst, Bastok and San d'Oria missions, a green check mark appears next to the title of a rank when every mission of the previous rank is completed (Rank 1 completed: check on "Rank 2"; Rank 2 completed: check on "Rank 3"; and so on). It uses the full list, so the "hide completed" and search filters do not change it.

#### Step 0.1.43

**Journal**
- New: the banners of the nations (Bastok, Windurst, San d'Oria) are also shown, centered, above the first quest of each nation in the list of quests (above the first zone title).
- Changed: in the "All" lists (missions or quests) every area now gets its own logo or banner above its first entry, not only the first area.

#### Step 0.1.42

**Journal**
- Changed: the banners of the three nations (Bastok, Windurst, San d'Oria) are drawn **twice as big** (up to the width of the list). The logos of the expansions keep their size. The size of each logo is set in `journal_logo_scale` of `ui.lua`.

#### Step 0.1.41

**Journal**
- New: the **San d'Oria banner** ("The Kingdom of San d'Oria") is shown, centered, above its first mission (`assets/logos/Sandoria_Logo.png`). The three nations now have their banner.

#### Step 0.1.40

**Journal**
- New: the **Bastok banner** ("The Republic of Bastok") is shown, centered, above its first mission (`assets/logos/Bastok_Logo.png`).

#### Step 0.1.39

**Journal**
- New: the missions of the three nations (Bastok, Windurst, San d'Oria) are **grouped by rank**: a title "Rank 1" ... "Rank 9" (in Spanish "Rango") above the first mission of each rank. The rank comes from the data of each mission. A rank with no mission in the list shows no title.
- New: the **Windurst banner** ("The Federation of Windurst") is shown, centered, above its first mission (`assets/logos/Windurst_Logo.png`). Bastok and San d'Oria have no banner yet; add `assets/logos/<name>.png` and one line in `journal_logo_files` of `ui.lua`.

#### Step 0.1.38

**Journal**
- Changed: the **subzone selector of the quests is gone**. The quests of each nation are now grouped by zone in the same list, like the missions: a gold title above each zone (Port Bastok, Bastok Mines, Bastok Markets, Metalworks, Other...), in the order of the data. The quests with no clear zone are in **Other**, at the end of the nation. The titles are only shown when the list has two groups or more.
- Changed: in the "All" list the groups go nation after nation. The active quests go first inside each zone group (and no longer at the very top of the whole list).
- Removed: the saved subzone setting. Searches and the "Hide complete", "Show not started" and "Only repeatable" options work on the groups, and a zone without quests left shows no title.

#### Step 0.1.37

**Journal**
- New: the missions of **Rhapsodies of Vana'diel** are shown by chapter, with the code of each one ("1-1" ... "3-35 A Rhapsody for the Ages (Finale)") and a title above each chapter ("Chapter 1: Creation and Rebirth", "Chapter 2: Revitalization", "Chapter 3: Reckoning"). The details show the code, the type (Cutscene, Quest, BCNM, Fight - Popped NM...) and the reward (key items, ciphers, accesses, the cutscene replay abilities).
- New: the **requirements** between missions of the walkthrough are shown as a short dim text before the mission they block ("Requires: Chains of Promathia up to The Road Forks", the ranks of your nation, the missions of Wings of the Goddess, Rise of the Zilart and Seekers of Adoulin...). Translated to Spanish.
- New: the **Epilogue** with *The Silent Forest* (information only, like the one of Seekers of Adoulin).
- Fixed in the data: the two missions named "Eddies of Despair" (1-10 and 2-35) keep their own steps, and the type and reward are given by mission id, so they do not mix.
- The note about the *imprimaturs* of Seekers of Adoulin (time-based currency, the only gated content) is not shown in the addon.

#### Step 0.1.36

**Journal**
- New: the **Rhapsodies of Vana'diel logo** is shown, centered, above its first mission in the list (`assets/logos/Rhapsodiesofvanadiel_Logo.png`).

#### Step 0.1.35

**Journal**
- New: the **Seekers of Adoulin logo** is shown, centered, above its first mission in the list (`assets/logos/Seekersofadoulin_Logo.png`).

#### Step 0.1.34

**Journal**
- New: the **Wings of the Goddess logo** is shown, centered, above its first mission in the list (`assets/logos/Wingsofthegoddess_Logo.png`).

#### Step 0.1.33

**Journal**
- New: the **Treasures of Aht Urhgan logo** is shown, centered, above its first mission in the list (`assets/logos/Treasuresofahturhgan_Logo.png`).

#### Step 0.1.32

**Journal**
- New: the **Rise of the Zilart logo** is shown, centered, at the top of its missions in the list, like the one of Chains of Promathia (`assets/logos/Riseofthezilart_Logo.png`).

#### Step 0.1.31

**Journal**
- New: the **Chains of Promathia logo** is shown, centered, at the top of its missions in the list (above "Chapter 1" and the first mission), in the "All" list too. It is the file `assets/logos/Chainsofpromathia_Logo.png`; without the file nothing is shown. The width follows the list (up to a limit). The code accepts logos for other areas by adding the file and one line to `journal_logo_files` in `ui.lua`.

#### Step 0.1.30

**Journal**
- New: the missions of **Seekers of Adoulin** are shown by chapter, with the code of each one ("1-1", "2-1-1", ... "5-5-1 The Light Within (Finale)") and a title above each chapter ("Chapter 1: The Sacred City of Adoulin" ... "Chapter 5: Hades"). The details show the code, the type (Cutscene, Quest, BCNM, Quest & BCNM...) and the reward or extra information (Bayld, experience, "Game day: wait for the next mission", accesses, rings) from the table of the walkthrough. Chapter titles now work from the code of the mission for any area.
- New: an **Epilogue** at the end of the list with *The Silent Forest*, *The Ygnas Directive* and *The Arciela Directive*. These quests are not in the quest data of the addon, so they are information only: hover a row to see its type and reward. They cannot be opened or tracked.
- The name of mission 4-3-9 is cut in the game's own data ("The Light of Dawn Comes..."); it is left as it is.

#### Step 0.1.29

**Journal**
- New: the details of the **Chains of Promathia** missions show the mission code (1-1 to 8-5), the type (Cutscene, Dungeon/BCNM, Fight, BCNM - Finale...) and the reward, key items and accesses, from the table of the walkthrough. For 5-3 *Three Paths* the type line lists the type of each path (Louverance's, Tenzen's and Ulmia's).

#### Step 0.1.28

**Journal**
- New: the details of the **Rise of the Zilart** missions show the chapter number, the type (Cutscene, Dungeon/BCNM, Quest/Fight, BCNM, Finale...) and the reward or key items, from the table of the walkthrough. Mission 17 *Awakening* is "Cutscene - Finale" and 18 *The Last Verse* is "Finale". "The Outlands" is not in the table and has no extra information.
- The names stay as in the data ("Kazham's Chieftainess", "Ark Angels"). The epilogue quests keep the rewards of the quest data.

#### Step 0.1.27

**Journal**
- New: the missions of **Treasures of Aht Urhgan** are numbered 1 to 48 in the list ("1. Land of Sacred Serpents" ... "48. Eternal Mercenary (Finale)").
- New: their details show the mission number, its type (Cutscene, Quest, BCNM, Dungeon/BCNM, Quest/Fight) and the reward or extra information (key items, Imperial pieces, access to Assault or Salvage, "Zone & Day: wait for the next mission"), from the table of the walkthrough. The name of mission 33 stays as in the data, "Sentinel's Honor".

#### Step 0.1.26

**Journal**
- New: the missions of **Chains of Promathia** are shown by chapter. Each mission has its code ("1-1. The Rites of Life" ... "8-4. Dawn", "8-5. The Last Verse (Finale)") and a title above each chapter ("Chapter 1: Ancient Flames Beckon" ... "Chapter 8: Emptiness Bleeds"). A title goes before the first mission of its chapter that is in the list, so it stays right when some missions are hidden.
- The **Epilogue** (Storms of Fate, Shadows of the Departed, Apocalypse Nigh) is now also in the list of Chains of Promathia, before 8-5 *The Last Verse*, as in Rise of the Zilart. In the "All" list both epilogues appear and each row works on its own.
- The three paths of 5-3 (Louverance, Tenzen, Ulmia) are not separate rows: they are hidden missions of the data and stay that way.

#### Step 0.1.25

**Journal**
- New: the missions of **Rise of the Zilart** are numbered as chapters, 1 to 18 ("1. The New Frontier" ... "17. Awakening", "18. The Last Verse (Finale)"). "The Outlands" has no chapter number and stays hidden as before.
- New: an **Epilogue** section in the list of Rise of the Zilart, between chapters 17 and 18, with the quests *Storms of Fate*, *Shadows of the Departed* and *Apocalypse Nigh* (with their status dot and the repeatable mark). Clicking one opens the quest in the Quests tab. They follow the search and the "Hide complete" / "Show not started" options of the missions. They are shown in the "All" list too.

#### Step 0.1.24

**Journal**
- Changed: the mission areas are now grouped in four types, with a title above each one in the area selector: **Starter City Missions** (Bastok, Windurst, San d'Oria), **Expansion Missions** (Rise of the Zilart, Chains of Promathia, Treasures of Aht Urhgan, Wings of the Goddess, Seekers of Adoulin, Rhapsodies of Vana'diel), **Scenario Missions** (A Crystalline Prophecy, A Moogle Kupo d'Etat, A Shantotto Ascension, Abyssea, The Voracious Resurgence) and **Special Battle Endeavors** (Assault, Campaign). The arrows, the shortcuts and the "All" list follow the same order.
- Voidwatch has no mission data in the addon yet, so it is not listed. Abyssea is a single area (Vision, Scars and Heroes of Abyssea together).
- The selected area is now saved by name, so the new order does not change it. A position saved by an older version is translated once.

#### Step 0.1.23

**Journal**
- New: **subzones for quests**. When a nation (category) is selected, a second selector appears next to it with *All* and the zones of that nation (for example Port Bastok, Bastok Mines, Bastok Markets, Metalworks), each with its own progress (`%, done/total`). Choosing a zone shows only its quests; the active ones stay at the top. The zone comes from the `zone` field of each quest in the data.
- Quests with no clear zone ("Multi-Nation", "Other Locations", "Mog House" or no zone) are grouped in **Other**, at the end of the list. The data is not changed.
- The selector is not shown with "All" nations, nor for a nation with fewer than two zones. Changing the nation, or following a link to a quest of another zone, goes back to *All* zones. The choice is saved.

#### Step 0.1.22

**Alerts**
- New: **"Quest Nearby" alert**. When you enter a zone (or log in to it), once the quest log has arrived, a banner lists up to 3 quests of that zone that are **not active and not completed** ("+N more" for the rest), with the text "Not active yet". It uses the `zone` of each quest in the data, so it only covers quests; missions have no zone in the data and are not included. Quests without tracker data cannot be checked and are skipped. Repeatable quests that are already completed are not listed.
- New: its own sound `assets/sounds/nearby_quest.wav` (optional; if missing it is silent and the chat says so once).
- New: in **Settings > Alerts**: an on/off checkbox for this alert, its own background opacity, text size and color, and a **Test: Quest Nearby** button. It also follows the main alert switch and the sound switch.

### 0.1.21

**Alerts**
- New: **alert of a new quest or mission**. When the game gives you a new quest or mission, a banner fades in at the center of the screen ("New Quest!" or "New Mission!") with the name of the item, a sound, and the question "Pin it to the Tracker?" with the buttons *Pin to Tracker* and *No thanks*. With no answer in 14 seconds it counts as *No*. If the item is already in the Tracker (for example with the automatic pins on) it does not ask and says so. If several things arrive together they are shown one after the other.
- New: **alert of a completed quest or mission** ("Quest Completed" or "Mission Completed"), with a green check mark that draws itself beside the title and its own sound. It does not ask anything.
- The alerts do not fire for what the character already had when logging in, during the first seconds after the addon loads, or when the game sends a reload of the data with many changes at once. An item that stops being active without being completed does not give a completed alert.
- New: the sounds are your own `.wav` files in `assets/sounds`: `new_quest.wav`, `new_mission.wav`, `complete_quest.wav` and `complete_mission.wav`. If one is missing that alert is silent and the chat says so once.
- New: an **Alerts** section in the settings window: turn the alerts, the sound and the question about pinning on or off. The new-item alerts and the completed alerts each have their own **background opacity** (0% to 100%), **text size** (60% to 160%) and **color** (the default of the alert or one of 8 colors). Four **test** buttons show each alert on the screen and keep it there while the settings window is open, so the look can be changed in front of it; pressing the button again, or closing the settings, hides it. Clicking the value of a setting resets it.
- New: `/journal alert [quest|mission] [done]` shows an alert for the item selected in the Journal.
- New file: `announce.lua` (the banners and the sounds). The check mark and the thumbtack are drawn in `icons.lua`.

**Journal**
- New: **All** is the first entry of the area selector (missions) and of the category selector (quests). It lists everything together, with the total progress, and the details show the cover of the area of the selected mission. The arrows and the keyboard and controller shortcuts go through it too. A link between quests made from "All" stays in "All". The choice is saved.
- Changed: the **active** missions and quests are always at the top of the lists, in an area or in "All". The rest keep their order.
- Changed: a **completed** mission or quest cannot be edited: its steps are shown all done, the boxes do not react, the counter shows `(N/N)` and the Reset steps button is not shown.
- Removed: the **Progress** button of the Journal toolbar. The progress of each area and the total are still shown in the area selector and its list.
- Changed: the camps button is now a red question mark drawn with lines, so it no longer depends on an image. The loading of `assets/camps.png` and its message in the chat are gone, and the file is not used any more.
- New: the setting **Show Journal button on close**. The small Journal button that stayed on the screen when the Journal was closed is now hidden by default; turn it on in the settings to get it back.

**Tracker**
- Removed: the **Mode** and **Close** buttons at the bottom of the Tracker. The layout and the visibility are still set in the settings window and with `/journal pin mode` and `/journal pin`.
- New: a small **thumbtack** on every pinned item. Pressing it unpins the item, which stays in gray with an empty thumbtack for 20 seconds so that pressing it again pins it back (with its steps as they were). After that it disappears. In the tabs layout the gray item is shown under the active one.

**Fixes and technical**
- Fixed: the addon did not load when the settings code used more than 60 values from outside a function, which LuaJIT does not allow ("function has more than 60 upvalues"). The alert and "All" settings are kept in tables and `apply_config` is split in two.
- All the new texts are translated to Spanish (`data/ui_es.lua`). The chat messages are plain ASCII.

### 0.1.20

- Fixed: in the guide for new adventurers the titles of the contents (Welcome, Choosing a nation and the rest) were cut. The panel is now as wide as the titles need, within limits (it follows the width of the window and the text size), and a title that is still too long goes on more than one line. Clicking any line of a title selects it.
- Changed: in the mission and quest lists, one click only selects a row and a double click opens its sheet. The keyboard and the controller keep opening the sheet when you confirm.
- Fixed: the button of the camps. The icon is now loaded again while the Journal is drawn if it could not be loaded at the start (a few tries), the button uses the same call as the button of the mini Journal, it also reacts when that call does not report the click, and if the icon cannot be loaded the chat says so once and the button becomes a plain button with the word Camps. `/journal camps` still opens the window.
- Fixed: in the camps, the names of the monsters are shown in the color of the monsters (red), also those that are not in the list of names.
- All the new texts are translated to Spanish.

### 0.1.19

- Fixed: a mission or quest that you unpin from the Tracker and pin again started on step 1 and ignored the steps already marked as done in the Journal. Now it starts on the first step that is not done. It also applies to the pin that replaces a completed mission with the next one, to the pins made with `/journal pin add` and to the automatic pins. Unpinning never forgets the marked steps.
- New: **Camps**, a guide to where to gain experience at each level. A button with its own icon in the Journal toolbar (next to the sprout of the guide), or `/journal camps`, opens a window of its own. It lists the standard and alternate camps with the level range they are good for, the monsters, the area, the map coordinates and a note when there is one. Two ways to read it: *For your level* (the camps of every range that suit the level) and *By level range* (tabs 10 to 70, with the camps that suit the level highlighted). The level is the one of the character when the game gives it, or it is set with - and +. Below level 10 it points to the guide for new adventurers. A checkbox hides the areas marked (S), which belong to Wings of the Goddess. The lists are in `data/camps.lua` (125 camps) and the icon in `assets/camps.png`.
- New: **Text size** in the settings (80% to 140%). The font of the Journal and of its windows, the height of the buttons and the bars, and the default size of the windows change together, so the text always fits. The Tracker keeps its own size.
- All the new texts are translated to Spanish. The translation dictionary now has 4,983 entries.

### 0.1.18

- New: a guide for new adventurers. A button with a green sprout in the Journal toolbar (next to Progress and Settings), or `/journal guide`, opens a window of its own: the contents on the left and the text on the right, in English or in Spanish. It follows the "New Player Guide" of the Phoenix Wiki without changing its content: choosing a nation, the first steps in town, levels 1-10 and 10-20, the milestones, the first gil (the repeatable quests of San d'Oria, Bastok and Windurst), getting around, how Phoenix differs from retail and where to go next. It remembers the section you read last. The window works even when the Journal is closed.
- The quests named in the guide (the tables of the first gil, the milestones and the Mog House quests) are links: they open that quest in the Journal. Repeatable ones carry the infinity sign. Every page ends with the source.
- The guide still mentions pages of the Phoenix Wiki (Game Terms, Fame, Jobs and others); they were kept as they are in the original text.
- New files: `data/guide.lua` (the text of the guide). The sprout is drawn in `icons.lua`, with lines and triangles, so it does not depend on a font.
- All the texts are translated to Spanish. The translation dictionary now has 4,972 entries.
- Name list for NPCs extended with the ones of the guide.

### 0.1.17

- New: step checklist with memory. Each step in the details of a quest or mission has a box. The steps you mark are shown dimmed, the title shows how many are done, for example `(3/10)`, and a **Reset steps** button starts over. The marks are saved per quest or mission, and a mark only counts while the step keeps its text, so a rewritten objective never gets a wrong mark. When a quest or mission is completed its marks are forgotten, so a repeatable quest starts clean the next time.
- Changed: the Tracker shares the checklist. The current step of a pinned item is always its first step not done. `>` marks the current step as done and skips the ones already done, `<` goes back one step and unmarks it, the automatic step change on zone change marks the step as done, `/journal pin <n>` marks the steps before n as done, and `/journal pin reset` clears the checklist. Pins made before this version keep their progress: the steps before the current one count as done.
- New: a button with the infinity sign in the header of the quest lists (the right end of the first row, next to "Hide complete quests") that shows only the repeatable quests. It lights up while it is on, it has a tooltip, it combines with the search and the other filters, and it is saved. A jump from a quest link to a quest that is not repeatable turns it off so the jump always arrives. The progress counters do not change with it.
- The Spanish texts of the above are in `data/ui_es.lua`.

### 0.1.16

- New: repeatable quests are marked with an infinity sign. It appears after the name in the Journal list, next to the title in the details panel, and to the right of the name of every pinned repeatable quest in the Tracker (in the stacked and in the tabs layouts, with its shadow). The sign is drawn with lines, so it does not depend on a font. It uses the new file `icons.lua`.
- New: automatic pins of the active quests. When it is on, the quests the game reports as active are pinned by themselves (up to the 8 pins of the Tracker, with no message when it is full), and the automatic pins go away when the quest is completed. Pins you made by hand are never removed. A quest you unpin by hand (or that you clear with all the pins) is not pinned again while it stays active. It is off by default. Turn it on in the Settings window ("Pin active quests automatically") or with `/journal pin auto [on|off]`. Turning it off keeps the pins as normal pins. This is for quests only.
- The Spanish texts of the above are in `data/ui_es.lua`.

### 0.1.15

- New: links between quests. In the details of a quest (and in its sheet), each quest named in "Prereq" is a line you can click to jump to it, including prereqs with several quests such as "The Fighting Fourth / Snake on the Plains / Steamed Rams". A "Next" list shows the quests that have this one as their prereq (up to 6, with "+N more"), and a "< Back" line returns to the quest you came from (up to 20 jumps; picking a quest from the list starts a new trail). Each link shows [x] if the quest is completed, [>] if active and [ ] if not. If the quest is hidden by the search, "Hide complete" or "Show not started", those are relaxed so the jump always arrives.
- New: a **Progress** window (button in the Journal toolbar). It lists every mission area and quest category with a bar and "30%  26/85", with the totals of missions and quests at the top. Clicking a row opens that area in the Journal.
- New: a **Settings** window (button in the Journal toolbar, or `/journal settings`). Language; Journal background opacity (35% to 100%; only the backgrounds fade, the text stays sharp); the four list filters; and for the Tracker: show, layout (stacked or tabs), size, text opacity (35% to 100%), background (0% to 80%, transparent by default), show the next step and auto step on zone change. It also has "Reset window positions", for a window that ended up off the screen. All of it is saved.
- Changed: the tracker size, next step, auto step and language controls moved from the details panel to the Settings window. The details panel keeps only the Pin to Tracker button.
- Changed: Esc (or B on a controller) closes the Sheet, the Progress and the Settings windows before it closes the Journal.
- New file content: the Spanish texts of all of the above are in `data/ui_es.lua`.

### 0.1.14

- Mission objectives written for all 52 Assault missions (Leujaoam Sanctum, Mamool Ja Training Grounds, Lebros Cavern, Periqia, Ilrusi Atoll and the two Nyzul Isle missions). Each one lists how to get the Imperial Army I.D. Tag and the Assault Orders, the Staging Point, the leader's Assault Armband, the time limit and the Rune of Release, plus the objective and notes of that assault. They come from BG-Wiki; for 18 assaults the page has no details, so the step only says to read the mission orders on entry. The mission sheet now shows the assault rank and area.
- Mission objectives written for all 246 Campaign Ops (84 operations for San d'Oria, Bastok and Windurst): the NPC and place of each nation, the campaign rank, the reward in experience and Allied Notes when known, the objective and the steps of its type (resource procurement, supply transport, security, supply manufacture, offensive, defensive, intel gathering and military training). They come from BG-Wiki; for operations whose objective the wiki does not give, the step says to check the mission menu.
- Removed: the objectives of 30 Chains of Promathia entries that 0.1.13 had added (chapter titles and the sub-missions of The Road Forks and Three Paths). The Tracker hides those entries on purpose, and The Road Forks and Three Paths already hold those steps. All the visible missions have objectives.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,834 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.13

- Removed: the Mission Log and the Quest Log windows. Only the Journal and the Tracker are left. This also removes the "Show in Mission Log / Quest Log" buttons, the commands `/journal log`, `/journal quest log` and `/journal text scale`, the log text scale, and the automatic jump of the log to the next mission. The old log settings are dropped from the saved settings file.
- Changed: `/journal pin add` now pins the mission or quest selected in the Journal (it pinned the items of the logs before). On a controller, the X button now pins or unpins the selected entry in the Tracker (it showed or hid the log before).
- Mission objectives written for the 30 Chains of Promathia missions that had none: the 8 chapter titles, the sub-missions of The Road Forks (San d'Oria and Windurst paths) and the sub-missions of Three Paths (Louverance, Tenzen and Ulmia). They come from BG-Wiki, and some pages are cut off in search results, so only the readable parts were written. All 64 CoP missions now have objectives.
- The new objectives are also translated to Spanish. The translation dictionary now has 4,461 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.12

- Quest objectives written for 54 quests of the Other areas: Mhaura (15), Selbina (11), Tavnazian Safehold (18) and the rest (Confessions of a Bellmaker, Bombs Away!, Waking the Beast, the three Koblakiq quests, the three Moogle quests and A Moral Manifest?). They come from BG-Wiki; several pages are cut off in search results, so for those only the parts that could be read were written. 13 quests that are not implemented on this server were left without objectives.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,407 entries.
- Name lists for NPCs, monsters and items extended for the new objectives, and a few names that coloured other steps wrongly were removed.

### 0.1.11

- New: the Journal shows how many missions and quests are completed in each area, for example `(30% 26/85)`. It appears on the questline / region selector button and next to every entry of its list, with a total line at the bottom of the list. Missions hidden by the tracker are not counted, and a quest without tracking data counts as not done.
- New: the whole Journal can be shown in Spanish, not only the objectives. The **Language** button in the Journal details panel (before: *Steps language*) and `/journal lang [en|es]` switch the buttons, lists, filters, details, window titles, help, Tracker and chat messages. The choice is saved. Names of quests, missions, zones, NPCs and rewards stay in English.
- The Spanish chat messages are plain ASCII (no accents), because the game chat does not show them reliably.
- New file: `data/ui_es.lua` (the Spanish texts of the Journal itself, loaded only when Spanish is selected).

### 0.1.10

- Quest objectives written for 46 Outlands quests: all of Kazham, Norg and Rabao, plus Open Sesame, Wrath of the Opo-opos, Wandering Souls, Soul Searching and Divine Might. They come from BG-Wiki. Ten Outlands quests that are not implemented on this server were left without objectives.
- Several BG-Wiki pages are cut off in search results (for example The Opo-opo and I, Forge Your Destiny and Chasing Dreams); for those only the parts that could be read were written.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,231 entries.
- Name lists for NPCs, monsters and items extended for the new objectives, and a few names that coloured other steps wrongly were removed.

### 0.1.9

- Fixed: the Mission Log and the Quest Log no longer open by themselves when you change zone. They only open when you open them from the Journal, and they are no longer restored when the game starts. The Journal window and the Tracker are restored only once, when the saved settings are first loaded, so a later settings reload (for example on a zone change) never opens or closes them.
- Quest objectives written for all 37 Jeuno quests (Path of the Bard, the Brutus quests, the 15 Borghertz's Hands, The Circle of Time, the Maat level cap quests, Storms of Fate, Apocalypse Nigh and more) and for all 54 Whitegate quests (Blue Mage, Corsair and Puppetmaster quests, the Wildcat Promotions, the Serpent Generals, Al Zahbi, Nashmau and more). Most come from BG-Wiki; a few partial pages were completed from other wikis.
- All the new objectives are also translated to Spanish. The translation dictionary now has 4,020 entries.
- Name lists for NPCs, monsters and items extended for the new objectives.

### 0.1.8

- New option to read the objectives in Spanish. Use the **Steps language** button in the Journal details panel, or `/journal lang [en|es]` (without an argument it switches between the two). The choice is saved.
- All the objective texts of missions and quests (4,020 steps) are translated. Names of zones, places, NPCs, monsters and items, and game terms such as Home Point, Auction House or key item, stay in English so they match what the game shows. Coordinates, numbers and quoted game dialogue are kept as they are.
- The Spanish text is used in the details panel, the Mission / Quest Sheet, the Mission and Quest Logs and the Tracker. A step without a translation is shown in English.
- The interface of the addon, rewards and requirements stay in English.
- New files: `i18n.lua` and `data/translations_es.lua` (loaded only when Spanish is selected).

### 0.1.7

Data only: there are no code changes in this version.

- Quest objectives written from BG-Wiki for 91 of the 92 Bastok quests, covering Port Bastok, Bastok Mines, Bastok Markets, Metalworks and the Bastok quests that start elsewhere. Rewards and repeatable marks are filled in where BG-Wiki states them. The only Bastok quest still without objectives is Chips.
- Corrected the reward of Welcome to Bastok, which was listed as a Shell Shield (the item you need to bring) instead of the Spatha you receive.
- Where BG-Wiki gave only part of a page, the objective list is shorter and nothing was filled in from memory.
- Name lists for NPCs, monsters and items extended for the new objectives, so more names are coloured in the steps.

### 0.1.6

First numbered version. It collects everything added on top of the original addon.

**Journal window**
- New look: navy striped panel, a single toolbar with the Missions / Quests buttons and the area selector, and nation colours (San d'Oria, Bastok and Windurst) on the toolbar button and the area popup.
- Status dots in the lists: not started, active, completed and not tracked.
- Search box that filters the current area or category.
- Mission / Quest sheet: clicking a row opens a window with the full record (name, status, rank, number, type, reward and objectives). Steps before the step pinned in the Tracker are marked as done, the current step is highlighted, and a completed mission or quest shows all its steps as done.
- The nation image in the details panel is 60% smaller, so the objectives are easier to read, and the space reserved for the buttons below the objectives now follows the controls shown.
- "Show not started" filter; quests without a tracking ID appear as Not Tracked.
- New objective text styles: zones in bold, other places in italics, and colours for NPCs, monsters and items, with editable name lists. Fira Sans is used for the steps and Carrois Gothic SC for titles and buttons.
- "Auto step on zone change" is now a checkbox in the Journal details panel.
- Controller: A opens the sheet, X shows or hides the selected entry in its Mission / Quest Log, and B closes the sheet first and then the Journal. The keyboard Enter key opens the sheet and Esc closes it first.

**Tracker**
- Pins up to 8 missions or quests, in stacked or tabbed mode, with automatic zone-based step advance and clean-up when completed.
- Names are shown in capitals, and the previous and next step buttons are translucent gray.
- Tracker size buttons (0.6x to 2.0x) and `/journal pin size`.
- Optional "Next:" line, toggled from the details panel or with `/journal pin preview [on|off]`.
- The auto step checkbox no longer appears in the Tracker.

**Data**
- The 72 nation missions of Windurst, San d'Oria and Bastok have rank, number, type and reward, and none is empty.
- Quest objectives written from BG-Wiki for every Windurst quest (92) and every San d'Oria quest (80), with rewards and repeatable marks where BG-Wiki states them. Pages that BG-Wiki gave only partially have shorter objective lists.
- Tracking IDs added for quests of the Other, Outlands and Bastok categories.
- Name lists for NPCs, monsters and items greatly extended.
- Fixes: text clean-up of duplicated or stray punctuation in steps, a Rhapsodies of Vana'diel mission whose steps changed between sessions, a misspelled key item name, and a packet parser that no longer stops the addon on unexpected data.
