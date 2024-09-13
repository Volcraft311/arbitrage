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
	name = "Кровотечение",
	icon = "danganronpa/ui/medical/bleeding.png",
	description = "Вы теряете {1} HP каждые {2} секунд.\nПриводит к смерти, когда общий запас здоровья достигает 0.",
	values = {
		[1] = {
			description = "Сколько HP игрок будет терять каждые {2} секунд",
			type = Medical.types.number,
			default = 1,
		},
		[2] = {
			description = "Спустя сколько времени будет терять {1} HP",
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
			return false, "Игрок имеет статус эффект 'Сильное кровотечение'"
		end
	end
})

Medical:TemporaryStatusEffects("heavy_bleeding", {
	name = "Сильное кровотечение",
	icon = "danganronpa/ui/medical/heavy_bleeding.png",
	description = "Вы теряете {1} HP каждые {2} секунд.\nВы оставляете брызги крови, а так же снижается максимальное количество выносливости.\nПриводит к смерти, когда общий запас здоровья достигает 0.",
	values = {
		[1] = {
			description = "Сколько HP игрок будет терять каждые {2} секунд",
			type = Medical.types.number,
			default = 2,
		},
		[2] = {
			description = "Спустя сколько времени будет терять {1} HP",
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
	end
})

local tunnelvision_square = Material("danganronpa/ui/medical/tunnelvision_square.png")
Medical:TemporaryStatusEffects("tunnel_vision", {
	name = "Туннельное зрение",
	icon = "danganronpa/ui/medical/tunnel_vision.png",
	description = "Потеря периферического обзора.",
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
	name = "Затемнение",
	icon = "danganronpa/ui/medical/tunnel_vision.png",
	description = "Затемнение видимости окружения.",
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
	name = "Боль",
	icon = "danganronpa/ui/medical/pain.png",
	description = "Размытие изображения.",
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
			return false, "Игрок имеет статус эффект 'На болеутоляющих'"
		end
	end
})

Medical:TemporaryStatusEffects("intoxication", {
	name = "Опьянение",
	icon = "danganronpa/ui/medical/debuff.png",
	description = "Сильно размытие изображения.",
	hooks = {
		RenderScreenspaceEffects = function(stored, values)
			stored.value = stored.value or 1

			local client = LocalPlayer()
			local time = client:GetTemporaryStatusEffectDelay("intoxication") or 1
			local delay = time - CurTime()

			stored.value = Lerp(FrameTime() * 4, stored.value, time <= 0 and 0.05 or (delay <= 1 and 1 or 0.05))

			DrawMotionBlur(stored.value, 1, 0.01)
		end
	}
})

Medical:TemporaryStatusEffects("drug_intoxication", {
	name = "Наркотическое опьянение",
	icon = "danganronpa/ui/medical/debuff.png",
	description = "Очень сильно размытие изображения.\nВаша цветовая коррекция меняется спустя время, вы видите то, чего нету перед вами.",
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
	}
})

Medical:TemporaryStatusEffects("broken_leg", {
	name = "Перелом ноги",
	icon = "danganronpa/ui/medical/fracture.png",
	description = "Вы не можете больше бегать, выносливость не восстанавливается.\nКамера покачивается при хотьбе, а скорость передвижения уменьшена на {1}%",
	values = {
		[1] = {
			description = "На сколько % будет уменьшена скорость передвижения",
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
			return false, "Данный эффект нельзя установить навсегда"
		end
	end,
	handler = function(client, stored, values)
		if math.random(1, 10) == 1 and client:HasTemporaryStatusEffect("painkillers") and Stamina:IsRunning(client) then
			client:TakeDamage(1)
			client:ViewPunch(Angle(0.7, -0.5, 0.3))
		end
	end
})

Medical:TemporaryStatusEffects("adrenalin", {
	name = "Адреналин",
	icon = "danganronpa/ui/medical/berserk.png",
	description = "Ваша скорость бега увеличина на {1}%",
	values = {
		[1] = {
			description = "На сколько % будет увеличина скорость передвижения",
			type = Medical.types.number,
			default = 10,
		}
	},
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("broken_leg") and !client:HasTemporaryStatusEffect("painkillers") then
			return false, "Игрок имеет статус эффект 'Перелом ноги'"
		end
	end
})

Medical:TemporaryStatusEffects("stun", {
	name = "Оглушение",
	icon = "danganronpa/ui/medical/contusion.png",
	description = "Все звуки заглушены.",
	values = {
		[1] = {
			description = "Уровень оглушения. От 1 до 14",
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
	name = "Восстановление голода",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваш голод восстанавливается.",
	handler = function(client, stored, values)
		local key = "Hunger"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))
	end
})

Medical:TemporaryStatusEffects("hunger_a", {
	name = "Сытость",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваш голод больше не тратится."
})

Medical:TemporaryStatusEffects("thirst", {
	name = "Восстановление жажды",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваша жажда восстанавливается.",
	handler = function(client, stored, values)
		local key = "Thirst"
		local info = Arbitrage.statistics.Get(client, key)

		Arbitrage.statistics.Set(client, key, math.Clamp(info + 1, 0, 100))
	end
})

Medical:TemporaryStatusEffects("thirst_a", {
	name = "Насыщенность",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваша жажда больше не тратится."
})

Medical:TemporaryStatusEffects("sleep", {
	name = "Восстановление энергии",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваш сон восстанавливается.",
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
	name = "Бессонница",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваш сон больше не тратится."
})

Medical:TemporaryStatusEffects("stamina", {
	name = "Восстановление сил",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваша выносливость восстанавливается.",
	handler = function(client, stored, values)
		local info = Stamina:GetStamina(client)

		if info < 100 then
			Stamina:SetStamina(client, math.Clamp(info + 5, 0, 100))
		end
	end
})

Medical:TemporaryStatusEffects("health", {
	name = "Регенерация здоровья",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваше здоровье восстанавливается.",
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
	name = "Регенерация здоровья (сон)",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваше здоровье восстанавливается.",
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
	name = "Восстановление энергии (анимация)",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Ваш сон очень медленно восстанавливается.",
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
	name = "Усталость",
	icon = "danganronpa/ui/medical/exhaustion.png",
	description = "Скорость вашего передвижения медленее.\nЭтот статус может вызвать эффект боли.",
	handler = function(client, stored, values)
		if math.random(1, 90) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	onCanAdd = function(client, delay)
		if client:HasTemporaryStatusEffect("severe_exhaustion") then
			return false, "Игрок имеет статус эффект 'Сильная усталость'"
		end
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("severe_exhaustion", {
	name = "Сильная усталость",
	icon = "danganronpa/ui/medical/exhaustion.png",
	description = "Вы больше не можете бегать, а скорость вашего передвижения медленее.\nЭтот статус может вызвать эффект боли.",
	handler = function(client, stored, values)
		if math.random(1, 50) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("exhaustion")
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("dehydration", {
	name = "Обезвоживание",
	icon = "danganronpa/ui/medical/dehydration.png",
	description = "Ваша выносливость больше не восстанавливается.\nЭтот статус может вызвать эффект боли.",
	handler = function(client, stored, values)
		if math.random(1, 40) == 1 then
			client:AddTemporaryStatusEffect("pain", 5)
		end
	end,
	noSave = true
})

Medical:TemporaryStatusEffects("painkillers", {
	name = "На болеутоляющих",
	icon = "danganronpa/ui/medical/painkillers.png",
	description = "Немного увеличивает контраст и снимает эффект боли.\n(При переломе) Позволяет идти с нормальной скоростью или бежать, но вы можете получить урон.",
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
	name = "Отравление",
	icon = "danganronpa/ui/medical/toxin.png",
	description = "Спустя некоторые время вы получаете эффекты на своем экране, которые усиливаются.",
	values = {
		[1] = {
			description = "Спустя сколько времени игрок начнет получать эффекты",
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
			return false, "Игрок имеет статус эффект 'Отравление (постоянный урон)'"
		end

		if client:HasTemporaryStatusEffect("poisoning_dead") then
			return false, "Игрок имеет статус эффект 'Отравление (мгновенная смерть)'"
		end
	end,
	isHidden = true
})

Medical:TemporaryStatusEffects("poisoning_damage", {
	name = "Отравление (постоянный урон)",
	icon = "danganronpa/ui/medical/toxin.png",
	description = "Спустя некоторые время вы получаете эффекты на своем экране, которые усиливаются.\nВы получаете {3} урона каждые {4} секунд.",
	values = {
		[1] = {
			description = "Спустя сколько времени игрок начнет получать эффекты",
			type = Medical.types.number,
			default = 30,
		},
		[2] = {
			description = "Спустя сколько времени игрок начнет получать {3} урона",
			type = Medical.types.number,
			default = 45,
		},
		[3] = {
			description = "Количество урона от отравления",
			type = Medical.types.number,
			default = 10,
		},
		[4] = {
			description = "Задержка между получением {3} урона",
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
			return false, "Игрок имеет статус эффект 'Отравление (постоянный урон)'"
		end

		local values = Medical:TemporaryStatusEffectsValues("poisoning_damage")
		local time = values[2] + 1

		if delay < time then
			return false, "Данный эффект нельзя установить меньше чем " .. time .. " секунд."
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("poisoning_effect")
	end,
	isHidden = true
})

Medical:TemporaryStatusEffects("poisoning_dead", {
	name = "Отравление (мгновенная смерть)",
	icon = "danganronpa/ui/medical/toxin.png",
	description = "Спустя некоторые время вы получаете эффекты на своем экране, которые усиливаются.\nВы умрете через некоторое время.",
	values = {
		[1] = {
			description = "Спустя сколько времени игрок начнет получать эффекты",
			type = Medical.types.number,
			default = 30,
		},
		[2] = {
			description = "Спустя сколько времени игрок умрет",
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
			return false, "Игрок имеет статус эффект 'Отравление (мгновенная смерть)'"
		end

		local values = Medical:TemporaryStatusEffectsValues("poisoning_dead")
		local time = values[2] + 1

		if delay != 0 then
			return false, "Данный эффект можно установить только на 0 секунд."
		end
	end,
	onAdd = function(client, delay)
		if CLIENT then return end

		client:RemoveTemporaryStatusEffect("poisoning_effect")
		client:RemoveTemporaryStatusEffect("poisoning_damage")
	end,
	isHidden = true
})

Medical:TemporaryStatusEffects("overheal", {
	name = "Overheal",
	icon = "danganronpa/ui/medical/buff.png",
	description = "Дает регенерацию здоровья, а так же увеличивает максимальное здоровье персонажа на +{1}.",
	values = {
		[1] = {
			description = "Сколько HP будет даваться дополнительно игроку",
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
	name = "Берсерк",
	icon = "danganronpa/ui/medical/berserk.png",
	description = "Увеличивает скорость передвижения на {1}% и уменьшает трату выносливости.\nТак же увеличивает ваш fov.",
	values = {
		[1] = {
			description = "На сколько % будет увеличина скорость передвижения",
			type = Medical.types.number,
			default = 15,
		}
	}
})