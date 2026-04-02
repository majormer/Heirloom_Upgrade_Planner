local addonName, ns = ...

-- =========================================================
-- MINIMAP BUTTON (LibDBIcon Integration)
-- =========================================================

local LDB = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
local LDBIcon = LibStub and LibStub:GetLibrary("LibDBIcon-1.0", true)

if not LDB then
    -- Fallback: Create basic minimap button without LibDBIcon
    local minimapButton = CreateFrame("Button", "HUP_MinimapButton", Minimap)
    minimapButton:SetSize(32, 32)
    minimapButton:SetFrameStrata("MEDIUM")
    minimapButton:SetFrameLevel(8)
    minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -15, 0)
    minimapButton:SetMovable(true)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForDrag("LeftButton")
    
    -- Icon texture
    local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexture("Interface\\AddOns\\Heirloom_Upgrade_Planner\\images\\HeirloomUpgradePlanner.png")
    
    -- Border
    local border = minimapButton:CreateTexture(nil, "OVERLAY")
    border:SetSize(52, 52)
    border:SetPoint("TOPLEFT", 0, 0)
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    -- Highlight
    local highlight = minimapButton:CreateTexture(nil, "HIGHLIGHT")
    highlight:SetSize(20, 20)
    highlight:SetPoint("CENTER", 0, 1)
    highlight:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    highlight:SetBlendMode("ADD")
    
    -- Click handler
    minimapButton:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            ns.ToggleFrame()
        elseif button == "RightButton" then
            -- Right-click could open options menu in future
            ns.ToggleFrame()
        end
    end)
    
    -- Tooltip
    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("|cff00ff00Heirloom Upgrade Planner|r", 1, 1, 1)
        GameTooltip:AddLine("Click to open planner", 0.7, 0.7, 0.7)
        GameTooltip:AddLine("Right-click for options", 0.5, 0.5, 0.5)
        GameTooltip:Show()
    end)
    
    minimapButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- Drag to move around minimap
    local function UpdatePosition()
        local x, y = GetCursorPosition()
        local scale = minimapButton:GetEffectiveScale()
        x, y = x / scale, y / scale
        
        local centerX, centerY = Minimap:GetCenter()
        local dx, dy = x - centerX, y - centerY
        local angle = math.atan2(dy, dx)
        
        local cos, sin = math.cos(angle), math.sin(angle)
        local radius = 80
        
        minimapButton:ClearAllPoints()
        minimapButton:SetPoint("CENTER", Minimap, "CENTER", cos * radius, sin * radius)
    end
    
    minimapButton:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", UpdatePosition)
    end)
    
    minimapButton:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil)
        self:UnlockHighlight()
        
        -- Save position
        if not HUP_Config then HUP_Config = {} end
        local point, _, relPoint, x, y = self:GetPoint()
        HUP_Config.minimapPos = {point, relPoint, x, y}
    end)
    
    -- Restore saved position
    local function RestorePosition()
        if HUP_Config and HUP_Config.minimapPos then
            local pos = HUP_Config.minimapPos
            minimapButton:ClearAllPoints()
            minimapButton:SetPoint(pos[1], Minimap, pos[2], pos[3], pos[4])
        end
    end
    
    -- Initialize position on load
    C_Timer.After(0.5, RestorePosition)
    
    ns.MinimapButton = minimapButton
    return
end

-- =========================================================
-- LibDataBroker + LibDBIcon Implementation
-- =========================================================

local dataObject = LDB:NewDataObject("HeirloomUpgradePlanner", {
    type = "launcher",
    text = "HUP",
    icon = "Interface\\AddOns\\Heirloom_Upgrade_Planner\\images\\HeirloomUpgradePlanner.png",
    OnClick = function(self, button)
        if button == "LeftButton" then
            ns.ToggleFrame()
        elseif button == "RightButton" then
            -- Future: Options menu
            ns.ToggleFrame()
        end
    end,
    OnTooltipShow = function(tooltip)
        if not tooltip or not tooltip.AddLine then return end
        tooltip:AddLine("|cff00ff00Heirloom Upgrade Planner|r")
        tooltip:AddLine(" ")
        tooltip:AddLine("|cffffffffLeft-click|r to open planner", 0.7, 0.7, 0.7)
        tooltip:AddLine("|cffffffffRight-click|r for options", 0.5, 0.5, 0.5)
    end,
})

-- Initialize LibDBIcon
if LDBIcon then
    -- Create default config if needed
    if not HUP_Config then HUP_Config = {} end
    if not HUP_Config.minimap then
        HUP_Config.minimap = {
            hide = false,
            minimapPos = 220,
            lock = false,
        }
    end
    
    -- Register with LibDBIcon
    LDBIcon:Register("HeirloomUpgradePlanner", dataObject, HUP_Config.minimap)
    
    -- Expose toggle function
    function ns.ToggleMinimapIcon()
        if HUP_Config.minimap.hide then
            LDBIcon:Show("HeirloomUpgradePlanner")
            HUP_Config.minimap.hide = false
            print("|cFF00FF00HUP:|r Minimap icon shown")
        else
            LDBIcon:Hide("HeirloomUpgradePlanner")
            HUP_Config.minimap.hide = true
            print("|cFF00FF00HUP:|r Minimap icon hidden")
        end
    end
    
    -- Slash command to toggle minimap icon
    SLASH_HUPMINIMAP1 = "/hupminimap"
    SlashCmdList["HUPMINIMAP"] = function()
        ns.ToggleMinimapIcon()
    end
end

ns.DataObject = dataObject
