Config = require("config")

RegisterCommand("duty", function(source, args, rawCommand)
    local src = source
    local currentTime = os.time()

    if #args == 0 then
        if Config.PlayerDutyStatus[src] then
            local dutyData = Config.PlayerDutyStatus[src]
            local dept = dutyData.dept
            local clockInTime = dutyData.startTime
            local dutyTime = math.floor((currentTime - clockInTime) / 60)

            Config.PlayerDutyStatus[src] = nil
            TriggerClientEvent("kovz-duty:toggle", src, dept, false)

            exports['mythic_notify']:SendAlert(src, 'inform', ('You are now off duty from %s. Time on duty: %d minutes.'):format(dept, dutyTime))
            print(("Player %s is now OFF duty from %s after %d minutes."):format(GetPlayerName(src), dept, dutyTime))
        else
            exports['mythic_notify']:SendAlert(src, 'error', 'You are not currently on duty.')
        end
        return
    end

    if #args < 2 then
        exports['mythic_notify']:SendAlert(src, 'error', 'Usage: /duty <dept> <callsign>')
        return
    end

    local dept = args[1]:lower()
    local callsign = args[2]

    if Config.Departments[dept] then
        local perm = Config.Departments[dept]

        if IsPlayerAceAllowed(src, perm) then
            Config.PlayerDutyStatus[src] = { dept = dept, callsign = callsign, startTime = currentTime }
            TriggerClientEvent("kovz-duty:toggle", src, dept, callsign)

            exports['mythic_notify']:SendAlert(src, 'success', ('You are now on duty as %s with callsign %s.'):format(dept, callsign))
            print(("Player %s is now ON duty in %s with callsign %s"):format(GetPlayerName(src), dept, callsign))
        else
            exports['mythic_notify']:SendAlert(src, 'error', 'You do not have permission to join this department.')
        end
    else
        exports['mythic_notify']:SendAlert(src, 'error', 'Invalid department.')
    end
end, false)
