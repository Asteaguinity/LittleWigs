﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Pandemonius"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Pandemonius",

	shell = "Dark Shell",
	shell_desc = "Warn when Dark Shell is cast",
	shell_trigger = "gains Dark Shell",
	shell_alert = "Dark Shell!",
} end )

L:RegisterTranslations("koKR", function() return {
	shell = "암흑의 보호막 알림",
	shell_desc = "암흑의 보호막 시전 시 알립니다.",
	shell_trigger = "암흑의 보호막 효과를 얻었습니다.", -- check
	shell_alert = "암흑의 보호막!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.partyContent = true
mod.otherMenu = "Auchindoun"
mod.zonename = AceLibrary("Babble-Zone-2.2")["Mana-Tombs"]
mod.enabletrigger = boss 
mod.toggleoptions = {"shell", "bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if self.db.profile.shell and msg == L["shell_trigger1"] then
		self:Message(L["shell_alert1"], "Attention")
	end
end
