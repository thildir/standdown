-- Standdown: shows the time left on your PvP flag in its own small box.
-- Type /standdown for the list of commands.

StanddownDB = StanddownDB or {}

local f = CreateFrame("Frame", "StanddownFrame", UIParent)
f:SetSize(86, 22)
f:SetFrameStrata("MEDIUM")
f:SetClampedToScreen(true)
f:SetMovable(true)
f:EnableMouse(false)
f:RegisterForDrag("LeftButton")
f:Hide()

local bg = f:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.5)

local text = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")

local unlocked = false

local function place()
    local p = StanddownDB.pos
    f:ClearAllPoints()
    if p then
        f:SetPoint(p[1], UIParent, p[2], p[3], p[4])
    else
        f:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
    end
end

f:SetScript("OnDragStart", function(self)
    if unlocked then self:StartMoving() end
end)
f:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, relPoint, x, y = self:GetPoint()
    StanddownDB.pos = { point, relPoint, x, y }
end)

local function update()
    local ms = GetPVPTimer and GetPVPTimer() or 0
    local active = UnitIsPVP("player") and ms and ms > 0 and ms <= 300000
    if active then
        -- a real timer is running: show it (also while the box is unlocked)
        local s = math.floor(ms / 1000 + 0.5)
        text:SetText(string.format("PvP %d:%02d", math.floor(s / 60), s % 60))
        if s <= 60 then text:SetTextColor(0.3, 1, 0.3) else text:SetTextColor(1, 0.3, 0.3) end
        f:Show()
    elseif unlocked then
        -- no timer: show a dummy box so there is something to drag
        text:SetText("PvP 4:32")
        text:SetTextColor(1, 0.82, 0)
        f:Show()
    else
        f:Hide()
    end
end

-- always-visible driver, so the box can reappear after it hid itself
local driver = CreateFrame("Frame")
local acc = 0
driver:SetScript("OnUpdate", function(_, elapsed)
    acc = acc + elapsed
    if acc >= 0.25 then
        acc = 0
        update()
    end
end)
driver:RegisterEvent("PLAYER_ENTERING_WORLD")
driver:RegisterEvent("PLAYER_FLAGS_CHANGED")
driver:RegisterEvent("UNIT_FACTION")
driver:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_ENTERING_WORLD" then place() end
    update()
end)

local function say(msg) print("|cffffd100Standdown:|r " .. msg) end

local function help()
    say("commands")
    print("  /standdown unlock  - show the box so you can drag it")
    print("  /standdown lock    - lock the box in place")
    print("  /standdown reset   - put the box back in the default place")
    print("  /standdown help    - show this list")
end

SLASH_STANDDOWN1 = "/standdown"
SlashCmdList["STANDDOWN"] = function(msg)
    local cmd = (msg or ""):lower():match("^%s*(%S*)")
    if cmd == "unlock" then
        unlocked = true
        f:EnableMouse(true)
        update()
        say("unlocked. Drag the box, then type /standdown lock.")
    elseif cmd == "lock" then
        unlocked = false
        f:EnableMouse(false)
        update()
        say("locked.")
    elseif cmd == "reset" then
        StanddownDB.pos = nil
        place()
        say("position reset.")
    else
        help()
    end
end
