local addonName, ns = ...

local frame = CreateFrame("Frame", "HeirloomUpgradePlannerFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(800, 600)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    ns.State:Save()
end)
frame:Hide()

if frame.SetPortraitToAsset then
    frame:SetPortraitToAsset("Interface\\AddOns\\Heirloom_Upgrade_Planner\\images\\HeirloomUpgradePlanner.png")
elseif frame.portrait then
    frame.portrait:SetTexture("Interface\\AddOns\\Heirloom_Upgrade_Planner\\images\\HeirloomUpgradePlanner.png")
end

-- Enhanced branded title
frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
frame.title:SetText("|cFFFFD700Heirloom|r |cFFFFFFFFUpgrade|r |cFF00FF00Planner|r")
frame.title:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

-- Options / State
local currentClass = select(2, UnitClass("player"))
local currentSpecName = ""
if ns.CLASS_SPECS[currentClass] and #ns.CLASS_SPECS[currentClass] > 0 then
    currentSpecName = ns.CLASS_SPECS[currentClass][1].name
end

local targetLevel = 70 -- Currently level 70 is max heirloom upgrade tier
local maxUpgradeTier = 6

-- =========================================================
-- UI COMPONENTS
-- =========================================================
local topBar = CreateFrame("Frame", nil, frame)
topBar:SetSize(760, 40)
topBar:SetPoint("TOPLEFT", 20, -30)

local classLabel = topBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
classLabel:SetPoint("LEFT", 0, 0)
classLabel:SetText("Class:")

local function CreateSimpleDropdown(name, parent, width)
    local f = CreateFrame("Button", name, parent, "UIMenuButtonStretchTemplate")
    f:SetSize(width, 24)
    local text = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("CENTER", 0, 0)
    f.Text = text
    
    local dArrow = f:CreateTexture(nil, "ARTWORK")
    dArrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    dArrow:SetSize(16, 16)
    dArrow:SetPoint("RIGHT", f, "RIGHT", -2, 0)
    
    local menu = CreateFrame("Frame", name.."Menu", f, "BackdropTemplate")
    menu:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile=true, tileSize=16, edgeSize = 16, insets = {left=4,right=4,top=4,bottom=4} })
    menu:SetBackdropColor(0,0,0,1)
    menu:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, 2)
    menu:SetFrameStrata("TOOLTIP")
    menu:Hide()
    f.Menu = menu
    
    f:SetScript("OnClick", function()
        if menu:IsShown() then menu:Hide() else menu:Show() end
    end)
    return f
end

local classDropdown = CreateSimpleDropdown("HUPClassDropdown", topBar, 120)
classDropdown:SetPoint("LEFT", classLabel, "RIGHT", 10, 0)
classDropdown.Text:SetText(currentClass)

local specLabel = topBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
specLabel:SetPoint("LEFT", classDropdown, "RIGHT", 20, 0)
specLabel:SetText("Spec:")

local specDropdown = CreateSimpleDropdown("HUPSpecDropdown", topBar, 140)
specDropdown:SetPoint("LEFT", specLabel, "RIGHT", 10, 0)
specDropdown.Text:SetText(currentSpecName)

local targetDropdown = CreateSimpleDropdown("HUPTargetDropdown", topBar, 140)
targetDropdown:SetPoint("RIGHT", topBar, "RIGHT", -10, 0)

local BuildSpecDropdown  -- forward-declared so mySpecBtn closure captures the upvalue

local mySpecBtn = CreateFrame("Button", nil, topBar, "UIPanelButtonTemplate")
mySpecBtn:SetSize(65, 22)
mySpecBtn:SetPoint("LEFT", specDropdown, "RIGHT", 10, 0)
mySpecBtn:SetText("My Spec")
mySpecBtn:SetScript("OnClick", function()
    local playerClass = select(2, UnitClass("player"))
    local specIdx = GetSpecialization()
    local _, specName = GetSpecializationInfo(specIdx)
    if not playerClass or not specName then return end
    currentClass = playerClass
    classDropdown.Text:SetText(currentClass)
    BuildSpecDropdown()
    local clSpecs = ns.CLASS_SPECS[currentClass] or {}
    for _, s in ipairs(clSpecs) do
        if s.name == specName then
            currentSpecName = s.name
            specDropdown.Text:SetText(currentSpecName)
            break
        end
    end
    UpdateDataAndUI()
    ns.State:Save()
end)
mySpecBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Use Current Spec", 1, 1, 1)
    GameTooltip:AddLine("Resets Class and Spec to your currently logged-in character.", 0.8, 0.8, 0.8, true)
    GameTooltip:Show()
end)
mySpecBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local refreshBtn = CreateFrame("Button", nil, topBar, "UIPanelButtonTemplate")
refreshBtn:SetSize(70, 22)
refreshBtn:SetPoint("LEFT", mySpecBtn, "RIGHT", 10, 0)
refreshBtn:SetText("Refresh")
refreshBtn:SetScript("OnClick", function()
    UpdateDataAndUI()
end)
refreshBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:AddLine("Refresh Heirloom Data", 1, 1, 1)
    GameTooltip:AddLine("Re-scans your bags and heirloom\ncollection for the latest state.", 0.8, 0.8, 0.8)
    GameTooltip:Show()
end)
refreshBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local targetLabel = topBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
targetLabel:SetPoint("RIGHT", targetDropdown, "LEFT", -10, 0)
targetLabel:SetText("Target Tier:")

-- Setup Dropdown Options
local classesList = {}
for k, _ in pairs(ns.CLASS_WEAPONS) do table.insert(classesList, k) end
table.sort(classesList)

function UpdateDataAndUI()
    -- Recalculate
    ns.RebuildPlan()
end

BuildSpecDropdown = function()
    local menu = specDropdown.Menu
    for _, child in ipairs({menu:GetChildren()}) do child:Hide() end
    
    local clSpecs = ns.CLASS_SPECS[currentClass]
    if not clSpecs then return end
    
    menu:SetSize(140, #clSpecs * 20 + 8)
    for i, s in ipairs(clSpecs) do
        local btn = CreateFrame("Button", nil, menu, "BackdropTemplate")
        btn:SetSize(132, 20)
        btn:SetPoint("TOPLEFT", 4, -4 - (i-1)*20)
        local t = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        t:SetPoint("LEFT", 5, 0)
        t:SetText(s.name)
        
        btn:SetScript("OnEnter", function(self) self:SetBackdrop({bgFile="Interface\\QuestFrame\\UI-QuestTitleHighlight"}) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdrop(nil) end)
        
        btn:SetScript("OnClick", function()
            currentSpecName = s.name
            specDropdown.Text:SetText(currentSpecName)
            menu:Hide()
            UpdateDataAndUI()
            ns.State:Save()
        end)
    end
end

local function BuildClassDropdown()
    local menu = classDropdown.Menu
    for _, child in ipairs({menu:GetChildren()}) do child:Hide() end
    
    menu:SetSize(120, #classesList * 20 + 8)
    for i, c in ipairs(classesList) do
        local btn = CreateFrame("Button", nil, menu, "BackdropTemplate")
        btn:SetSize(112, 20)
        btn:SetPoint("TOPLEFT", 4, -4 - (i-1)*20)
        local t = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        t:SetPoint("LEFT", 5, 0)
        t:SetText(c)
        
        btn:SetScript("OnEnter", function(self) self:SetBackdrop({bgFile="Interface\\QuestFrame\\UI-QuestTitleHighlight"}) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdrop(nil) end)
        
        btn:SetScript("OnClick", function()
            currentClass = c
            classDropdown.Text:SetText(currentClass)
            menu:Hide()
            
            local clSpecs = ns.CLASS_SPECS[currentClass]
            if clSpecs and #clSpecs > 0 then
                currentSpecName = clSpecs[1].name
            else
                currentSpecName = "Unknown"
            end
            specDropdown.Text:SetText(currentSpecName)
            
            BuildSpecDropdown()
            UpdateDataAndUI()
            ns.State:Save()
        end)
    end
end

local function BuildTargetDropdown()
    local menu = targetDropdown.Menu
    for _, child in ipairs({menu:GetChildren()}) do child:Hide() end
    
    local tierList = {}
    table.insert(tierList, {tier = 0, name = "Base (Level 29)"})
    for i, t in ipairs(ns.UPGRADE_LEVELS) do
        table.insert(tierList, {tier = t[1], name = "Tier " .. t[1] .. " (Level " .. t[8] .. ")"})
    end
    
    menu:SetSize(140, #tierList * 20 + 8)
    for i, t in ipairs(tierList) do
        local btn = CreateFrame("Button", nil, menu, "BackdropTemplate")
        btn:SetSize(132, 20)
        btn:SetPoint("TOPLEFT", 4, -4 - (i-1)*20)
        local text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        text:SetPoint("LEFT", 5, 0)
        text:SetText(t.name)
        
        if t.tier == maxUpgradeTier then
            targetDropdown.Text:SetText(t.name)
        end
        
        btn:SetScript("OnEnter", function(self) self:SetBackdrop({bgFile="Interface\\QuestFrame\\UI-QuestTitleHighlight"}) end)
        btn:SetScript("OnLeave", function(self) self:SetBackdrop(nil) end)
        
        btn:SetScript("OnClick", function()
            maxUpgradeTier = t.tier
            targetDropdown.Text:SetText(t.name)
            menu:Hide()
            UpdateDataAndUI()
            ns.State:Save()
        end)
    end
end

BuildClassDropdown()
BuildSpecDropdown()
BuildTargetDropdown()

local debugBtn = CreateFrame("Button", nil, topBar, "UIPanelButtonTemplate")
debugBtn:SetSize(60, 24)
debugBtn:SetPoint("RIGHT", targetLabel, "LEFT", -20, 0)
debugBtn:SetText("Debug")
debugBtn:SetScript("OnClick", function()
    if ns.RunDebugDump then
        ns.RunDebugDump(currentClass, currentSpecName, maxUpgradeTier)
    end
end)
debugBtn:Hide()

-- Currency Bar
local currencyBar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
currencyBar:SetSize(760, 24)
currencyBar:SetPoint("TOPLEFT", 20, -76)
currencyBar:SetBackdrop({
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 8, edgeSize = 10,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
currencyBar:SetBackdropColor(0, 0, 0, 0.4)
currencyBar:SetBackdropBorderColor(0.4, 0.4, 0.5, 0.8)

local goldDisplay = currencyBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
goldDisplay:SetPoint("LEFT", 10, 0)
goldDisplay:SetText("|cffffff00Gold:|r --")

local twDisplay = currencyBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
twDisplay:SetPoint("LEFT", goldDisplay, "RIGHT", 24, 0)
twDisplay:SetText("|cff00ccffTimewarped Badges:|r --")

local function UpdateCurrencyBar()
    local copper = GetMoney() or 0
    local gold   = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local cop    = copper % 100
    goldDisplay:SetText(string.format("|cffffff00Gold:|r |cffd4af37%dg|r |cffc0c0c0%ds|r |cffb87333%dc|r", gold, silver, cop))

    local twID = 1166 -- Timewarped Badge currency ID
    local twAmt = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(twID) and C_CurrencyInfo.GetCurrencyInfo(twID).quantity or 0
    twDisplay:SetText(string.format("|cff00ccffTimewarped Badges:|r |cffffffff%d|r", twAmt))
end

-- Layout Panels
local leftBg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
leftBg:SetSize(380, 460)
leftBg:SetPoint("TOPLEFT", 20, -104)
leftBg:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
leftBg:SetBackdropColor(0, 0, 0, 0.5)

local leftScrollFrame = CreateFrame("ScrollFrame", nil, leftBg, "UIPanelScrollFrameTemplate")
leftScrollFrame:SetPoint("TOPLEFT", 10, -10)
leftScrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local leftContent = CreateFrame("Frame", nil, leftScrollFrame)
leftContent:SetSize(330, 700)
leftScrollFrame:SetScrollChild(leftContent)

local rightBg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
rightBg:SetSize(360, 460)
rightBg:SetPoint("TOPRIGHT", -20, -104)
rightBg:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
rightBg:SetBackdropColor(0, 0, 0, 0.5)

local slotsList = {}

-- Detail row pool for expandable slot panels
local detailRowPool = {}

-- SLOT OVERRIDES [class][spec][slotKey] = itemID
ns.overrides = {}
local function GetOverride(class,spec,k) return ns.overrides[class] and ns.overrides[class][spec] and ns.overrides[class][spec][k] end
local function SetOverride(class,spec,k,id) if not ns.overrides[class] then ns.overrides[class]={} end; if not ns.overrides[class][spec] then ns.overrides[class][spec]={} end; ns.overrides[class][spec][k]=id; ns.State:Save() end
local function ClearOverride(class,spec,k) if ns.overrides[class] and ns.overrides[class][spec] then ns.overrides[class][spec][k]=nil end; ns.State:Save() end

local function AcquireDetailRow()
    local dr = table.remove(detailRowPool)
    if not dr then
        dr = CreateFrame("Frame", nil, leftContent)
        dr:SetSize(316, 20)
        dr:EnableMouse(true)

        local bg = dr:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0.15, 0.15, 0.2, 0.6)
        dr.bg = bg

        dr.icon = dr:CreateTexture(nil, "ARTWORK")
        dr.icon:SetSize(16, 16)
        dr.icon:SetPoint("LEFT", 20, 0)

        dr.nameTxt = dr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dr.nameTxt:SetPoint("LEFT", dr.icon, "RIGHT", 4, 0)
        dr.nameTxt:SetWidth(130)
        dr.nameTxt:SetJustifyH("LEFT")
        dr.nameTxt:SetWordWrap(false)

        dr.scoreTxt = dr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dr.scoreTxt:SetPoint("LEFT", dr.nameTxt, "RIGHT", 4, 0)
        dr.scoreTxt:SetWidth(40)
        dr.scoreTxt:SetJustifyH("RIGHT")

        dr.tierTxt = dr:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        dr.tierTxt:SetPoint("LEFT", dr.scoreTxt, "RIGHT", 4, 0)
        dr.tierTxt:SetWidth(40)
        dr.tierTxt:SetJustifyH("LEFT")
        dr.pinBtn = CreateFrame("Button", nil, dr, "UIPanelButtonTemplate")
        dr.pinBtn:SetSize(40, 14)
        dr.pinBtn:SetPoint("TOPRIGHT", dr, "TOPRIGHT", -4, -3)
        dr.pinBtn:SetNormalFontObject("GameFontNormalSmall")
        dr.pinBtn:SetText("Pin")
        dr.pinBtn:SetScript("OnClick", function(self)
            if self.slotKey and self.candID then SetOverride(currentClass,currentSpecName,self.slotKey,self.candID); UpdateDataAndUI() end
        end)
        dr.pinBtn:SetScript("OnEnter", function(self)
            if not self:IsEnabled() then return end
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:AddLine("Pin this item",1,1,1)
            GameTooltip:AddLine("Always use this heirloom for this slot, overriding the auto-suggestion.",0.8,0.8,0.8,true); GameTooltip:Show()
        end)
        dr.pinBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        dr:SetScript("OnEnter", function(self)
            if self.itemID then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local link = C_Heirloom.GetHeirloomLink(self.itemID)
                if link then
                    GameTooltip:SetHyperlink(link)
                else
                    GameTooltip:SetItemByID(self.itemID)
                end
                GameTooltip:Show()
            end
        end)
        dr:SetScript("OnLeave", function() GameTooltip:Hide() end)
    end
    dr:Show()
    return dr
end

local function ReleaseAllDetailRows()
    for _, row in ipairs(slotsList) do
        for _, dr in ipairs(row.detailRows) do
            dr:Hide()
            dr:ClearAllPoints()
            table.insert(detailRowPool, dr)
        end
        wipe(row.detailRows)
    end
end

local function RepositionRows()
    local y = -4
    for i, row in ipairs(slotsList) do
        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", leftContent, "TOPLEFT", 4, y)
        y = y - 66
        if row.expanded then
            for _, dr in ipairs(row.detailRows) do
                dr:ClearAllPoints()
                dr:SetPoint("TOPLEFT", leftContent, "TOPLEFT", 4, y)
                y = y - 22
            end
        end
    end
    leftContent:SetHeight(math.max(700, math.abs(y) + 10))
end

-- Cached reference to the Collections heirloom search box.
-- TWW may rename or restructure this frame, so we probe multiple paths and fall back
-- to EnumerateFrames if needed (result is cached after first successful find).
local heirloomSearchBox = nil
local function GetHeirloomSearchBox()
    if heirloomSearchBox then return heirloomSearchBox end
    heirloomSearchBox = (CollectionsJournal and CollectionsJournal.SearchBox)
        or (CollectionsJournal and CollectionsJournal.searchBox)
        or HeirloomCollectionFrameSearchBox
        or (HeirloomCollectionFrame and HeirloomCollectionFrame.SearchBox)
        or (HeirloomCollectionFrame and HeirloomCollectionFrame.searchBox)
    if heirloomSearchBox then return heirloomSearchBox end
    -- Fallback: walk all frames looking for an EditBox whose parent name contains
    -- "Heirloom" or "Collection" (covers renamed/restructured frames in future patches).
    if EnumerateFrames then
        local f = EnumerateFrames()
        while f do
            if f.GetObjectType and f:GetObjectType() == "EditBox" then
                local p = f:GetParent()
                local pn = (p and p:GetName()) or ""
                if pn:find("[Hh]eirloom") or pn:find("[Cc]ollection") then
                    heirloomSearchBox = f
                    return heirloomSearchBox
                end
            end
            f = EnumerateFrames(f)
        end
    end
    return nil
end

local function CreateLeftPanelSlots()
    for i, slotData in ipairs(ns.PLAN_SLOTS) do
        local row = CreateFrame("Frame", nil, leftContent)
        row:SetSize(326, 64)
        if i == 1 then
            row:SetPoint("TOPLEFT", 4, -4)
        else
            row:SetPoint("TOPLEFT", slotsList[i-1], "BOTTOMLEFT", 0, -2)
        end

        local expandTxt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        expandTxt:SetPoint("TOPLEFT", 2, -10)
        expandTxt:SetText("|cffffff00+|r")

        local txt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        txt:SetPoint("LEFT", expandTxt, "RIGHT", 1, 2)
        txt:SetWidth(54)
        txt:SetJustifyH("LEFT")
        txt:SetText(slotData.key)

        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(26, 26)
        icon:SetPoint("TOPLEFT", txt, "TOPRIGHT", 4, 2)

        local itemTxt = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        itemTxt:SetPoint("TOPLEFT", icon, "TOPRIGHT", 8, -2)
        itemTxt:SetWidth(88)
        itemTxt:SetJustifyH("LEFT")
        itemTxt:SetWordWrap(false)

        local levelTxt = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        levelTxt:SetPoint("TOPRIGHT", row, "TOPRIGHT", -5, -8)
        levelTxt:SetWidth(60)
        levelTxt:SetJustifyH("RIGHT")

        local upgradeBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        upgradeBtn:SetSize(52, 18)
        upgradeBtn:SetPoint("TOPRIGHT", row, "TOPRIGHT", -70, -6)
        upgradeBtn:SetNormalFontObject("GameFontNormalSmall")
        upgradeBtn:SetText("Upgrade")
        upgradeBtn:Hide()
        upgradeBtn:SetScript("OnClick", function(self)
            if not row.itemID or not row.heirloomName then return end
            if CollectionsJournal and not CollectionsJournal:IsShown() then
                ShowUIPanel(CollectionsJournal)
            end
            if CollectionsJournalTab4 then CollectionsJournalTab4:Click() end
            heirloomSearchBox = nil
            C_Timer.After(0.15, function()
                local sb = GetHeirloomSearchBox()
                if sb then sb:SetText(row.heirloomName) end
            end)
        end)
        upgradeBtn:SetScript("OnEnter", function(self)
            if self.tokenName then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine("Upgrade Heirloom", 1, 1, 1)
                GameTooltip:AddLine("Uses: " .. self.tokenName, 0.8, 0.8, 0.8, true)
                if self.hasToken then
                    GameTooltip:AddLine("|cff00ff00Token available in bags|r", 1, 1, 1)
                else
                    GameTooltip:AddLine("|cffff4444No token in bags — buy from vendor|r", 1, 1, 1)
                end
                GameTooltip:Show()
            end
        end)
        upgradeBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        row.upgradeBtn = upgradeBtn

        local copyBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        copyBtn:SetSize(52, 18)
        copyBtn:SetPoint("TOPRIGHT", row, "TOPRIGHT", -70, -30)
        copyBtn:SetNormalFontObject("GameFontNormalSmall")
        copyBtn:SetText("Copy")
        copyBtn:Hide()
        copyBtn:SetScript("OnClick", function(self)
            if not row.itemID then return end
            if self.isEquipMode then
                EquipItemByName(row.itemID, self.targetSlot)
            else
                C_Heirloom.CreateHeirloom(row.itemID)
            end
        end)
        copyBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            if self.isEquipMode then
                GameTooltip:AddLine("Equip Heirloom", 1, 1, 1)
                GameTooltip:AddLine("Equips this heirloom from your bags.", 0.8, 0.8, 0.8, true)
            else
                GameTooltip:AddLine("Create Heirloom Copy", 1, 1, 1)
                GameTooltip:AddLine("Puts a copy of this heirloom into your bags.", 0.8, 0.8, 0.8, true)
                GameTooltip:AddLine("Useful for quickly gearing an alt.", 0.8, 0.8, 0.8, true)
            end
            if (self.equippedCount or 0) > 0 then
                GameTooltip:AddLine(string.format("|cffff9900%d cop%s currently equipped.|r", self.equippedCount, self.equippedCount == 1 and "y" or "ies"), 1, 1, 1)
            end
            if (self.bagCount or 0) > 0 then
                GameTooltip:AddLine(string.format("|cffffff00%d cop%s in bags.|r", self.bagCount, self.bagCount == 1 and "y" or "ies"), 1, 1, 1)
            end
            if (self.equippedCount or 0) == 0 and (self.bagCount or 0) == 0 then
                GameTooltip:AddLine("|cff00ff00No copies currently out.|r", 1, 1, 1)
            end
            if self.betterItemEquipped then
                GameTooltip:AddLine("|cffaaaaaa(Higher-level item equipped in slot — Equip not offered.)|r", 1, 1, 1, true)
            end
            GameTooltip:AddLine("|cffaaaaaa(Upgrades apply account-wide — all copies update automatically.)|r", 1, 1, 1, true)
            GameTooltip:Show()
        end)
        copyBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        row.copyBtn = copyBtn
        local autoBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        autoBtn:SetSize(50, 14)
        autoBtn:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", 2, 10)
        autoBtn:SetNormalFontObject("GameFontNormalSmall")
        autoBtn:SetText("|cffff9900Pinned|r")
        autoBtn:Hide()
        autoBtn:SetScript("OnClick", function(self) ClearOverride(currentClass,currentSpecName,slotData.key); UpdateDataAndUI() end)
        autoBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self,"ANCHOR_RIGHT"); GameTooltip:AddLine("Item Pinned",1,0.6,0)
            if self.autoName then GameTooltip:AddLine("Auto-suggested: "..self.autoName,0.8,0.8,0.8,true) end
            GameTooltip:AddLine("Click to reset to the auto-suggestion.",0.6,0.6,0.6,true); GameTooltip:Show()
        end)
        autoBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
        row.autoBtn = autoBtn
        -- Suggestion area: shown only when a better spec-native item exists
        local suggestArea = CreateFrame("Frame", nil, row)
        suggestArea:SetSize(90, 18)
        suggestArea:SetPoint("TOPLEFT", itemTxt, "BOTTOMLEFT", 0, -1)
        suggestArea:EnableMouse(true)
        suggestArea:Hide()

        local suggestIconTex = suggestArea:CreateTexture(nil, "ARTWORK")
        suggestIconTex:SetSize(16, 16)
        suggestIconTex:SetPoint("LEFT", 0, 0)

        local suggestNameTxt = suggestArea:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        suggestNameTxt:SetPoint("LEFT", suggestIconTex, "RIGHT", 4, 0)
        suggestNameTxt:SetWidth(66)
        suggestNameTxt:SetJustifyH("LEFT")
        suggestNameTxt:SetWordWrap(false)

        suggestArea:SetScript("OnEnter", function(self)
            if self.suggestionID then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local slink = C_Heirloom.GetHeirloomLink(self.suggestionID)
                if slink then
                    GameTooltip:SetHyperlink(slink)
                else
                    GameTooltip:SetItemByID(self.suggestionID)
                end
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffff9900Recommended for your spec|r", 1, 1, 1, true)
                if not self.suggestionCollected then
                    GameTooltip:AddLine("|cff999999You do not own this item yet.|r", 1, 1, 1, true)
                end
                GameTooltip:Show()
            end
        end)
        suggestArea:SetScript("OnLeave", function() GameTooltip:Hide() end)

        row.icon       = icon
        row.itemTxt    = itemTxt
        row.levelTxt   = levelTxt
        row.suggestArea    = suggestArea
        row.suggestIconTex = suggestIconTex
        row.suggestNameTxt = suggestNameTxt

        row:EnableMouse(true)
        row:SetScript("OnEnter", function(self)
            if self.itemID then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                local link = C_Heirloom.GetHeirloomLink(self.itemID)
                if link then
                    GameTooltip:SetHyperlink(link)
                else
                    GameTooltip:SetItemByID(self.itemID)
                end
                -- Append obtainability + purchase cost info
                local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[self.itemID]
                if ob then
                    GameTooltip:AddLine(" ")
                    if not ob.obtainable then
                        GameTooltip:AddLine("|cffaa0000No longer obtainable|r", 1, 1, 1)
                    elseif ob.limited then
                        GameTooltip:AddLine("|cffff9900Limited availability|r", 1, 1, 1)
                    end
                    if ob.source then
                        GameTooltip:AddLine("|cff999999Source: " .. ob.source .. "|r", 1, 1, 1, true)
                    end
                end
                local costInfo = ns.HEIRLOOM_PURCHASE_COSTS and ns.HEIRLOOM_PURCHASE_COSTS[self.itemID]
                if costInfo then
                    if not ob then GameTooltip:AddLine(" ") end
                    if costInfo.gold then
                        GameTooltip:AddLine(string.format("|cffffff00Purchase: %dg|r", costInfo.gold), 1, 1, 1)
                    end
                    if costInfo.altCurrency then
                        for _, cur in ipairs(costInfo.altCurrency) do
                            local cInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(cur[1])
                            local cName = cInfo and cInfo.name or ("Currency " .. cur[1])
                            GameTooltip:AddLine(string.format("|cffaaaaaa  or %d x %s|r", cur[2], cName), 1, 1, 1)
                        end
                    end
                    if costInfo.vendor then
                        GameTooltip:AddLine("|cff999999Vendor: " .. costInfo.vendor .. "|r", 1, 1, 1, true)
                    end
                end
                GameTooltip:Show()
            end
        end)
        row:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        row.expandTxt = expandTxt
        row.expanded = false
        row.detailRows = {}
        row.assignedID = nil

        row:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" and #self.detailRows > 0 then
                self.expanded = not self.expanded
                self.expandTxt:SetText(self.expanded and "|cffffff00-|r" or "|cffffff00+|r")
                for _, dr in ipairs(self.detailRows) do
                    if self.expanded then dr:Show() else dr:Hide() end
                end
                RepositionRows()
            end
        end)

        table.insert(slotsList, row)
    end
end
CreateLeftPanelSlots()

local rightScrollFrame = CreateFrame("ScrollFrame", nil, rightBg, "UIPanelScrollFrameTemplate")
rightScrollFrame:SetPoint("TOPLEFT", 10, -10)
rightScrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local rightContent = CreateFrame("Frame", nil, rightScrollFrame)
rightContent:SetSize(320, 500)
rightScrollFrame:SetScrollChild(rightContent)

local shoppingText = rightContent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
shoppingText:SetPoint("TOPLEFT", 5, -5)
shoppingText:SetWidth(310)
shoppingText:SetJustifyH("LEFT")
shoppingText:SetJustifyV("TOP")
shoppingText:SetText("Evaluating upgrades...")

-- =========================================================
-- LOGIC
-- =========================================================

local GetItemStats = C_Item and C_Item.GetItemStats or _G.GetItemStats

-- Safe wrapper for GetItemInfo — returns nil gracefully on failure
function ns.SafeGetItemInfo(id)
    local ok, name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice, classID, subclassID = pcall(GetItemInfo, id)
    if not ok or not name then return nil end
    return name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice, classID, subclassID
end

local function HasEligibleStats(itemID, armorType, primaryStat, usableWeapons)
    local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, icon, vendorPrice, classID, subclassID = GetItemInfo(itemID)
    if not name then return false end

    -- Filter out fishing poles/non-equipable
    if not equipSlot or equipSlot == "" then return false end

    -- Faction restriction: skip items the player's faction cannot obtain
    if ns.HEIRLOOM_FACTION and ns.HEIRLOOM_FACTION[itemID] then
        local playerFaction = UnitFactionGroup("player")
        if ns.HEIRLOOM_FACTION[itemID] ~= playerFaction then return false end
    end

    -- Fixed-stat items (necklaces, some trinkets, held off-hands) do not adapt to spec.
    -- Let them through the eligibility filter — statMatch is determined later in the
    -- candidate loop so the scoring system can deprioritize mismatched items instead of
    -- hiding them entirely (e.g. no STR necklace exists, but AGI neck is still useful).
    if ns.FIXED_STAT_ITEMS and ns.FIXED_STAT_ITEMS[itemID] then
        return true
    end

    -- Stat checking applies only to accessories (rings, necks, cloaks, trinkets, off-hands).
    -- Body armor, shields, and weapons are spec-adaptive in WoW — GetItemStats returns the
    -- base-stat profile (e.g. STR for a plate helm or a sword) even for specs that receive INT,
    -- so filtering by primary stat on those slots produces false negatives.
    -- Eligibility for armor is determined by armor type; for weapons by usableWeapons + weaponStyle.
    local isClassAdaptive = (equipSlot == "INVTYPE_HEAD" or equipSlot == "INVTYPE_SHOULDER"
        or equipSlot == "INVTYPE_CHEST" or equipSlot == "INVTYPE_ROBE"
        or equipSlot == "INVTYPE_LEGS" or equipSlot == "INVTYPE_WAIST"
        or equipSlot == "INVTYPE_FEET" or equipSlot == "INVTYPE_WRIST"
        or equipSlot == "INVTYPE_HAND"
        or equipSlot == "INVTYPE_SHIELD"
        or equipSlot == "INVTYPE_FINGER"       -- rings scale with spec in modern WoW
        or classID == Enum.ItemClass.Weapon)  -- all weapons scale with spec

    if not isClassAdaptive then
        local stats = GetItemStats(link)
        if stats then
            local hasInt = false
            local hasAgi = false
            local hasStr = false
            for k, v in pairs(stats) do
                if k:find("INTELLECT") then hasInt = true end
                if k:find("AGILITY") then hasAgi = true end
                if k:find("STRENGTH") then hasStr = true end
            end

            -- Wands and Off-hands imply Intellect natively
            if equipSlot == "INVTYPE_WAND" or equipSlot == "INVTYPE_HOLDABLE" then hasInt = true end

            -- If the item grants *any* primary stat, it MUST include the one we need.
            -- If it grants NO primary stats (like some trinkets), we let it pass.
            if hasInt or hasAgi or hasStr then
                if primaryStat == "Intellect" and not hasInt then return false end
                if primaryStat == "Agility"   and not hasAgi then return false end
                if primaryStat == "Strength"  and not hasStr then return false end
            end
        end
    end

    -- Rough armor/weapon type inclusion here.
    
    if classID == Enum.ItemClass.Armor then
        -- Cloaks/Rings/Trinkets/Necks have no specific class armor generally, subclass 0
        if equipSlot == "INVTYPE_CLOAK" or equipSlot == "INVTYPE_FINGER" or equipSlot == "INVTYPE_TRINKET" or equipSlot == "INVTYPE_NECK" then
            return true
        end
        -- Shields are under armor
        if equipSlot == "INVTYPE_SHIELD" then
            for _, w in ipairs(usableWeapons) do
                if w == "Shields" then return true end
            end
            return false
        end
        -- Armor Type: Plate(4), Mail(3), Leather(2), Cloth(1)
        local armorMatches = false
        if armorType == "Plate" and subclassID == 4 then armorMatches = true end
        if armorType == "Mail" and subclassID == 3 then armorMatches = true end
        if armorType == "Leather" and subclassID == 2 then armorMatches = true end
        if armorType == "Cloth" and subclassID == 1 then armorMatches = true end
        return armorMatches
    elseif classID == Enum.ItemClass.Weapon then
        -- Check weapon types
        local weaponSubtypesMap = {
            [0] = "One-Handed Axes", [1] = "Two-Handed Axes", [2] = "Bows", [3] = "Guns",
            [4] = "One-Handed Maces", [5] = "Two-Handed Maces", [6] = "Polearms",
            [7] = "One-Handed Swords", [8] = "Two-Handed Swords", [9] = "Warglaives",
            [10] = "Staves", [13] = "Fist Weapons", [15] = "Daggers", [18] = "Crossbows", [19] = "Wands"
        }
        local mappedType = weaponSubtypesMap[subclassID]
        if mappedType then
            for _, w in ipairs(usableWeapons) do
                if w == mappedType then return true end
            end
        end
        return false
    end
    
    return true
end

-- Score a candidate heirloom for ranking within a slot.
-- Higher score = better choice.  Collected > uncollected, statMatch > not, higher upgrade > lower.
-- Obtainability affects ranking so unobtainable items rank below obtainable ones when all else is equal.
function ns.ScoreCandidate(c)
    local score = 0
    local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[c.id]
    -- Unobtainable + not collected = score 0 (can never acquire it)
    if not c.collected and ob and not ob.obtainable then
        return 0
    end
    if c.collected then score = score + 1000 end
    if c.statMatch  then score = score + 500  end
    score = score + (c.upgrade * 50)
    if not ob or ob.obtainable then
        score = score + 100  -- prefer currently-obtainable items
    elseif ob and ob.limited then
        score = score - 25   -- small penalty for limited-availability items
    end
    return score
end

-- Maps each plan-slot key to its WoW inventory slot number for per-slot equip checks
local ROW_TO_INVSLOT = {
    ["Head"]=1,  ["Neck"]=2,  ["Shoulders"]=3, ["Back"]=15,
    ["Chest"]=5, ["Legs"]=7,
    ["Ring 1"]=11, ["Ring 2"]=12,
    ["Trinket 1"]=13, ["Trinket 2"]=14,
    ["Main Hand"]=16, ["Off Hand"]=17,
}

function ns.RebuildPlan()
    -- Gather current specs
    local armorType = ns.CLASS_ARMOR[currentClass]
    local usableWeapons = ns.CLASS_WEAPONS[currentClass] or {}
    
    local clSpecs = ns.CLASS_SPECS[currentClass]
    local spInfo = nil
    for _, s in ipairs(clSpecs) do
        if s.name == currentSpecName then spInfo = s; break end
    end
    if not spInfo then return end

    local primaryStat = spInfo.primaryStat
    local weaponStyle = spInfo.weaponStyle -- 2H, DW, 1H+Shield, 1H+OH, Ranged

    local allHeirlooms = C_Heirloom.GetHeirloomItemIDs()
    
    -- Ensure Item Data Cache is Fully Loaded
    local missingData = false
    for _, id in ipairs(allHeirlooms) do
        local name = GetItemInfo(id)
        if not name then
            missingData = true
        end
    end
    if missingData then
        shoppingText:SetText("Evaluating upgrades...\n|cff999999(Waiting on WoW client item cache...)|r")
        C_Timer.After(0.5, function() ns.RebuildPlan() end)
        return
    end
    
    local bestSlotAssignments = {}
    for _, s in ipairs(ns.PLAN_SLOTS) do bestSlotAssignments[s.key] = nil end
    
    -- Filter candidate heirlooms
    local candidates = {}
    for _, id in ipairs(allHeirlooms) do
        if HasEligibleStats(id, armorType, primaryStat, usableWeapons) then
            -- Safely extract standard heirloom info
            local name, itemEquipLoc, isPvP, icon, upgradeLevel, source, searchFiltered, active, totalUpgrades, isWeapon, _, _, maxLevel = C_Heirloom.GetHeirloomInfo(id)
            if name then
                local collected = C_Heirloom.PlayerHasHeirloom(id)
                -- Map to our PLAN_SLOTS
                local mappedSlots = {}
                if itemEquipLoc == "INVTYPE_HEAD" then table.insert(mappedSlots, "Head")
                elseif itemEquipLoc == "INVTYPE_NECK" then table.insert(mappedSlots, "Neck")
                elseif itemEquipLoc == "INVTYPE_SHOULDER" then table.insert(mappedSlots, "Shoulders")
                elseif itemEquipLoc == "INVTYPE_CLOAK" then table.insert(mappedSlots, "Back")
                elseif itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then table.insert(mappedSlots, "Chest")
                elseif itemEquipLoc == "INVTYPE_LEGS" then table.insert(mappedSlots, "Legs")
                elseif itemEquipLoc == "INVTYPE_FINGER" then
                    table.insert(mappedSlots, "Ring 1")
                    table.insert(mappedSlots, "Ring 2")
                elseif itemEquipLoc == "INVTYPE_TRINKET" then
                    table.insert(mappedSlots, "Trinket 1")
                    table.insert(mappedSlots, "Trinket 2")
                elseif itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_HOLDABLE" then
                    if weaponStyle == "1H+Shield" or weaponStyle == "1H+OH" then
                        table.insert(mappedSlots, "Off Hand")
                    end
                elseif itemEquipLoc == "INVTYPE_WEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" then
                    local is2H     = (itemEquipLoc == "INVTYPE_2HWEAPON")
                    local isRanged = (itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT")
                    local isOHOnly = (itemEquipLoc == "INVTYPE_WEAPONOFFHAND")
                    if weaponStyle == "Ranged" then
                        if isRanged then table.insert(mappedSlots, "Main Hand") end
                    elseif weaponStyle == "2H" then
                        -- Only true 2H weapons (staves, 2H swords, polearms, etc.)
                        if is2H then table.insert(mappedSlots, "Main Hand") end
                    elseif weaponStyle == "DW" then
                        -- Dual-wield: only 1H weapons, no 2H, no ranged
                        if not is2H and not isRanged then
                            if isOHOnly then
                                table.insert(mappedSlots, "Off Hand")
                            else
                                table.insert(mappedSlots, "Main Hand")
                                table.insert(mappedSlots, "Off Hand")
                            end
                        end
                    elseif weaponStyle == "1H+Shield" then
                        -- Strictly 1H only; shield comes from the INVTYPE_SHIELD block above
                        if not is2H and not isRanged and not isOHOnly then
                            table.insert(mappedSlots, "Main Hand")
                        end
                    else -- "1H+OH": prefer 1H but allow 2H staves as fallback for casters
                        if not isRanged then
                            if isOHOnly then
                                table.insert(mappedSlots, "Off Hand")
                            else
                                table.insert(mappedSlots, "Main Hand")
                            end
                        end
                    end
                end
                
                local maxPossible = C_Heirloom.GetHeirloomMaxUpgradeLevel and C_Heirloom.GetHeirloomMaxUpgradeLevel(id) or ns.MAX_UPGRADE_LEVEL
                
                -- Normalize irregular upgrade paths (like Hellscream weapons) into the standard 6-tier system
                local effectiveUpgrade = upgradeLevel or 0
                if maxPossible > 0 and maxPossible < ns.MAX_UPGRADE_LEVEL then
                    local offset = ns.MAX_UPGRADE_LEVEL - maxPossible
                    effectiveUpgrade = effectiveUpgrade + offset
                end

                -- Determine if this item's base stats genuinely match the spec's primary stat.
                -- This distinguishes items with a fixed INT (e.g. Devout Autastone Hammer) from
                -- adaptive items that only gain INT at runtime (e.g. a STR sword for a Holy Pally).
                local statMatch = false
                local _, statLink, _, _, _, _, _, _, _, _, _, itemClassID = GetItemInfo(id)
                if statLink then
                    local stats = GetItemStats(statLink)
                    if stats then
                        for k in pairs(stats) do
                            if primaryStat == "Intellect" and k:find("INTELLECT") then statMatch = true; break end
                            if primaryStat == "Agility"   and k:find("AGILITY")   then statMatch = true; break end
                            if primaryStat == "Strength"  and k:find("STRENGTH")  then statMatch = true; break end
                        end
                    end
                    -- Wands and off-hands are natively INT
                    if itemEquipLoc == "INVTYPE_WAND" or itemEquipLoc == "INVTYPE_HOLDABLE" then
                        if primaryStat == "Intellect" then statMatch = true end
                    end
                end
                -- All heirloom armor, rings, trinkets, necks, and cloaks are spec-adaptive.
                -- Only weapons can have genuinely mismatched stats (e.g. a STR sword for an INT spec).
                -- Exception: fixed-stat items (certain necks, trinkets, off-hands) keep their real stat match.
                if ns.FIXED_STAT_ITEMS and ns.FIXED_STAT_ITEMS[id] then
                    local fixedStat = ns.FIXED_STAT_ITEMS[id]
                    statMatch = (fixedStat == primaryStat) or (fixedStat == "Stamina")
                elseif not itemClassID or itemClassID ~= Enum.ItemClass.Weapon then
                    statMatch = true
                end

                table.insert(candidates, {
                    id = id,
                    name = name,
                    icon = icon,
                    equipLoc = itemEquipLoc,
                    upgrade = effectiveUpgrade,
                    rawUpgrade = upgradeLevel or 0,
                    totalUpgrades = ns.MAX_UPGRADE_LEVEL,
                    collected = collected,
                    statMatch = statMatch,
                    mappedSlots = mappedSlots
                })
            end
        end
    end
    
    -- Store all candidates per slot for the detail panel
    ns.slotCandidates = {}
    for _, sObj in ipairs(ns.PLAN_SLOTS) do
        local slotKey = sObj.key
        local slotCands = {}
        for _, c in ipairs(candidates) do
            for _, s in ipairs(c.mappedSlots) do
                if s == slotKey then
                    table.insert(slotCands, c)
                    break
                end
            end
        end
        table.sort(slotCands, function(a, b)
            return ns.ScoreCandidate(a) > ns.ScoreCandidate(b)
        end)
        ns.slotCandidates[slotKey] = slotCands
    end

    -- Assign candidates to slots
    local usedIDs = {}
    local usedGroups = {}
    local mutuallyExclusiveGroups = {
        [128172] = "GhostPirateRing", -- Captain Sander's Returned Band
        [128173] = "GhostPirateRing", -- Admiral Taylor's Loyalty Ring
        [128169] = "GhostPirateRing", -- Signet of the Third Fleet
    }
    -- Explicit duplicate guard for paired slots (Ring 1/2, Trinket 1/2)
    local slotGroups = {
        ["Ring 1"] = "Ring", ["Ring 2"] = "Ring",
        ["Trinket 1"] = "Trinket", ["Trinket 2"] = "Trinket",
    }
    local usedInSlotGroup = {}  -- slotGroup -> chosen item id

    for _, sObj in ipairs(ns.PLAN_SLOTS) do
        local slotKey = sObj.key
        local bestCand = nil            -- best collected item (any stat)
        local bestStatMatch = nil        -- best statMatch=true item (collected or not), for suggestion
        local bestUncollected = nil      -- any uncollected candidate (last-resort fallback)

        local slotGroupName = slotGroups[slotKey]

        for _, c in ipairs(candidates) do
            local canFit = false
            for _, s in ipairs(c.mappedSlots) do
                if s == slotKey then canFit = true; break end
            end

            if canFit then
                local group = mutuallyExclusiveGroups[c.id]
                local groupUsed = group and usedGroups[group]

                -- Skip if this item was already chosen for another slot, or is in a used mutual-exclusion group,
                -- or was already assigned to the paired slot (Ring 1/2 or Trinket 1/2).
                if not usedIDs[c.id] and not groupUsed
                        and not (slotGroupName and usedInSlotGroup[slotGroupName] == c.id) then
                    -- Best owned item (scored)
                    if c.collected then
                        if not bestCand or ns.ScoreCandidate(c) > ns.ScoreCandidate(bestCand) then
                            bestCand = c
                        end
                    end
                    -- Best spec-correct item (prefer collected, then by score)
                    if c.statMatch then
                        if not bestStatMatch or ns.ScoreCandidate(c) > ns.ScoreCandidate(bestStatMatch) then
                            bestStatMatch = c
                        end
                    end
                    -- Track any uncollected candidate as last-resort fallback
                    if not c.collected then
                        if not bestUncollected or ns.ScoreCandidate(c) > ns.ScoreCandidate(bestUncollected) then
                            bestUncollected = c
                        end
                    end
                end
            end
        end
        
        -- Use the best owned item; attach a suggestion if a better spec-correct item exists
        local chosen = bestCand
        local suggestion = nil
        if chosen and not chosen.statMatch and bestStatMatch then
            suggestion = bestStatMatch  -- a spec-native item is available/buyable
        elseif not chosen and bestStatMatch then
            chosen = bestStatMatch      -- nothing owned — show the ideal as missing
        elseif not chosen and bestUncollected then
            chosen = bestUncollected    -- last resort — show any uncollected candidate
        end
        
        local overrideID = GetOverride(currentClass, currentSpecName, slotKey)
        if overrideID then
            for _, c in ipairs(candidates) do
                if c.id == overrideID then
                    local oc = {}; for k,v in pairs(c) do oc[k]=v end
                    oc.isOverride=true; oc.autoID=chosen and chosen.id; oc.autoName=chosen and chosen.name
                    chosen=oc
                    if not oc.statMatch and bestStatMatch and bestStatMatch.id~=oc.id then suggestion=bestStatMatch else suggestion=nil end
                    break
                end
            end
        end
        if chosen then
            if chosen.collected then
                bestSlotAssignments[slotKey] = chosen
            else
                local ghost = {}
                for k,v in pairs(chosen) do ghost[k] = v end
                ghost.isMissing = true
                chosen = ghost
                bestSlotAssignments[slotKey] = chosen
            end
            if suggestion then
                bestSlotAssignments[slotKey].suggestion = suggestion
            end
            usedIDs[chosen.id] = true
            -- For DW specs, allow the same weapon in both Main Hand and Off Hand
            -- (heirloom weapons are NOT unique-equipped; you can create two from collections).
            -- Remove the ID from usedIDs after assigning to Main Hand so Off Hand can reuse it.
            if weaponStyle == "DW" and (slotKey == "Main Hand") and chosen.equipLoc
                    and chosen.equipLoc ~= "INVTYPE_SHIELD" and chosen.equipLoc ~= "INVTYPE_HOLDABLE" then
                usedIDs[chosen.id] = nil
            end
            if slotGroupName then
                usedInSlotGroup[slotGroupName] = chosen.id
            end
            if mutuallyExclusiveGroups[chosen.id] then
                usedGroups[mutuallyExclusiveGroups[chosen.id]] = true
            end
        end
    end

    -- If Main Hand was assigned a 2H weapon, block Off Hand
    local mhAssign = bestSlotAssignments["Main Hand"]
    if mhAssign and mhAssign.equipLoc == "INVTYPE_2HWEAPON" then
        bestSlotAssignments["Off Hand"] = { blocked2H = true }
    end

    -- Update UI
    local requiredTokens = {
        armorTokens = {
            [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0
        },
        weaponTokens = {
            [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0
        }
    }
    
    -- Track items already counted for upgrades (heirloom upgrades are account-wide per item ID,
    -- so duplicate weapons in MH+OH only need upgrading once).
    local upgradeCounted = {}
    
    for i, slotData in ipairs(ns.PLAN_SLOTS) do
        local row = slotsList[i]
        local assignment = bestSlotAssignments[slotData.key]
        row.assignedID = assignment and assignment.id or nil
        row.autoAssignedID = assignment and (assignment.autoID or assignment.id) or nil
        if assignment then
            row.suggestArea.suggestionID = nil
            row.suggestArea.suggestionCollected = nil
            if assignment.blocked2H then
                row.itemID = nil
                row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
                row.itemTxt:SetText("|cff999999(2H Weapon — no off hand)|r")
                row.levelTxt:SetText("N/A")
                row.suggestArea:Hide()
                row.upgradeBtn:Hide()
                row.copyBtn:Hide()
                row.autoBtn:Hide()
            elseif assignment.isMissing then
                row.itemID = assignment.id
                row.icon:SetTexture(assignment.icon)
                -- Color the "(Not Collected)" label based on obtainability
                local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[assignment.id]
                local missingColor, missingTag
                if not ob or ob.obtainable then
                    if ob and ob.limited then
                        missingColor = ns.COLORS.missing_limited
                        missingTag = ns.TAGS.missing_limited
                    else
                        missingColor = ns.COLORS.missing_obtainable
                        missingTag = ns.TAGS.missing_obtainable
                    end
                else
                    missingColor = ns.COLORS.missing_unobtainable
                    missingTag = ns.TAGS.missing_unobtainable
                end
                row.itemTxt:SetText(missingColor .. "(Not Collected)" .. missingTag .. "|r")
                row.levelTxt:SetText("N/A")
                row.suggestArea:Hide()
                row.upgradeBtn:Hide()
                row.copyBtn:Hide()
                row.autoBtn:Hide()
            else
                row.itemID = assignment.id
                row.heirloomName = assignment.name
                row.icon:SetTexture(assignment.icon)
                -- Color owned item name by obtainability
                local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[assignment.id]
                local ownedColor, ownedTag
                if ob and not ob.obtainable then
                    ownedColor = ns.COLORS.owned_unobtainable
                    ownedTag = ns.TAGS.owned_unobtainable
                else
                    ownedColor = ns.COLORS.owned_obtainable
                    ownedTag = ns.TAGS.owned_obtainable
                end
                row.itemTxt:SetText(ownedColor .. assignment.name .. ownedTag .. "|r")
                row.levelTxt:SetText("Tier " .. assignment.upgrade .. "/" .. assignment.totalUpgrades)
                -- Override indicator
                if assignment.isOverride then
                    row.autoBtn.autoName = assignment.autoName
                    row.autoBtn:Show()
                else
                    row.autoBtn:Hide()
                end
                -- Suggestion hint
                if assignment.suggestion then
                    local s = assignment.suggestion
                    local owned = s.collected and "" or " |cff999999(not owned)|r"
                    row.suggestIconTex:SetTexture(s.icon)
                    row.suggestNameTxt:SetText("|cffff9900Better: " .. s.name .. owned .. "|r")
                    row.suggestArea.suggestionID = s.id
                    row.suggestArea.suggestionCollected = s.collected
                    row.suggestArea:Show()
                else
                    row.suggestArea:Hide()
                end
                
                local isWeaponLike = (assignment.equipLoc == "INVTYPE_WEAPON" or assignment.equipLoc == "INVTYPE_2HWEAPON" or assignment.equipLoc == "INVTYPE_WEAPONMAINHAND" or assignment.equipLoc == "INVTYPE_WEAPONOFFHAND" or assignment.equipLoc == "INVTYPE_RANGED" or assignment.equipLoc == "INVTYPE_RANGEDRIGHT")
                
                if assignment.upgrade < maxUpgradeTier and not upgradeCounted[assignment.id] then
                    upgradeCounted[assignment.id] = true
                    local limit = math.min(maxUpgradeTier, assignment.totalUpgrades)
                    for u = assignment.upgrade + 1, limit do
                        if isWeaponLike then
                            requiredTokens.weaponTokens[u] = requiredTokens.weaponTokens[u] + 1
                        else
                            requiredTokens.armorTokens[u] = requiredTokens.armorTokens[u] + 1
                        end
                    end
                end
                -- Upgrade button: show when below target tier; enabled only if token is in bags
                -- Use rawUpgrade (not normalized) to find the correct token tier for C_Heirloom.UpgradeHeirloom
                local nextTier = assignment.upgrade + 1
                local rawNextTier = (assignment.rawUpgrade or assignment.upgrade) + 1
                local targetTier = math.min(maxUpgradeTier, assignment.totalUpgrades)
                if nextTier <= targetTier and ns.UPGRADE_LEVELS[rawNextTier] then
                    local tokenName = isWeaponLike and ns.UPGRADE_LEVELS[rawNextTier][3] or ns.UPGRADE_LEVELS[rawNextTier][2]
                    local hasToken = (GetItemCount(tokenName) or 0) > 0
                    row.upgradeBtn.tokenName = tokenName
                    row.upgradeBtn.hasToken = hasToken
                    row.upgradeBtn:SetEnabled(hasToken)
                    row.upgradeBtn:Show()
                else
                    row.upgradeBtn:Hide()
                end
                -- Per-slot equipped check: only count the specific WoW slot this row maps to
                local targetSlot = ROW_TO_INVSLOT[slotData.key]
                local isEquippedInSlot = targetSlot and (GetInventoryItemID("player", targetSlot) == assignment.id)
                -- Total equipped across all slots (for correcting GetItemCount which includes equipped)
                local totalEquipped = 0
                for s = 1, 19 do
                    if GetInventoryItemID("player", s) == assignment.id then
                        totalEquipped = totalEquipped + 1
                    end
                end
                local bagCount = math.max(0, (GetItemCount(assignment.id) or 0) - totalEquipped)
                -- Store target slot on button for slot-specific EquipItemByName
                row.copyBtn.targetSlot = targetSlot
                if isEquippedInSlot then
                    row.copyBtn:SetText("Equipped")
                    row.copyBtn:SetEnabled(false)
                    row.copyBtn:Show()
                else
                    -- Offer Equip if item is in bags and this specific slot has no better item
                    local showEquip = false
                    local betterItemEquipped = false
                    if bagCount > 0 and targetSlot then
                        local heirloomLink = C_Heirloom.GetHeirloomLink(assignment.id)
                        local heirloomIlvl = heirloomLink and GetDetailedItemLevelInfo and (GetDetailedItemLevelInfo(heirloomLink) or 0) or 0
                        local occupantID = GetInventoryItemID("player", targetSlot)
                        if not occupantID then
                            showEquip = true
                        else
                            local occupantIlvl = GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(GetInventoryItemLink("player", targetSlot) or "") or 0
                            if (occupantIlvl or 0) <= heirloomIlvl then
                                showEquip = true
                            else
                                betterItemEquipped = true
                            end
                        end
                    end
                    row.copyBtn:SetEnabled(true)
                    row.copyBtn.bagCount = bagCount
                    row.copyBtn.isEquipMode = showEquip
                    row.copyBtn.betterItemEquipped = betterItemEquipped
                    if showEquip then
                        row.copyBtn:SetText("Equip")
                    elseif bagCount > 0 then
                        row.copyBtn:SetText("Copy (" .. bagCount .. ")")
                    else
                        row.copyBtn:SetText("Copy")
                    end
                    row.copyBtn:Show()
                end
            end
        else
            row.itemID = nil
            row.suggestArea.suggestionID = nil
            row.suggestArea.suggestionCollected = nil
            row.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            row.itemTxt:SetText("|cffff2222No Eligible Heirloom|r")
            row.levelTxt:SetText("-")
            row.suggestArea:Hide()
            row.upgradeBtn:Hide()
            row.copyBtn:Hide()
            row.autoBtn:Hide()
        end
    end

    -- Populate detail rows for expandable slot panels
    ReleaseAllDetailRows()
    for i, slotData in ipairs(ns.PLAN_SLOTS) do
        local row = slotsList[i]
        local slotKey = slotData.key
        local slotCands = ns.slotCandidates and ns.slotCandidates[slotKey] or {}
        local slotGroupName = slotGroups[slotKey]
        for _, cand in ipairs(slotCands) do
            -- Skip candidates that are unavailable for this slot:
            -- 1) assigned to a different slot (usedIDs) — but allow the item assigned to THIS slot
            -- 2) in a mutual-exclusion group that's already consumed by another slot
            -- 3) duplicate in a paired slot group (same ring/trinket already in slot 1)
            local isAssignedHere = (cand.id == row.assignedID)
            local skip = false
            if not isAssignedHere then
                if usedIDs[cand.id] then skip = true end
                if not skip then
                    local group = mutuallyExclusiveGroups[cand.id]
                    if group and usedGroups[group] then skip = true end
                end
                if not skip and slotGroupName and usedInSlotGroup[slotGroupName] == cand.id then
                    skip = true
                end
            end
            if not skip then
            local dr = AcquireDetailRow()
            dr.itemID = cand.id
            dr.icon:SetTexture(cand.icon)
            local isBest = (cand.id == row.assignedID)
            local nameColor, nameTag
            if cand.collected then
                local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[cand.id]
                if ob and not ob.obtainable then
                    nameColor = ns.COLORS.owned_unobtainable
                    nameTag = ns.TAGS.owned_unobtainable
                else
                    nameColor = ns.COLORS.owned_obtainable
                    nameTag = ns.TAGS.owned_obtainable
                end
            else
                local ob = ns.HEIRLOOM_OBTAINABILITY and ns.HEIRLOOM_OBTAINABILITY[cand.id]
                if not ob or ob.obtainable then
                    if ob and ob.limited then
                        nameColor = ns.COLORS.missing_limited
                        nameTag = ns.TAGS.missing_limited
                    else
                        nameColor = ns.COLORS.missing_obtainable
                        nameTag = ns.TAGS.missing_obtainable
                    end
                else
                    nameColor = ns.COLORS.missing_unobtainable
                    nameTag = ns.TAGS.missing_unobtainable
                end
            end
            local prefix = isBest and "|cffffff00> |r" or "  "
            dr.nameTxt:SetText(prefix .. nameColor .. cand.name .. nameTag .. "|r")
            dr.scoreTxt:SetText("|cffaaaaaa" .. ns.ScoreCandidate(cand) .. "|r")
            dr.tierTxt:SetText("T" .. cand.upgrade .. "/" .. cand.totalUpgrades)
            dr.bg:SetColorTexture(isBest and 0.2 or 0.1, isBest and 0.2 or 0.1, isBest and 0.3 or 0.15, 0.6)
            local isPinned = (cand.id == GetOverride(currentClass, currentSpecName, slotKey))
            local isBestAuto = (cand.id == row.autoAssignedID) and not isPinned
            dr.pinBtn.slotKey = slotKey; dr.pinBtn.candID = cand.id
            if isPinned then dr.pinBtn:SetText("|cffff9900Pinned|r"); dr.pinBtn:SetEnabled(false)
            elseif isBestAuto then dr.pinBtn:SetText("|cff00ff00Best|r"); dr.pinBtn:SetEnabled(false)
            else dr.pinBtn:SetText("Pin"); dr.pinBtn:SetEnabled(true) end
            if not row.expanded then
                dr:Hide()
            end
            table.insert(row.detailRows, dr)
            end
        end
        local hasCands = #row.detailRows > 0
        row.expandTxt:SetText(hasCands and (row.expanded and "|cffffff00-|r" or "|cffffff00+|r") or "")
    end
    RepositionRows()

    -- Build structured shopping needs table (used by both text display and vendor panel)
    ns.shoppingNeeds = {}
    for l = 1, maxUpgradeTier do
        local aCount = requiredTokens.armorTokens[l]
        if aCount > 0 then
            local name = ns.UPGRADE_LEVELS[l][2]
            table.insert(ns.shoppingNeeds, {
                name     = name,
                tier     = l,
                needCount = aCount,
                bagCount = GetItemCount(name) or 0,
                goldCost = ns.UPGRADE_LEVELS[l][4],
                twCost   = ns.UPGRADE_LEVELS[l][6],
            })
        end
        local wCount = requiredTokens.weaponTokens[l]
        if wCount > 0 then
            local name = ns.UPGRADE_LEVELS[l][3]
            table.insert(ns.shoppingNeeds, {
                name     = name,
                tier     = l,
                needCount = wCount,
                bagCount = GetItemCount(name) or 0,
                goldCost = ns.UPGRADE_LEVELS[l][5],
                twCost   = ns.UPGRADE_LEVELS[l][7],
            })
        end
    end

    -- Generate Shopping List text
    local shopLines = {}
    table.insert(shopLines, "|cff00ff00Shopping List (Up to Tier " .. maxUpgradeTier .. ")|r\n")
    
    local totalGold = 0
    local hasAny = false
    local lastTier = nil

    for _, need in ipairs(ns.shoppingNeeds) do
        if need.tier ~= lastTier then
            if lastTier then table.insert(shopLines, "") end
            table.insert(shopLines, "|cffcccccc" .. "Tier " .. need.tier .. " (" .. ns.UPGRADE_LEVEL_NAMES[need.tier] .. ")|r")
            lastTier = need.tier
        end

        local stillNeeded = math.max(0, need.needCount - need.bagCount)
        local goldCostTotal = need.goldCost * stillNeeded
        totalGold = totalGold + goldCostTotal

        local line
        if need.bagCount >= need.needCount then
            -- Fully covered: grey out, no cost shown, bag count at end
            line = string.format("  |cff999999%d x %s|r |cff00ff00[%d in bags - done]|r",
                need.needCount, need.name, need.bagCount)
        elseif need.bagCount > 0 then
            -- Partially covered: show cost, bag count at end
            line = string.format("  %d x %s (|cffffff00%dg|r / |cffaaaaaa%d TW badges|r each) |cff00ff00[%d in bags]|r",
                stillNeeded, need.name, need.goldCost, need.twCost, need.bagCount)
        else
            -- None in bags: show cost only
            line = string.format("  %d x %s (|cffffff00%dg|r / |cffaaaaaa%d TW badges|r each)",
                need.needCount, need.name, need.goldCost, need.twCost)
        end
        table.insert(shopLines, line)
        hasAny = true
    end
    
    if not hasAny then
        table.insert(shopLines, "All equipped heirlooms meet the target level!")
    else
        table.insert(shopLines, "\n-------------------------")
        table.insert(shopLines, string.format("Total Gold Still Needed: |cffffff00%dg|r", totalGold))
    end

    -- Acquisition cost summary for uncollected slots
    local acquisitionGold = 0
    local acquisitionCurrency = {}  -- currencyID -> total amount
    local hasAcquisition = false
    for i, slotData in ipairs(ns.PLAN_SLOTS) do
        local assignment = bestSlotAssignments[slotData.key]
        if assignment and assignment.isMissing then
            local costInfo = ns.HEIRLOOM_PURCHASE_COSTS and ns.HEIRLOOM_PURCHASE_COSTS[assignment.id]
            if costInfo then
                hasAcquisition = true
                if costInfo.gold then
                    acquisitionGold = acquisitionGold + costInfo.gold
                end
            end
        end
    end
    if hasAcquisition and acquisitionGold > 0 then
        table.insert(shopLines, string.format("\n|cffff9900Uncollected Purchase Cost: %dg|r", acquisitionGold))
    end
    
    shoppingText:SetText(table.concat(shopLines, "\n"))
    UpdateCurrencyBar()
    UpdateVendorNav()
end

-- =========================================================
-- TOMTOM INTEGRATION
-- =========================================================
function ns.SetVendorWaypoint(vendorInfo)
    if not TomTom then
        print("|cFFFF6600Heirloom Upgrade Planner:|r TomTom addon is not installed.")
        return false
    end
    if not vendorInfo or not vendorInfo.mapID then return false end

    TomTom:AddWaypoint(vendorInfo.mapID, vendorInfo.x, vendorInfo.y, {
        title  = string.format("%s (%s)", vendorInfo.name, vendorInfo.title or ""),
        source = "HeirloomUpgradePlanner",
        persistent = false,
        minimap    = true,
        world      = true,
    })

    local msg = string.format("|cFF00FF00HUP:|r Waypoint set to %s in %s", vendorInfo.name, vendorInfo.zone)
    if vendorInfo.note then
        msg = msg .. " |cffaaaaaa(" .. vendorInfo.note .. ")|r"
    end
    print(msg)
    return true
end

-- =========================================================
-- VENDOR NAVIGATION PANEL (Standalone Collapsible)
-- =========================================================
local vendorNavFrame = CreateFrame("Frame", "HUP_VendorNavFrame", UIParent, "BackdropTemplate")
vendorNavFrame:SetSize(320, 300)
vendorNavFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", -10, 0)
vendorNavFrame:SetFrameStrata("HIGH")
vendorNavFrame:SetBackdrop({
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
vendorNavFrame:SetBackdropColor(0.05, 0.05, 0.1, 0.95)
vendorNavFrame:SetBackdropBorderColor(0.4, 0.6, 0.8, 1)
vendorNavFrame:Hide()

-- Title bar
local vendorNavTitle = vendorNavFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
vendorNavTitle:SetPoint("TOP", 0, -10)
vendorNavTitle:SetText("|cff00ccffVendor Navigation|r")

-- Close button
local vendorNavCloseBtn = CreateFrame("Button", nil, vendorNavFrame, "UIPanelCloseButton")
vendorNavCloseBtn:SetPoint("TOPRIGHT", -2, -2)
vendorNavCloseBtn:SetScript("OnClick", function() vendorNavFrame:Hide() end)

-- Scroll frame for vendor buttons
local vendorNavScroll = CreateFrame("ScrollFrame", nil, vendorNavFrame, "UIPanelScrollFrameTemplate")
vendorNavScroll:SetPoint("TOPLEFT", 10, -30)
vendorNavScroll:SetPoint("BOTTOMRIGHT", -30, 10)

local vendorNavContent = CreateFrame("Frame", nil, vendorNavScroll)
vendorNavContent:SetSize(280, 400)
vendorNavScroll:SetScrollChild(vendorNavContent)

local vendorNavButtons = {}

local function CreateVendorNavButton(parent, vendorInfo, yOffset)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(270, 24)
    btn:SetPoint("TOPLEFT", 5, yOffset)
    btn:SetText(string.format("%s — %s", vendorInfo.name, vendorInfo.zone))
    btn:SetNormalFontObject("GameFontNormalSmall")
    btn:SetHighlightFontObject("GameFontHighlightSmall")
    btn:SetScript("OnClick", function()
        ns.SetVendorWaypoint(vendorInfo)
    end)
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(vendorInfo.name, 1, 1, 1)
        GameTooltip:AddLine(vendorInfo.title, 0.7, 0.7, 0.7)
        GameTooltip:AddLine(vendorInfo.zone, 0.5, 0.8, 1)
        if vendorInfo.note then
            GameTooltip:AddLine(vendorInfo.note, 1, 0.8, 0)
        end
        if not TomTom then
            GameTooltip:AddLine("|cffff4444TomTom addon not detected|r", 1, 0.3, 0.3)
        else
            GameTooltip:AddLine("Click to set TomTom waypoint", 0, 1, 0)
        end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return btn
end

function UpdateVendorNav()
    -- Hide existing buttons
    for _, btn in ipairs(vendorNavButtons) do
        btn:Hide()
    end

    local faction = UnitFactionGroup("player")
    if not faction then return end
    local factionKey = faction:upper() == "ALLIANCE" and "ALLIANCE" or "HORDE"
    local factionVendors = ns.VENDOR_COORDS[factionKey]
    local neutralVendors = ns.VENDOR_COORDS.NEUTRAL
    if not factionVendors then return end

    local yOffset = -5
    local btnIdx = 0

    -- TomTom status indicator
    if not vendorNavFrame.tomtomStatus then
        vendorNavFrame.tomtomStatus = vendorNavContent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        vendorNavFrame.tomtomStatus:SetPoint("TOPLEFT", 5, 0)
    end
    if TomTom then
        vendorNavFrame.tomtomStatus:SetText("|cff00ff00TomTom Detected|r")
    else
        vendorNavFrame.tomtomStatus:SetText("|cffff4444TomTom Not Installed|r")
    end
    yOffset = yOffset - 20

    -- Build ordered list of vendors to show
    local vendorList = {}
    for key, info in pairs(factionVendors) do
        table.insert(vendorList, info)
    end
    for key, info in pairs(neutralVendors) do
        table.insert(vendorList, info)
    end

    for i, vendorInfo in ipairs(vendorList) do
        btnIdx = btnIdx + 1
        if not vendorNavButtons[btnIdx] then
            vendorNavButtons[btnIdx] = CreateVendorNavButton(vendorNavContent, vendorInfo, yOffset)
        else
            vendorNavButtons[btnIdx]:SetText(string.format("%s — %s", vendorInfo.name, vendorInfo.zone))
            vendorNavButtons[btnIdx]:SetScript("OnClick", function()
                ns.SetVendorWaypoint(vendorInfo)
            end)
            vendorNavButtons[btnIdx]:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:AddLine(vendorInfo.name, 1, 1, 1)
                GameTooltip:AddLine(vendorInfo.title, 0.7, 0.7, 0.7)
                GameTooltip:AddLine(vendorInfo.zone, 0.5, 0.8, 1)
                if vendorInfo.note then
                    GameTooltip:AddLine(vendorInfo.note, 1, 0.8, 0)
                end
                if not TomTom then
                    GameTooltip:AddLine("|cffff4444TomTom addon not detected|r", 1, 0.3, 0.3)
                else
                    GameTooltip:AddLine("Click to set TomTom waypoint", 0, 1, 0)
                end
                GameTooltip:Show()
            end)
            vendorNavButtons[btnIdx]:SetPoint("TOPLEFT", 5, yOffset)
        end
        vendorNavButtons[btnIdx]:Show()
        yOffset = yOffset - 28
    end

    -- Resize content to fit all buttons
    local totalHeight = math.abs(yOffset) + 10
    vendorNavContent:SetHeight(math.max(totalHeight, 400))
end

-- Toggle button in the shopping list area
local vendorNavToggleBtn = CreateFrame("Button", nil, rightContent, "UIPanelButtonTemplate")
vendorNavToggleBtn:SetSize(140, 24)
vendorNavToggleBtn:SetPoint("TOPLEFT", shoppingText, "BOTTOMLEFT", 0, -10)
vendorNavToggleBtn:SetText("Vendor Navigation")
vendorNavToggleBtn:SetNormalFontObject("GameFontNormalSmall")
vendorNavToggleBtn:SetScript("OnClick", function()
    if vendorNavFrame:IsShown() then
        vendorNavFrame:Hide()
    else
        UpdateVendorNav()
        vendorNavFrame:Show()
    end
end)
vendorNavToggleBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Vendor Navigation", 1, 1, 1)
    GameTooltip:AddLine("Click to show/hide vendor waypoint panel", 0.7, 0.7, 0.7)
    if TomTom then
        GameTooltip:AddLine("|cff00ff00TomTom detected|r - waypoints available", 0.5, 1, 0.5)
    else
        GameTooltip:AddLine("|cffff4444TomTom not installed|r", 1, 0.3, 0.3)
    end
    GameTooltip:Show()
end)
vendorNavToggleBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- =========================================================
-- VENDOR OVERLAY
-- =========================================================
local vendorFrame = CreateFrame("Frame", "HUP_VendorFrame", UIParent, "BackdropTemplate")
vendorFrame:SetSize(310, 50)
vendorFrame:SetFrameStrata("HIGH")
vendorFrame:SetBackdrop({
    bgFile   = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 14,
    insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
vendorFrame:SetBackdropColor(0.05, 0.05, 0.1, 0.95)
vendorFrame:SetBackdropBorderColor(0.5, 0.5, 0.8, 1)
vendorFrame:Hide()

local vendorTitle = vendorFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
vendorTitle:SetPoint("TOP", 0, -8)
vendorTitle:SetText("|cff00ff00HUP Shopping List|r")

local vendorRows = {}

local function BuildVendorPanel()
    if not ns.shoppingNeeds or #ns.shoppingNeeds == 0 then
        vendorFrame:Hide()
        return
    end

    -- Scan all merchant items by name -> index
    local merchantByName = {}
    local total = GetMerchantNumItems()
    for i = 1, total do
        local itemInfo = C_MerchantFrame.GetItemInfo(i)
        if itemInfo and itemInfo.name then
            merchantByName[itemInfo.name] = i
        end
    end

    -- Filter to only items this vendor actually sells that we still need
    local available = {}
    for _, need in ipairs(ns.shoppingNeeds) do
        local idx = merchantByName[need.name]
        if idx and need.bagCount < need.needCount then
            table.insert(available, {
                name          = need.name,
                stillNeeded   = need.needCount - need.bagCount,
                merchantIndex = idx,
                goldCost      = need.goldCost,
                twCost        = need.twCost,
                tier          = need.tier,
            })
        end
    end

    -- Hide old rows
    for _, r in ipairs(vendorRows) do r:Hide() end
    vendorRows = {}

    if #available == 0 then
        vendorFrame:Hide()
        return
    end

    local rowH = 28
    local padding = 10
    local totalH = 26 + #available * (rowH + 2) + padding

    vendorFrame:SetHeight(totalH)
    if MerchantFrame and MerchantFrame:IsShown() then
        vendorFrame:ClearAllPoints()
        vendorFrame:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 4, 0)
    end

    for i, item in ipairs(available) do
          local row = CreateFrame("Button", nil, vendorFrame, "SecureActionButtonTemplate,BackdropTemplate")
        row:SetSize(290, rowH)
        row:SetPoint("TOPLEFT", 10, -24 - (i - 1) * (rowH + 2))
        row:SetBackdrop({
            bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 8, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        row:SetBackdropColor(0.1, 0.1, 0.15, 0.8)

        -- Item label
        local label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        label:SetPoint("LEFT", 6, 0)
        label:SetWidth(170)
        label:SetJustifyH("LEFT")
        label:SetWordWrap(false)
        label:SetText(string.format("|cffffff00%dx|r %s", item.stillNeeded, item.name))

        -- Price label (per-item cost)
        local price = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        price:SetPoint("RIGHT", -60, 0)
        price:SetJustifyH("RIGHT")
        price:SetText(string.format("|cffffff00%dg ea|r", item.goldCost))

        -- Buy button (buys 1 at a time) — BuyMerchantItem is not protected, no secure template needed
        local buyBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
        buyBtn:SetSize(52, 20)
        buyBtn:SetPoint("RIGHT", -4, 0)
        buyBtn:SetNormalFontObject("GameFontNormalSmall")
        buyBtn:SetText("|cff00ff00Buy 1|r")

        local capturedIndex = item.merchantIndex
        local capturedName  = item.name
        local capturedGold  = item.goldCost
        local capturedTW    = item.twCost
        local capturedNeed  = item.stillNeeded
        buyBtn:SetScript("OnClick", function()
            BuyMerchantItem(capturedIndex, 1)
            -- Optimistic update: reflect the purchase immediately in both panels
            for _, need in ipairs(ns.shoppingNeeds) do
                if need.name == capturedName then
                    need.bagCount = need.bagCount + 1
                    break
                end
            end
            BuildVendorPanel()
            -- Full reconciliation once the server confirms the bag update
            C_Timer.After(1.0, function()
                ns.RebuildPlan()
                if vendorFrame:IsShown() then BuildVendorPanel() end
            end)
        end)

        buyBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(string.format("Buy 1x %s", capturedName), 1, 1, 1)
            GameTooltip:AddLine(string.format("|cffffff00%dg|r per token  (need %d more)", capturedGold, capturedNeed), 1, 1, 1)
            if capturedTW and capturedTW > 0 then
                GameTooltip:AddLine(string.format("|cffaaaaaa%d Timewarped Badges|r per token", capturedTW), 1, 1, 1)
            end
            GameTooltip:Show()
        end)
        buyBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

        table.insert(vendorRows, row)
    end

    vendorFrame:Show()
end

ns.BuildVendorPanel = BuildVendorPanel

-- =========================================================
-- STATE PERSISTENCE
-- =========================================================
ns.State = {}

function ns.State:Save()
    if not HUP_Config then HUP_Config = {} end
    local point, _, relPoint, x, y = frame:GetPoint()
    HUP_Config.currentClass   = currentClass
    HUP_Config.currentSpec    = currentSpecName
    HUP_Config.targetTier     = maxUpgradeTier
    HUP_Config.framePos       = {point or "CENTER", relPoint or "CENTER", x or 0, y or 0}
    HUP_Config.overrides      = ns.overrides
end

function ns.State:Load()
    if not HUP_Config then return end
    if HUP_Config.currentClass and ns.CLASS_SPECS[HUP_Config.currentClass] then
        currentClass = HUP_Config.currentClass
        classDropdown.Text:SetText(currentClass)
        BuildSpecDropdown()
    end
    if HUP_Config.currentSpec then
        local clSpecs = ns.CLASS_SPECS[currentClass]
        for _, s in ipairs(clSpecs or {}) do
            if s.name == HUP_Config.currentSpec then
                currentSpecName = s.name
                specDropdown.Text:SetText(currentSpecName)
                break
            end
        end
    end
    if HUP_Config.targetTier then
        maxUpgradeTier = HUP_Config.targetTier
        -- Update target dropdown label
        local tierName = "Tier " .. maxUpgradeTier
        for _, t in ipairs(ns.UPGRADE_LEVELS) do
            if t[1] == maxUpgradeTier then
                tierName = "Tier " .. t[1] .. " (Level " .. t[8] .. ")"
                break
            end
        end
        targetDropdown.Text:SetText(tierName)
    end
    if HUP_Config.framePos then
        local p = HUP_Config.framePos
        frame:ClearAllPoints()
        frame:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    end
    ns.overrides = HUP_Config.overrides or {}
end

local isInitialized = false
local bagUpdatePending = false
frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        if not HUP_Config then HUP_Config = {} end
        ns.State:Load()
    elseif event == "PLAYER_ENTERING_WORLD" then
        if not isInitialized then
            C_Timer.After(2, function() UpdateDataAndUI() end)
            isInitialized = true
        end
    elseif event == "MERCHANT_SHOW" then
        C_Timer.After(0.3, BuildVendorPanel)
    elseif event == "MERCHANT_CLOSED" then
        vendorFrame:Hide()
    elseif event == "PLAYER_MONEY" or event == "CURRENCY_DISPLAY_UPDATE" then
        UpdateCurrencyBar()
    elseif event == "BAG_UPDATE" then
        -- Debounce: only rebuild once per batch of bag changes
        -- Handles both vendor purchases and heirloom upgrades
        if not bagUpdatePending then
            bagUpdatePending = true
            C_Timer.After(0.5, function()
                bagUpdatePending = false
                ns.RebuildPlan()
                if MerchantFrame and MerchantFrame:IsShown() and vendorFrame:IsShown() then
                    BuildVendorPanel()
                end
            end)
        end
    end
end)
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_CLOSED")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
frame:RegisterEvent("BAG_UPDATE")

function ns.ToggleFrame()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        UpdateDataAndUI()
    end
end

-- Register frame for ESC key (Blizzard's standard pattern for closeable panels)
tinsert(UISpecialFrames, "HeirloomUpgradePlannerFrame")

-- Slash commands
SLASH_HEIRLOOMPLANNER1 = "/hup"
SLASH_HEIRLOOMPLANNER2 = "/heirloom"
SlashCmdList["HEIRLOOMPLANNER"] = function()
    ns.ToggleFrame()
end

SLASH_HUPDEBUGTOGGLE1 = "/hupdebug"
SlashCmdList["HUPDEBUGTOGGLE"] = function()
    debugBtn:SetShown(not debugBtn:IsShown())
    print("|cFF00FF00HUP:|r Debug button " .. (debugBtn:IsShown() and "shown" or "hidden"))
end