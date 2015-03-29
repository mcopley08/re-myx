scriptId = 'com.thalmic.BaidCopley.Myx-Preset2'
scriptTitle = "Myx Preset 2"
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

-- This is used to delay reading in actions (for volume, specifically)
DELAY_PERIOD = 150
delaySince = 0

-- this is used to have a "holding" pause functionality.
paused = false

-- This is used to determine the y position of the user
user_position = 100
current_move = "rest"

-- Setting the slip to true
myo.keyboard("e", "press")
myo.keyboard("i", "press")

-- This is for adjusting pitch on the grab.
pitch_difference = 0
scratch_enabled = false

function onForegroundWindowChange(app, title)
	-- myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	if (title == "Mixxx 1.11.0 x64") or (title == "Mixxx") then
		myo.debug("its in the djj thanngggg")
		user_position = myo.getPitch()
		myo.debug("user position is: " .. user_position)
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
	if(edge == "on" and ((now - delaySince) > DELAY_PERIOD)) then

		current_move = pose
		myo.debug("onPoseEdge: " .. pose .. ": " .. edge)

		if (pose == "doubleTap")  then
			myo.debug("doubleTap - #djsweg")
			myo.lock()
		elseif (pose == "fist") then
			myo.debug("fist - #djsweg pausing muzik")
			paused = true
			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
		elseif (pose == "fingersSpread") then
			-- local roll = myo.getRoll()
			-- myo.debug("roll is: " .. roll)

			-- Getting the time so that we can delay reading again for 1 second.
			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
			delaySince = now
		elseif (pose == "waveOut") then
			myo.debug("waving out - doing an effect")

			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true

		elseif (pose == "waveIn") then
			myo.debug("waving in - messing with the track")

			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true

		elseif (pose == "rest" and paused == true) then
			myo.debug("unpausing the music (if its paused)")
			paused = false

			for i = 0, pitch_difference, 1 do
				myo.keyboard("z", "press")
	            myo.keyboard("n", "press")
			end

			pitch_difference = 0
			
		elseif (pose == "rest" and scratch_enabled == true) then
			myo.debug("taking the scratch offfffff!")
			scratch_enabled = false

			myo.keyboard("comma", "up")
			myo.keyboard("c", "up")
		else
            enabled=false
		end
	end
end

function adjustScratch()

	scratch_enabled = true
	myo.keyboard("c", "down")

	myo.keyboard("comma", "down")

end

function adjustScratchTemp()

	myo.keyboard("c", "press")

	myo.keyboard("comma", "press")

end

-- This toggles ALL music in the application.
function toggleFade()
	myo.keyboard("1", "press")
    myo.keyboard("3", "press")
end

-- This is for detecting arm rotations
function onPeriodic()  
    local now = myo.getTimeMilliseconds()
    if (myo.isUnlocked()) and enabled then
        local relativeRoll = degreeDiff(getMyoRollDegrees(), rollReference)

        if (current_move == "waveOut") then
        	adjustScratch()
        	moveSince = now

        elseif (current_move == "waveIn") then
        	adjustScratchTemp()
        	moveSince = now

        elseif (current_move == "fist") then

        	-- This prevents it from counting it if its at the minimum.
        	if (pitch_difference < 19) then
        		pitch_difference = pitch_difference + 1
        	end

        	toggleFade()
        end
    end
end  


