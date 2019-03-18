--[[	Config	]]--

local format = string.format
local wipe = table.wipe

----------------------

local InCombatLockdown = InCombatLockdown

----------------------

local SpeedyLoc = LibStub("AceAddon-3.0"):GetAddon("SpeedyLoc")

local L = LibStub("AceLocale-3.0"):GetLocale("SpeedyLoc")
local Media = LibStub("LibSharedMedia-3.0")

----------------------

local options = nil
local function getOptions()
	SpeedyLoc.prtD("getOptions")

	if not options then
		options = {
			type = "group",
			name = "SpeedyLoc",
			args = {
				info = {
					order = 1, type = "group", inline = true,
					name = L["Info"],
					args = {
						version = {
							order = 1, type = "description", fontSize = "medium",
							width = "half",
							name = format("%s %.1f", L["Version:"], SpeedyLocDB.version),
						},
						reset = {
							order = 2, type = "execute", func = function() wipe(SpeedyLocDB); ReloadUI() end, confirm = true,
							width = "half",
							name = "Reset",
							desc = format("|cffff0000%s", L["This will wipe all settings and reload the user interface."]),
						},
					},
				},
				frame = {
					order = 2, type = "group",
					name = L["Layout Frame"],
					get = function(info)
						local key = info[#info]
						local v = SpeedyLoc.db.profile[key]

						return v
					end,
					set = function(info, v)
						local key = info[#info]
						SpeedyLoc.db.profile[key] = v
					end,
					args = {
						bar = {
							order = 1, type = "group", inline = true,
							name = L["Bar"],
							args = {
								locked = {
									order = 1, type = "toggle",
									width = "full",
									name = L["Bar Lock"],
									desc = L["Lock/unlock the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.locked = v
										SpeedyLoc:SetPosition(true)
									end,
								},
								clamped = {
									order = 2, type = "toggle",
									width = "full",
									name = L["Clamped To Screen"],
									desc = L["Set whether the layout frame is restricted to the screen."],
									set = function(info, v)
										SpeedyLoc.db.profile.clamped = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								strata = {
									order = 3, type = "select", values = {
																			BACKGROUND = L["BACKGROUND"],
																			LOW = L["LOW"],
																			MEDIUM = L["MEDIUM"],
																			HIGH = L["HIGH"],
																			DIALOG = L["DIALOG"],
																			FULLSCREEN = L["FULLSCREEN"],
																			FULLSCREEN_DIALOG = L["FULLSCREEN_DIALOG"],
																			TOOLTIP = L["TOOLTIP"],
									},
									name = L["Bar Strata"],
									desc = L["Set the strata level of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.strata = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								width = {
									order = 4, type = "range", min = 10, max = 600, step = 1,
									width = "full",
									name = L["Width"],
									desc = L["Adjust the width of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.width = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								height = {
									order = 5, type = "range", min = 10, max = 200, step = 1,
									width = "full",
									name = L["Height"],
									desc = L["Adjust the height of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.height = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								scale = {
									order = 6, type = "range", min = 0.1, max = 2.0, step = 0.05,
									width = "full",
									name = L["Scale"],
									desc = L["Adjust the scale of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.scale = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
					},
				},
				layout = {
					order = 3, type = "group",
					name = L["Layout Background"],
					get = function(info)
						local key = info[#info]
						local v = SpeedyLoc.db.profile[key]
						if (type(v) == "table" and v.r and v.g and v.b) then
							return v.r, v.g, v.b, v.a
						else
							return v
						end
					end,
					set = function(info, v)
						local key = info[#info]
						SpeedyLoc.db.profile[key] = v
					end,
					args = {
						background = {
							order = 1, type = "group", inline = true,
							name = L["Background"],
							args = {
								backgroundColor = {
									order = 1, type = "color", hasAlpha = true,
									name = L["Background Color"],
									desc = L["Set the background color of the layout frame."],
									set = function(info, r, g, b, a)
										local color = SpeedyLoc.db.profile.backgroundColor
										color.r, color.g, color.b, color.a = r, g, b, a
										SpeedyLoc:UpdateLayout()
									end,
								},
								backgroundTexture = {
									order = 2, type = "select",
									name = L["Background Texture"],
									desc = L["Set the background texture of the layout frame."],
									dialogControl = "LSM30_Background",
									values = Media:HashTable("background"),
									set = function(info, v)
										SpeedyLoc.db.profile.backgroundTexture = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
						border = {
							order = 2, type = "group", inline = true,
							name = L["Border"],
							args = {
								borderColor = {
									order = 1, type = "color", hasAlpha = true,
									name = L["Border Color"],
									desc = L["Set the border color of the layout frame."],
									set = function(info, r, g, b, a)
										local color = SpeedyLoc.db.profile.borderColor
										color.r, color.g, color.b, color.a = r, g, b, a
										SpeedyLoc:UpdateLayout()
									end,
								},
								borderTexture = {
									order = 2, type = "select",
									name = L["Border Texture"],
									desc = L["Set the border texture of the layout frame."],
									dialogControl = "LSM30_Border",
									values = Media:HashTable("border"),
									set = function(info, v)
										SpeedyLoc.db.profile.borderTexture = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								borderSize = {
									order = 3, type = "range", min = 1, max = 64, step = 1,
									width = "full",
									name = L["Border Size"],
									desc = L["Set the border size of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.borderSize = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								borderInset = {
									order = 4, type = "range", min = 0, max = 32, step = 1,
									width = "full",
									name = L["Border Inset"],
									desc = L["Set the border inset of the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.borderInset = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
					},
				},
				coords = {
					order = 4, type = "group",
					name = L["Coordinates"],
					get = function(info)
						local key = info[#info]
						local v = SpeedyLoc.db.profile.coords[key]

						return v
					end,
					set = function(info, v)
						local key = info[#info]
						SpeedyLoc.db.profile.coords[key] = v
					end,
					args = {
						coordsfont = {
							order = 1, type = "group", inline = true,
							name = L["Font"],
							args = {
								font = {
									order = 1, type = "select",
									dialogControl = "LSM30_Font",
									values = Media:HashTable("font"),
									name = L["Bar Coords Font"],
									desc = L["Set the bar coords font for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.font = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontSize = {
									order = 2, type = "range", min = 4, max = 32, step = 1,
									name = L["Bar Coords Font Size"],
									desc = L["Set the bar coords font size for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.fontSize = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontOutline = {
									order = 3, type = "select", values = {
																			NONE = L["NONE"],
																			OUTLINE = L["OUTLINE"],
																			THICKOUTLINE = L["THICKOUTLINE"],
									},
									name = L["Bar Coords Font Outline"],
									desc = L["Set the bar coords font outline for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.fontOutline = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontShadow = {
									order = 4, type = "toggle",
									width = "full",
									name = L["Bar Coords Font Shadow"],
									desc = L["Use shadow for the layout frame coords text."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.fontShadow = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},					
						position = {
							name = L["Position"], type = "group", inline = true,
							order = 2,
							args = {
								anchor = {
									order = 1, type = "select", values = {
																			LEFT = L["LEFT"],
																			CENTER = L["CENTER"],
																			RIGHT = L["RIGHT"],
									},
									name = L["Coords Anchor"],
									desc = L["Set the anchor point of coords text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.anchor = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posx = {
									order = 2, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Coords X Offset"],
									desc = L["Set the horizontal position of the coords text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.posx = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posy = {
									order = 3, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Coords Y Offset"],
									desc = L["Set the vertical position of the coords text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.posy = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
						opts = {
							name = L["Options"], type = "group", inline = true,
							order = 3,
							args = {
								accuracy = {
									order = 1, type = "range", min = 0, max = 2, step = 1,
									name = L["Coordinates Accuracy"],
									desc = L["Control the accuracy of the coordinates."],
									set = function(info, v)
										SpeedyLoc.db.profile.coords.accuracy = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
					},
				},
				direction = {
					order = 5, type = "group",
					name = L["Direction"],
					get = function(info)
						local key = info[#info]
						local v = SpeedyLoc.db.profile.direction[key]

						return v
					end,
					set = function(info, v)
						local key = info[#info]
						SpeedyLoc.db.profile.direction[key] = v
					end,
					args = {
						dirfont = {
							order = 1, type = "group", inline = true,
							name = L["Font"],
							args = {
								font = {
									order = 1, type = "select",
									dialogControl = "LSM30_Font",
									values = Media:HashTable("font"),
									name = L["Bar Direction Font"],
									desc = L["Set the bar direction font for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.font = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontSize = {
									order = 2, type = "range", min = 4, max = 32, step = 1,
									name = L["Bar Direction Font Size"],
									desc = L["Set the bar direction font size for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.fontSize = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontOutline = {
									order = 3, type = "select", values = {
																			NONE = L["NONE"],
																			OUTLINE = L["OUTLINE"],
																			THICKOUTLINE = L["THICKOUTLINE"],
									},
									name = L["Bar Direction Font Outline"],
									desc = L["Set the bar direction font outline for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.fontOutline = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontShadow = {
									order = 4, type = "toggle",
									width = "full",
									name = L["Bar Direction Font Shadow"],
									desc = L["Use shadow for the layout frame direction text."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.fontShadow = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},	
						position = {
							name = L["Position"], type = "group", inline = true,
							order = 2,
							args = {
								anchor = {
									order = 1, type = "select", values = {
																			LEFT = L["LEFT"],
																			CENTER = L["CENTER"],
																			RIGHT = L["RIGHT"],
									},
									name = L["Direction Anchor"],
									desc = L["Set the anchor point of direction text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.anchor = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posx = {
									order = 2, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Direction X Offset"],
									desc = L["Set the horizontal position of the direction text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.posx = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posy = {
									order = 3, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Direction Y Offset"],
									desc = L["Set the vertical position of the direction text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.direction.posy = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
					},
				},
				speed = {
					order = 6, type = "group",
					name = L["Speed"],
					get = function(info)
						local key = info[#info]
						local v = SpeedyLoc.db.profile.speed[key]

						return v
					end,
					set = function(info, v)
						local key = info[#info]
						SpeedyLoc.db.profile.speed[key] = v
					end,
					args = {
						speedfont = {
							order = 1, type = "group", inline = true,
							name = L["Font"],
							args = {
								font = {
									order = 1, type = "select",
									name = L["Bar Speed Font"],
									desc = L["Set the bar speed font for the layout frame text."],
									dialogControl = "LSM30_Font",
									values = Media:HashTable("font"),
									set = function(info, v)
										SpeedyLoc.db.profile.speed.font = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontSize = {
									order = 2,
									type = "range", min = 4, max = 32, step = 1,
									name = L["Bar Speed Font Size"],
									desc = L["Set the bar speed font size for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.fontSize = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontOutline = {
									order = 3, type = "select", values = {
																			NONE = L["NONE"],
																			OUTLINE = L["OUTLINE"],
																			THICKOUTLINE = L["THICKOUTLINE"],
									},
									name = L["Bar Speed Font Outline"],
									desc = L["Set the bar speed font outline for the layout frame text."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.fontOutline = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								fontShadow = {
									order = 4, type = "toggle",
									width = "full",
									name = L["Bar Speed Font Shadow"],
									desc = L["Use shadow for the layout frame speed text."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.fontShadow = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
						position = {
							name = L["Position"], type = "group", inline = true,
							order = 2,
							args = {
								anchor = {
									order = 1, type = "select", values = {
																			LEFT = L["LEFT"],
																			CENTER = L["CENTER"],
																			RIGHT = L["RIGHT"],
									},
									name = L["Speed Anchor"],
									desc = L["Set the anchor point of speed text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.anchor = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posx = {
									order = 2, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Speed X Offset"],
									desc = L["Set the horizontal position of the speed text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.posx = v
										SpeedyLoc:UpdateLayout()
									end,
								},
								posy = {
									order = 3, type = "range", min = -100, max = 100, step = 1,
									width = "full",
									name = L["Speed Y Offset"],
									desc = L["Set the vertical position of the speed text on the layout frame."],
									set = function(info, v)
										SpeedyLoc.db.profile.speed.posy = v
										SpeedyLoc:UpdateLayout()
									end,
								},
							},
						},
					},
				},
			},
		}
	end
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(SpeedyLoc.db)

	return options
end

function SpeedyLoc:SetupOptions()
	SpeedyLoc.prtD("Setup Options")

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SpeedyLoc", getOptions)

	local function OpenOptions()
		SpeedyLoc.prtD("Open Options")

		if (not InCombatLockdown()) then
			LibStub("AceConfigDialog-3.0"):SetDefaultSize("SpeedyLoc", 675, 505)
			LibStub("AceConfigDialog-3.0"):Open("SpeedyLoc")
		else
			SpeedyLoc.prtError(L["Cannot open options while in combat."])
			LibStub("AceConfigDialog-3.0"):Close("SpeedyLoc")
		end
	end

	LibStub("AceConsole-3.0"):RegisterChatCommand("speedyloc", OpenOptions)
end
