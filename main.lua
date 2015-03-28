scriptId = 'com.thalmic.examples.myfirstscript'
scriptTitle = "SpartaHack - DJ Sparta"
scriptDetailsUrl = ""

myo.setLockingPolicy("standard")
falcon_check = false
charge_check = false
waveOut_check = false
character = 'm'

-- This is more code for our toggle functionality
-- myo.setLockingPolicy("none")
-- lockState = false

-- These are our primary bindings, mainly used
-- to have the doubleTap just toggle whether
-- were accepting myo inputs.
local BINDINGS = {
    -- fist_on          = startShooting,
    -- fist_off         = stopShooting,
 
    -- fingersSpread_on = activateSuperpower,
 
    -- waveOut_on       = mouseOff,
    -- waveOut_off      = mouseOn,
    
    doubleTap_on     = myo.lock
}

function onForegroundWindowChange(app, title)
	myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	if (title == "Mixxx 1.11.0 x64") then
		myo.debug("its in the djj thanngggg")
		return true
	else
		return false
	end
end

function onUnlock()
	myo.unlock("hold")
end

-- This function recognizes the movement from the armband and does the appropriate motions.
function onPoseEdge(pose, edge)

	-- if (pose ~= "rest" and pose ~= "unknown") then
 --        -- hold if edge is on, timed if edge is off
 --        myo.unlock("hold")
 --    end

    -- if we've toggled it to accept input, this handles it.
	if(edge == "on") then
		myo.debug("onPoseEdge: " .. pose .. ": " .. edge)
		if (pose == "doubleTap")  then
			myo.debug("doubleTap - #djsweg")
			myo.lock()
		elseif (pose == "fist") then
			myo.debug("fist - #djsweg")
			toggleMusic()
		-- elseif ((charachter = 'f') and (falcon_check == false) and (pose == "fingersSpread")) then
		-- 	Falcon()
		-- elseif ((falcon_check) and (pose == "fist")) then
		-- 	Punch()
		-- elseif ((charachter = 'f') and (falcon_check == false) and (pose == "fist")) then
		-- 	Yes()
		-- elseif ((charachter = 'f') and (falcon_check == false) and (pose == "waveIn")) then
		-- 	ComeOn()
			
			
		-- elseif ((charachter = 'm') and (pose == "fist")) then
		-- 	Jump()
		-- elseif ((charachter = 'm') and (pose == "waveIn")) then
		-- 	Grow()
		-- elseif ((charachter = 'm') and (pose == "fingersSpread")) then
		-- 	Fire()
		
		
		-- elseif ((charachter = 'r') and (charge_check == false) and (pose == "fist")) then
		-- 	Charge()
		-- elseif ((charge_check) and (pose == "fingersSpread")) then
		-- 	Thoron()
		-- elseif ((charachter = 'r') and (charge_check == false) and (pose == "fingersSpread")) then
		-- 	ArcFire()	
		-- elseif ((charachter = 'r') and (charge_check == false) and (pose == "waveIn")) then
		-- 	Nosferatu()	
		end
	end
end

function toggleMusic()
	myo.keyboard("d", "press")
end

-- function onWaveOut()
-- 	if (charachter = 'm') then 
-- 		charachter = 'f'
-- 		myo.keyboard("f","down")
-- 		myo.debug("f")
-- 	elseif (charachter = 'f') then
-- 		charachter = 'r'
-- 		myo.keyboard("r","down")
-- 		myo.debug("r")
-- 	else
-- 		charachter = 'm'
-- 		myo.keyboard("m","down")
-- 		myo.debug("m")
-- 	end
-- 	waveOut_check = false
-- end

-- function Falcon()
-- 	falcon_check = true
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("none")
-- 	myo.debug("1")
-- 	myo.vibrate("short")
-- 	myo.keyboard("1","press")
-- end

-- function Punch()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("2")
-- 	myo.vibrate("short")
-- 	myo.keyboard("2","down")
-- 	falcon_check = false
-- end

-- function Yes()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("3")
-- 	myo.vibrate("short")
-- 	myo.keyboard("3","down")
-- end

-- function ComeOn()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("4")
-- 	myo.vibrate("short")
-- 	myo.keyboard("4","down")
-- end

-- function Jump()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("5")
-- 	myo.vibrate("short")
-- 	myo.keyboard("5","down")
-- end

-- function Grow()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("6")
-- 	myo.vibrate("short")
-- 	myo.keyboard("6","down")
-- end

-- function Fire()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("7")
-- 	myo.vibrate("short")
-- 	myo.keyboard("7","down")
-- end

-- function Charge()
-- 	waveOut_check = false
-- 	charge_check = true
-- 	myo.setLockingPolicy("none")
-- 	myo.debug("8")
-- 	myo.vibrate("short")
-- 	myo.keyboard("8","down")	
-- end

-- function Thoron()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("9")
-- 	myo.vibrate("short")
-- 	myo.keyboard("9","down")
-- 	charge_check = false
-- end

-- function ArcFire()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("0")
-- 	myo.vibrate("short")
-- 	myo.keyboard("0","down")
-- end

-- function Nosferatu()
-- 	waveOut_check = false
-- 	myo.setLockingPolicy("standard")
-- 	myo.debug("minus")
-- 	myo.vibrate("short")
-- 	myo.keyboard("minus","down")
-- end