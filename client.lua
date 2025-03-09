local onDuty = false
local currentDept = nil
local currentCallsign = nil

RegisterNetEvent("kovz-duty:toggle")
AddEventHandler("kovz-duty:toggle", function(dept, callsign, status)
    onDuty = status
    currentDept = dept
    currentCallsign = callsign

    if onDuty then
        SetBlipSprite(createDutyBlip(), 1)
        TriggerEvent("mythic_notify:client:SendAlert", { type = 'success', text = ('You are now on duty as %s with callsign %s.'):format(dept, callsign), length = 2500 })
    else
        SetBlipSprite(removeDutyBlip())
        TriggerEvent("mythic_notify:client:SendAlert", { type = 'inform', text = ('You are now off duty from %s.'):format(dept), length = 2500 })
    end
end)

function createDutyBlip()
    local blip = AddBlipForEntity(PlayerPedId())
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 38)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    return blip
end

function removeDutyBlip()
    if onDuty then
        RemoveBlip(dutyBlip)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(0, 38) then
            TriggerServerEvent("duty")
        end
    end
end)
