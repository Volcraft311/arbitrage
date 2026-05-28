local workshop = asterionlib.workshop

hook.Add("asterionlib.workshop:Initialize", "arbitrage.workshop", function()
    -- MAIN

    workshop:Add("3731399324", {     --  Main Content
        onCheck = function()
            return !workshop:ModelIsError("models/bh/props/dead.mdl")
        end
    })

    workshop:Add("3731400716", {     --  Hyoko new MDL
        onCheck = function()
            return !workshop:ModelIsError("models/dih/SaionjiHiyokoSFW.mdl")
        end
    })

    workshop:Add("3731522409", {     --  Sprites
        onCheck = function()
            return !workshop:MaterialIsError("danganronpa/characters/akane/pixel.png") and
                !workshop:MaterialIsError("danganronpa/characters/junko/logo.png")
        end
    })

    workshop:Add("2717853308", {     -- Asterion Academy - Models Content #1
        onCheck = function()
            return !workshop:ModelIsError("models/custom/aoi_asahina.mdl") and
                !workshop:ModelIsError("models/player/dewobedil/danganronpa/tsumugi_shirogane/default_p.mdl")
        end
    })

    workshop:Add("2780751458", {     -- Asterion Academy - Models Content #2
        onCheck = function()
            return !workshop:ModelIsError("models/player/dewobedil/danganronpa/fuyuhiko/default_p.mdl")
        end
    })

    workshop:Add("2723789180", {     -- Asterion Academy - Models Content #3
        onCheck = function()
            return !workshop:ModelIsError("models/player/dewobedil/danganronpa/angie_yonaga/default_p.mdl")
        end
    })

    workshop:Add("2849953494", {     -- Asterion Academy - Models Content #4
        onCheck = function()
            return !workshop:ModelIsError("models/player/kotoko/kotoko_p.mdl")
        end
    })

    workshop:Add("2791583716", {     -- Asterion Academy - Additional Content
        onCheck = function()
            return !workshop:MaterialIsError("danganronpa/characters/monokuma/white.png")
        end
    })

    workshop:Add("2860471023", {     -- Asterion Academy — Prop Content #1
        onCheck = function()
            return !workshop:ModelIsError("models/asterion/academy/props/classroom/ast_classroom_board.mdl")
        end
    })

    -- OTHER

    workshop:Add("160250458", {     -- Wiremod
        onCheck = function()
            return !workshop:ModelIsError("models/segment.mdl")
        end
    })

    workshop:Add("2840031720", {     -- TFA Base
        onCheck = function()
            return !workshop:ModelIsError("models/tfa/rifleshell.mdl")
        end
    })

    workshop:Add("246756300", {     -- Stream Radio
        onCheck = function()
            return !workshop:MaterialIsError("3dstreamradio/cursor.png")
        end
    })

    workshop:Add("108024198", {     -- Food and Household items
        onCheck = function()
            return !workshop:ModelIsError("models/foodnhouseholditems/apple.mdl")
        end
    })

    workshop:Add("1920810365", {     -- Facial Emote Mod
        onCheck = function()
            return !workshop:MaterialIsError("facial_emote/like.png")
        end
    })

    workshop:Add("1784911999")       -- LED screens
    workshop:Add("329174479")        -- Extended Emitter

    workshop:Add("1161268544", {     -- Pink Blood
        onCheck = function()
            return !workshop:ModelIsError("models/gibs/hgibs_spine.mdl")
        end
    })

    workshop:Add("2840295308", {     -- Primitive
        onCheck = function()
            return !workshop:MaterialIsError("primitive/icons/cone.png")
        end
    })

    workshop:Add("2963988886", {     -- more materials
        onCheck = function()
            return !workshop:MaterialIsError("metal/metalwall1")
        end
    })
    workshop:Add("2782265858")     -- DSteps: Dynamic Footsteps

    -- WEAPONS
    workshop:Add("2842765511", {     -- nmrih reupload
        onCheck = function()
            return !workshop:ModelIsError("models/weapons/tfa_nmrih/v_fa_1911.mdl")
        end
    })

    workshop:Add("244540803", {     -- Customizable Flashlight
        onCheck = function()
            return !workshop:ModelIsError("models/weapons/w_flashlight_zm.mdl")
        end
    })

    workshop:Add("921195220", {     -- TFA CS:S Weapons
        onCheck = function()
            return !workshop:ModelIsError("models/weapons/2_c4.mdl")
        end
    })

    workshop:Add("1414153810", {     -- [TTT] Night vision
        onCheck = function()
            return !workshop:ModelIsError("models/weapons/cbinocularsbp/w_nvbinoculars.mdl")
        end
    })

    workshop:Add("104607228", {     -- Fire Extinguisher
        onCheck = function()
            return !workshop:ModelIsError("models/weapons/w_fire_extinguisher.mdl")
        end
    })

    -- MAPS
    workshop:Add("2902905430", {     -- Asterion Hope's Peak [Pre-Release]
        onCheck = function()
            return !workshop:MaterialIsError("asterion_hopespeak/fish_1.png")
        end
    })

    -- MODELS
    workshop:Add("1246554779", {     -- Roleplay Props Extended
        onCheck = function()
            return !workshop:ModelIsError("models/statua/falloutdoor.mdl")
        end
    })

    workshop:Add("958532452", {     -- Interior Props Pack
        onCheck = function()
            return !workshop:ModelIsError("models/props/doors/door_barricade.mdl")
        end
    })

    workshop:Add("3324595242", {     -- Developer Style Props!
        onCheck = function()
            return !workshop:ModelIsError("models/props/dev_boxset.mdl")
        end
    })

    workshop:Add("1990021079", {     -- Some school props
        onCheck = function()
            return !workshop:ModelIsError("models/aschool25/camera.mdl")
        end
    })

    workshop:Add("213181442", {     -- Mobile Computing Pack
        onCheck = function()
            return !workshop:ModelIsError("models/lt_c/tech/cellphone.mdl")
        end
    })

    workshop:Add("104477476", {     -- Misc Props Pack
        onCheck = function()
            return !workshop:ModelIsError("models/props_vtmb/armchair.mdl")
        end
    })

    workshop:Add("2546157752", {     -- Stockplus - More Construct Props
        onCheck = function()
            return !workshop:ModelIsError("models/okxapack/stockplus/hunter/pipes/pipe025.mdl")
        end
    })

    workshop:Add("1805856532", {     -- [DR] Nidai Nekomaru
        onCheck = function()
            return !workshop:ModelIsError("models/nekomaru/nekomaruniidai.mdl")
        end
    })

    -- LAST DOWNLOAD
    workshop:Add("3347087744", {     -- Asterion - Animations
        onCheck = function()
            local bValid = true
            local checkList = {
                sit = true,
                d1_t02_plaza_sit01_idle = true,
                sit_chair = true,
                sit_ground = true,
                sit_zen = true,
                sitccouchtv1 = true,
                sitchair1 = true,
                sitchairtable1 = true,
                sitcouch1 = true,
                sitcouchfeet1 = true,
                sitcouchknees1 = true
            }

            do
                local entity = ClientsideModel("models/player/kleiner.mdl")
                entity:SetPos(Vector(0, 0, 0))

                for checkID in pairs(checkList) do
                    local sequence = entity:LookupSequence(checkID)

                    if sequence <= -1 then
                        bValid = false
                    end
                end

                entity:Remove()
            end

            do
                local entity = ClientsideModel("models/player/mossman.mdl")
                entity:SetPos(Vector(0, 0, 0))

                for checkID in pairs(checkList) do
                    local sequence = entity:LookupSequence(checkID)

                    if sequence <= -1 then
                        bValid = false
                    end
                end

                entity:Remove()
            end

            return bValid
        end
    })
end)
