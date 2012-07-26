-- main.lua

------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight

local bg = display.newGroup()
local hud = display.newGroup()
local radarPos = display.newCircle(10, 10, 5)
local radarScale = 21.9

------------------------------------------------------------------------------

-- BG
for i=1, 5, 1 do
	local img = display.newImageRect(i..".png", 2048, 400)
	img:setReferencePoint(display.TopLeftReferencePoint)
	img.x, img.y = (i-1)*2048, 0 

	bg:insert(img)
end

-- HUD
local radar = display.newImageRect("radar.png", screenW, 20)
radar.x, radar.y = screenW/2, 10
hud:insert(radar)

radarPos:setFillColor(0, 255, 0)
hud:insert(radarPos)

local heart = display.newImageRect("health.png", 32, 32)
heart.x, heart.y = 25, screenH-30
hud:insert(heart)

local healthBar = display.newText("100%", 50, screenH-50, native.systemFontBold, 32)
healthBar:setTextColor(240, 70, 1)
hud:insert(healthBar)

killsCount = display.newText("0 kills", screenW-120, screenH-50, native.systemFontBold, 32)
killsCount:setTextColor(240, 70, 1)
hud:insert(killsCount)
