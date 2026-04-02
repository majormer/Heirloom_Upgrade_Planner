local addonName, ns = ...

local debugFrame = CreateFrame("Frame", "HUPDebugFrame", UIParent, "BasicFrameTemplateWithInset")
debugFrame:SetSize(600, 400)
debugFrame:SetPoint("CENTER")
debugFrame:SetFrameStrata("DIALOG")
debugFrame:Hide()

debugFrame.title = debugFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
debugFrame.title:SetPoint("CENTER", debugFrame.TitleBg, "CENTER", 0, 0)
debugFrame.title:SetText("HUP Debug Log")

local scrollFrame = CreateFrame("ScrollFrame", nil, debugFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -30)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 40) -- Made room for a close button if needed

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(540, 300)
scrollFrame:SetScrollChild(scrollChild)

local editBox = CreateFrame("EditBox", nil, scrollChild)
editBox:SetMultiLine(true)
editBox:SetFontObject("ChatFontNormal")
editBox:SetWidth(540)
editBox:SetHeight(300)
editBox:SetAutoFocus(false)
editBox:SetPoint("TOPLEFT", 5, -5)
editBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)

function ns.ShowDebugLog(text)
    editBox:SetText(text)
    debugFrame:Show()
end

function ns.RunDebugDump(currentClass, currentSpecName, maxUpgradeTier)
    local out = {}
    table.insert(out, "=== HUP Debug Dump ===")
    table.insert(out, "Class: " .. tostring(currentClass))
    table.insert(out, "Spec: " .. tostring(currentSpecName))
    table.insert(out, "Tier Target: " .. tostring(maxUpgradeTier))
    
    local armorType = ns.CLASS_ARMOR[currentClass]
    local usableWeapons = ns.CLASS_WEAPONS[currentClass] or {}
    
    table.insert(out, "")
    table.insert(out, "Armor Type Expected: " .. tostring(armorType))
    table.insert(out, "Weapons Allowed: " .. table.concat(usableWeapons, ", "))
    
    local clSpecs = ns.CLASS_SPECS[currentClass]
    local spInfo = nil
    if clSpecs then
        for _, s in ipairs(clSpecs) do
            if s.name == currentSpecName then spInfo = s; break end
        end
    end
    
    if not spInfo then
        table.insert(out, "ERROR: spInfo is nil! Cannot find spec.")
    else
        table.insert(out, "primaryStat: " .. tostring(spInfo.primaryStat))
        table.insert(out, "weaponStyle: " .. tostring(spInfo.weaponStyle))
    end
    
    local all = C_Heirloom.GetHeirloomItemIDs()
    table.insert(out, "")
    table.insert(out, "Total Heirlooms in Game: " .. tostring(all and #all or "nil"))
    
    local GetItemStats = C_Item and C_Item.GetItemStats or _G.GetItemStats
    -- Test a few specific IDs (Tattered Dreadmist Mask = 50287, Hellscream's Doomblade = 105675, Repurposed Lava Dredger = 42948)
    local testIDs = {50287, 105675, 122365, 122369, 122352}
    for _, id in ipairs(testIDs) do
        local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice, classID, subclassID = GetItemInfo(id)
        table.insert(out, "---")
        table.insert(out, "Test ID " .. id .. ": " .. tostring(name))
        if name then
            table.insert(out, "  classID: " .. tostring(classID) .. ", subclassID: " .. tostring(subclassID) .. ", equipSlot: " .. tostring(equipSlot))
            
            -- Simulate HasEligibleStats logic
            local passedClassType = false
            
            if classID == Enum.ItemClass.Weapon or (classID == Enum.ItemClass.Armor and equipSlot == "INVTYPE_SHIELD") then
                local stats = GetItemStats(link)
                local hasStat = false
                if stats then
                    for k, v in pairs(stats) do
                        if spInfo and spInfo.primaryStat == "Intellect" and k:find("INTELLECT") then hasStat = true; break; end
                        if spInfo and spInfo.primaryStat == "Agility" and k:find("AGILITY") then hasStat = true; break; end
                        if spInfo and spInfo.primaryStat == "Strength" and k:find("STRENGTH") then hasStat = true; break; end
                    end
                end
                if spInfo and spInfo.primaryStat == "Intellect" and (equipSlot == "INVTYPE_WAND" or equipSlot == "INVTYPE_HOLDABLE") then hasStat = true end
                table.insert(out, "  Weapon/Shield Stat Check passed? " .. tostring(hasStat))
            end
            
            -- Debug API values specifically!
            local r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15 = C_Heirloom.GetHeirloomInfo(id)
            local maxUpg = C_Heirloom.GetHeirloomMaxUpgradeLevel and C_Heirloom.GetHeirloomMaxUpgradeLevel(id)
            table.insert(out, "  Max Upgrade Level API: " .. tostring(maxUpg))
            table.insert(out, "  C_Heirloom.GetHeirloomInfo:")
            table.insert(out, "   1: " .. tostring(r1) .. " | 2: " .. tostring(r2) .. " | 3: " .. tostring(r3))
            table.insert(out, "   4: " .. tostring(r4) .. " | 5: " .. tostring(r5) .. " | 6: " .. tostring(r6))
            table.insert(out, "   7: " .. tostring(r7) .. " | 8: " .. tostring(r8) .. " | 9: " .. tostring(r9))
            table.insert(out, "   10: " .. tostring(r10) .. " | 11: " .. tostring(r11) .. " | 12: " .. tostring(r12))
            table.insert(out, "   13: " .. tostring(r13) .. " | 14: " .. tostring(r14) .. " | 15: " .. tostring(r15))
            
            if classID == Enum.ItemClass.Armor then
                table.insert(out, "  Armor Check (Expected: " .. tostring(armorType) .. ", Is: " .. tostring(subclassID) .. ")")
            elseif classID == Enum.ItemClass.Weapon then
                table.insert(out, "  Weapon Check (Subclass: " .. tostring(subclassID) .. ")")
            end
        else
            table.insert(out, "  GetItemInfo returned nil. Cached?")
        end
    end
    
    table.insert(out, "=== End Dump ===")
    ns.ShowDebugLog(table.concat(out, "\n"))
end

-- Supplementary debug: dump data-table stats
function ns.RunDataTableDump()
    local out = {}
    table.insert(out, "=== HUP Data Table Dump ===")
    table.insert(out, "")

    -- HEIRLOOM_OBTAINABILITY
    local obCount, obUnobtainable, obLimited = 0, 0, 0
    if ns.HEIRLOOM_OBTAINABILITY then
        for id, info in pairs(ns.HEIRLOOM_OBTAINABILITY) do
            obCount = obCount + 1
            if not info.obtainable then obUnobtainable = obUnobtainable + 1 end
            if info.limited then obLimited = obLimited + 1 end
        end
    end
    table.insert(out, string.format("HEIRLOOM_OBTAINABILITY: %d entries (%d unobtainable, %d limited)", obCount, obUnobtainable, obLimited))

    -- HEIRLOOM_FACTION
    local facCount = 0
    if ns.HEIRLOOM_FACTION then
        for _ in pairs(ns.HEIRLOOM_FACTION) do facCount = facCount + 1 end
    end
    table.insert(out, string.format("HEIRLOOM_FACTION: %d entries", facCount))

    -- FIXED_STAT_ITEMS
    local fsCount = 0
    if ns.FIXED_STAT_ITEMS then
        for _ in pairs(ns.FIXED_STAT_ITEMS) do fsCount = fsCount + 1 end
    end
    table.insert(out, string.format("FIXED_STAT_ITEMS: %d entries", fsCount))

    -- HEIRLOOM_PURCHASE_COSTS
    local pcCount, pcGold, pcCurrency = 0, 0, 0
    if ns.HEIRLOOM_PURCHASE_COSTS then
        for id, info in pairs(ns.HEIRLOOM_PURCHASE_COSTS) do
            pcCount = pcCount + 1
            if info.gold then pcGold = pcGold + 1 end
            if info.altCurrency then pcCurrency = pcCurrency + 1 end
        end
    end
    table.insert(out, string.format("HEIRLOOM_PURCHASE_COSTS: %d entries (%d with gold, %d with alt currency)", pcCount, pcGold, pcCurrency))

    -- Player faction
    local playerFaction = UnitFactionGroup("player")
    table.insert(out, "")
    table.insert(out, "Player Faction: " .. tostring(playerFaction))

    -- Saved State
    table.insert(out, "")
    table.insert(out, "--- Saved State (HUP_Config) ---")
    if HUP_Config then
        for k, v in pairs(HUP_Config) do
            if type(v) == "table" then
                table.insert(out, string.format("  %s = {table: %d items}", k, #v > 0 and #v or 0))
            else
                table.insert(out, string.format("  %s = %s", k, tostring(v)))
            end
        end
    else
        table.insert(out, "  (nil)")
    end

    table.insert(out, "")
    table.insert(out, "=== End Data Table Dump ===")
    ns.ShowDebugLog(table.concat(out, "\n"))
end

SLASH_HUPDEBUG1 = "/hupdebug"
SlashCmdList["HUPDEBUG"] = function()
    -- This relies on the global variables from Core.lua being passed, 
    -- but we can't easily access locals from Core.lua.
    -- We will call this directly via a button on the UI instead!
end