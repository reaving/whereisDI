-- Setup

require('luau')
packets = require('packets')
config = require('config')
--res = require 'resources'

_addon.name = 'WhereIsDI'
_addon.author = 'Wunjo'
_addon.commands = {'WhereIsDI'}
_addon.version = '1.0.0.2'

lastDImsg = 'DI: location not set yet'
lastDIdt = os.time()
countMessages = 0

function getTimeSince()
    -- local timeSince
    local secondsSince = os.difftime(os.time(),lastDIdt)
    local minutesSince = math.floor(secondsSince/60)
    
    if secondsSince < 60 then
        return secondsSince..' seconds ago'
    elseif minutesSince == 1 then
        return 'about '..minutesSince..' minute ago'
    else
        return 'about '..minutesSince..' minutes ago'
    end
end

-- Source: Windower4\res\chat.lua
-- mode: 3=tell, 4=party, 5=LS, 33=unity
windower.register_event('chat message', function(message,sender,mode,gm)
    
    if mode == 33 then
        -- Unity chat messages
        setDI(message)
    elseif mode == 5 or mode == 4 or mode == 3 then
        -- LS Chat messages
        local lowermsg = string.lower(message)
        -- local reqsender = string.lower(sender)
        
        if mode == 5 then
            if string.sub(lowermsg,1,3) == '!di' then
                windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
            end
            if lowermsg:contains('where') and (lowermsg:contains(' di') or lowermsg:contains('di ')) then
                windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
            end
            if lowermsg:contains('where') and lowermsg:contains('domain') then
                windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
            end
        end
    -- elseif mode == 4 and reqsender == 'wunjo' then
        -- -- Only Wunjo is allowed in party chat for testing purposes.
    end
    log(mode..':'..message)
end)

textMessage = {
-- 0x00000120 = HEX for EschaZitah (288)
-- ,0000002c,00000120,0000048a,0000fc2b, = 'We've defeated 1162 monsters in a row, for a total of 64555 monsters defeated'
[',0000002e,00000120,00000000,0000000a,'] = {zone="Escha - Zi\'Tah",text="10 minute message"},
[',0000002d,00000120,00000000,00000000,'] = {zone="Escha - Zi\'Tah",text="monsters appeared"},
[',0000002f,00000120,00000000,00000000,'] = {zone="Escha - Zi\'Tah",text="Azi Dahaka appeared"},
[',00000031,00000120,00000000,00000000,'] = {zone="Escha - Zi\'Tah",text="Azi Dahaka defeated"},
[',0000002f,00000120,00000000,00000003,'] = {zone="Escha - Zi\'Tah",text="Mireu appeared"},
[',00000031,00000120,00000000,00000003,'] = {zone="Escha - Zi\'Tah",text="Mireu defeated"},
[',00000032,00000120,00000000,00000003,'] = {zone="Escha - Zi\'Tah",text="Mireu left"},
-- 0x00000120 = HEX for EschaRuAun (289)
[',0000002e,00000121,00000001,0000000a,'] = {zone="Escha - Ru\'Aun",text="10 minute message"},
[',0000002d,00000121,00000001,00000001,'] = {zone="Escha - Ru\'Aun",text="monsters appeared"},
[',0000002f,00000121,00000001,00000001,'] = {zone="Escha - Ru\'Aun",text="Naga Raja appeared"},
[',00000031,00000121,00000001,00000001,'] = {zone="Escha - Ru\'Aun",text="Naga Raja defeated"},
[',0000002f,00000121,00000001,00000003,'] = {zone="Escha - Ru\'Aun",text="Mireu appeared"},
[',00000031,00000121,00000001,00000003,'] = {zone="Escha - Ru\'Aun",text="Mireu defeated"},
[',00000032,00000121,00000001,00000003,'] = {zone="Escha - Ru\'Aun",text="Mireu left"},
-- 0x00000120 = HEX for Reisenjima (291)
[',0000002e,00000123,00000002,0000000a,'] = {zone="Reisenjima",text="10 minute message"},
[',0000002d,00000123,00000002,00000002,'] = {zone="Reisenjima",text="monsters appeared"},
[',0000002f,00000123,00000002,00000002,'] = {zone="Reisenjima",text="Quetzalcoatl appeared"},
[',00000031,00000123,00000002,00000002,'] = {zone="Reisenjima",text="Quetzalcoatl defeated"},
[',0000002f,00000123,00000002,00000003,'] = {zone="Reisenjima",text="Mireu appeared"},
[',00000031,00000123,00000002,00000003,'] = {zone="Reisenjima",text="Mireu defeated"},
[',00000032,00000123,00000002,00000003,'] = {zone="Reisenjima",text="Mireu left"},
}

function setDI(message)
    -- Unity messages from Unity NPCs are not text strings, they are coded messages to your FFXI client.
    -- Just match the coded message to determine their meaning.
    
    if string.sub(message,1,3) == '0a,' then
        local submessage = string.sub(message,17,53)
        
        if textMessage[submessage] then
            log(message)
            -- We found the message in the DI messages dictionary.
            countMessages = countMessages + 1
            
            -- os.time() reference: https://www.lua.org/pil/22.1.html
            lastDIdt = os.time()
            lastDImsg = textMessage[submessage]['zone']..', '..textMessage[submessage]['text']..'('..os.date("%b%d %H:%M")..')'
            log(lastDImsg..' '..countMessages)
            
            if textMessage[submessage]['text'] == 'Mireu appeared' then
                windower.chat.input:schedule(1, '/l '..lastDImsg..'[just now]')
                windower.chat.input:schedule(6, '/l '..lastDImsg..'[5 seconds ago]')
                windower.chat.input:schedule(11,'/l '..lastDImsg..'[10 seconds ago]')
                windower.chat.input:schedule(21,'/l '..lastDImsg..'[20 seconds ago]')
                windower.chat.input:schedule(31,'/l '..lastDImsg..'[30 seconds ago]')
                windower.chat.input:schedule(61,'/l '..lastDImsg..'[one minute ago]')
                windower.chat.input:schedule(91,'/l '..lastDImsg..'[one minute and 30 seconds ago]')
                windower.chat.input:schedule(121,'/l '..lastDImsg..'[two minutes ago]')
                windower.chat.input:schedule(151,'/l '..lastDImsg..'[two minutes and 30 seconds ago]')
                windower.chat.input:schedule(181,'/l '..lastDImsg..'[three minutes ago]')
            end
        else
            -- Not found in the DI messages dictionary.
            log(message)
        end -- if textMessage[submessage] then
    else
        -- Not found in the DI messages dictionary.
        log(message)
    end -- if string.sub(message,1,3) == '0a,' then
end
