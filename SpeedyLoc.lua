--[[	SpeedyLoc	]]--

local deg = math.deg
local format = string.format
local tonumber = tonumber

----------------------

local AddMessage = AddMessage
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetPlayerFacing = GetPlayerFacing
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition
local GetUnitSpeed = GetUnitSpeed
local IsFalling = IsFalling
local UIParent = UIParent
local UnitOnTaxi = UnitOnTaxi

----------------------

local SpeedyLoc = LibStub("AceAddon-3.0"):NewAddon("SpeedyLoc")

local L = LibStub("AceLocale-3.0"):GetLocale("SpeedyLoc")
local Media = LibStub("LibSharedMedia-3.0")

SpeedyLoc.VERSION = 1.2
SpeedyLoc.DebugOn = false
SpeedyLoc.Prefix = "|cffa0a0a0Speedy:"

local facing, facingShort
local speed
local texttemplate, text = "|cffa0a0a0%%.%df.%%.%df", "|cffa0a0a0%%.%df.%%.%df"

----------------------

local db
local defaults = {
	profile = {
		point = "CENTER",
		posX = 0,
		posY = 0,
		locked = false,
		clamped = true,
		strata = "HIGH",
		width = 130,
		height = 30,
		scale = 1,
		backgroundColor = {r = 0, g = 0, b = 0, a = 1},
		backgroundTexture = "Blizzard Tooltip",
		borderColor = {r = 1, g = 1, b = 1, a = 1},
		borderTexture = "Blizzard Tooltip",
		borderSize = 15,
		borderInset = 3,
		coords = {
			font = "Friz Quadrata TT",
			fontSize = 12,
			fontOutline = "NONE",
			fontShadow = false,
			anchor = "LEFT",
			posx = 7,
			posy = 0,
			accuracy = 0,
			hideZero = false,
		},
		direction = {
			font = "Friz Quadrata TT",
			fontSize = 12,
			fontOutline = "NONE",
			fontShadow = false,
			anchor = "CENTER",
			posx = 0,
			posy = 0,
		},
		speed = {
			font = "Friz Quadrata TT",
			fontSize = 12,
			fontOutline = "NONE",
			fontShadow = false,
			anchor = "RIGHT",
			posx = -7,
			posy = 0,
		},
	}
}

----------------------

function SpeedyLoc.prt(msg)
	DEFAULT_CHAT_FRAME:AddMessage(SpeedyLoc.Prefix.." |cffffffff"..msg)
end

function SpeedyLoc.prtError(msg)
	DEFAULT_CHAT_FRAME:AddMessage(SpeedyLoc.Prefix.." |cffff0000"..msg)
end

function SpeedyLoc.prtD(...)
	if SpeedyLoc.DebugOn then
		SpeedyLoc.prt(...)
	end
end

----------------------

function SpeedyLoc:OnInitialize()
	SpeedyLoc.prtD("OnInitialize")

	self.db = LibStub("AceDB-3.0"):New("SpeedyLocDB", defaults, true)
	db = self.db.profile

	self.db.RegisterCallback(self, "OnProfileChanged", "UpdateLayout")
	self.db.RegisterCallback(self, "OnProfileCopied", "UpdateLayout")
	self.db.RegisterCallback(self, "OnProfileReset", "UpdateLayout")

	self:Updater()

	self:SetupOptions()
end

----------------------

function SpeedyLoc:OnEnable()
	SpeedyLoc.prtD("OnEnable")

	if (not self.frame) then
		self:CreateBar()
	end

	self:UpdateLayout()
end

----------------------

function SpeedyLoc:OnDisable()
	SpeedyLoc.prtD("OnDisable")
end

----------------------

function SpeedyLoc:Updater()
	SpeedyLoc.prtD("Updater")

	if (not SpeedyLocDB.version) then
		SpeedyLocDB.version = SpeedyLoc.VERSION
		StaticPopupDialogs["SPEEDYLOC_WELCOME"] = {
			text = L["Welcome! Type /speedyloc to configure."],
			button1 = "Okay",
			button2 = "Open Options",
			OnCancel = function()
				OpenOptions()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("SPEEDYLOC_WELCOME")
	elseif SpeedyLocDB.version ~= SpeedyLoc.VERSION then
		SpeedyLocDB.version = SpeedyLoc.VERSION
		SpeedyLoc.prt(format("|cff00ff00%s", L["Updated to latest version"]))
	end
end

----------------------

function GetPlayerPosition()
	SpeedyLoc.prtD("GetPlayerPosition")
	db = SpeedyLoc.db.profile

	local px, py
	local MapID = GetBestMapForUnit("player")
	local xy = GetPlayerMapPosition(MapID or WorldMapFrame:GetID(), "player")
	if xy then
		px, py = xy:GetXY()
	end

	if not px or px == 0 then
		if db.coords.hideZero then
			return ""
		else
			return text:format(0, 0)
		end
	else
		return text:format(100 * px, 100 * py)
	end
end

function GetFacing()
	SpeedyLoc.prtD("GetFacing")

	local plyrFacing = GetPlayerFacing()
	if plyrFacing then
		facing = 360 - deg(plyrFacing)
		facingShort = 0
		if ((facing >= 337.5) or (facing < 22.5)) and (facingShort ~= 1) then SpeedyLoc.prtD("N")
			facingShort = 1
			return "|cffa0a0a0N"
		elseif (facing >= 22.5) and (facing < 67.5) and (facingShort ~= 2) then SpeedyLoc.prtD("NE")
			facingShort = 2
			return "|cffa0a0a0NE"
		elseif (facing >= 67.5) and (facing < 112.5) and (facingShort ~= 3) then SpeedyLoc.prtD("E")
			facingShort = 3
			return "|cffa0a0a0E"
		elseif (facing >= 112.5) and (facing < 157.5) and (facingShort ~= 4) then SpeedyLoc.prtD("SE")
			facingShort = 4
			return "|cffa0a0a0SE"
		elseif (facing >= 157.5) and (facing < 202.5) and (facingShort ~= 5) then SpeedyLoc.prtD("S")
			facingShort = 5
			return "|cffa0a0a0S"
		elseif (facing >= 202.5) and (facing < 247.5) and (facingShort ~= 6) then SpeedyLoc.prtD("SW")
			facingShort = 6
			return "|cffa0a0a0SW"
		elseif (facing >= 247.5) and (facing < 292.5) and (facingShort ~= 7) then SpeedyLoc.prtD("W")
			facingShort = 7
			return "|cffa0a0a0W"
		elseif (facing >= 292.5) and (facing < 337.5) and (facingShort ~= 8) then SpeedyLoc.prtD("NW")
			facingShort = 8
			return "|cffa0a0a0NW"
		else SpeedyLoc.prtD("N")
			return "|cffa0a0a0N"
		end
	end
end

----------------------

function SpeedyLoc:CreateBar()
	SpeedyLoc.prtD("CreateBar")

	local f = CreateFrame("Frame", "SpeedyLocFrame", UIParent)
	f:SetBackdrop({
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 15,
					insets = {left = 3, right = 3, top = 3, bottom = 3},
	})
	f.speedTxt = f:CreateFontString(nil, "ARTWORK")
	f.coordsTxt = f:CreateFontString(nil, "ARTWORK")
	f.dirTxt = f:CreateFontString(nil, "ARTWORK")

	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", function(self) SpeedyLoc.prtD("OnDragStart")
		if (not db.locked) and (not InCombatLockdown()) then
			self:ClearAllPoints()
			self:StartMoving()
		elseif InCombatLockdown() then
			SpeedyLoc.prtError(L["Cannot move bar while in combat."])
		end
	end)

	f:SetScript("OnDragStop", function(self) SpeedyLoc.prtD("OnDragStop")
		if (not db.locked) then
			self:StopMovingOrSizing()
			SpeedyLoc:SetPosition(true)
		end
	end)

	local t = 0
	f:SetScript("OnUpdate", function(self, elapsed)
		t = t + elapsed
		if t > 1 then
			if UnitOnTaxi("player") or IsFalling() then
				speed = 0
				f.speedTxt:SetText(format("|cffa0a0a0%+.0f%%", speed))
				f.coordsTxt:SetText(GetPlayerPosition())
				f.dirTxt:SetText(GetFacing())
			else
				speed = GetUnitSpeed("player")
				f.speedTxt:SetText(format("|cffa0a0a0%+.0f%%", (speed / BASE_MOVEMENT_SPEED) * 100))
				f.coordsTxt:SetText(GetPlayerPosition())
				f.dirTxt:SetText(GetFacing())
			end
		end
	end)

	self.frame = f
end

----------------------

function SpeedyLoc:SetPosition(save)
	SpeedyLoc.prtD("SetPosition")

	if (save) then
		local point, _, _, x, y = SpeedyLocFrame:GetPoint()
		db.point, db.posX, db.posY = point, x, y
	else
		SpeedyLocFrame:ClearAllPoints()
		SpeedyLocFrame:SetPoint(db.point, UIParent, db.point, db.posX, db.posY)
	end
end

----------------------

function SpeedyLoc:UpdateLayout()
	SpeedyLoc.prtD("UpdateLayout")
	db = SpeedyLoc.db.profile

	self:SetPosition()

	self.frame:SetWidth(db.width)
	self.frame:SetHeight(db.height)
	self.frame:SetScale(db.scale)
	self.frame:SetClampedToScreen(db.clamped)
	self.frame:SetFrameStrata(db.strata)

	local backdrop = self.frame:GetBackdrop()
	backdrop.bgFile = Media and Media:Fetch(Media.MediaType.BACKGROUND, db.backgroundTexture)
	backdrop.edgeFile = Media and Media:Fetch(Media.MediaType.BORDER, db.borderTexture)
	backdrop.edgeSize = db.borderSize
	backdrop.insets.left = db.borderInset
	backdrop.insets.right = db.borderInset
	backdrop.insets.top =  db.borderInset
	backdrop.insets.bottom = db.borderInset
	self.frame:SetBackdrop(backdrop)

	self.frame:SetBackdropBorderColor(db.borderColor.r, db.borderColor.g, db.borderColor.b, db.borderColor.a)
	self.frame:SetBackdropColor(db.backgroundColor.r, db.backgroundColor.g, db.backgroundColor.b, db.backgroundColor.a)

	local coordsFont = Media and Media:Fetch(Media.MediaType.FONT, db.coords.font) or "Fonts\\FRIZQT__.ttf"
	local coordsFontSize = db.coords.fontSize
	local coordsFontOutline = db.coords.fontOutline
	local coordsFontShadow = db.coords.fontShadow and 1 or 0

	self.frame.coordsTxt:SetFont(coordsFont, coordsFontSize, coordsFontOutline)
	self.frame.coordsTxt:SetShadowOffset(0, 0)
	self.frame.coordsTxt:SetShadowOffset(coordsFontShadow, -coordsFontShadow)
	self.frame.coordsTxt:SetPoint(db.coords.anchor, self.frame, db.coords.posx, db.coords.posy)

	local acc = tonumber(db.coords.accuracy) or 1
	text = texttemplate:format(acc, acc)

	local dirFont = Media and Media:Fetch(Media.MediaType.FONT, db.direction.font) or "Fonts\\FRIZQT__.ttf"
	local dirFontSize = db.direction.fontSize
	local dirFontOutline = db.direction.fontOutline
	local dirFontShadow = db.direction.fontShadow and 1 or 0

	self.frame.dirTxt:SetFont(dirFont, dirFontSize, dirFontOutline)
	self.frame.dirTxt:SetShadowOffset(0, 0)
	self.frame.dirTxt:SetShadowOffset(dirFontShadow, -dirFontShadow)
	self.frame.dirTxt:SetPoint(db.direction.anchor, self.frame, db.direction.posx, db.direction.posy)

	local speedFont = Media and Media:Fetch(Media.MediaType.FONT, db.speed.font) or "Fonts\\FRIZQT__.ttf"
	local speedFontSize = db.speed.fontSize
	local speedFontOutline = db.speed.fontOutline
	local speedFontShadow = db.speed.fontShadow and 1 or 0

	self.frame.speedTxt:SetFont(speedFont, speedFontSize, speedFontOutline)
	self.frame.speedTxt:SetShadowOffset(0, 0)
	self.frame.speedTxt:SetShadowOffset(speedFontShadow, -speedFontShadow)
	self.frame.speedTxt:SetPoint(db.speed.anchor, self.frame, db.speed.posx, db.speed.posy)

	self.frame:Show()
end
