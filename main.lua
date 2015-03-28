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

-- This is used to delay reading in actions (for volume, specifically)
DELAY_PERIOD = 150
delaySince = 0

-- this is used to have a "holding" pause functionality.
paused = false

-- This is used to determine the y position of the user
user_position = 100
current_move = "rest"

function onForegroundWindowChange(app, title)
	-- myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
	if (title == "Mixxx 1.11.0 x64") then
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
			toggleMusic()
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

			-- Checking to see which one to do.
			local new_user_position = myo.getPitch()
			myo.debug("new user pos is: " .. new_user_position)

			local difference = new_user_position - user_position

			-- toggling on high kill
			if (difference > 0.05) then
				myo.keyboard("7", "press") -- left
				myo.keyboard("9", "press") -- right
			-- switch track to the right
			elseif (difference < 0) then
				moveActive = edge == "on"
	            rollReference = getMyoRollDegrees()
	            moveSince = now
	            enabled=true
				-- myo.keyboard("2", "press") -- left
			end

			-- changeFilter()
		elseif (pose == "waveIn") then
			myo.debug("waving in - messing with the track")

			-- Checking to see which one to do.
			local new_user_position = myo.getPitch()
			myo.debug("new user pos is: " .. new_user_position)

			local difference = new_user_position - user_position

			-- switch to the right track
			if (difference > 0.05) then
				myo.keyboard("1", "press") -- left
				myo.keyboard("3", "press") -- right
			-- switch to the left track
			elseif (difference < 0) then
				moveActive = edge == "on"
	            rollReference = getMyoRollDegrees()
	            moveSince = now
	            enabled=true
				-- myo.keyboard("2", "press") -- left
			end

			-- moveActive = edge == "on"
   --          rollReference = getMyoRollDegrees()
   --          moveSince = now
   --          enabled=true
			-- delaySince = now
		elseif (pose == "rest" and paused == true) then
			myo.debug("unpausing the music (if its paused)")
			paused = false
			toggleMusic()
		else
            enabled=false
		end
	end
end

-- function changeFilter()
-- 	local new_user_position = myo.getPitch()
-- 	myo.debug("new user pos is: " .. new_user_position)

-- 	local difference = new_user_position - user_position

-- 	if (difference > 0.05) then
-- 		myo.keyboard("7", "press") -- left
-- 		myo.keyboard("9", "press") -- right
-- 	elseif (difference < -0.05) then
-- 		myo.keyboard("1", "press") -- left
-- 		myo.keyboard("3", "press") -- right
-- 	-- else
-- 	-- 	myo.keyboard("4", "press") -- left
-- 	-- 	myo.keyboard("6", "press") -- right
-- 	end

-- end

function adjustTrack()
	local new_user_position = myo.getPitch()
	myo.debug("new user pos is: " .. new_user_position)

	local difference = new_user_position - user_position

	-- Moving the right track
	if (current_move == "waveIn") then
		myo.keyboard("8", "press")
	-- moving to left track
	elseif (current_move == "waveOut") then
		myo.keyboard("2", "press")
	-- spinning the track
	-- else
	-- 	myo.keyboard("2", "press")
	end

end

-- This toggles ALL music in the application.
function toggleMusic()
	myo.keyboard("y", "press")
	myo.keyboard("u", "press")
end

-- This is for detecting arm rotations
function onPeriodic()  
    local now = myo.getTimeMilliseconds()
    if (myo.isUnlocked()) and enabled then
        local relativeRoll = degreeDiff(getMyoRollDegrees(), rollReference)
        if math.abs(relativeRoll)> ROLL_MOTION_THRESHOLD then
            if now - moveSince > SLOW_MOVE_PERIOD then

            	-- This is for the volume case (fingersSpead)
            	if (current_move == "fingersSpread") then
	                if relativeRoll>0 then
	                	myo.debug("turning uppppppppppppp")
	                    myo.keyboard("equal", "press")
	                else
	                	myo.debug("turning downnnnnnnnnnnnn")
	                    myo.keyboard("minus", "press")
	                end    
	            end

                moveSince = now
            end
        elseif (current_move == "waveIn" or current_move == "waveOut") then
        	myo.keyboard("w", "press")
        	adjustTrack()
        	moveSince = now
        end
    end
end  


