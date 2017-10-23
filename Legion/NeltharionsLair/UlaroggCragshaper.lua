
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ularogg Cragshaper", 1065, 1665)
if not mod then return end
mod:RegisterEnableMob(91004)
mod.engageId = 1791

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.totems = "Totems"
	L.bellow = "{193375} (Totems)" -- Bellow of the Deeps (Totems)
	L.bellow_desc = 193375
	L.bellow_icon = 193375
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		198564, -- Stance of the Mountain
		198496, -- Sunder
		{216290, "ICON"}, -- Strike of the Mountain
		"bellow",
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "StanceOfTheMountain", 198564)
	self:Log("SPELL_CAST_START", "Sunder", 198496)
	self:Log("SPELL_CAST_START", "StrikeOfTheMountain", 216290)
	self:Log("SPELL_CAST_SUCCESS", "StrikeOfTheMountainOver", 216290)
	self:Log("SPELL_CAST_START", "BellowOfTheDeeps", 193375)
	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1")
end

function mod:OnEngage()
	self:Bar(216290, 15) -- Strike of the Mountain
	self:Bar(198564, self:Mythic() and 27 or 36) -- Stance of the Mountain
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:StanceOfTheMountain(args)
	self:Message(args.spellId, "Attention", "Long")
	self:StopBar(198496) -- Sunder
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(216290)
		end
		self:PrimaryIcon(216290, player)
		self:TargetMessage(216290, player, "Important", "Alarm")
	end
	function mod:StrikeOfTheMountain(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID)
		self:Bar(args.spellId, 15) -- pull:15.8, 15.8, 47.3, 26.7, 17.0
	end
	function mod:StrikeOfTheMountainOver(args)
		self:PrimaryIcon(args.spellId)
	end
end

function mod:BellowOfTheDeeps(args)
	self:Message("bellow", "Urgent", "Info", CL.incoming:format(L.totems), args.spellId)
	--self:CDBar(args.spellId, 29) -- pull:20.6, 44.9, 31.5, 31.5
end

function mod:Sunder(args)
	self:Message(args.spellId, "Info", "Alert", CL.casting:format(args.spellName))
	self:CDBar(args.spellId, 9.3)
end

function mod:UNIT_TARGETABLE_CHANGED(unit)
	if UnitCanAttack("player", unit) then
		self:Bar(198564, self:Mythic() and 51 or 97) -- Stance of the Mountain
	end
end
