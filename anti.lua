require "lib.moonloader"
local sampev = require 'lib.samp.events'
local spec = false
local inicfg = require 'inicfg'
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'

update_state = false

local script_vers = 1
local script_vers_text = "1.02"

local update_url = "https://raw.githubusercontent.com/Pattersonsoo/test/main/update.ini"
local update_path = getWorkingDirectory().. "/update.ini"

local script_url = "https://github.com/Pattersonsoo/test/blob/main/anti.luac?raw=true"
local script_parh = thisScript().path


function main()
key1_timesPressed = 0

	while true do
	wait(0)
		if isPlayerPlaying(playerHandle) then
				if isKeyDown(0x72) and not sampIsDialogActive() then
					key1_timesPressed = key1_timesPressed + 1
					sampSendChat("/ot")
				wait(10)
			end
		end
	end
end
function main()
    sampRegisterChatCommand("update", cmd_update)

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("���� ����������! ������: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

	end
end