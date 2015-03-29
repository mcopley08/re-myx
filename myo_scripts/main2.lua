scriptId = 'com.thalmic.Baid_Copley.Myx'
scriptTitle = "Myx"
scriptDetailsUrl = ""

myo.setLockingPolicy("standard")

center = 0

-- This is used to delay reading in actions (for volume, specifically)
DELAY_PERIOD = 150
delaySince = 0

--keeps track of current movement
current_move = "rest"


local BINDINGS = {
    -- fist_on          = startShooting,
    -- fist_off         = stopShooting,
 
    -- fingersSpread_on = activateSuperpower,
 
    -- waveOut_on       = mouseOff,
    -- waveOut_off      = mouseOn,
    
    doubleTap_on     = myo.lock
}

function onForegroundWindowChange(app, title)
	-- myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	if (title == "Mixxx") then
		myo.debug("Mixxx is on")
		return true
	else
		return false
	end
end

function onUnlock()
	myo.debug("Unlocked")
	myo.unlock("hold")
end

function onLock()
	myo.debug("Locked")
end

-- This function recognizes the movement from the armband and does the appropriate motions.
function onPoseEdge(pose, edge)

	local now = myo.getTimeMilliseconds()
    -- if we've toggled it to accept input, this handles it.
	if (edge == "on" and ((now - delaySince) > DELAY_PERIOD)) then

		delaySince = now
		current_move = pose
		if (pose == "doubleTap")  then
			myo.debug("double Tap")
			myo.lock()
			myo.debug("Locked")
		elseif (pose == "fist") then
			myo.debug("fist")
			centre()
		elseif (pose == "fingersSpread") then
			escape()
		end
	end
end

function onPeriodic()

	local now = myo.getTimeMilliseconds()
	if(myo.isUnlocked() and (now - delaySince) > DELAY_PERIOD) then

		myo.debug("onPeriodic")
	end

end


function toggleMusic()
	myo.debugg("Pausing music")
	myo.keyboard("d", "press")
end

function centre()  
    center = myo.getYaw()
    myo.debug("Centered"..center)
    myo.vibrate("short")    
end

function escape()  
    center = 0
    myo.debug("Escape: "..center)
end  