local addonName, ns = ...

-- =============================================================
-- CLASS -> ARMOR TYPE
-- =============================================================
ns.CLASS_ARMOR = {
    WARRIOR="Plate", PALADIN="Plate", DEATHKNIGHT="Plate",
    HUNTER="Mail", SHAMAN="Mail", EVOKER="Mail",
    ROGUE="Leather", DRUID="Leather", MONK="Leather", DEMONHUNTER="Leather",
    MAGE="Cloth", PRIEST="Cloth", WARLOCK="Cloth",
}

-- =============================================================
-- CLASS -> USABLE WEAPON SUBTYPES
-- =============================================================
ns.CLASS_WEAPONS = {
    WARRIOR     = {"Daggers","One-Handed Swords","Two-Handed Swords","One-Handed Axes","Two-Handed Axes","One-Handed Maces","Two-Handed Maces","Polearms","Staves","Shields","Fist Weapons"},
    PALADIN     = {"One-Handed Swords","Two-Handed Swords","One-Handed Axes","Two-Handed Axes","One-Handed Maces","Two-Handed Maces","Polearms","Shields"},
    DEATHKNIGHT = {"One-Handed Swords","Two-Handed Swords","One-Handed Axes","Two-Handed Axes","One-Handed Maces","Two-Handed Maces","Polearms"},
    HUNTER      = {"Bows","Crossbows","Guns","Polearms","Staves","Daggers","One-Handed Axes","Two-Handed Axes","One-Handed Swords","Two-Handed Swords","Fist Weapons"},
    SHAMAN      = {"One-Handed Axes","Two-Handed Axes","One-Handed Maces","Two-Handed Maces","Daggers","Fist Weapons","Staves","Shields"},
    EVOKER      = {"One-Handed Swords","One-Handed Axes","One-Handed Maces","Daggers","Fist Weapons","Staves","Held In Off-hand"},
    ROGUE       = {"Daggers","One-Handed Swords","One-Handed Axes","One-Handed Maces","Fist Weapons"},
    DRUID       = {"Staves","Polearms","One-Handed Maces","Two-Handed Maces","Daggers","Fist Weapons","Held In Off-hand"},
    MONK        = {"One-Handed Swords","One-Handed Axes","One-Handed Maces","Staves","Polearms","Fist Weapons"},
    DEMONHUNTER = {"Warglaives","One-Handed Swords","One-Handed Axes","Fist Weapons"},
    MAGE        = {"Staves","Daggers","One-Handed Swords","Wands","Held In Off-hand"},
    PRIEST      = {"Staves","Daggers","One-Handed Maces","Wands","Held In Off-hand"},
    WARLOCK     = {"Staves","Daggers","One-Handed Swords","Wands","Held In Off-hand"},
}

-- =============================================================
-- SPEC DEFINITIONS
-- primaryStat: "Intellect", "Agility", "Strength"
-- weaponStyle: "2H", "DW", "1H+OH", "1H+Shield", "Ranged"
-- =============================================================
ns.CLASS_SPECS = {
    WARRIOR = {
        {name="Arms",       primaryStat="Strength", weaponStyle="2H"},
        {name="Fury",       primaryStat="Strength", weaponStyle="DW"},
        {name="Protection", primaryStat="Strength", weaponStyle="1H+Shield"},
    },
    PALADIN = {
        {name="Holy",        primaryStat="Intellect", weaponStyle="1H+Shield"},
        {name="Protection",  primaryStat="Strength",  weaponStyle="1H+Shield"},
        {name="Retribution", primaryStat="Strength",  weaponStyle="2H"},
    },
    DEATHKNIGHT = {
        {name="Blood",  primaryStat="Strength", weaponStyle="2H"},
        {name="Frost",  primaryStat="Strength", weaponStyle="DW"},
        {name="Unholy", primaryStat="Strength", weaponStyle="2H"},
    },
    HUNTER = {
        {name="Beast Mastery", primaryStat="Agility", weaponStyle="Ranged"},
        {name="Marksmanship",  primaryStat="Agility", weaponStyle="Ranged"},
        {name="Survival",      primaryStat="Agility", weaponStyle="2H"},
    },
    SHAMAN = {
        {name="Elemental",   primaryStat="Intellect", weaponStyle="1H+Shield"},
        {name="Enhancement", primaryStat="Agility",   weaponStyle="DW"},
        {name="Restoration", primaryStat="Intellect", weaponStyle="1H+Shield"},
    },
    EVOKER = {
        {name="Devastation",  primaryStat="Intellect", weaponStyle="2H"},
        {name="Preservation", primaryStat="Intellect", weaponStyle="2H"},
        {name="Augmentation", primaryStat="Intellect", weaponStyle="2H"},
    },
    ROGUE = {
        {name="Assassination", primaryStat="Agility", weaponStyle="DW"},
        {name="Outlaw",        primaryStat="Agility", weaponStyle="DW"},
        {name="Subtlety",      primaryStat="Agility", weaponStyle="DW"},
    },
    DRUID = {
        {name="Balance",     primaryStat="Intellect", weaponStyle="2H"},
        {name="Feral",       primaryStat="Agility",   weaponStyle="2H"},
        {name="Guardian",    primaryStat="Agility",   weaponStyle="2H"},
        {name="Restoration", primaryStat="Intellect", weaponStyle="1H+OH"},
    },
    MONK = {
        {name="Brewmaster", primaryStat="Agility",   weaponStyle="2H"},
        {name="Mistweaver", primaryStat="Intellect", weaponStyle="2H"},
        {name="Windwalker", primaryStat="Agility",   weaponStyle="DW"},
    },
    DEMONHUNTER = {
        {name="Havoc",     primaryStat="Agility",   weaponStyle="DW"},
        {name="Vengeance", primaryStat="Agility",   weaponStyle="DW"},
        {name="Devourer",  primaryStat="Intellect", weaponStyle="DW"},
    },
    MAGE = {
        {name="Arcane", primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Fire",   primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Frost",  primaryStat="Intellect", weaponStyle="1H+OH"},
    },
    PRIEST = {
        {name="Discipline", primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Holy",       primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Shadow",     primaryStat="Intellect", weaponStyle="1H+OH"},
    },
    WARLOCK = {
        {name="Affliction",  primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Demonology",  primaryStat="Intellect", weaponStyle="1H+OH"},
        {name="Destruction", primaryStat="Intellect", weaponStyle="1H+OH"},
    },
}

-- =============================================================
-- UPGRADE TOKEN DATA
-- {upgradeLevel, armorTokenName, weaponTokenName, goldArmor, goldWeapon, twBadgeArmor, twBadgeWeapon, resultMaxLevel}
-- =============================================================
ns.UPGRADE_LEVELS = {
    {1, "Ancient Heirloom Armor Casing",         "Ancient Heirloom Scabbard",         500,  750,  750,  900,  35},
    {2, "Timeworn Heirloom Armor Casing",        "Timeworn Heirloom Scabbard",        1000, 1500, 1000, 1200, 40},
    {3, "Weathered Heirloom Armor Casing",       "Weathered Heirloom Scabbard",       2000, 3000, 1000, 1200, 45},
    {4, "Battle-Hardened Heirloom Armor Casing",  "Battle-Hardened Heirloom Scabbard", 5000, 7500, 1000, 1200, 50},
    {5, "Eternal Heirloom Armor Casing",         "Eternal Heirloom Scabbard",         5000, 7500, 1000, 1200, 60},
    {6, "Awakened Heirloom Armor Casing",        "Awakened Heirloom Scabbard",        5000, 7500, 1000, 1200, 70},
}

ns.UPGRADE_LEVEL_NAMES = {
    [0] = "Base (1-30)",
    [1] = "Level 1 (1-35)",
    [2] = "Level 2 (1-40)",
    [3] = "Level 3 (1-45)",
    [4] = "Level 4 (1-50)",
    [5] = "Level 5 (1-60)",
    [6] = "Level 6 (1-70)",
}

ns.MAX_UPGRADE_LEVEL = 6

-- =============================================================
-- PLAN SLOTS
-- =============================================================
ns.PLAN_SLOTS = {
    {key="Head",      equipLoc="INVTYPE_HEAD"},
    {key="Neck",      equipLoc="INVTYPE_NECK"},
    {key="Shoulders", equipLoc="INVTYPE_SHOULDER"},
    {key="Back",      equipLoc="INVTYPE_CLOAK"},
    {key="Chest",     equipLoc="INVTYPE_CHEST"},
    {key="Legs",      equipLoc="INVTYPE_LEGS"},
    {key="Ring 1",    equipLoc="INVTYPE_FINGER"},
    {key="Ring 2",    equipLoc="INVTYPE_FINGER"},
    {key="Trinket 1", equipLoc="INVTYPE_TRINKET"},
    {key="Trinket 2", equipLoc="INVTYPE_TRINKET"},
    {key="Main Hand", equipLoc="MAINHAND"},
    {key="Off Hand",  equipLoc="OFFHAND"},
}

-- =============================================================
-- VENDORS
-- =============================================================
ns.VENDORS = {
    ALLIANCE = {
        heirloom = {name="Krom Stoutarm", location="Hall of Explorers, Ironforge"},
        guild    = {name="Shay Pressler", location="Stormwind City"},
        pvp      = {name="Liliana Emberfrost", location="Champion's Hall, Stormwind"},
        tw       = {name="Timewalking Vendor", location="Available during Timewalking events"},
    },
    HORDE = {
        heirloom = {name="Estelle Gendry", location="Gates of Orgrimmar"},
        guild    = {name="Goram", location="Orgrimmar"},
        pvp      = {name="Galra", location="Hall of Legends, Orgrimmar"},
        tw       = {name="Timewalking Vendor", location="Available during Timewalking events"},
    },
}

-- =============================================================
-- HELPERS
-- =============================================================
function ns.IsArmorSlot(equipLoc)
    return equipLoc == "INVTYPE_HEAD" or equipLoc == "INVTYPE_SHOULDER"
        or equipLoc == "INVTYPE_CHEST" or equipLoc == "INVTYPE_ROBE"
        or equipLoc == "INVTYPE_LEGS" or equipLoc == "INVTYPE_CLOAK"
end

function ns.UsesArmorCasing(equipLoc)
    return ns.IsArmorSlot(equipLoc)
end

-- =============================================================
-- HEIRLOOM OBTAINABILITY
-- Items not in this table are assumed currently obtainable.
-- =============================================================
ns.HEIRLOOM_OBTAINABILITY = {
    -- Hellscream weapons (Garrosh Hellscream - Siege of Orgrimmar, Normal)
    [104399] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104400] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104401] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104402] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104403] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104404] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104405] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104406] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104407] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104408] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    [104409] = {obtainable=false, source="Garrosh Hellscream (SoO Normal)"},
    -- Hellscream weapons (Heroic)
    [105670] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105671] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105672] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105673] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105674] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105675] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105676] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105677] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105678] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105679] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    [105680] = {obtainable=false, source="Garrosh Hellscream (SoO Heroic)"},
    -- Hellscream weapons (Mythic)
    [105683] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105684] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105685] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105686] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105687] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105688] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105689] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105690] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105691] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105692] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    [105693] = {obtainable=false, source="Garrosh Hellscream (SoO Mythic)"},
    -- WoD Mythic Dungeon trinkets (removed in Legion)
    [133595] = {obtainable=false, source="WoD Mythic Dungeon drop"},
    [133585] = {obtainable=false, source="WoD Mythic Dungeon drop"},
    [133596] = {obtainable=false, source="WoD Mythic Dungeon drop"},
    [133597] = {obtainable=false, source="WoD Mythic Dungeon drop"},
    [133598] = {obtainable=false, source="WoD Mythic Dungeon drop"},
    -- TWW pre-patch event ring (one-time event, no longer available)
    [219325] = {obtainable=false, source="TWW Pre-Patch: Radiant Echoes event"},
    -- Limited availability
    [122529] = {obtainable=true, limited=true, source="STV Fishing Extravaganza (weekly)"},
    [128169] = {obtainable=true, limited=true, source="Garrison Mission: The Wave Mistress"},
    [128172] = {obtainable=true, limited=true, source="Garrison Mission: For Hate's Sake"},
    [128173] = {obtainable=true, limited=true, source="Garrison Mission: The House Always Wins"},
    [153130] = {obtainable=true, limited=true, source="Garrison Mission"},
    [131733] = {obtainable=true, limited=true, source="Archaeology (Vrykul)"},
    [122396] = {obtainable=true, limited=true, source="Brawler's Guild Rank 8"},
}

-- =============================================================
-- FACTION RESTRICTIONS (items exclusive to one faction)
-- =============================================================
ns.HEIRLOOM_FACTION = {
    -- Alliance exclusive
    [166770] = "Alliance",  -- Banded Gilnean Cloak
    [166769] = "Alliance",  -- Dwarven War Horn
    [166768] = "Alliance",  -- Hymnal of the 7th Legion
    [166767] = "Alliance",  -- Kaldorei Powder of Twilight
    [166766] = "Alliance",  -- Tidesages' Warscroll
    [122371] = "Alliance",  -- Inherited Insignia of the Alliance
    -- Horde exclusive
    [166752] = "Horde",     -- Stone Guard's Bladed Cloak
    [166753] = "Horde",     -- Orcish War Horn
    [166754] = "Horde",     -- Tome of Thalassian Hymns
    [166755] = "Horde",     -- Deathstalkers' Gloaming Powder
    [166756] = "Horde",     -- Loa-Touched Warscroll
    [122370] = "Horde",     -- Inherited Insignia of the Horde
}

-- =============================================================
-- FIXED-STAT ITEMS
-- These items do NOT scale with spec; they have a fixed primary stat.
-- HasEligibleStats checks this table first and returns immediately.
-- All INVTYPE_HOLDABLE off-hands are fixed Intellect.
-- =============================================================
ns.FIXED_STAT_ITEMS = {
    -- Necklaces (all have fixed primary stats)
    [122663] = "Intellect",  -- Eternal Amulet of the Redeemed
    [122667] = "Intellect",  -- Eternal Emberfury Talisman
    [122664] = "Agility",    -- Eternal Horizon Choker
    [122662] = "Agility",    -- Eternal Talisman of Evasion
    [122668] = "Intellect",  -- Eternal Will of the Martyr
    [122666] = "Intellect",  -- Eternal Woven Ivy Necklace
    [153130] = "Intellect",  -- Man'ari Training Amulet
    -- Trinkets with fixed primary stats
    [122362] = "Intellect",  -- Discerning Eye of the Beast
    [122530] = "Stamina",    -- Inherited Mark of Tyranny (tank-focused, usable by all)
    [133595] = "Strength",   -- Gronntooth War Horn (unobtainable)
    [133585] = "Intellect",  -- Judgment of the Naaru (unobtainable)
    [133596] = "Intellect",  -- Orb of Voidsight (unobtainable)
    [133598] = "Stamina",    -- Purified Shard of the Third Moon (unobtainable)
    [166768] = "Intellect",  -- Hymnal of the 7th Legion (Alliance)
    [166766] = "Intellect",  -- Tidesages' Warscroll (Alliance)
    [166754] = "Intellect",  -- Tome of Thalassian Hymns (Horde)
    [166756] = "Intellect",  -- Loa-Touched Warscroll (Horde)
    -- Held off-hands (all fixed Intellect — also bypasses broken armor-type check for Misc subclass)
    [122390] = "Intellect",  -- Musty Tome of the Lost
    [104408] = "Intellect",  -- Hellscream's Tome of Destruction (Normal)
    [105676] = "Intellect",  -- Hellscream's Tome of Destruction (Heroic)
    [105689] = "Intellect",  -- Hellscream's Tome of Destruction (Mythic)
}

-- =============================================================
-- UI COLOR CODES FOR OBTAINABILITY STATES
-- =============================================================
ns.COLORS = {
    owned_obtainable     = "|cff00ff00",   -- Green:    owned, still gettable
    owned_unobtainable   = "|cff888888",   -- Gray:     owned, no longer gettable
    missing_obtainable   = "|cffffff00",   -- Yellow:   missing, can still buy
    missing_unobtainable = "|cffaa0000",   -- Dark Red: missing, unobtainable
    missing_limited      = "|cffff9900",   -- Orange:   missing, limited availability
}
-- Accessibility text tags (appended to names so colors aren't the only indicator)
ns.TAGS = {
    owned_obtainable     = "",
    owned_unobtainable   = " [Legacy]",
    missing_obtainable   = " [Buy]",
    missing_unobtainable = " [Gone]",
    missing_limited      = " [Rare]",
}

-- =============================================================
-- CURRENCY IDS used across the addon
-- =============================================================
ns.CURRENCY_IDS = {
    TimewarpedBadge      = 1166,
    ChampionsSeal        = 241,
    MarkOfHonor          = 1901, -- Marks of Honor (honor currency)
    DarkmoonPrizeTicket  = 515,
    CoinOfAncestry       = 21100, -- NOTE: Item ID, not Currency ID
    LoveToken            = 1997,  -- Love Token (Currency ID 1997)
    TrickyTreat          = 2030,  -- Tricky Treat (Currency ID 2030 or Item ID 33226?)
}

-- =============================================================
-- HEIRLOOM PURCHASE COSTS
-- Each entry: { gold = <copper>, currency = { {id, amount}, ... }, vendor = "..." }
-- Gold is in gold (not copper). Items not in this table have unknown cost.
-- Hellscream weapons and WoD mythic dungeon trinkets are omitted (unobtainable).
-- =============================================================
ns.HEIRLOOM_PURCHASE_COSTS = {
    -- ===== HEAD (Guild Vendor, 500g, Friendly) =====
    [122250] = {gold=500, vendor="Guild Vendor"},        -- Tattered Dreadmist Mask
    [122249] = {gold=500, vendor="Guild Vendor"},        -- Preened Tribal War Feathers
    [122248] = {gold=500, vendor="Guild Vendor"},        -- Stained Shadowcraft Cap
    [122247] = {gold=500, vendor="Guild Vendor"},        -- Mystical Coif of Elements
    [122246] = {gold=500, vendor="Guild Vendor"},        -- Tarnished Raging Berserker's Helm
    [122263] = {gold=500, vendor="Guild Vendor"},        -- Burnished Helm of Might
    [122245] = {gold=500, vendor="Guild Vendor"},        -- Polished Helm of Valor
    [127012] = {gold=500, vendor="Heirloom Curator"},    -- Pristine Lightforge Helm

    -- ===== SHOULDERS (mixed sources) =====
    -- Mark of Honor shoulders
    [122378] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Exquisite Sunderseer Mantle
    [122376] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Exceptional Stormshroud Shoulders
    [122377] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Lasting Feralheart Spaulders
    [122375] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Aged Pauldrons of the Five Thunders
    [122374] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Prized Beastmaster's Mantle
    [122373] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Pristine Lightforge Spaulders
    [122372] = {gold=500, altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 8}}, vendor="PvP Vendor"},  -- Strengthened Stockade Pauldrons
    -- Champion's Seal / Darkmoon Faire shoulders
    [122360] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122359] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122358] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122357] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122388] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122355] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},
    [122356] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},

    -- ===== CHEST (Heirloom Curator / Argent / Darkmoon) =====
    [122384] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122382] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122383] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122379] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122380] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122387] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [122381] = {gold=500, altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Heirloom Curator"},
    [127010] = {gold=500, vendor="Heirloom Curator"},    -- Pristine Lightforge Breastplate

    -- ===== LEGS (Guild Vendor, 500g, Honored) =====
    [122256] = {gold=500, vendor="Guild Vendor"},        -- Tattered Dreadmist Leggings
    [122255] = {gold=500, vendor="Guild Vendor"},        -- Preened Wildfeather Leggings
    [122254] = {gold=500, vendor="Guild Vendor"},        -- Stained Shadowcraft Pants
    [122253] = {gold=500, vendor="Guild Vendor"},        -- Mystical Kilt of Elements
    [122252] = {gold=500, vendor="Guild Vendor"},        -- Tarnished Leggings of Destruction
    [122264] = {gold=500, vendor="Guild Vendor"},        -- Burnished Legplates of Might
    [122251] = {gold=500, vendor="Guild Vendor"},        -- Polished Legplates of Valor
    [127011] = {gold=500, vendor="Guild Vendor"},        -- Pristine Lightforge Legplates

    -- ===== CLOAKS (Guild Vendor or PvP) =====
    [122262] = {gold=500, vendor="Guild Vendor"},        -- Ancient Bloodmoon Cloak
    [122261] = {gold=500, vendor="Guild Vendor"},        -- Inherited Cape of the Black Baron
    [122266] = {gold=500, vendor="Guild Vendor"},        -- Ripped Sandstorm Cloak
    [122260] = {gold=500, vendor="Guild Vendor"},        -- Worn Stoneskin Gargoyle Cape
    [166770] = {altCurrency={{1716, 75}}, vendor="Alliance PvP Vendor"},  -- Banded Gilnean Cloak (7th Legion Service Medal)
    [166752] = {altCurrency={{1717, 75}}, vendor="Horde PvP Vendor"},     -- Stone Guard's Bladed Cloak (Honorbound Service Medal)

    -- ===== NECKLACES (Heirloom Curator, 700g) =====
    [122663] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Amulet of the Redeemed
    [122667] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Emberfury Talisman
    [122664] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Horizon Choker
    [122662] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Talisman of Evasion
    [122668] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Will of the Martyr
    [122666] = {gold=700, vendor="Heirloom Curator"},    -- Eternal Woven Ivy Necklace

    -- ===== TRINKETS =====
    [122362] = {gold=700, vendor="Heirloom Curator"},    -- Discerning Eye of the Beast
    [122361] = {gold=700, vendor="Heirloom Curator"},    -- Swift Hand of Justice
    [126948] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"}, -- Defending Champion
    [126949] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"}, -- Returning Champion
    [122371] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="Alliance PvP Vendor"},  -- Inherited Insignia of the Alliance
    [122370] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="Horde PvP Vendor"},     -- Inherited Insignia of the Horde
    [122530] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},           -- Inherited Mark of Tyranny
    -- Alliance PvP service medal trinkets (75 x 7th Legion Service Medal = currency 1716)
    [166769] = {altCurrency={{1716, 75}}, vendor="Alliance PvP Vendor"},  -- Dwarven War Horn
    [166768] = {altCurrency={{1716, 75}}, vendor="Alliance PvP Vendor"},  -- Hymnal of the 7th Legion
    [166767] = {altCurrency={{1716, 75}}, vendor="Alliance PvP Vendor"},  -- Kaldorei Powder of Twilight
    [166766] = {altCurrency={{1716, 75}}, vendor="Alliance PvP Vendor"},  -- Tidesages' Warscroll
    -- Horde PvP service medal trinkets (75 x Honorbound Service Medal = currency 1717)
    [166753] = {altCurrency={{1717, 75}}, vendor="Horde PvP Vendor"},     -- Orcish War Horn
    [166754] = {altCurrency={{1717, 75}}, vendor="Horde PvP Vendor"},     -- Tome of Thalassian Hymns
    [166755] = {altCurrency={{1717, 75}}, vendor="Horde PvP Vendor"},     -- Deathstalkers' Gloaming Powder
    [166756] = {altCurrency={{1717, 75}}, vendor="Horde PvP Vendor"},     -- Loa-Touched Warscroll
    [128318] = {vendor="Garrison Mission"},                               -- Touch of the Void

    -- ===== WEAPONS — 1H =====
    -- Daggers
    [122350] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Balanced Heartseeker
    [122364] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- Sharpened Scarlet Kris
    -- Fist Weapons
    [122396] = {gold=1000, vendor="Brawler's Guild (Rank 8)"},  -- Brawler's Razor Claws
    -- 1H Swords
    [122369] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- Battleworn Thrash Blade
    [122389] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Bloodsoaked Skullforge Reaver
    [122351] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Venerable Dal'Rend's Sacred Charge
    -- 1H Maces
    [122367] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- The Blessed Hammer of Grace
    [122385] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Venerable Mass of McGowan
    -- 1H Axes
    [122354] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Devout Aurastone Hammer

    -- ===== WEAPONS — 2H =====
    [122349] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 40}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 75}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Bloodied Arcanite Reaper (2H Axe)
    [122365] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- Reforged Truesilver Champion (2H Mace)
    [122386] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 40}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 75}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Repurposed Lava Dredger (2H Mace)
    -- Polearms
    [140773] = {gold=750, vendor="Heirloom Curator"},    -- Eagletalon Spear
    -- Staves
    [122363] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 40}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 75}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Burnished Warden Staff
    [122353] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 40}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 75}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Dignified Headmaster's Charge
    [122368] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- Grand Staff of Jordan

    -- ===== RANGED =====
    [122352] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 40}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 75}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Charmed Ancient Bone Bow
    [122366] = {altCurrency={{ns.CURRENCY_IDS.MarkOfHonor, 10}}, vendor="PvP Vendor"},  -- Upgraded Dwarven Hand Cannon

    -- ===== OFF-HANDS =====
    [122391] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Flamescarred Draconian Deflector (Shield)
    [122392] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Weathered Observer's Shield
    [122390] = {altCurrency={{ns.CURRENCY_IDS.ChampionsSeal, 25}, {ns.CURRENCY_IDS.DarkmoonPrizeTicket, 50}}, vendor="Argent Tournament / Darkmoon Faire"},  -- Musty Tome of the Lost (OH)
}

-- =============================================================
-- HEIRLOOM VENDOR LOCATIONS (for TomTom integration)
-- uiMapID + normalized x,y coords (0-1 range)
-- =============================================================
ns.VENDOR_COORDS = {
    ALLIANCE = {
        heirloom = {
            name  = "Krom Stoutarm",
            title = "Heirloom Curator",
            zone  = "Ironforge",
            mapID = 87,
            x     = 0.7455,
            y     = 0.0978,
        },
        guild = {
            name  = "Shay Pressler",
            title = "Guild Vendor",
            zone  = "Stormwind City",
            mapID = 84,
            x     = 0.6440,
            y     = 0.7690,
        },
        pvp = {
            name  = "Liliana Emberfrost",
            title = "Mark of Honor Vendor",
            zone  = "Stormwind City",
            mapID = 84,
            x     = 0.7450,
            y     = 0.6784,
        },
        bfa = {
            name  = "Provisioner Stoutforge",
            title = "BfA Service Medal Vendor",
            zone  = "Boralus",
            mapID = 1161,
            x     = 0.6688,
            y     = 0.2578,
        },
        tw_kiatke = {
            name  = "Kiatke",
            title = "Timewalking Vendor (Cataclysm)",
            zone  = "Stormwind City",
            mapID = 84,
            x     = 0.7310,
            y     = 0.1740,
            note  = "Only during Cataclysm Timewalking",
        },
        tw_tempra = {
            name  = "Tempra",
            title = "Timewalking Vendor (WoD)",
            zone  = "Stormshield",
            mapID = 622,
            x     = 0.3735,
            y     = 0.7225,
            note  = "Only during Warlords of Draenor Timewalking",
        },
        love = {
            name  = "Lovely Merchant",
            title = "Love is in the Air Vendor",
            zone  = "Stormwind City",
            mapID = 84,
            x     = 0.6200,
            y     = 0.7400,
            note  = "Only during Love is in the Air",
        },
        hallows = {
            name  = "Dorothy",
            title = "Hallow's End Candy Vendor",
            zone  = "Elwynn Forest",
            mapID = 37,
            x     = 0.4600,
            y     = 0.6500,
            note  = "Only during Hallow's End",
        },
    },
    HORDE = {
        heirloom = {
            name  = "Estelle Gendry",
            title = "Heirloom Curator",
            zone  = "Orgrimmar",
            mapID = 85,
            x     = 0.5710,
            y     = 0.9000,
            note  = "Gates of Orgrimmar (requires BfA intro)",
        },
        guild = {
            name  = "Goram",
            title = "Guild Vendor",
            zone  = "Orgrimmar",
            mapID = 85,
            x     = 0.4820,
            y     = 0.7550,
        },
        pvp = {
            name  = "Galra",
            title = "Mark of Honor Vendor",
            zone  = "Orgrimmar",
            mapID = 85,
            x     = 0.3800,
            y     = 0.7040,
        },
        bfa = {
            name  = "Provisioner Mukra",
            title = "BfA Service Medal Vendor",
            zone  = "Dazar'alor",
            mapID = 1165,
            x     = 0.5120,
            y     = 0.9520,
        },
        tw_kiatke = {
            name  = "Kiatke",
            title = "Timewalking Vendor (Cataclysm)",
            zone  = "Orgrimmar",
            mapID = 85,
            x     = 0.5200,
            y     = 0.4150,
            note  = "Only during Cataclysm Timewalking",
        },
        tw_kronnus = {
            name  = "Kronnus",
            title = "Timewalking Vendor (WoD)",
            zone  = "Warspear",
            mapID = 624,
            x     = 0.4280,
            y     = 0.5450,
            note  = "Only during Warlords of Draenor Timewalking",
        },
        love = {
            name  = "Lovely Merchant",
            title = "Love is in the Air Vendor",
            zone  = "Orgrimmar",
            mapID = 85,
            x     = 0.4500,
            y     = 0.7700,
            note  = "Only during Love is in the Air",
        },
        hallows = {
            name  = "Chub",
            title = "Hallow's End Candy Vendor",
            zone  = "Undercity",
            mapID = 18,
            x     = 0.6200,
            y     = 0.6700,
            note  = "Only during Hallow's End",
        },
    },
    NEUTRAL = {
        darkmoon = {
            name  = "Daenrand Dawncrest",
            title = "Darkmoon Faire Vendor",
            zone  = "Darkmoon Island",
            mapID = 407,
            x     = 0.4769,
            y     = 0.6652,
            note  = "Only during Darkmoon Faire (1st Sunday of each month)",
        },
        argent = {
            name  = "Dame Evniki Kapsalis",
            title = "Argent Tournament Vendor",
            zone  = "Icecrown",
            mapID = 118,
            x     = 0.6940,
            y     = 0.2320,
            note  = "Requires Argent Tournament progression",
        },
        tw_cupri = {
            name  = "Cupri",
            title = "Timewalking Vendor (Burning Crusade)",
            zone  = "Shattrath City",
            mapID = 111,
            x     = 0.5450,
            y     = 0.3840,
            note  = "Only during TBC Timewalking",
        },
        tw_auzin = {
            name  = "Auzin",
            title = "Timewalking Vendor (Wrath of the Lich King)",
            zone  = "Dalaran (Northrend)",
            mapID = 125,
            x     = 0.5000,
            y     = 0.4600,
            note  = "Only during WotLK Timewalking",
        },
        tw_xia = {
            name  = "Mistweaver Xia",
            title = "Timewalking Vendor (Mists of Pandaria)",
            zone  = "Timeless Isle",
            mapID = 554,
            x     = 0.4300,
            y     = 0.5540,
            note  = "Only during MoP Timewalking",
        },
        lunar = {
            name  = "Fariel Starsong",
            title = "Lunar Festival Vendor",
            zone  = "Moonglade",
            mapID = 80,
            x     = 0.5400,
            y     = 0.3500,
            note  = "Only during Lunar Festival",
        },
    },
}
