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
    cost = 6,
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
                    card = card
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
    cost = 6,
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
SMODS.Joker{
    name = 'Dance Recital',
    key = 'dance_recital',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=4,y=0},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Dance Recital',
        text = {
            'Retrigger each',
            'played {C:attention}5{}, {C:attention}6{}, {C:attention}7{}, or {C:attention}8{}'
        }
    },
    config = { extra = { repetitions = 1} },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card:get_id() == 5 then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = card,
                }
            end
        end
    end
}
SMODS.Joker{
    name = 'Prime Time',
    key = 'prime_time',
    rarity = 1, 
    atlas = 'Delatro1',
    pos = {x=0,y=1},   
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Prime Time',
        text = {
            'Each {C:attention}Unique{} scored',
            '{C:attention}Prime Number{} gives',
            '{C:mult}+Next Prime Number{} Mult',
            '{C:inactive}(2,3,5,7){}'
        }
    },
    config = { extra = { twof = true, threef = true, fivef = true, sevenf = true }},
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            if context.other_card:get_id() == 2 and card.ability.extra.twof then
                card.ability.extra.twof = false
                return{
                    mult_mod = 3,
                    message = localize {type = 'variable', key = 'a_mult', vars = {3}},
                    card = card.other_card,
                }
            elseif context.other_card:get_id() == 3 and card.ability.extra.threef then
                card.ability.extra.threef = false
                return{
                    mult_mod = 5,
                    message = localize {type = 'variable', key = 'a_mult', vars = {5}},
                    card = card.other_card
                }
            elseif context.other_card:get_id() == 5 and card.ability.extra.fivef then
                card.ability.extra.fivef = false
                return{
                    mult_mod = 7,
                    message = localize {type = 'variable', key = 'a_mult', vars = {7}},
                    card = card.other_card
                }
            elseif context.other_card:get_id() == 7 and card.ability.extra.sevenf then
                card.ability.extra.sevenf = false
                return{
                    mult_mod = 11,
                    message = localize {type = 'variable', key = 'a_mult', vars = {11}},
                    card = card.other_card
                }
            end
        end
        if context.after then
            card.ability.extra.twof = true
            card.ability.extra.threef = true
            card.ability.extra.fivef = true
            card.ability.extra.sevenf = true
            return nil
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
    jd_def['j_delatro_dance_recital'] = {
        text = {
            {text = "(5,6,7,8)"},
        },
        text_config = {colour = G.C.UI.TEXT_DARK, scale = 0.3},
    }
    jd_def['j_delatro_prime_time'] = {
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            local a = true
            local b = true
            local c = true
            local d = true
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_hand or scoring_card.highlighted then
                        if scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 2 and a then
                            count = count + 3
                            a = false
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 3 and b then
                            count = count + 5
                            b = false
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 5 and c then
                            count = count + 7
                            c = false
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 7 and d then
                            count = count + 11
                            d = false
                        end
                    end 
                end
            end
            card.joker_display_values.count = count
            
        end,
        text = {
            {text = "+"},
            {ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "mult"}
        },
        text_config = {colour = G.C.MULT},
        reminder_text = {
            {text = "(2,3,5,7)"},
        },
        
    }

end