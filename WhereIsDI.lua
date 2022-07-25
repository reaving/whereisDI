-- Include Windower libraries.
require('luau')
config = require('config')

-- Addon Author and Version Information
_addon.name = 'WhereIsDI'
_addon.author = 'Wunjo'
_addon.commands = {'WhereIsDI'}
_addon.version = '1.0.1.6'

-- Default Values
lastDImsg = 'DI: location not set yet'
lastDIdt = os.time()

-- Set up the Mireu information file.
defaults = {}
Mireu = config.load('mireu.xml',defaults)

-- 1. This only works with Jakoh's unity.  If you choose another unity, then you will 
--    need to change the specific messages.  
-- 2. I use 'incoming text' instead of 'chat message' since 'chat message' is unreliable.
-- 3. Underscore as a parameter means that I don't need that parameter.

-- This event fires every time you can a chat message.
-- Parameters -------------------------------
-- "text" = is the chat message itself
-- "mode" = chat type (Reference https://github.com/Windower/Lua/wiki/Game-ID-Reference#chat-mode-ids)
windower.register_event('incoming text', function(_, text, mode, _, blocked)
    -- If text is blocked or empty, then leave.
    if blocked or text == '' then return end
    if mode == 207 then return end
    -- if not unity chat mode, then leave.
    if mode ~= 212 then return end
    -- If this unity message is not from Jakoh, then leave.
    if not string.startswith(text,"{Jakoh Wahcondalo}") then return end
    
    local zoneDI = ""
    local dragonDI = ""
    local stepDI = ""
    
    -- Are any of the Domain Invasion zones mentioned in the unity NPC's chat?
    if string.contains(text,"Escha - Zi\'Tah")  then zoneDI = "Escha - Zi\'Tah" end
    if string.contains(text,"Escha - Ru\'Aun")  then zoneDI = "Escha - Ru\'Aun" end
    if string.contains(text,"Reisenjima")       then zoneDI = "Reisenjima" end
    -- If the zone name is still blank, then leave.
    if zoneDI == "" then return end
    
    -- Are any of the Domain Invasion dragons mentioned?
    if string.contains(text,"Azi Dahaka")   then dragonDI = "Azi Dahaka" end
    if string.contains(text,"Naga Raja")    then dragonDI = "Naga Raja" end
    if string.contains(text,"Quetzalcoatl") then dragonDI = "Quetzalcoatl" end
    if string.contains(text,"???")          then dragonDI = "Mireu" end
    -- If the dragon name is still blank, then leave.
    if dragonDI == "" then return end
    
    -- Is this one of the recognized Domain Invasion messages?
    if string.contains(text,"One of our young seers says")  then stepDI = "10 minute message" end
    if string.contains(text,"Looks like a prelude to the")  then stepDI = "monsters appeared" end
    if string.contains(text,"Help us brrring the fight t")  then stepDI = dragonDI.." appeared" end
    if string.contains(text,"You Opo-opo-headed numbskul")  then stepDI = dragonDI.." left" end
    if string.contains(text,"You kittens arrren't so wea")  then stepDI = dragonDI.." defeated" end
    -- If the message step is still blank, then leave.
    -- This is to ensure that the message actually was related to Domain Invasion.
    if stepDI == "" then return end
    
    -- If we're still here, then we'll assume that this is a valid Domain Invasion message.
    
    -- Save the current time-stamp of the latest DI message.
    -- This will allow us to figure out how long ago the last message occurred.
    -- os.time() reference: https://www.lua.org/pil/22.1.html
    lastDIdt = os.time()
    -- Arrange the message with a time-stamp.  This will be in whatever
    -- timezone the alt is in so maybe it's not that useful.
    lastDImsg = zoneDI..', '..stepDI..' ('..os.date("%b%d %H:%M",lastDIdt)..')'
    -- Send the message to the alt's display only so you know it worked.
    log(lastDImsg)
    
    -- If it's Mireu, alert the LS!
    if stepDI == "Mireu appeared" then
        
        -- Fire off LS Spam.
        -- LS#1 = '/l',  LS#2 = '/l2'
        
        -- Comment in/out what you need or don't need.
        
        windower.chat.input:schedule(001,   '/l '..lastDImsg..'[just now]')
        --windower.chat.input:schedule(003,   '/l2 '..lastDImsg..'[just now]')
        windower.chat.input:schedule(006,   '/l '..lastDImsg..'[5 seconds ago]')
        --windower.chat.input:schedule(008,   '/l2 '..lastDImsg..'[5 seconds ago]')
        windower.chat.input:schedule(011,   '/l '..lastDImsg..'[10 seconds ago]')
        --windower.chat.input:schedule(013,   '/l2 '..lastDImsg..'[10 seconds ago]')
        
        windower.chat.input:schedule(16,'/yell '..zoneDI..', '..stepDI)
        windower.chat.input:schedule(021,   '/l '..lastDImsg..'[20 seconds ago]')
        --windower.chat.input:schedule(023,   '/l2 '..lastDImsg..'[20 seconds ago]')
        
        windower.chat.input:schedule(26,'/shout '..zoneDI..', '..stepDI)
        windower.chat.input:schedule(031,   '/l '..lastDImsg..'[30 seconds ago]')
        --windower.chat.input:schedule(033,   '/l2 '..lastDImsg..'[30 seconds ago]')
        windower.chat.input:schedule(061,   '/l '..lastDImsg..'[one minute ago]')
        --windower.chat.input:schedule(063,   '/l2 '..lastDImsg..'[one minute ago]')
        
        windower.chat.input:schedule(76,'/yell '..zoneDI..', '..stepDI)
        windower.chat.input:schedule(091,   '/l '..lastDImsg..'[one minute and 30 seconds ago]')
        --windower.chat.input:schedule(093,   '/l2 '..lastDImsg..'[one minute and 30 seconds ago]')
        windower.chat.input:schedule(121,   '/l '..lastDImsg..'[two minutes ago]')
        --windower.chat.input:schedule(123,   '/l2 '..lastDImsg..'[two minutes ago]')
        windower.chat.input:schedule(151,   '/l '..lastDImsg..'[two minutes and 30 seconds ago]')
        --windower.chat.input:schedule(153,   '/l2 '..lastDImsg..'[two minutes and 30 seconds ago]')
        
        windower.chat.input:schedule(161,'/yell '..zoneDI..', '..stepDI..' -- try not to get warped out!')
        windower.chat.input:schedule(181,   '/l '..lastDImsg..'[three minutes ago] Last Notice')
        --windower.chat.input:schedule(183,   '/l2 '..lastDImsg..'[three minutes ago] Last Notice')
        
    elseif stepDI == "Mireu left" then
        -- Record the time when Mireu left (undefeated).
        Mireu['lastdefeated'] = GetNow()
        config.save(Mireu,'all')
        
    elseif stepDI == "Mireu defeated" then
        -- Record the time when Mireu was defeated.
        Mireu['lastdefeated'] = GetNow()
        config.save(Mireu,'all')
        
    end -- if stepDI == "Mireu appeared" then
    
end)

function getTimeSince()
    -- How many seconds have passed since the last stored DI message?
    local secondsSince = os.difftime(os.time(),lastDIdt)
    -- Get that in minutes.
    local minutesSince = math.floor(secondsSince/60)
    
    if secondsSince < 60 then                                               -- Less than one minute ago
        return secondsSince..' seconds ago'
    elseif minutesSince == 1 then                                           -- Between one and two minutes
        return 'about one minute ago'
    elseif minutesSince <= 10 then                                          -- Less than 10 minutes
        return 'about '..minutesSince..' minutes ago'
    elseif string.contains(lastDImsg,'Mireu') and minutesSince <= 60 then   -- Mireu takes more than ten minutes.
        return 'about '..minutesSince..' minutes ago'
    else                                                                    -- This add-on might have stopped working.
        return '**this stopped working about '..minutesSince..' minutes ago** check if we are in a BC area'
    end
end

function getNextWindow()
    
    local nowDateTime = os.time()
    local textTimeSince = ""
    
    -- Get the "last defeated" date/time
    local lastWindowClosed = Mireu['lastdefeated']
    -- Break the human-readable stored text [yyyy-mm-dd hh:mm:ss] into the constituent parts.
    local runyear, runmonth, runday, runhour, runminute, runseconds = lastWindowClosed:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
    -- Re-assemble those parts into a date/time variable type and add 5 days after.
    -- FYI: Will be an hour off if it crosses Daylight Savings Time.
    local nextWindowOpen = os.time({year=runyear, month=runmonth, day=runday, hour=runhour, min=runminute, sec=runseconds}) + 86400*5
    
    -- How many seconds have passed since the last stored DI message?
    local secondsSince = os.difftime(nextWindowOpen,nowDateTime)
    -- Are we still waiting for the window to open?
    local waitingForWindow = (secondsSince > 0)
    -- Use absolute value to clear the +/- flag.
    secondsSince = math.abs(secondsSince)
    
    -- Get the difference in sec/min/hour/days
    local displaySeconds    = math.floor(secondsSince % 60)
    local displayMinutes    = math.floor((secondsSince % 3600)/60)
    local displayHours      = math.floor((secondsSince % 86400)/3600)
    local displayDays       = math.floor(secondsSince/86400)
    -- Create some text to explain the time difference.
    if displayMinutes >= 1 then
        if textTimeSince ~= '' then textTimeSince = ', '..textTimeSince end
        textTimeSince = displayMinutes..' min'..textTimeSince
    end
    if displayHours >= 1 then
        if textTimeSince ~= '' then textTimeSince = ', '..textTimeSince end
        textTimeSince = displayHours..' hr'..textTimeSince
    end
    if displayDays >= 1 then
        if textTimeSince ~= '' then textTimeSince = ', '..textTimeSince end
        textTimeSince = displayDays..' dy'..textTimeSince
    end
    
    -- Change the message depending on whether we're still waiting for the 
    -- window to open or if it has already opened.
    if waitingForWindow then
        textTimeSince = "Mireu window opens "..textTimeSince.." from now."
    else
        textTimeSince = "Mireu window has been open for "..textTimeSince.."."
    end
    
    return textTimeSince
end

-- Source: Windower4\res\chat.lua
-- mode: 3=tell, 4=party, 5=LS#1, 27=LS#2, 33=unity
windower.register_event('chat message', function(message,sender,mode,gm)
    
    message = trim12(string.lower(message))
    
    -- Comment in/out what you need or don't need.
    if mode == 5 then                                                          -- linkshell #1
        if message:startswith('!di') or message:startswith('#di') then
            -- Someone types "!di" in LS chat
            windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
        elseif message:contains('where') and (message:contains(' di') or message:contains('di ')) then
            -- Someone asks "where is di" in LS chat
            windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
        elseif message:contains('where') and message:contains('domain') then
            -- Someone asks "where is domain invasion" in LS chat
            windower.chat.input:schedule(1,'/l '..lastDImsg..'['..getTimeSince()..']')
        elseif message:contains('!mireu') or message:contains('#mireu') then
            -- Asking for Mireu window
            windower.chat.input:schedule(1,'/l '..getNextWindow())
        end
    end
    -- if mode == 27 then                                                          -- linkshell #2
        -- if message:startswith('!di') or message:startswith('#di') then
            -- -- Someone types "!di" in LS chat
            -- windower.chat.input:schedule(1,'/l2 '..lastDImsg..'['..getTimeSince()..']')
        -- elseif message:contains('where') and (message:contains(' di') or message:contains('di ')) then
            -- -- Someone asks "where is di" in LS chat
            -- windower.chat.input:schedule(1,'/l2 '..lastDImsg..'['..getTimeSince()..']')
        -- elseif message:contains('where') and message:contains('domain') then
            -- -- Someone asks "where is domain invasion" in LS chat
            -- windower.chat.input:schedule(1,'/l2 '..lastDImsg..'['..getTimeSince()..']')
        -- elseif message:contains('!mireu') or message:contains('#mireu') then
            -- -- Asking for Mireu window
            -- windower.chat.input:schedule(1,'/l2 '..getNextWindow())
        -- end
    -- end
end)

function GetNow()
    -- os.date will get the system's date/time information
    -- See Also: https://www.lua.org/pil/22.1.html
    local Now = os.date("*t")
    
    -- Separate the date/time information out into its parts so that we can format it.
    local dtYear, dtMonth,  dtDay    = Now.year, Now.month, Now.day
    local dtHour, dtMinute, dtSecond = Now.hour, Now.min,   Now.sec
    
    -- return the formatted date/time string (yyyy-mm-dd hh:mm:ss)
    -- See Also: https://www.lua.org/pil/20.html
    return string.format("%04d-%02d-%02d %02d:%02d:%02d", dtYear, dtMonth, dtDay, dtHour, dtMinute, dtSecond)
end

function trim12(s)
   local from = s:match"^%s*()"
   return from > #s and "" or s:match(".*%S", from)
end

