--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Medical:TemporaryStatusEffects("light_bleeding", {
	name = "#status_effects_light_bleeding_title",
	icon = "asterion/academy/ui/health/tremor_2.png",
	description = "#status_effects_light_bleeding_desc",
	values = {
		[1] = {
			description = "#status_effects_light_bleeding_val1",
			type = Medical.types.number,
			default = 1,
		},
		[2] = {
			description = "#status_effects_light_bleeding_val2",
			type = Medical.types.number,
			default = 10,
		}
	},
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= values[2] then return end

		client:TakeDamage(values[1])
		stored.time = 0
	end,
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("heavy_bleeding") then
			return false, "#status_effects_have_effect '#status_effects_heavy_bleeding_title'"
		end
	end,
	tooltip = {
		format = "#status_effects_light_bleeding_tooltip",
		color = Color(136, 37, 37)
	}
})

Medical:TemporaryStatusEffects("heavy_bleeding", {
	name = "#status_effects_heavy_bleeding_title",
	icon = "asterion/academy/ui/health/tremor_2.png",
	description = "#status_effects_heavy_bleeding_desc",
	values = {
		[1] = {
			description = "#status_effects_heavy_bleeding_val1",
			type = Medical.types.number,
			default = 2,
		},
		[2] = {
			description = "#status_effects_heavy_bleeding_val2",
			type = Medical.types.number,
			default = 7,
		}
	},
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= values[2] then return end

		client:TakeDamage(values[1])
		stored.time = 0
	end,
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.alpha = stored.alpha or 0

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("heavy_bleeding") or 1
			local delay = time - CurTime()
			stored.alpha = Lerp(FrameTime() * 3, stored.alpha, time <= 0 and 1 or (delay <= 1 and -0.1 or 1))

			local alpha = math.max(0, stored.alpha)

			surface.SetDrawColor(255, 0, 0, alpha * 5)
			surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
		end
	},
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("light_bleeding")
	end,
	tooltip = {
		format = "#status_effects_heavy_bleeding_tooltip",
		color = Color(206, 33, 33)
	}
})

local tunnelvision_square = Material("danganronpa/ui/medical/tunnelvision_square.png")
Medical:TemporaryStatusEffects("tunnel_vision", {
	name = "#status_effects_tunnel_vision_title",
	icon = "asterion/academy/ui/health/tunnel_1.png",
	description = "#status_effects_tunnel_vision_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.alpha = stored.alpha or 0

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("tunnel_vision") or 1
			local delay = time - CurTime()
			stored.alpha = Lerp(FrameTime() * 2, stored.alpha, time <= 0 and 1 or (delay <= 1 and -0.1 or 1))

			local alpha = math.max(0, stored.alpha)
			local size = ScrH() + 4
			local a = alpha * 256

			surface.SetDrawColor(255, 255, 255, a)
			surface.SetMaterial(tunnelvision_square)
			surface.DrawTexturedRect(ScrW() / 2 - size / 2, -1, size, size)

			surface.SetDrawColor(0, 0, 0, a)
			surface.DrawRect(ScrW() / 2 - size / 2 - ScrW(), -1, ScrW(), size)
			surface.DrawRect(ScrW() / 2 - size / 2 + size, -1, ScrW(), size)
		end
	}
})


Medical:TemporaryStatusEffects("blackout", {
	name = "#status_effects_blackout_title",
	icon = "asterion/academy/ui/health/tunnel_2.png",
	description = "#status_effects_blackout_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.alpha = stored.alpha or 0

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("blackout") or 1
			local delay = time - CurTime()
			local ft = FrameTime()
			local speed = time <= 0 and 10 or (delay <= 2 and 1 or 10)

			stored.alpha = Lerp(ft * speed, stored.alpha, time <= 0 and 1 or (delay <= 2 and -0.1 or 1))

			local alpha = math.max(0, stored.alpha)
			local a = alpha * 230

			surface.SetDrawColor(0, 0, 0, a)
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

			surface.SetDrawColor(0, 0, 0, math.sin(RealTime() * 2) * 200 * alpha)
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
		end
	}
})

Medical:TemporaryStatusEffects("pain", {
	name = "#status_effects_pain_title",
	icon = "asterion/academy/ui/health/tremor_3.png",
	description = "#status_effects_pain_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.value = stored.value or 1

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("pain") or 1
			local delay = time - CurTime()

			stored.value = Lerp(FrameTime() * 4, stored.value, time <= 0 and 0.3 or (delay <= 1 and 1 or 0.3))

			DrawMotionBlur(stored.value, 2, 0.01)
		end
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("painkillers") then
			return false, "#status_effects_have_effect '#status_effects_painkillers_title'"
		end
	end
})

Medical:TemporaryStatusEffects("intoxication", {
	name = "#status_effects_intoxication_title",
	icon = "asterion/academy/ui/health/intoxication_drugs_2.png",
	description = "#status_effects_intoxication_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.value = stored.value or 1

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("intoxication") or 1
			local delay = time - CurTime()

			stored.value = Lerp(FrameTime() * 4, stored.value, time <= 0 and 0.05 or (delay <= 1 and 1 or 0.05))

			DrawMotionBlur(stored.value, 1, 0.01)
		end
	},
	tooltip = {
		format = "#status_effects_intoxication_tooltip",
		color = Color(122, 173, 63)
	},
})

Medical:TemporaryStatusEffects("drug_intoxication", {
	name = "#status_effects_drug_intoxication_title",
	icon = "asterion/academy/ui/health/intoxication_drugs_2.png",
	description = "#status_effects_drug_intoxication_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.value = stored.value or 1

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("drug_intoxication") or 1
			local delay = time - CurTime()

			stored.value = Lerp(FrameTime() * 4, stored.value, time <= 0 and 0.01 or (delay <= 1 and 1 or 0.01))

			DrawMotionBlur(stored.value, 1, 0.01)

			if time <= 0 or delay > 1 then
				local tab = {
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = 0,
					["$pp_colour_contrast"] = 1,
					["$pp_colour_colour"] = math.max(0, math.cos(RealTime() * 0.5)),
					["$pp_colour_mulr"] = math.max(0, math.sin(RealTime() * 0.2)),
					["$pp_colour_mulg"] = math.max(0, math.cos(RealTime() * 0.09)),
					["$pp_colour_mulb"] = math.max(0, math.sin(RealTime() * 0.06))
				}

				DrawColorModify(tab)
			end
		end
	},
	tooltip = {
		format = "#status_effects_drug_intoxication_tooltip",
		color = Color(141, 223, 48)
	},
})

Medical:TemporaryStatusEffects("broken_leg", {
	name = "#status_effects_broken_leg_title",
	icon = "asterion/academy/ui/health/fracture.png",
	description = "#status_effects_broken_leg_desc",
	values = {
		[1] = {
			description = "#status_effects_broken_leg_val1",
			type = Medical.types.number,
			default = 20,
		}
	},
	onAdd = function(client, delay)
		if CLIENT then return end

		if !client:HasTemporaryStatusEffect("painkillers") then
			client:RemoveTemporaryStatusEffect("adrenalin")

			Stamina:SetStamina(client, 0)
			Stamina:SetStaminaCD(client, delay - CurTime())
		end
	end,
	onRemove = function(client)
		client.StaminaCD = CurTime()
	end,
	onCanAdd = function(client, delay)
		if delay <= 0 then
			return false, "#status_effects_cant_forever"
		end
	end,
	handler = function(client, stored, values)
		if math.random(1, 10) == 1 and client:HasTemporaryStatusEffect("painkillers") and Stamina:IsRunning(client) then
			client:TakeDamage(1)
			client:ViewPunch(Angle(0.7, -0.5, 0.3))
		end
	end,
	tooltip = {
		format = "#status_effects_broken_leg_tooltip",
		color = Color(238, 92, 92)
	},
})

Medical:TemporaryStatusEffects("adrenalin", {
	name = "#status_effects_adrenalin_title",
	icon = "asterion/academy/ui/health/adrenaline.png",
	description = "#status_effects_adrenalin_desc",
	values = {
		[1] = {
			description = "#status_effects_adrenalin_val1",
			type = Medical.types.number,
			default = 10,
		}
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("broken_leg") and !client:HasTemporaryStatusEffect("painkillers") then
			return false, "#status_effects_have_effect '#status_effects_broken_leg_title'"
		end
	end
})

Medical:TemporaryStatusEffects("stun", {
	name = "#status_effects_stun_title",
	icon = "asterion/academy/ui/health/stun_2.png",
	description = "#status_effects_stun_desc",
	values = {
		[1] = {
			description = "#status_effects_stun_val1",
			type = Medical.types.number,
			default = 14,
		}
	},
	onAdd = function(client, delay)
		local values = Medical:TemporaryStatusEffectsValues("stun")
		local level = values[1]

		client:SetDSP(level)
	end,
	onRemove = function(client)
		if !client.healthDSP then
			client:SetDSP(0)
		end
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("hunger", {
	name = "#status_effects_hunger_title",
	icon = "asterion/academy/ui/health/nutrition_1.png",
	description = "#status_effects_hunger_desc",
	handler = function(client, stored, values)
		local key = "Hunger"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))
	end
})

Medical:TemporaryStatusEffects("hunger_a", {
	name = "#status_effects_hunger_a_title",
	icon = "asterion/academy/ui/health/nutrition_1.png",
	description = "#status_effects_hunger_a_desc"
})

Medical:TemporaryStatusEffects("thirst", {
	name = "#status_effects_thirst_title",
	icon = "asterion/academy/ui/health/hydration_1.png",
	description = "#status_effects_thirst_desc",
	handler = function(client, stored, values)
		local key = "Thirst"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))
	end
})

Medical:TemporaryStatusEffects("thirst_a", {
	name = "#status_effects_thirst_a_title",
	icon = "asterion/academy/ui/health/hydration_1.png",
	description = "#status_effects_thirst_a_desc"
})

Medical:TemporaryStatusEffects("sleep", {
	name = "#status_effects_sleep_title",
	icon = "asterion/academy/ui/health/sleep_2.png",
	description = "#status_effects_sleep_desc",
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= 2 then return end

		local key = "Sleep"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))

		stored.time = 0
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("sleep_a", {
	name = "#status_effects_sleep_a_title",
	icon = "asterion/academy/ui/health/sleep_1.png",
	description = "#status_effects_sleep_a_desc"
})

Medical:TemporaryStatusEffects("stamina", {
	name = "#status_effects_stamina_title",
	icon = "asterion/academy/ui/health/adrenaline_2.png",
	description = "#status_effects_stamina_desc",
	handler = function(client, stored, values)
		local info = Stamina:GetStamina(client)

		if info < 100 then
			Stamina:SetStamina(client, math.Clamp(info + 5, 0, 100))
		end
	end
})

Medical:TemporaryStatusEffects("health", {
	name = "#status_effects_health_title",
	icon = "asterion/academy/ui/health/health_1.png",
	description = "#status_effects_health_desc",
	handler = function(client, stored, values)
		local info = client:Health()

		local health = 100
		if client:HasTemporaryStatusEffect("overheal") then
			local overheal_values = Medical:TemporaryStatusEffectsValues("overheal")

			health = health + overheal_values[1]
		end

		client:SetHealth(math.min(health, info + 1))
	end
})

Medical:TemporaryStatusEffects("health_bed", {
	name = "#status_effects_health_bed_title",
	icon = "asterion/academy/ui/health/health_2.png",
	description = "#status_effects_health_bed_desc",
	handler = function(client, stored, values)
		-- на самом деле не знаю, почему это находится тут (но просто лень еще одно место создавать)...
		local info = Arbitrage.statistics.Get(client, "Sleep") or 100
		if info >= 100 then
			local maxAStatus = 400
			local keyname = "sleep_a"
			local a_delay = (client:GetTemporaryStatusEffectDelay(keyname) or CurTime()) - CurTime()
			a_delay = math.min(maxAStatus, a_delay + 1 * 2)

			client:SetTemporaryStatusEffect(keyname, a_delay)
		end

		stored.time = (stored.time or 0) + 1
		if stored.time <= 6 then return end

		local health = client:Health()
		if health < 100 then
		    client:SetHealth(math.Clamp(health + 1, 0, 100))
		end

		stored.time = 0
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("sleep_action", {
	name = "#status_effects_sleep_action_title",
	icon = "asterion/academy/ui/health/sleep_3.png",
	description = "#status_effects_sleep_action_desc",
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= 8 then return end

		local key = "Sleep"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))

		stored.time = 0
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("exhaustion", {
	name = "#status_effects_exhaustion_title",
	icon = "asterion/academy/ui/health/energy_2.png",
	description = "#status_effects_exhaustion_desc",
	handler = function(client, stored, values)
		if math.random(1, 90) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("severe_exhaustion") then
			return false, "#status_effects_have_effect '#status_effects_severe_exhaustion_title'"
		end
	end,
	tooltip = {
		format = "#status_effects_exhaustion_tooltip",
		color = Color(36, 84, 139)
	},
	noSave = true
})

Medical:TemporaryStatusEffects("severe_exhaustion", {
	name = "#status_effects_severe_exhaustion_title",
	icon = "asterion/academy/ui/health/eye_drowsiness_1.png",
	description = "#status_effects_severe_exhaustion_desc",
	handler = function(client, stored, values)
		if math.random(1, 50) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("exhaustion")
	end,
	tooltip = {
		format = "#status_effects_severe_exhaustion_tooltip",
		color = Color(37, 70, 216)
	},
	noSave = true
})

Medical:TemporaryStatusEffects("dehydration", {
	name = "#status_effects_dehydration_title",
	icon = "asterion/academy/ui/health/thirst_2.png",
	description = "#status_effects_dehydration_desc",
	handler = function(client, stored, values)
		if math.random(1, 40) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("starvation", {
	name = "#status_effects_starvation_title",
	icon = "asterion/academy/ui/health/nutrition_2.png",
	description = "#status_effects_starvation_desc",
	handler = function(client, stored, values)
		if math.random(1, 40) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	tooltip = {
		format = "#status_effects_starvation_tooltip",
		color = Color(207, 168, 39)
	},
	noSave = true
})

Medical:TemporaryStatusEffects("armor", {
	name = "#status_effects_armor_title",
	icon = "asterion/academy/ui/health/shield_1.png",
	description = "#status_effects_armor_desc",
	tooltip = {
		format = "#status_effects_armor_tooltip",
		color = Color(0, 119, 255)
	},
	noSave = true
})

Medical:TemporaryStatusEffects("painkillers", {
	name = "#status_effects_painkillers_title",
	icon = "asterion/academy/ui/health/painkiller_1.png",
	description = "#status_effects_painkillers_desc",
	handler = function(client, stored, values)
		-- eh...
	end,
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.value = stored.value or 1

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("painkillers") or 1
			local delay = time - CurTime()

			stored.value = Lerp(FrameTime() * 2, stored.value, time <= 0 and 1.3 or (delay <= 1 and 1 or 1.3))

			local tab = {
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = 0,
				["$pp_colour_contrast"] = stored.value,
				["$pp_colour_colour"] = 1,
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 0
			}

			DrawColorModify(tab)
		end
	},
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("pain")

		-- сбрасываем КД на реген стамины, если ноги сломаны
		if client:HasTemporaryStatusEffect("broken_leg") then
			client.StaminaCD = CurTime()
		end
	end
})

local function poisoning_effect(stored, values)
	stored.time = stored.time or 0

	if (!stored.timeCD or CurTime() >= stored.timeCD) then
		stored.time = stored.time + 1

		stored.timeCD = CurTime() + 1
	end

	if stored.time > values[1] * 2.5 then
		local tab = {
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = 0,
			["$pp_colour_contrast"] = 0.5 + math.max(0, math.cos(RealTime() * 1)) * 0.5,
			["$pp_colour_colour"] = math.max(0, math.cos(RealTime() * 0.5)),
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}

		DrawColorModify(tab)

		if stored.time > values[1] * 4 then
			DrawMotionBlur(0.05, 1, 0.05)
		else
			DrawMotionBlur(0.1, 1, 0.01)
		end
	elseif stored.time > values[1] * 2 then
		DrawMotionBlur(0.1, 1, 0.01)
	elseif stored.time > values[1] then
		DrawMotionBlur(0.4, 0.8, 0.01)
	end
end

Medical:TemporaryStatusEffects("poisoning_effect", {
	name = "#status_effects_poisoning_effect_title",
	icon = "asterion/academy/ui/health/poison_2.png",
	description = "#status_effects_poisoning_effect_desc",
	values = {
		[1] = {
			description = "#status_effects_poisoning_effect_val1",
			type = Medical.types.number,
			default = 30,
		}
	},
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			poisoning_effect(stored, values)
		end
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("poisoning_damage") then
			return false, "#status_effects_have_effect '#status_effects_poisoning_damage_title'"
		end

		if client:HasTemporaryStatusEffect("poisoning_dead") then
			return false, "#status_effects_have_effect '#status_effects_poisoning_dead_title'"
		end
	end,
	tooltip = {
		format = "#status_effects_poisoning_effect_tooltip",
		color = Color(122, 173, 63)
	},
	isHidden = true
})

Medical:TemporaryStatusEffects("poisoning_damage", {
	name = "#status_effects_poisoning_damage_title",
	icon = "asterion/academy/ui/health/poison_1.png",
	description = "#status_effects_poisoning_damage_desc",
	values = {
		[1] = {
			description = "#status_effects_poisoning_damage_val1",
			type = Medical.types.number,
			default = 30,
		},
		[2] = {
			description = "#status_effects_poisoning_damage_val2",
			type = Medical.types.number,
			default = 45,
		},
		[3] = {
			description = "#status_effects_poisoning_damage_val3",
			type = Medical.types.number,
			default = 10,
		},
		[4] = {
			description = "#status_effects_poisoning_damage_val4",
			type = Medical.types.number,
			default = 30,
		}
	},
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= values[2] then return end

		if (!stored.timeCD or CurTime() >= stored.timeCD) then
			client:TakeDamage(values[3])

			stored.timeCD = CurTime() + values[4]
		end
	end,
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			poisoning_effect(stored, values)
		end
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("poisoning_damage") then
			return false, "#status_effects_have_effect '#status_effects_poisoning_damage_title'"
		end

		local values = Medical:TemporaryStatusEffectsValues("poisoning_damage")
		local time = values[2] + 1

		if delay < time then
			return false, "#status_effects_cant_less_than " .. time .. " #seconds."
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("poisoning_effect")
	end,
	tooltip = {
		format = "#status_effects_poisoning_damage_tooltip",
		color = Color(122, 173, 63)
	},
	isHidden = true
})

Medical:TemporaryStatusEffects("poisoning_dead", {
	name = "#status_effects_poisoning_dead_title",
	icon = "asterion/academy/ui/health/poison_1.png",
	description = "#status_effects_poisoning_dead_desc",
	values = {
		[1] = {
			description = "#status_effects_poisoning_dead_val1",
			type = Medical.types.number,
			default = 30,
		},
		[2] = {
			description = "#status_effects_poisoning_dead_val2",
			type = Medical.types.number,
			default = 600,
		}
	},
	handler = function(client, stored, values)
		stored.time = (stored.time or 0) + 1
		if stored.time <= values[2] then return end

		client:Kill()
		client:RemoveTemporaryStatusEffect("poisoning_dead")
	end,
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			poisoning_effect(stored, values)
		end
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("poisoning_dead") then
			return false, "#status_effects_have_effect '#status_effects_poisoning_dead_title'"
		end

		if delay != 0 then
			return false, "#status_effects_only_possible_0"
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("poisoning_effect")
		client:RemoveTemporaryStatusEffect("poisoning_damage")
	end,
	tooltip = {
		format = "#status_effects_poisoning_dead_tooltip",
		color = Color(122, 173, 63)
	},
	isHidden = true
})

Medical:TemporaryStatusEffects("overheal", {
	name = "#status_effects_overheal_title",
	icon = "asterion/academy/ui/health/shield_1.png",
	description = "#status_effects_overheal_desc",
	values = {
		[1] = {
			description = "#status_effects_overheal_val1",
			type = Medical.types.number,
			default = 50,
		}
	},
	onAdd = function(client)
		if CLIENT then return end

		local values = Medical:TemporaryStatusEffectsValues("overheal")
		client:AddTemporaryStatusEffect("health", values[1])
	end,
	onRemove = function(client)
		if client:Health() > 100 then
			client:SetHealth(100)
		end
	end
})

Medical:TemporaryStatusEffects("berserk", {
	name = "#status_effects_berserk_title",
	icon = "asterion/academy/ui/health/hydration_3.png",
	description = "#status_effects_berserk_desc",
	values = {
		[1] = {
			description = "#status_effects_berserk_val1",
			type = Medical.types.number,
			default = 15,
		}
	}
})

Medical:TemporaryStatusEffects("flashbang", {
	name = "#status_effects_flashbang_title",
	icon = "asterion/academy/ui/health/eye_blindness_2.png",
	description = "#status_effects_flashbang_desc",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			local ft = FrameTime()

			stored.st = stored.st or 1

			stored.alpha_black1 = stored.alpha_black1 or 255
			stored.alpha_white = stored.alpha_white or 255
			stored.alpha_black2 = stored.alpha_black2 or 255

			if stored.st == 1 then
				stored.alpha_black1 = Lerp(ft * 10, stored.alpha_black1, -100)

				if stored.alpha_black1 <= 0 then
					stored.st = 2
				end
			elseif stored.st == 2 then
				stored.alpha_white = Lerp(ft * 10, stored.alpha_white, -10)

				if stored.alpha_white <= 0 then
					stored.st = 3
				end
			elseif stored.st == 3 then
				local client = LocalPlayer()
				local time = client:GetTemporaryStatusEffectDelay("flashbang") or 1
				local delay = time - CurTime()

				if delay <= 4 then
					stored.alpha_black2 = Lerp(ft * 0.8, stored.alpha_black2, -8)

					if stored.alpha_black2 <= 0 then
						stored.st = 4
					end
				end
			end

			surface.SetDrawColor(0, 0, 0, stored.alpha_black2)
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

			asterionlib.DrawBlurAt(-1, -1, ScrW() + 2, ScrH() + 2, 10, nil, stored.alpha_black2)
			DrawMotionBlur(stored.alpha_black2, stored.alpha_black2, 0.01)

			surface.SetDrawColor(255, 255, 255, stored.alpha_white)
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
			surface.SetDrawColor(0, 0, 0, stored.alpha_black1)
			surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)
		end
	},
	onAdd = function(client, delay)
		if CLIENT then return end

		client:ViewPunch(Angle(-50, -50, -50))
	end
})

-- Для Селестии
Medical:TemporaryStatusEffects("luck", {
	name = "#status_effects_luck_title",
	icon = "asterion/academy/ui/health/luck_1.png",
	description = "#status_effects_luck_desc",
	hooks = {
		OnCommandTry = function(client, rand)
			local bSucc = math.random(1, 5) == 5 -- 20% на то, что повезет

			if bSucc then
				return true, true
			end
		end,
		OnCommandRoll = function(client, rand, maxRand)
			local bSucc = math.random(1, 5) == 5 -- 20% на то, что повезет

			if bSucc then
				local newRand = math.Clamp(rand + math.random(10, 30), 0, maxRand)
				return true, newRand
			end
		end
	}
})

-- Для Макото
local emoteList = {
	"#increased_luck_protect_1",
	"#increased_luck_protect_2",
	"#increased_luck_protect_3",
	"#increased_luck_protect_4",
	"#increased_luck_protect_5"
}
Medical:TemporaryStatusEffects("increased_luck", {
	name = "#status_effects_increased_luck_title",
	icon = "asterion/academy/ui/health/luck_2.png",
	description = "#status_effects_increased_luck_desc",
	hooks = {
		OnCommandTry = function(client, rand)
			if rand == false then
				local bSucc = math.random(1, 5) == 5 -- 20% на то, что повезет

				if bSucc then
					return true, true
				end
			end
		end,
		OnCommandRoll = function(client, rand, maxRand)
			if rand < maxRand / 2 then
				local bSucc = math.random(1, 5) == 5 -- 20% на то, что повезет

				if bSucc then
					return true, maxRand
				end
			end
		end,
		ScalePlayerDamage = function(client, hitgroup, dmginfo)
			local bSucc = math.random(1, 5) == 5 -- 20% на то, что повезет

			if bSucc then
				dmginfo:ScaleDamage(0)
				Arbitrage.chat.SendCommand("me", client, emoteList[math.random(1, #emoteList)])

				return true
			end
		end
	}
})

-- Для Нагито
Medical:TemporaryStatusEffects("absolute_luck", {
	name = "#status_effects_absolute_luck_title",
	icon = "asterion/academy/ui/health/luck_3.png",
	description = "#status_effects_absolute_luck_desc",
	hooks = {
		OnCommandTry = function(client, rand)
			local bSucc = math.random(1, 2) == 1 -- 50% на то, что повезет

			if bSucc then
				return true, true
			else
				return true, false
			end
		end,
		OnCommandRoll = function(client, rand, maxRand)
			local bSucc = math.random(1, 2) == 1 -- 50% на то, что повезет

			if bSucc then
				return true, maxRand
			else
				return true, 0
			end
		end
	}
})

-- Для Химико и Чиаки (спят где хотят)
Medical:TemporaryStatusEffects("gifted_sleeper", {
	name = "#status_effects_gifted_sleeper_title",
	icon = function(client)
		if IsValid(client) then
			local character = Character.team:GetByID(client:Team())

			if character then
				local icons = character.status_effects_icons

				if icons and icons.gifted_sleeper then
					return icons.gifted_sleeper
				end
			end
		end

		return "asterion/academy/ui/health/sleep_4.png"
	end,
	description = "#status_effects_gifted_sleeper_desc",
	hooks = {
		OnCanGiftedSleeper = function(client)
			return true
		end
	}
})

Medical:TemporaryStatusEffects("choreographer", {
	name = "#status_effects_choreographer_title",
	icon = "asterion/academy/ui/health/error.png",
	description = "#status_effects_choreographer_desc",
	hooks = {
		PermissionToDance = function(client, id)
			return true
		end,
		TeachDancing = function(client, target)
			return true
		end
	}
})

Medical:TemporaryStatusEffects("dancer", {
	name = "#status_effects_dancer_title",
	icon = "asterion/academy/ui/health/error.png",
	description = "#status_effects_dancer_desc",
	hooks = {
		PermissionToDance = function(client, id)
			return true
		end
	}
})