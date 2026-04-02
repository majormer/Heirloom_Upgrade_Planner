# Heirloom Upgrade Planner

Heirloom Upgrade Planner is a comprehensive planning and upgrade assistant for World of Warcraft heirloom gear. Whether you're outfitting a new alt or optimizing an entire roster, this addon calculates exactly what you need — and lets you act on it directly.

**Quick Access:** Click the minimap icon or use `/hup` to open the planner.

---

## Features

### Smart Upgrade Planning
Select your character's **class** and **specialization** from intuitive dropdowns, and the addon automatically identifies the optimal heirloom for every equipment slot. It accounts for:

- **Primary stat requirements** — Intellect, Agility, or Strength depending on your spec
- **Armor type restrictions** — Cloth, Leather, Mail, or Plate
- **Weapon type compatibility** — including dual-wield, two-handed, ranged, and off-hand setups
- **Mutually exclusive items** — for example, Ghost Pirate Rings that cannot be equipped together
- **Weighted scoring system** — Prioritizes collected items, stat matches, and obtainability

### Tiered Cost Breakdown
Set a **Target Tier** and instantly see a complete shopping list on the right panel, broken down tier by tier. The list shows:

- How many **Armor Casings** and **Scabbards** are needed at each tier
- The **gold cost** for each token type
- A **total gold required** summary at the bottom

Supported tiers:
| Tier | Cap Level | Armor Token | Weapon Token |
|------|-----------|-------------|--------------|
| 1 | 35 | Ancient Heirloom Armor Casing | Ancient Heirloom Scabbard |
| 2 | 40 | Timeworn Heirloom Armor Casing | Timeworn Heirloom Scabbard |
| 3 | 45 | Weathered Heirloom Armor Casing | Weathered Heirloom Scabbard |
| 4 | 50 | Battle-Hardened Heirloom Armor Casing | Battle-Hardened Heirloom Scabbard |
| 5 | 60 | Eternal Heirloom Armor Casing | Eternal Heirloom Scabbard |
| 6 | 70 | Awakened Heirloom Armor Casing | Awakened Heirloom Scabbard |

### Interactive Heirloom List
Each row in the left panel shows:

- The **item icon** (hover for a full tooltip with stats and set bonuses)
- The **item name** with color-coded obtainability status:
  - **Green** — Owned and obtainable
  - **Yellow** — Missing but can still be acquired
  - **Orange** — Missing with limited availability (rare sources)
  - **Dark Red** — Missing and no longer obtainable (legacy items)
  - **Gray** — Owned legacy items
- The current **Tier level** (e.g. `Tier 5/6`)
- A **`+` expand button** to view all eligible heirlooms for that slot
- An **Upgrade button** (when token is in bags) that opens the Collections Journal filtered to that heirloom for one-click upgrading
- A **Copy / Equip button** to create a bag copy or equip the heirloom directly; slot-aware for main hand, off hand, and trinket slots

### Expandable Slot Details & Item Override
Click the **`+`** button on any slot to expand and see:
- All eligible heirlooms for that slot, sorted by score
- Tier information and stat compatibility
- Obtainability status with color coding
- Best-assigned item highlighted with `>` marker

Each candidate also has a **Pin** button. Click it to lock that specific item for the current class, spec, and slot — overriding the automatic suggestion. The main row will show a **Pinned** badge; hover it to see what the auto-suggestion was, or click it to revert.

### Obtainability Tracking
The addon tracks **38 unobtainable items** (Hellscream weapons, WoD Mythic trinkets) and **7 limited-availability items** (Garrison missions, STV Fishing), helping you make informed decisions about which heirlooms to pursue.

### Minimap Icon
Quick access via a draggable minimap button:
- **Left-click** to open the planner
- **Drag** to reposition around the minimap
- Toggle visibility with `/hupminimap`
- Works with or without LibDBIcon

### Vendor Navigation (TomTom Integration)
The right panel includes a built-in vendor waypoint section below the shopping list:
- One-click waypoint buttons for all relevant heirloom token vendors
- Faction-appropriate list — Alliance, Horde, and Neutral vendors shown separately
- Covers Heirloom Curator, Guild Vendor, PvP/Mark of Honor, BfA Service Medal, Timewalking, Darkmoon Faire, Argent Tournament, and seasonal event vendors
- Requires TomTom addon; buttons indicate when TomTom is not installed

### Vendor Overlay Panel
When visiting heirloom token vendors, an overlay panel automatically appears showing:
- Items you still need from this vendor
- **One-click "Buy 1" buttons** for instant purchases
- Real-time cost display and inventory updates
- Automatic refresh after purchases

### Bag Scanning
The addon automatically scans your inventory for upgrade tokens. If you carry the token needed for the very next tier on any heirloom, the **Upgrade button** appears beside that slot — no manual searching required.

### Legacy Heirloom Support
Older heirlooms with non-standard upgrade caps (such as Hellscream's Weapons capped at 4 upgrades instead of 6) are **automatically normalized** into the standard 6-tier system so costs are always calculated accurately.

---

## How to Use

1. **Open the planner:**
   - Click the minimap icon, or
   - Use `/hup` or `/heirloom` slash command
2. Select your **Class** and **Spec** from the dropdowns
3. Set your **Target Tier** — the tier you want all heirlooms to reach
4. Review the **left panel** for your current heirloom assignments and tiers
   - Click **`+`** on any slot to see all eligible heirlooms
5. Review the **right panel** for the complete shopping list and total cost
6. Use the **Vendor Navigation** waypoint buttons in the right panel to set a TomTom waypoint to the nearest vendor (requires TomTom)
7. Visit a vendor and use the overlay panel to purchase tokens with one click

---

## Tips

- **Color coding helps you prioritize:** Yellow items are still obtainable, red items are legacy-only
- **Expand slots** to see all options and compare alternatives
- **Hover over any heirloom icon** to see its full item tooltip, including set bonus information
- The planner uses **weighted scoring** to pick the best heirloom: collected > stat match > upgrade tier > obtainability
- **Bag scanning is automatic** — upgrade buttons appear when you have the required token
- **State persistence** — Your class, spec, and target tier selections are saved across sessions

---

## Slash Commands

| Command | Action |
|---------|--------|
| `/hup` | Toggle the Heirloom Upgrade Planner window |
| `/heirloom` | Toggle the Heirloom Upgrade Planner window |
| `/hupminimap` | Toggle minimap icon visibility |
| `/hupdebug` | Toggle debug button visibility (for troubleshooting) |

---

## Compatibility

- **Game Version:** World of Warcraft Retail (Midnight 12.x)
- **Required:** No dependencies — works standalone
- **Optional Addons:**
  - **TomTom** — Enables vendor waypoint navigation
  - **LibDBIcon** — Enhanced minimap icon (built-in fallback included)
- Compatible with the default Heirloom Journal and Heirloom Steward

---

## Feedback & Bugs

If you find a bug or a missing edge case, please leave a comment on the CurseForge page with:
- Your class and spec
- The heirloom name that is being misidentified or miscalculated
- What you expected vs. what the addon displayed
