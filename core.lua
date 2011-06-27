local ADDON_NAME, ns = ...

local LWB_events = {}
local LWB_frame = CreateFrame("Frame")
LWB_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

local PLAYER_NAME = UnitName("player")
local PLAYER_GUID = UnitGUID("player")
local LIGHTWELL_SPELLID = 724
local RENEW_SPELLID = 7001

local message;

local gsub = string.gsub
local SendChatMessgae = SendChatMessage

local LWB_phrases = {
--[[
Format:
  [#] = "Phrase",
  [#] = "Phrase",

Any occurrence of %u in the phrase will be replaced with the Lightwell user's name, any of %p will be replaced with your name.
Put a double dash ( -- ) at the start of a line in this table to "comment" it and stop LWB from using that phrase.
To use the \ (backslash) or | (vertical bar) characters in the phrase, you may need to use \\ or || respectively.
]]

  --Start of table
  [1] = "Thank you for using the Lightwell %u!",
  [2] = "May the Light bless you %u.",
  
  
  --End of table
}

function LWB_events:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, spellId, spellName, spellSchool, ...)

  if event == "SPELL_AURA_APPLIED" and sourceGUID == PLAYER_GUID and spellId == RENEW_SPELLID then
    message = nil --reset the message
    
    repeat --keep trying to pick a random message until we get one
      message = LWB_phrases[random(#LWB_phrases)] or nil
    until message
    
    message = gsub(message, "(%%[pu])", function(arg)
	if arg == "%p" then
	  return PLAYER_NAME
	else
	  return destName
	end
      end)
    SendChatMessgae(message, SAY, nil, nil) --Say the message. DO NOT CHANGE THE message ARGUMENT.
    --[[
    To change how the message is said (e.g. language, channel), visit this page:
      http://www.wowpedia.org/API_SendChatMessage
    ]]
  end
end



LWB_frame:SetScript("OnEvent", function(self, event, ...)
  LWB_events[event](self, ...)
end)