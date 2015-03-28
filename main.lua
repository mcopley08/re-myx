scriptId = 'com.thalmic.examples.myfirstscript'
scriptTitle = "SpartaHack - DJ Sparta"
scriptDetailsUrl = ""

myo.setLockingPolicy("standard")
falcon_check = false
charge_check = false
waveOut_check = false
character = 'm'

-- This is more code for our rotation detection
ROLL_MOTION_THRESHOLD = 7 -- degrees  
SLOW_MOVE_PERIOD = 20  
rollReference=0  
moveSince=0  
enabled=false 

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
	enabled=false
end

function getMyoRollDegrees()  
    local RollValue = math.deg(myo.getRoll())
    return RollValue
end  

function degreeDiff(value, base)  
    local diff = value - base

    if diff > 180 then
        diff = diff - 360
    elseif diff < -180 then
        diff = diff + 360
    end

    return diff
end  

-- This function recognizes the movement from the armband and does the appropriate motions.
function onPoseEdge(pose, edge)

	-- logging when the pose was done
	local now = myo.getTimeMilliseconds()

    -- if we've toggled it to accept input, this handles it.
	if(edge == "on") then
		myo.debug("onPoseEdge: " .. pose .. ": " .. edge)

		if (pose == "doubleTap")  then
			myo.debug("doubleTap - #djsweg")
			myo.lock()
		elseif (pose == "fist") then
			myo.debug("fist - #djsweg")
			toggleMusic()
		elseif (pose == "fingersSpread") then
			-- local roll = myo.getRoll()
			-- myo.debug("roll is: " .. roll)
			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
            myo.debug("does it happen before?")
		else
            enabled=false

		end
	end
end

function toggleMusic()
	myo.keyboard("d", "press")
end

-- This is for detecting arm rotations
function onPeriodic()  
    local now = myo.getTimeMilliseconds()
    if (myo.isUnlocked()) and enabled then
        local relativeRoll = degreeDiff(getMyoRollDegrees(), rollReference)
        if math.abs(relativeRoll)> ROLL_MOTION_THRESHOLD then
            if now - moveSince > SLOW_MOVE_PERIOD then
                if relativeRoll>0 then
                	myo.debug("turning uppppppppppppp")
                    myo.keyboard("equal", "press")
                else
                	myo.debug("turning downnnnnnnnnnnnn")
                    myo.keyboard("minus", "press")
                end    
                moveSince = now
            end
        end
    end
end  


