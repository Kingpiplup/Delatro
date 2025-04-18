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
SMODS.Joker{
    name = "Raise", 
    key = 'raise',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=1,y=0},
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Raise',
        text = {
            'Gains {C:chips}+#2#{} Chips each hand played',
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips = 0, chip_gain = 2 } },
    loc_vars = function(self, info_queue, card)
		return {
             vars = {
                card.ability.extra.chips,card.ability.extra.chip_gain
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
        if context.before and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = "Upgraded!",
                colour = G.C.CHIPS,
                card = card,
            } 
        end
    end
}
SMODS.Joker{
    name = "Mult Joker", 
    key = 'mult_joker',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=2,y=0},
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = 'm_mult',
    loc_txt = {
        name = 'Mult Joker',
        text = {
            'Retrigger {C:attention}first{}',
            'scored {C:attention}Mult Card{}',
            'an additional {C:attention}2 {}times'
        }
    },
    config = { extra = { repetitions = 2, card_found = nil, found = false } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            for _, played_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(played_card, 'm_mult') then
                    card.ability.extra.card_found = played_card
                    card.ability.extra.found = true
                    break
                end 
            end
            if context.other_card == card.ability.extra.card_found then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = context.other_card
                }
            end
        end      
    end
}
SMODS.Joker{
    name = "Bonus Joker",
    key = 'bonus_joker',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=3,y=0},
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = 'm_bonus',
    loc_txt = {
        name = 'Bonus Joker',
        text = {
            'Each {C:attention}Bonus Card{} held in hand',
            'at end of round has {C:green}#3# in #2# {}',
            'chance to give {C:money}$#1#{}'
        }
    },
    config = { extra = { income = 1,odds = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return {
            vars = {
                card.ability.extra.income, card.ability.extra.odds,(G.GAME.probabilities.normal or 1)
            } 
        }
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.cardarea == G.hand and context.individual and SMODS.has_enhancement(context.other_card, 'm_bonus') then
            if pseudorandom('bonus_joker') < G.GAME.probabilities.normal/card.ability.extra.odds then
                if context.other_card.debuff then
                    return {
                        message = 'debuffed',
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                else
                    return {
                        dollars = card.ability.extra.income,
                    }
                end
            end
        end
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
    jd_def['j_delatro_raise'] = {
        text = {
            {text = "+"},
            {ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'chips'}
        },
        text_config = {colour = G.C.CHIPS},
    }
    jd_def['j_delatro_bonus_joker'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "mult" },
            { text = "x",                              scale = 0.35 },
            { text = "$",                              colour = G.C.GOLD },
            { ref_table = "card.ability.extra",        ref_value = "income", colour = G.C.GOLD },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local playing_hand = next(G.play.cards)
            local count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_hand or not playing_card.highlighted then
                    if playing_card.facing and not (playing_card.facing == 'back') and SMODS.has_enhancement(playing_card, 'm_bonus') then
                        count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
                    end
                end
            end
            card.joker_display_values.count = count
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds } }
            card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
        end
    }
end