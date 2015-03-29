scriptId = 'com.thalmic.Baid_Copley.Myx-Visuals'
scriptTitle = "Myx Visuals"
scriptDetailsUrl = ""

myo.setLockingPolicy("standard")

current_move = "rest"
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
	if (title == "Vovoid VSXu Player 0.5.0 [Windows 64-bit]") then
		myo.debug("In visual application")
		return true
	else
		return false
	end
end

function onUnlock()
	myo.unlock("hold")
	enabled=false
end

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
			myo.debug("fist")
			paused = true
            enabled=true
		elseif (pose == "fingersSpread") then
			myo.debug("")
		elseif (pose == "waveOut") then
			myo.debug("waving out")
			myo.keyboard("right_arrow", "press")
            enabled=true
		elseif (pose == "waveIn") then
			myo.debug("waving in")
			myo.keyboard("left_arrow", "press")
            enabled=true
		else
            enabled=false
		end
	end
end


function explode()

	for var = 0, 10, 1 do
		myo.keyboard("space", "press")
	end

end

