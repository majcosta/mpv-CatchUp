-- run every [timerFrequency] seconds
-- target having at most [playtimeTarget] second(s) buffered
-- increment speed by [speedUpIncrement] for each full second over [playtimeTarget] we're at
-- [speed] - keeps track of what we last set speed to
local timerFrequency, playtimeTarget, speedUpIncrement, speed = 1, 1, 0.05, 1

function AdjustSpeed(newSpeed)
    if speed ~= newSpeed then
        mp.set_property_number("speed", newSpeed)
    end
    return newSpeed
end

function CatchUp()
    if mp.get_property_bool("core-idle") then
        return
    end

    local playtimeRemaining = mp.get_property_number("time-remaining")
    local secondsBehind = math.floor(playtimeRemaining - playtimeTarget)

    if secondsBehind <= playtimeTarget then
        -- we're on target
        speed = AdjustSpeed(1)
    else
        -- we're late, decide by how much to adjust speed
        speed = AdjustSpeed(1 + (secondsBehind * speedUpIncrement))
        mp.msg.debug(string.format("~%d seconds late, adjusting speed to %.2f", secondsBehind, speed))
    end
end

TimerObj = mp.add_periodic_timer(timerFrequency, CatchUp)
