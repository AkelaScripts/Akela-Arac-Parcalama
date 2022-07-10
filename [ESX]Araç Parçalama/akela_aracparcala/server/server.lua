ESX               = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('akela_aracparcala:basla')
AddEventHandler('akela_aracparcala:basla', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('akela_aracparcala:pdbildir',source)
end)

RegisterServerEvent('akela_aracparcala:parcala')
AddEventHandler('akela_aracparcala:parcala', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canSwapItem('aracparcalari', 0, 'aracparcalari', 1) then 
		xPlayer.addInventoryItem('aracparcalari', 1)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Araç parçaları söküldü.'})
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Daha fazla taşıyamazsın!'})
	end
end)

RegisterNetEvent("akela_aracparcala:sat")
AddEventHandler("akela_aracparcala:sat", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getInventoryItem('aracparcalari').count > 0 then
                local money = Config.Prize
                local count = xPlayer.getInventoryItem('aracparcalari').count
                xPlayer.removeInventoryItem('aracparcalari', count)
                dclog(xPlayer, '** '..count.. ' adet araç parçası satışı yaptı ' ..money * count.. ' $ dolar karapara kazandı**')				
                xPlayer.addInventoryItem('black_money', money*count)
            elseif xPlayer.getInventoryItem('aracparcalari').count < 1 then
                xPlayer.showNotification("Üstünde Gerekli Eşyalar Yok!!")
        end
    end
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
  
    local discord_webhook = "https://discord.com/api/webhooks/980933131899134012/Fmx5F3lelVuUhDUS-v2BsCirenGDmERgqZw0KiDktnHrOrpJIZfexLIlUfrgB5PydWx8"
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = "Moon Logger - Araç Parçası Satış",
      ["avatar_url"] = "https://i.hizliresim.com/9jnonmu.png",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName .. ' - ' .. xPlayer.identifier
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end