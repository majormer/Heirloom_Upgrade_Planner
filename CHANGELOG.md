# Changelog

All notable changes to Heirloom Upgrade Planner will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-04-02

### Added

#### Smart Recommendations
- **Class & Spec Selection** — All 13 classes and 39 specializations supported, including Demon Hunter Devourer (Midnight)
- **Spec-Adaptive Filtering** — Armor type, primary stat (Strength / Agility / Intellect), and weapon style per spec
- **Fixed-Stat Item Handling** — Proper handling for 20 necklaces, trinkets, and held off-hands that do not scale with spec
- **Weighted Scoring** — Candidates ranked by: collected > stat match > upgrade tier > obtainability
- **Duplicate Prevention** — Same item cannot fill both Ring slots or both Trinket slots
- **Mutually Exclusive Items** — Ghost Pirate Rings and similar pairs handled correctly
- **Faction Filtering** — 12 faction-locked PvP items restricted to the appropriate faction

#### Obtainability & Status
- **Obtainability Tracking** — 38 unobtainable items (Hellscream weapons, WoD Mythic trinkets, removed content) and 7 limited-availability items flagged
- **Color-Coded Status** — Green (owned), yellow (obtainable), orange (limited availability), dark red (unobtainable), gray (owned legacy)
- **Purchase Cost Data** — Gold and alternate currency costs shown in item tooltips and shopping list

#### UI
- **Left Panel** — 12 equipment slots with assigned heirloom, icon, current tier, and action buttons
- **Upgrade Button** — Appears when item is below target tier and token is in bags; opens the Collections Journal filtered to that heirloom for one-click upgrading
- **Copy / Equip Button** — Creates a bag copy of the heirloom, or equips it directly if already in bags; slot-aware for dual-wield and trinket slots
- **Slot Override (Pin)** — Click `Pin` on any candidate in the expanded list to lock that item for the current class/spec/slot; a `Pinned` indicator on the main row shows the override is active with a tooltip naming the auto-suggested alternative; click it to revert
- **Expandable Slot Details** — Click any slot to expand and see all eligible candidates with score, tier, and obtainability; best item marked with `>`
- **Spec Suggestion Hint** — Shows a secondary icon and name when a better stat-matched heirloom exists for your spec
- **Right Panel** — Tiered shopping list showing required tokens, gold cost, Timewarped Badge cost, and running total
- **Currency Bar** — Live display of your gold and Timewarped Badge balance
- **Minimap Icon** — Draggable button using LibDBIcon when available, with a built-in fallback; position saved across sessions; toggle with `/hupminimap`

#### Vendor Features
- **Vendor Overlay Panel** — Auto-appears when visiting any heirloom token vendor; shows only what you still need; one-click `Buy 1` buttons with real-time inventory and cost updates
- **Vendor Navigation** — TomTom waypoint integration covering all faction-appropriate heirloom token vendors (Heirloom Curator, Guild Vendor, PvP/Mark of Honor vendor, BfA Service Medal vendor, Timewalking vendors, Darkmoon Faire, Argent Tournament, seasonal event vendors); faction-split entries so Alliance and Horde each navigate to their own city

#### Persistence & Accessibility
- **State Persistence** — Class, spec, target tier, frame position, and per-slot item overrides all saved in `HUP_Config`
- **ESC Key Support** — Main frame registered with `UISpecialFrames` for standard keyboard dismiss
- **Slash Commands** — `/hup`, `/heirloom`, `/hupminimap`, `/hupdebug`
- **Debug Mode** — `/hupdebug` reveals the Debug button for API diagnostic output

### Technical Details
- **Game Version:** WoW Retail — Midnight (12.x)
- **Required:** `Blizzard_Collections`
- **Optional:** TomTom (vendor waypoints), LibStub + LibDataBroker-1.1 + LibDBIcon-1.0 (enhanced minimap icon)
- **SavedVariables:** `HUP_Config`
- **Files:** `Core.lua`, `Data.lua`, `Debug.lua`, `Minimap.lua`
- **Events:** `PLAYER_LOGIN`, `PLAYER_ENTERING_WORLD`, `MERCHANT_SHOW`, `MERCHANT_CLOSED`, `BAG_UPDATE`, `HEIRLOOM_UPGRADE_COMPLETE`, `PLAYER_MONEY`, `CURRENCY_DISPLAY_UPDATE`
- Legacy heirloom tier normalization (e.g. Hellscream weapons capped at 4 upgrades mapped into the standard 6-tier system)
