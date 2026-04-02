# Heirloom Upgrade Planner

A World of Warcraft Retail addon for planning and managing heirloom gear upgrades across all classes and specializations.

## Overview

Heirloom Upgrade Planner helps you calculate exactly what tokens and gold you need to upgrade your heirlooms to your target level. Select your class and spec, and the addon automatically identifies the optimal heirloom for each equipment slot—accounting for primary stats, armor types, weapon styles, and mutually exclusive items.

## Features

### Smart Slot Assignment

- **Class/Spec Detection** — Automatically detects your current class and specialization on load
- **Primary Stat Matching** — Filters heirlooms by Intellect, Agility, or Strength requirements
- **Armor Type Filtering** — Only shows Plate/Mail/Leather/Cloth appropriate for your class
- **Weapon Style Support** — Handles 2H, Dual-Wield, 1H+Shield, 1H+Offhand, and Ranged configurations
- **Mutually Exclusive Items** — Prevents equipping incompatible items (e.g., Ghost Pirate Rings)
- **Spec-Native Suggestions** — Highlights when a better stat-matching heirloom is available for your spec

### Upgrade Planning

- **Target Tier Selection** — Choose any upgrade tier from Base (Level 29) to Tier 6 (Level 70)
- **Token Cost Calculation** — Shows exact Armor Casing and Scabbard counts per tier
- **Gold Cost Breakdown** — Displays per-token gold costs and total gold required
- **Timewarped Badge Pricing** — Shows alternate currency costs for each token
- **Bag Scanning** — Detects tokens already in your inventory and deducts from shopping list

### Interactive UI

- **Left Panel** — Shows all 12 equipment slots with assigned heirlooms, current tier, and action buttons
- **Right Panel** — Displays tiered shopping list with costs and totals
- **Currency Bar** — Real-time display of your gold and Timewarped Badges
- **Item Tooltips** — Hover any heirloom icon for full item details including set bonuses
- **Upgrade Suggestions** — Indicates when a better spec-native item exists (collected or not)
- **Upgrade Button** — Appears per slot when item is below target tier and token is in bags; opens Collections Journal filtered to that heirloom
- **Copy / Equip Button** — Creates a heirloom copy or equips it directly from bags; slot-aware for main hand, off hand, and trinket slots
- **Slot Override (Pin)** — Expand any slot and click `Pin` on a candidate to lock it for the current class/spec/slot, overriding the auto-suggestion; a `Pinned` badge on the main row shows the override is active; hover for the original suggestion, click to revert
- **Minimap Icon** — Draggable button with LibDBIcon support and built-in fallback; toggle with `/hupminimap`

### Vendor Integration

- **Auto-Display at Vendors** — Shopping panel appears when visiting heirloom token vendors
- **One-Click Purchasing** — Buy tokens directly from the overlay panel
- **Real-Time Updates** — Bag counts and costs refresh immediately after purchase
- **Vendor Navigation** — TomTom waypoint buttons for all faction-appropriate vendors: Heirloom Curator, Guild Vendor, PvP/Mark of Honor, BfA Service Medal, Timewalking vendors, Darkmoon Faire, Argent Tournament, and seasonal event vendors (Hallow's End, Love is in the Air, Lunar Festival)

### Legacy Heirloom Support

- **Irregular Upgrade Caps** — Automatically normalizes items with non-standard max tiers (e.g., Hellscream's Weapons capped at 4) into the 6-tier system
- **Accurate Cost Calculation** — Ensures costs are always calculated correctly regardless of item origin

## Installation

1. Download the latest release
2. Extract to your WoW addon directory:
   - **Windows:** `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\`
   - **Mac:** `/Applications/World of Warcraft/_retail_/Interface/AddOns/`
3. Ensure the folder is named `Heirloom_Upgrade_Planner`
4. Restart WoW or type `/reload` in-game

## Usage

### Opening the Planner

- Type `/hup` or `/heirloom` in chat
- Or access via the addon compartment (if available)

### Planning Upgrades

1. **Select Class** — Use the class dropdown (defaults to your current class)
2. **Select Spec** — Use the spec dropdown (defaults to your current spec)
3. **Set Target Tier** — Choose your desired upgrade level from the dropdown
4. **Review Left Panel** — See assigned heirlooms and current tiers for each slot
5. **Review Right Panel** — See complete shopping list with costs

### Understanding the Display

| Element | Meaning |
|---------|---------|
| Gold item name | Heirloom is collected |
| Grey `(Not Collected)` | Heirloom is not in your collection |
| `Tier X/6` | Current upgrade level / maximum |
| Orange `Better: [Item]` | A spec-native alternative exists |
| Green `[X in bags]` | You have tokens in inventory |
| Green `[X in bags - done]` | You have enough tokens for this tier |

### Purchasing Tokens

1. Visit an heirloom token vendor:
   - **Alliance:** Krom Stoutarm (Hall of Explorers, Ironforge)
   - **Horde:** Estelle Gendry (Gates of Orgrimmar)
2. The shopping panel will appear automatically
3. Click **Buy 1** for each token you need
4. Panel updates in real-time as you purchase

### Debug Mode

Click the **Debug** button in the top bar to view detailed API information for testing and troubleshooting.

## Upgrade Tiers

| Tier | Max Level | Armor Token | Weapon Token | Gold (Armor) | Gold (Weapon) |
|------|-----------|-------------|--------------|--------------|---------------|
| 1 | 35 | Ancient Heirloom Armor Casing | Ancient Heirloom Scabbard | 500g | 750g |
| 2 | 40 | Timeworn Heirloom Armor Casing | Timeworn Heirloom Scabbard | 1,000g | 1,500g |
| 3 | 45 | Weathered Heirloom Armor Casing | Weathered Heirloom Scabbard | 2,000g | 3,000g |
| 4 | 50 | Battle-Hardened Heirloom Armor Casing | Battle-Hardened Heirloom Scabbard | 5,000g | 7,500g |
| 5 | 60 | Eternal Heirloom Armor Casing | Eternal Heirloom Scabbard | 5,000g | 7,500g |
| 6 | 70 | Awakened Heirloom Armor Casing | Awakened Heirloom Scabbard | 5,000g | 7,500g |

All tiers also have alternate Timewarped Badge pricing (750-1,200 badges per token).

## Supported Slots

| Slot | Equipment Location |
|------|-------------------|
| Head | `INVTYPE_HEAD` |
| Neck | `INVTYPE_NECK` |
| Shoulders | `INVTYPE_SHOULDER` |
| Back | `INVTYPE_CLOAK` |
| Chest | `INVTYPE_CHEST` / `INVTYPE_ROBE` |
| Legs | `INVTYPE_LEGS` |
| Ring 1 | `INVTYPE_FINGER` |
| Ring 2 | `INVTYPE_FINGER` |
| Trinket 1 | `INVTYPE_TRINKET` |
| Trinket 2 | `INVTYPE_TRINKET` |
| Main Hand | Various weapon types |
| Off Hand | Shield / Holdable / Weapon |

## Class & Spec Support

All 13 classes and 38 specializations are fully supported:

| Class | Specs | Armor | Primary Stats |
|-------|-------|-------|---------------|
| Warrior | Arms, Fury, Protection | Plate | Strength |
| Paladin | Holy, Protection, Retribution | Plate | Intellect, Strength |
| Death Knight | Blood, Frost, Unholy | Plate | Strength |
| Hunter | Beast Mastery, Marksmanship, Survival | Mail | Agility |
| Shaman | Elemental, Enhancement, Restoration | Mail | Intellect, Agility |
| Evoker | Devastation, Preservation, Augmentation | Mail | Intellect |
| Rogue | Assassination, Outlaw, Subtlety | Leather | Agility |
| Druid | Balance, Feral, Guardian, Restoration | Leather | Intellect, Agility |
| Monk | Brewmaster, Mistweaver, Windwalker | Leather | Agility, Intellect |
| Demon Hunter | Havoc, Vengeance, Devourer | Leather | Agility, Intellect |
| Mage | Arcane, Fire, Frost | Cloth | Intellect |
| Priest | Discipline, Holy, Shadow | Cloth | Intellect |
| Warlock | Affliction, Demonology, Destruction | Cloth | Intellect |

## Technical Details

### File Structure

```
Heirloom_Upgrade_Planner/
├── Heirloom_Upgrade_Planner.toc  # Addon metadata
├── Core.lua                     # Main UI, logic, event handlers
├── Data.lua                     # Static data tables
├── Debug.lua                    # Debug utility
├── Minimap.lua                  # Minimap icon (LibDBIcon + fallback)
└── docs/
    ├── API.md                   # WoW API documentation
    └── CurseForge_Description.md
```

### Key Functions

| Function | Purpose |
|----------|---------|
| `ns.RebuildPlan()` | Recalculates slot assignments and shopping list |
| `ns.ToggleFrame()` | Shows/hides the main UI |
| `ns.BuildVendorPanel()` | Constructs the vendor overlay |
| `ns.SetVendorWaypoint(info)` | Sets a TomTom waypoint for a vendor |
| `ns.RunDebugDump()` | Outputs API diagnostic information |
| `GetOverride(class, spec, slot)` | Returns the pinned item ID for a slot, if any |
| `SetOverride(class, spec, slot, id)` | Pins an item to a slot and saves |
| `ClearOverride(class, spec, slot)` | Removes a pin and reverts to auto-suggestion |

### Events Handled

- `PLAYER_LOGIN` — Load saved state
- `PLAYER_ENTERING_WORLD` — Initial data load and UI refresh
- `MERCHANT_SHOW` — Display vendor overlay
- `MERCHANT_CLOSED` — Hide vendor overlay
- `BAG_UPDATE` — Refresh vendor panel and shopping list after bag changes
- `HEIRLOOM_UPGRADE_COMPLETE` — Refresh UI after upgrading a heirloom
- `PLAYER_MONEY` — Update gold display
- `CURRENCY_DISPLAY_UPDATE` — Update Timewarped Badge display

### Saved Variables

- `HUP_Config` — Stores class, spec, target tier, frame position, minimap position, and per-slot item overrides (`HUP_Config.overrides[class][spec][slot]`)

## Compatibility

- **Game Version:** World of Warcraft Retail (Midnight 12.x)
- **API:** Uses modern `C_Item` and `C_Heirloom` APIs
- **Dependencies:** `Blizzard_Collections` (built-in)
- **Optional:** TomTom, LibStub, LibDataBroker-1.1, LibDBIcon-1.0
- **Conflicts:** None known

## Known Limitations

- Heirlooms must be cached by the WoW client; newly encountered items may show "Evaluating upgrades..." briefly on first open
- PvP heirlooms are detected but may not have complete token cost data
- Vendor Navigation requires the TomTom addon; waypoint buttons are disabled without it
- Seasonal vendor coordinates (Hallow's End, Love is in the Air) are approximate and may need fine-tuning in-game

## Contributing

When contributing code, please follow the guidelines in `.github/copilot-instructions.md`:

- Use `C_*` namespaced APIs over legacy globals
- Use `BackdropTemplate` for frames with `SetBackdrop`
- Use `SecureActionButtonTemplate` for protected actions
- Test with `InCombatLockdown()` checks before modifying secure frames

## License

This addon is provided as-is for the World of Warcraft community. Feel free to modify and share.

## Feedback

Report bugs or feature requests via the issue tracker. When reporting, include:

- Your class and spec
- The heirloom name being misidentified or miscalculated
- Expected vs. actual behavior
