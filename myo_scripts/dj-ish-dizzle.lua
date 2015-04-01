scriptId = 'com.thalmic.Baid_Copley.Myx'
scriptTitle = "Myx - Ish"
scriptDetailsUrl = ""

myo.setLockingPolicy("standard")

-- This is more code for our rotation detection
ROLL_MOTION_THRESHOLD = 7 -- degrees  
SLOW_MOVE_PERIOD = 20  
rollReference=0  
moveSince=0  
enabled=false 

-- This is used to delay reading in actions (for volume, specifically)
DELAY_PERIOD = 150
delaySince = 0

fistCount = 0


-- this is used to have a "holding" pause functionality.
paused = false

-- This is used to determine the y position of the user
user_position = 100
current_move = "rest"

-- Setting the slip to true
myo.keyboard("e", "press")
myo.keyboard("i", "press")

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

		if(current_move == "rest" or current_move == "fist") then
			if(current_move == "fist") then
				myo.debug("Fist: "..fistCount)
				fistCount = fistCount + 1
			end
			if(fistCount == 2) then
				myo.debug("Triple press")
				fistCount = 0
				thriplePress()
			end
		end


		--if not fist, duration for fist has ended
		if (pose == "doubleTap")  then
			myo.debug("doubleTap - #djsweg")
			myo.lock()
		elseif (pose == "fist") then
			fist()
		elseif (pose == "fingersSpread") then

			-- Getting the time so that we can delay reading again for 1 second.
			moveActive = edge == "on"
            rollReference = getMyoRollDegrees()
            moveSince = now
            enabled=true
			delaySince = now
		elseif (pose == "waveOut") then
			myo.debug("waving out - doing an effect")
			volumeUp()
			
		elseif (pose == "waveIn") then
			myo.debug("waving in - messing with the track")
			volumeDown()
			
		elseif (pose == "rest" and paused == true) then
			myo.debug("unpausing the music (if its paused)")
			paused = false

		else
            enabled=false
		end
	end
end


function fist()

	myo.debug("fist")
end

function thriplePress()

	--kill mid
	myo.keyboard("6", "press")
	myo.keyboard("4", "press")

	--kill high
	myo.keyboard("9", "press")
	myo.keyboard("7", "press")

end

function volumeUp()
	--increase volume
	for var = 0, 10, 1 do
			myo.keyboard("equal", "press")
	end
	
end

function volumeDown()
	
	--decrease volume
	for var = 0, 10, 1 do				
		myo.keyboard("minus", "press")
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
	                	myo.debug("Increasing bass")
	                    myo.keyboard("x", "press")
	                    myo.keyboard("m", "press")
	                else
	                	myo.debug("Lowering bass")
	                    myo.keyboard("z", "press")
	                    myo.keyboard("n", "press")
	                end  
	                moveSince = now  
	            end
            end
    	end
	end
end