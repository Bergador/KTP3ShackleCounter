local ShackleCounterEnabled = true;

local ShackleCounter = CreateFrame("Frame");
ShackleCounter.numShackled = 0;
ShackleCounter:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
ShackleCounter:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
ShackleCounter:SetScript("OnEvent", function()
	local event = event;
	if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
		if arg1 ~= nil then
			if arg1 == "Guardian of Icecrown is afflicted by Shackle Undead." then
				this.numShackled = this.numShackled+1;
				if IsRaidLeader() ~= nil or IsRaidOfficer() ~= nil then
					SendChatMessage(string.format(">>> %d/3 SHACKLES UP <<<", this.numShackled), "RAID_WARNING")
				else
					UIErrorsFrame:AddMessage(string.format(">>> %d/3 SHACKLES UP <<<", this.numShackled), 1.0, 1.0, 0.0, 53, 5)
				end
			end
		end
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
		if arg1 ~= nil then
			if arg1 == "Shackle Undead fades from Guardian of Icecrown." then
				this.numShackled = math.max(0,this.numShackled-1);
				if IsRaidLeader() ~= nil or IsRaidOfficer() ~= nil then
					SendChatMessage(string.format(">>> SHACKLE BROKE - %d/3 SHACKLES UP <<<", this.numShackled), "RAID_WARNING")
				else
					UIErrorsFrame:AddMessage(string.format(">>> %d/3 SHACKLES UP <<<", this.numShackled), 1.0, 1.0, 0.0, 53, 5)
				end
			end
		end
	end
end);

SLASH_KTSHACKLE1 = "/ktshackle";
SlashCmdList.KTSHACKLE = function (str)
	if ShackleCounterEnabled then
		ShackleCounterEnabled = false;
		ShackleCounter:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
		ShackleCounter:UnregisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
		DEFAULT_CHAT_FRAME:AddMessage("KTShackle disabled.");
	else
		ShackleCounterEnabled = true;
		ShackleCounter:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE");
		ShackleCounter:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER");
		DEFAULT_CHAT_FRAME:AddMessage("KTShackle enabled.");
	end
end;