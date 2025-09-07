-- Receive update from a client & sync to everyone else
RegisterNetEvent("fd_turnsignals:update", function(netVeh,left,right,hazard)
    local src = source
    TriggerClientEvent("fd_turnsignals:sync", -1, netVeh, left, right, hazard)
end)
