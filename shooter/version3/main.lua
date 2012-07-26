-- main.lua

------------------------------------------------------------------------------
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight

local bg = display.newGroup()
local hud = display.newGroup()
local radarPos = display.newCircle(10, 10, 5)
local radarScale = 21.9

local moveDirectionX, moveDirectionY, moveTimer
local maxShiftX = 5*2048 - screenW  -- 5 images with 2048 width
local maxShiftY = 80
local moveDx, moveDy = 20, 3

------------------------------------------------------------------------------

-- Move by tapping --
local function moveHandler(e)
	-- X axis
	if moveDirectionX > 0 then
		if bg.x > -maxShiftX then
			bg.x = bg.x-moveDx
		else
			bg.x = -maxShiftX
		end
	elseif moveDirectionX < 0 then
		if bg.x < 0 then
			bg.x = bg.x+moveDx
		else
			bg.x = 0
		end
	end
	
	radarPos.x = 10 - bg.x / radarScale

	-- Y axis
	if moveDirectionY > 0 then
		if bg.y > -maxShiftY then
			bg.y = bg.y-moveDy
		else
			bg.y = -maxShiftY
		end
	else
		if bg.y < 0 then
			bg.y = bg.y+moveDy
		else
			bg.y = 0
		end
	end
end

local function moveBg(e)
	if e.x > screenW*3/4 then
		moveDirectionX = 1
	elseif e.x < screenW/4 then
		moveDirectionX = -1
	else
		moveDirectionX = 0
	end
	
	if e.y > screenH/2 then
		moveDirectionY = 1
	else
		moveDirectionY = -1
	end
	
	if e.phase == "began" then
		moveTimer = timer.performWithDelay(30, moveHandler, 0)
	elseif e.phase == "ended" or e.phase == "canceled" then
		timer.cancel(moveTimer)
		moveTimer = nil
	end
	
	return true
end

------------------------------------------------------------------------------

-- BG
for i=1, 5, 1 do
	local img = display.newImageRect(i..".png", 2048, 400)
	img:setReferencePoint(display.TopLeftReferencePoint)
	img.x, img.y = (i-1)*2048, 0 

	img:addEventListener('touch', moveBg)

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

------------------------------------------------------------------------------

function addTerorist(e)
	-- create new terorist
	local t = display.newImageRect("terorist1.png", 320, 400)
	t:scale(0.5, 0.5)
	t.x = 100 + math.random()*10000
	t.y = 300
	bg:insert(t)
	
	-- point on radar
	local radarT = display.newCircle(10 + t.x/radarScale, 10, 5)
	radarT:setFillColor(255, 0, 0)
	hud:insert(radarT)
	t.radar = radarT
end

-- Terorists generator
timer.performWithDelay(1000, addTerorist, 0)
