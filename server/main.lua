-- dps-bucketfix
--
-- wasabi_spawn's escrowed client puts players into routing bucket 1 during spawn
-- selection and never returns them to 0. Consequences observed:
--   * qbx_core applies SetRoutingBucketEntityLockdownMode to bucket 0 only, so
--     entity lockdown was protecting nobody.
--   * dps-trains skips any player whose bucket differs from the train's (0), so
--     no player was ever a valid creation candidate and no train ever spawned.
--
-- We cannot patch the escrowed caller, so correct it server-side. Only bucket 1
-- is touched; qs-housing uses random buckets (1..100000) for interiors and those
-- are left alone, as is any deliberate instancing.

local STUCK_BUCKET = 1
local TARGET_BUCKET = 0

local function correct(src, why)
    if GetPlayerRoutingBucket(src) ~= STUCK_BUCKET then return false end
    SetPlayerRoutingBucket(src, TARGET_BUCKET)
    print(('[bucketfix] %s (%s) moved from bucket %d -> %d (%s)')
        :format(GetPlayerName(src) or '?', tostring(src), STUCK_BUCKET, TARGET_BUCKET, why))
    return true
end

AddEventHandler('playerSpawned', function()
    local src = source
    CreateThread(function()
        Wait(5000)
        correct(src, 'playerSpawned')
    end)
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local src = source
    CreateThread(function()
        Wait(5000)
        correct(src, 'OnPlayerLoaded')
    end)
end)

-- Safety net: anyone left in the stuck bucket gets corrected. A house interior
-- never uses bucket 1 unless a house is explicitly configured with id 1.
CreateThread(function()
    while true do
        Wait(15000)
        for _, src in ipairs(GetPlayers()) do
            correct(tonumber(src), 'sweep')
        end
    end
end)

RegisterCommand('bucketcheck', function(source)
    if source ~= 0 then return end
    for _, src in ipairs(GetPlayers()) do
        src = tonumber(src)
        print(('[bucketfix] %s (%s) bucket=%d')
            :format(GetPlayerName(src) or '?', tostring(src), GetPlayerRoutingBucket(src)))
    end
end, true)
