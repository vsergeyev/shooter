-- main.lua

------------------------------------------------------------------------------
local Particles = require("lib_particle_candy")

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local screenW, screenH = display.contentWidth, display.contentHeight

local moveDirectionX, moveDirectionY, moveTimer
local maxShiftX = 5*2048 - screenW  -- 5 images with 2048 width
local maxShiftY = 80
local moveDx, moveDy = 20, 3
local killsCount -- text for displaying statistics
local killed = 0

local bg = display.newGroup()
local hud = display.newGroup()
local radarPos
local radarScale = 21.9

------------------------------------------------------------------------------

function killWithBlood(e)
		Particles.GetEmitter("E1").rotation = math.random()*360;
		Particles.GetEmitter("E1").x = e.x - bg.x
		Particles.GetEmitter("E1").y = e.y - bg.y
		Particles.StartEmitter("E1", true)

		killed = killed + 1
		killsCount.text = killed.." kills"

		e.target.radar:removeSelf()
		e.target:removeSelf()

		return true
end

function addTerorist(e)
	-- create new terorist
	local i = math.random(2)
	local t = display.newImageRect("terorist"..i..".png", 320, 400)
	t:scale(0.5, 0.5)
	t.x = 100 + math.random()*10000
	t.y = 300
	bg:insert(t)
	
	-- point on radar
	local radarT = display.newCircle(10 + t.x/radarScale, 10, 5)
	radarT:setFillColor(255, 0, 0)
	hud:insert(radarT)
	t.radar = radarT

	t:addEventListener("tap", killWithBlood)
end

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

local radarPos = display.newCircle(10, 10, 5)
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

-- local cr = display.newImageRect("crosshair.png", 48, 48)
-- cr.x, cr.y = screenW/2, screenH/2
-- hud:insert(cr)

-- Blood
local em = Particles.CreateEmitter("E1", screenW*0.5, screenH*0.5, 0, false, false)

Particles.CreateParticleType ("BigSplat", 
	{
	imagePath          = "splat.png",
	imageWidth         = 128,
	imageHeight        = 128,
	velocityStart      = 0,	
	alphaStart         = 1,	
	fadeInSpeed        = 0,	
	fadeOutSpeed       = -0.2,
	fadeOutDelay       = 2000,
	scaleStart         = 0.1,
	scaleVariation     = 0,
	scaleInSpeed       = 10,
	scaleMax           = 1.5,
	rotationVariation  = 360,
	rotationChange     = 0,
	weight             = 0.001,	
	bounceX            = false, 
	bounceY            = false, 
	bounciness         = 0.75,
	emissionShape      = 0,
	emissionRadius     = 140,
	killOutsideScreen  = false,	
	lifeTime           = 8000, 
	autoOrientation    = false,	
	useEmitterRotation = false,	
	blendMode          = "normal", 
	colorChange        = {-30,-70,-70},
	} )

Particles.CreateParticleType ("SmallSplats", 
	{
	imagePath          = "splat1.png",
	imageWidth         = 128,
	imageHeight        = 128, 
	velocityStart      = -300,
	velocityChange     = -7,
	alphaStart         = 1,	
	fadeInSpeed        = 0,	
	fadeOutSpeed       = -0.2,
	fadeOutDelay       = 2000,
	scaleStart         = 0.1,
	scaleVariation     = 2.0,
	scaleInSpeed       = 10,
	scaleMax           = 1.5,
	faceEmitter        = true,
	weight             = 0.01,	
	bounceX            = false, 
	bounceY            = false, 
	bounciness         = 0.75,
	emissionShape      = 2,
	emissionRadius     = 50,
	killOutsideScreen  = false,	
	lifeTime           = 8000, 
	autoOrientation    = false,	
	useEmitterRotation = true,
	rotationVariation  = 360, -- 10
	directionVariation = 1,
	blendMode          = "normal", 
	colorChange        = {-30,-70,-70},
	} )


Particles.AttachParticleType("E1", "BigSplat", 1, 9999,0) 
Particles.AttachParticleType("E1", "SmallSplats", 5, 9999,0) 

local Snd_Shot = audio.loadSound("shot.wav");
Particles.SetEmitterSound("E1", Snd_Shot, 0, false, { channel = 0, loops = 0 } )

bg:insert(Particles.GetEmitter("E1"))

-- Terorists generator
timer.performWithDelay(1000, addTerorist, 0)

----------------------------------------------------------------
-- MAIN LOOP
----------------------------------------------------------------
local function main( event )
	-- UPDATE PARTICLES
	Particles.Update()
end

Runtime:addEventListener( "enterFrame", main )


function accelerometerHandler(e)
	if e.yGravity < 0 then
		if bg.x > -maxShiftX then
			bg.x = bg.x+100*e.yGravity
		else
			bg.x = -maxShiftX
		end
	elseif e.yGravity > 0 then
		if bg.x < 0 then
			bg.x = bg.x+100*e.yGravity
		else
			bg.x = 0
		end
	end

	if e.xGravity < 0 then
		if bg.y > -maxShiftY then
			bg.y = bg.y+50*e.xGravity
		else
			bg.y = -maxShiftY
		end
	elseif e.xGravity > 0 then
		if bg.y < 0 then
			bg.y = bg.y+50*e.xGravity
		else
			bg.y = 0
		end
	end

	radarPos.x = 10 - bg.x / radarScale

	return true
end

Runtime:addEventListener("accelerometer", accelerometerHandler)