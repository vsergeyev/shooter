-- main.lua

------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight

local moveDirectionX, moveDirectionY, moveTimer
local maxShiftX = 5*2048 - screenW/2  -- 5 images with 2048 width
local maxShiftY = 80
local moveDx, moveDy = 20, 3

local bg = display.newGroup()
local hud = display.newGroup()

------------------------------------------------------------------------------

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
local heart = display.newImageRect("health.png", 48, 48)
heart.x, heart.y = 25, screenH-30
hud:insert(heart)

local healthBar = display.newText("100%", 50, screenH-50, native.systemFontBold, 32)
healthBar:setTextColor(0, 255, 0)
hud:insert(healthBar)

local cr = display.newImageRect("crosshair.png", 48, 48)
cr.x, cr.y = screenW/2, screenH/2
hud:insert(cr)
