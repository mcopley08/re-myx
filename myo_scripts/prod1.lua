scriptId = 'com.thalmic.BaidCopley.Myx-Prod1'
scriptTitle = "Myx - Prod 1"
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
pitch_difference = 0
pose_avail = true
pitch_up = false

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

	-- if we haven't finished our last action, dont do a new one
	-- if (pose_avail == false) then
	-- 	return
	-- end

    -- if we've toggled it to accept input, this handles it.
	if(edge == "on" and ((now - delaySince) > DELAY_PERIOD)) then

		current_move = pose
		myo.debug("onPoseEdge: " .. pose .. ": " .. edge)

		if (pose == "doubleTap")  then
			myo.debug("doubleTap - #djsweg")
			pose_avail = false
			myo.keyboard("k", "press")
			myo.keyboard("d", "press")

			myo.lock()
		elseif (pose == "fist") then
			myo.debug("fist - #lowers pitch temporarily")
			pose_avail = false

			-- Checking to see which one to do.
			local new_user_position = myo.getPitch()
			myo.debug("new user pos is: " .. new_user_position)

			local difference = new_user_position - user_position

			if (difference > 0.2) then
				pitch_up = true
			elseif (difference < 0) then
				pitch_up = false
			end


			paused = true
			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
		elseif (pose == "fingersSpread") then
			pose_avail = false

			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
			delaySince = now
		elseif (pose == "waveOut") then
			myo.debug("waving out - doing an effect")
			pose_avail = false

			-- Checking to see which one to do.
			local new_user_position = myo.getPitch()
			myo.debug("new user pos is: " .. new_user_position)

			local difference = new_user_position - user_position

			-- toggling on high kill
			if (difference > -0.15) then
				myo.keyboard("7", "press") -- left
				myo.keyboard("9", "press") -- right
			-- switch track to the right
			elseif (difference < -0.2) then
				moveActive = edge == "on"
	            rollReference = getMyoRollDegrees()
	            moveSince = now
	            enabled=true
			end

		elseif (pose == "waveIn") then
			myo.debug("waving in - messing with the track")
			pose_avail = false

			-- Checking to see which one to do.
			local new_user_position = myo.getPitch()
			myo.debug("new user pos is: " .. new_user_position)

			local difference = new_user_position - user_position

			-- switch to the right track
			if (difference > -0.15) then
				myo.keyboard("1", "press") -- left
				myo.keyboard("3", "press") -- right
			-- switch to the left track
			elseif (difference < -0.2) then
				moveActive = edge == "on"
	            rollReference = getMyoRollDegrees()
	            moveSince = now
	            enabled=true
			end

		elseif (pose == "rest" and paused == true) then
			myo.debug("unpausing the music (if its paused)")
			paused = false

			if (pitch_up == false) then
				for i = 0, pitch_difference, 1 do
					myo.keyboard("f4", "press")
		            myo.keyboard("f8", "press")
				end
			else
				for i = 0, pitch_difference, 1 do
					myo.keyboard("f3", "press")
		            myo.keyboard("f7", "press")
				end
			end

			pitch_difference = 0
			pose_avail = true
			myo.lock()
		elseif (pose == "rest") then
			myo.lock()
			pose_avail = true
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

-- This brings down the pitch of both tracks a little bit.
function togglePitch()
	if (pitch_up == false) then
		myo.keyboard("f3", "press")
    	myo.keyboard("f7", "press")
    else
    	myo.keyboard("f4", "press")
	    myo.keyboard("f8", "press")
    end
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
        elseif (current_move == "fist") then
        	-- This prevents it from counting it if its at the minimum.
        	if (pitch_difference < 19) then
        		pitch_difference = pitch_difference + 1
        	end

        	moveSince = now

        	-- have a 'set' variable that tells us its already going in one direction or the other
        	-- so we don't mix going up & down at the same gesture
        	togglePitch()
        end
    end
end  


