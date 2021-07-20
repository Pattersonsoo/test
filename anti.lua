require "lib.moonloader" -- 
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 1
local script_vers_text = "1.00"

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
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://raw.githubusercontent.com/Pattersonsoo/test/main/update.ini', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться
          sampAddChatMessage(('[Testing]: У вас и так последняя версия! Обновление отменено'), color)
        end
      end
    end
  end
end)
end

function goupdate()
sampAddChatMessage(('[Testing]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...'), color)
sampAddChatMessage(('[Testing]: Текущая версия: '..thisScript().version..". Новая версия: "..version), color)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
  sampAddChatMessage(('[Testing]: Обновление завершено!'), color)
  thisScript():reload()
end
end)
end