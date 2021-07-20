require "lib.moonloader" -- 
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local version = 1


local update_url = "https://raw.githubusercontent.com/Pattersonsoo/test/main/update.ini" 
local update_path = getWorkingDirectory() .. "/update.ini" 

local script_url = "https://github.com/Pattersonsoo/test/blob/main/anti.lua?raw=true"
local script_path = thisScript().path

function main()
    while true do
        wait(0)
        if isKeyDown(0x72) and not sampIsChatInputActive() and not sampIsDialogActive() then
            sampSendChat('/ot')
			sampSendChat('/ot')
			sampSendChat('/ot')
        end
    end
end


function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- êóäà áóäåò êà÷àòüñÿ íàø ôàéëèê äëÿ ñðàâíåíèÿ âåðñèè
  downloadUrlToFile('https://raw.githubusercontent.com/Pattersonsoo/test/main/update.ini', fpath, function(id, status, p1, p2) -- ññûëêó íà âàø ãèòõàá ãäå åñòü ñòðî÷êè êîòîðûå ÿ ââ¸ë â òåìå èëè ëþáîé äðóãîé ñàéò
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- îòêðûâàåò ôàéë
    if f then
      local info = decodeJson(f:read('*a')) -- ÷èòàåò
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- ïåðåâîäèò âåðñèþ â ÷èñëî
        if version > tonumber(thisScript().version) then -- åñëè âåðñèÿ áîëüøå ÷åì âåðñèÿ óñòàíîâëåííàÿ òî...
          lua_thread.create(goupdate) -- àïäåéò
        else -- åñëè ìåíüøå, òî
          update = false -- íå äà¸ì îáíîâèòüñÿ
          sampAddChatMessage(('[Testing]: Ó âàñ è òàê ïîñëåäíÿÿ âåðñèÿ! Îáíîâëåíèå îòìåíåíî'), color)
        end
      end
    end
  end
end)
end

function goupdate()
sampAddChatMessage(('[Testing]: Îáíàðóæåíî îáíîâëåíèå. AutoReload ìîæåò êîíôëèêòîâàòü. Îáíîâëÿþñü...'), color)
sampAddChatMessage(('[Testing]: Òåêóùàÿ âåðñèÿ: '..thisScript().version..". Íîâàÿ âåðñèÿ: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- êà÷àåò âàø ôàéëèê ñ latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Îáíîâëåíèå çàâåðøåíî!'), color)
  thisScript():reload()
end
end)
end
