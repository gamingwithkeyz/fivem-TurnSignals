-- CONFIG
local keyLeft  = 174 -- Left Arrow
local keyRight = 175 -- Right Arrow
local keyHazard = 173 -- Down Arrow
local indicatorSpeedLimit = 50.0 -- auto turn-off speed threshold (optional)

local signalState = {
    left = false,
    right = false,
    hazard = false
}

-- Toggle helper
local function setSignals(vehicle, left, right)
    SetVehicleIndicatorLights(vehicle, 1, left)  -- Left
    SetVehicleIndicatorLights(vehicle, 0, right) -- Right
end

-- Reset all signals
local function resetSignals(vehicle)
    signalState.left = false
    signalState.right = false
    signalState.hazard = false
    setSignals(vehicle, false, false)
end

-- Main thread
CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            sleep = 0
            local veh = GetVehiclePedIsIn(ped, false)

            -- Left blinker
            if IsControlJustPressed(0, keyLeft) then
                if signalState.left then
                    resetSignals(veh)
                else
                    signalState.left = true
                    signalState.right = false
                    signalState.hazard = false
                    setSignals(veh, true, false)
                end
            end

            -- Right blinker
            if IsControlJustPressed(0, keyRight) then
                if signalState.right then
                    resetSignals(veh)
                else
                    signalState.right = true
                    signalState.left = false
                    signalState.hazard = false
                    setSignals(veh, false, true)
                end
            end

            -- Hazard lights (both)
            if IsControlJustPressed(0, keyHazard) then
                if signalState.hazard then
                    resetSignals(veh)
                else
                    signalState.hazard = true
                    signalState.left = false
                    signalState.right = false
                    setSignals(veh, true, true)
                end
            end

            -- Auto turn-off at higher speed (optional)
            if (signalState.left or signalState.right) and GetEntitySpeed(veh) * 3.6 > indicatorSpeedLimit then
                resetSignals(veh)
            end
        else
            signalState = { left=false, right=false, hazard=false }
        end
        Wait(sleep)
    end
end)
