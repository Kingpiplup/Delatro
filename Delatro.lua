--- STEAMODDED HEADER
--- MOD_NAME: DelatroPack1
--- MOD_ID: DelatroPack1
--- MOD_AUTHOR: [Devdelta]
--- MOD_DESCRIPTION: Adding a few new jokers for fun
--- PREFIX: delatro
--- BADGE_COLOR: ad3047

----------------------------------------------
------------MOD CODE -------------------------

local mod = SMODS.current_mod

SMODS.Atlas {key = 'Delatro1',path = 'Delatro1Sprites.png',px =71,py = 95}

SMODS.Joker{
    name = "Jambo", --for testing
    key = 'jambo',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=0,y=0},
    cost = 2,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Jambo',
        text = {
            '{C:chips}+#1#{} Chips'
        }
    },
    config = { extra = { chips = 20 } },
    loc_vars = function(self, info_queue, card)
		return {
             vars = {
                card.ability.extra.chips
                } 
            }
	end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
                message = localize {type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}
            }
        end
        return nil
    end
}

if JokerDisplay then 
    local jd_def = JokerDisplay.Definitions
    jd_def['j_delatro_jambo'] = {
        text = {
            {text = "+"},
            {ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'chips'}
        },
        text_config = {colour = G.C.CHIPS},
    }
end


--[[
if JokerDisplay then
    local jd_def = JokerDisplay.Definitions

    jd_def["j_multi_math_homework"] = { -- Jokester
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            local has_face = false
            local has_selected = false
            if G.hand and G.hand.cards then
                for _, selected_card in ipairs(G.hand.cards) do
                    if selected_card.highlighted then
                        has_selected = true
                        if selected_card:get_id() then
                            if not ((selected_card:get_id() <= 10  and selected_card:get_id() >= 2) or selected_card:get_id() == 14) then
                                has_face = true
                            end
                        end
                    end
                end
            end
            if has_face or not has_selected then
                card.joker_display_values.mult = 0
            else
                card.joker_display_values.mult = card.ability.extra.mult
            end
        end
    }

    jd_def["j_multi_collectors_item"] = { -- Top 5
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "chips" }
        },
        text_config = { colour = G.C.CHIPS },
        calc_function = function(card)
            local unique_jokers_owned = 1
            if G.GAME["MultiJokersMod_unique_jokers_owned"] then
                unique_jokers_owned = table_length(G.GAME["MultiJokersMod_unique_jokers_owned"])
            end
            card.joker_display_values.chips = card.ability.extra * unique_jokers_owned
        end
    }

    jd_def['j_multi_incremental'] = {
        text = {
            {
                border_nodes = {
                    { text = 'X'},
                    { ref_table = 'card.ability.extra', ref_value = 'x_mult', retrigger_type = 'exp' },
                }
            }
        }
    }
end

local add_to_deck_ref = Card.add_to_deck
function Card:add_to_deck()
    if G.GAME and self.ability.set == "Joker" then
        if G.GAME["MultiJokersMod_unique_jokers_owned"] == nil then
            G.GAME["MultiJokersMod_unique_jokers_owned"] = {}
        end
        G.GAME["MultiJokersMod_unique_jokers_owned"][self.ability.name] = true
    end
    return add_to_deck_ref(self)
end
]]--

----------------------------------------------
------------MOD CODE END----------------------
