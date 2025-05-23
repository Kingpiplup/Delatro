----------------------------------------------
------------MOD CODE -------------------------

local mod = SMODS.current_mod

SMODS.Atlas {key = 'Delatro1',path = 'Delatro1Sprites.png',px =71,py = 95}
SMODS.Atlas {key = 'modicon',path = 'modicon.png',px =32,py = 32}

SMODS.Joker{ -- Jambo 
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
            [1] = '{C:chips}+#1#{} Chips'
        }
    },
    config = { extra = { chips = 20 } },
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips}}
	end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
        return nil
    end
}
SMODS.Joker{ -- Raise
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
            [1] ='Gains {C:chips}+#2#{} Chips each hand played',
            [2] ="{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
        }
    },
    config = { extra = { chips = 0, chip_gain = 3 } },
    loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.chips,card.ability.extra.chip_gain}}
	end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
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
SMODS.Joker{ -- Mult
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
            [1] ='Retrigger {C:attention}first{}',
            [2] ='scored {C:attention}Mult Card{}',
            [3] ='an additional {C:attention}2 {}times'
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
SMODS.Joker{ -- Bonus
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
            [1] ='Each {C:attention}Bonus Card{} held in hand',
            [2] ='at end of round has {C:green}#3# in #2# {}',
            [3] ='chance to give {C:money}$#1#{}'
        }
    },
    config = { extra = { income = 2,odds = 2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return {vars = {card.ability.extra.income, card.ability.extra.odds,(G.GAME.probabilities.normal or 1)}}
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
SMODS.Joker{ -- Dance Recital
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
            [1] ='Retrigger each',
            [2] ='played {C:attention}5{}, {C:attention}6{}, {C:attention}7{}, or {C:attention}8{}'
        }
    },
    config = { extra = { repetitions = 1} },
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
             if context.other_card:get_id() >= 5 and context.other_card:get_id() <= 8 then
                return {
                    message = 'Again!',
                    repetitions = card.ability.extra.repetitions,
                    card = card,
                }
            end
        end
    end
}
SMODS.Joker{ -- Prime Time
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
            [1] ='Each {C:attention}Unique{} scored',
            [2] ='{C:attention}2{}, {C:attention}3{}, {C:attention}5{}, or {C:attention}7{} gives',
            [3] ='{C:mult}+3{}, {C:mult}+5{}, {C:mult}+7{} or {C:mult}+11{}',
            [4] ='Mult respectivly',
        }
    },
    config = { extra = {}},
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            local flags = { [2] = true, [3] = true, [5] = true, [7] = true }
            for _, played_card in ipairs(context.scoring_hand) do
                if flags[played_card:get_id()] then
                    flags[played_card:get_id()] = false
                    played_card.delatro_active_prime = true
                end
            end
            if context.individual and context.other_card.delatro_active_prime then
                local mults = { [2] = 3, [3] = 5, [5] = 7, [7] = 11 }
                return {mult = mults[context.other_card:get_id()]}
            end
        end
        if context.after then
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card.delatro_active_prime then played_card.delatro_active_prime = nil end
            end
        end
    end
}
SMODS.Joker{ -- Top 10
    name = 'Top 10',
    key = 'top_10',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=1,y=1},
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Top 10',
        text = {
            [1] ='Scored number cards',
            [2] ='give {C:chips}+#1#{} Chips',
        }
    },
    config = { extra = { chips = 12} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual then
            if context.other_card:get_id() >= 1 and context.other_card:get_id() <= 10 then
                return {
                    chips = card.ability.extra.chips,
                    card = card.other_card,
                }
            end
        end
    end
    
}
SMODS.Joker{ -- 7 Iris
    name = '7 Iris',
    key = '7_iris',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=2,y=1},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = '7 Iris',
        text = {
            [1] ='Each played {C:attention}7{} has a',
            [2] ='{C:green}#1# in #2#{} chance to',
            [3] ='level up played hand'
        }
    },
    config = { extra = { odds = 4 , handup = scoring_name} },
    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.individual then
            if context.other_card:get_id() == 7 and pseudorandom('7_iris') < G.GAME.probabilities.normal/card.ability.extra.odds then
                return {
                    message = 'Level Up!',
                    card = card,
                    level_up_hand(card, context.scoring_name, true, 1)
                }
            end
        end
    end
}
SMODS.Joker{ -- Consolidation
    name = 'Consolidation',
    key = 'consolidation',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=3,y=1},
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Consolidation',
        text = {
            [1] ='{C:money}+$#1#{} sell value at end of',
            [2] ='round, sells at {C:money}#2#x{} if',
            [3] ='{C:money}money{} is under {C:money}$1{}',
            [4] ='{C:inactive}(Starts at $0){}'

        }
    },
    config = { extra = { sell_inc = 1, sell_mult = 4, val = 0} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.sell_inc, card.ability.extra.sell_mult, card.ability.extra.val}}
    end,
    calculate = function(self,card,context)
        if card.ability.extra.val ~= card.sell_cost then
            card.ability.extra_value = (card.ability.extra_value or 0) + ((card.sell_cost - card.ability.extra.val)*(G.GAME.dollars < 1 and card.ability.extra.sell_mult-1 or 0))
            card:set_cost()
            card.ability.extra.val = card.sell_cost
        end
            if not context.blueprint then 
            if context.end_of_round and not context.individual and not context.repetition then
                card.ability.extra.val = (card.ability.extra.val or 0) + (card.ability.extra.sell_inc*(G.GAME.dollars < 1 and card.ability.extra.sell_mult or 1))
                card.ability.extra_value = (card.ability.extra_value or 0) + (card.ability.extra.sell_inc*(G.GAME.dollars < 1 and card.ability.extra.sell_mult or 1))
                card:set_cost()
                return {
                    message = ("Upgrade"),
                    colour = G.C.MONEY,
                    card = card,
                }
            end
            if context.selling_self then return{
                message = (G.GAME.dollars < 1 and {"4x!"} or {"1x"})[1],
                colour = G.C.MONEY,
                card = card,
            }end
            if context.delatro_ease_dollars then
                local CGD = G.GAME.dollars + context.delatro_ease_dollars
                if CGD < 1 then
                    if CGD - context.delatro_ease_dollars >= 1 then
                        card.ability.extra_value = (card.ability.extra_value or 0) + (card.sell_cost*(card.ability.extra.sell_mult-1))
                        card.ability.extra.val = (card.ability.extra.val or 0) + (card.sell_cost*(card.ability.extra.sell_mult-1))
                        card:set_cost() card:juice_up()
                    end
                else
                    if CGD - context.delatro_ease_dollars < 1 then
                        card.ability.extra_value = (card.ability.extra_value or 0) - ((card.ability.extra.sell_mult-1)*(card.sell_cost/card.ability.extra.sell_mult))
                        card.ability.extra.val = (card.ability.extra.val or 0) - ((card.ability.extra.sell_mult-1)*(card.sell_cost/card.ability.extra.sell_mult))
                        card:set_cost() card:juice_up()
                    end
                end    
            end
        end
    end,
    add_to_deck = function(self,card,from_debuff)
        card.ability.extra_value = -card.sell_cost
        card:set_cost()
    end
}
SMODS.Joker{ -- Divine Order
    name = 'Divine Order',
    key = 'divine_order',
    rarity = 3,
    atlas = 'Delatro1',
    pos = {x=4,y=1},
    cost = 9,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Divine Order',
        text = {
            [1] ='Creates a copy of {C:attention}1{} random',
            [2] ='{C:attention}consumable{} card in your',
            [3] ='possession if{C:attention} scoring hand{}',
            [4] ='contains three {C:attention}7s{}',
        }
    },
    config = { extra = { count = 0} },
    calculate = function(self,card,context)
        if context.before then
            for _, scoring_card in pairs(G.play.cards) do
                if scoring_card:get_id() == 7 then
                    card.ability.extra.count = card.ability.extra.count + 1
                end
            end
            if card.ability.extra.count >= 3 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        local card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('divine_order')), nil)
                        card:add_to_deck()
                        card:juice_up()
                        G.consumeables:emplace(card)
                        return true
                    end,
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,{ message = localize('k_duplicated_ex') })
            end
            card.ability.extra.count = 0
        end
    end   
}
SMODS.Joker{ -- Heap Leaching
    name = 'Heap Leaching',
    key = 'heap_leaching',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=0,y=2},
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = 'm_stone',
    loc_txt = {
        name = 'Heap Leaching',
        text = {
            [1] ='Scored {C:attention}Stone Cards{} have a {C:red}#5# in #3#{} chance',
            [2] ='to be destroyed. If destroyed: {C:green}#5# in #4#{}',
            [3] ='chance to increase {C:attention}Gold Card{}',
            [4] ='payout by {C:money}+$#1#{} {C:inactive}(Caps at $#6#){}'
        }
    },
    config = { extra = { inc = 1 , total = 0, break_odds = 2, leach_odds = 6, cap = 15} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        return {vars = {card.ability.extra.inc, card.ability.extra.total, card.ability.extra.break_odds,
                        card.ability.extra.leach_odds, (G.GAME.probabilities.normal or 1), card.ability.extra.cap
        }}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play then
            if context.other_card then
                if pseudorandom('heap_leaching') < G.GAME.probabilities.normal/card.ability.extra.break_odds and 
                SMODS.has_enhancement(context.other_card, "m_stone") and context.individual and not context.repetition then
                    context.other_card.marked_for_death = true
                    if pseudorandom('heap_leaching2') < G.GAME.probabilities.normal/card.ability.extra.leach_odds and G.P_CENTERS['m_gold'].config.h_dollars < 15 then
                        card.ability.extra.total = card.ability.extra.total + card.ability.extra.inc
                        if G.GAME.delatro_bonuses.delatro_gold_bonus == nil then
                            G.GAME.delatro_bonuses.delatro_gold_bonus = 3
                        end
                        G.GAME.delatro_bonuses.delatro_gold_bonus = G.GAME.delatro_bonuses.delatro_gold_bonus + card.ability.extra.inc
                        G.P_CENTERS['m_gold'].config.h_dollars = G.GAME.delatro_bonuses.delatro_gold_bonus
                        for k, v in pairs(G.playing_cards) do
                            if v.config.center == G.P_CENTERS['m_gold'] then
                                v.ability.h_dollars =  G.GAME.delatro_bonuses.delatro_gold_bonus
                            end
                        end
                        G.E_MANAGER:add_event(Event({func = function() card:juice_up() return true end}))
                        return {
                            message = 'Leached',
                            colour = G.C.MONEY,
                            card = context.other_card,
                        }
                    end
                    return {
                        message = 'Broken',
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                end
            end
            if context.destroy_card and context.destroy_card.marked_for_death then
                return {
                    remove = true
                }
            end
        end
    end
}
SMODS.Joker{ -- Stone Slag
    name = 'Stone Slag',
    key = 'stone_slag',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=1,y=2},
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = 'm_stone',
    loc_txt = {
        name = 'Stone Slag',
        text = {
            [1] ='Scored {C:attention}Stone Cards{} have a {C:red}#5# in #3#{} chance',
            [2] ='to be destroyed. If destroyed: {C:green}#5# in #4#{}',
            [3] ='chance to increase {C:attention}Steel Card{}',
            [4] ='Mult by {X:mult,C:white}X#1#{} Mult'
        }
    },
    config = { extra = { inc = 0.1 , total = 0, break_odds = 3, slag_odds = 5} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return {
            vars = {
                card.ability.extra.inc, card.ability.extra.total, card.ability.extra.break_odds, card.ability.extra.slag_odds, (G.GAME.probabilities.normal or 1)
                } 
            }
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play then
            if context.other_card then
                if pseudorandom('stone_slag') < G.GAME.probabilities.normal/card.ability.extra.break_odds and 
                SMODS.has_enhancement(context.other_card, "m_stone") and context.individual and not context.repetition then
                    context.other_card.marked_for_death = true
                    if pseudorandom('stone_slag2') < G.GAME.probabilities.normal/card.ability.extra.slag_odds then
                        card.ability.extra.total = card.ability.extra.total + card.ability.extra.inc
                        if G.GAME.delatro_bonuses.delatro_steel_bonus == nil then
                            G.GAME.delatro_bonuses.delatro_steel_bonus = 1.5
                        end
                        G.GAME.delatro_bonuses.delatro_steel_bonus = G.GAME.delatro_bonuses.delatro_steel_bonus + card.ability.extra.inc
                        G.P_CENTERS['m_steel'].config.h_x_mult = G.GAME.delatro_bonuses.delatro_steel_bonus
                        for k, v in pairs(G.playing_cards) do
                            if v.config.center == G.P_CENTERS['m_steel'] then
                                v.ability.h_x_mult =  G.GAME.delatro_bonuses.delatro_steel_bonus
                            end
                        end
                        G.E_MANAGER:add_event(Event({func = function() card:juice_up() return true end}))
                        return {
                            message = 'Slag',
                            colour = G.C.MONEY,
                            card = context.other_card,
                        }
                    end
                    return {
                        message = 'Broken',
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                end
            end
            if context.destroy_card and context.destroy_card.marked_for_death then
                return {
                    remove = true
                }
            end
        end
    end
}
SMODS.Joker{ -- Rebound Funds
    name = 'Rebound Funds',
    key = 'rebound_funds',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=2,y=2},
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Rebound Funds',
        text = {
            [1] = 'Gives {C:money}$#2#{} at end of round',
            [2] = 'Increases payout by {C:money}$#3#{} whenever {C:money}${} is',
            [3] = 'earned while owning {C:money}$#1#{} or less',
            [4] = '{C:inactive}(Resets each payout)'
        }
    },
    config = { extra = { thresh = 5, payout = 0, payout_inc = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.thresh, card.ability.extra.payout, card.ability.extra.payout_inc} }
    end,
    calculate = function(self,card,context)
        if not context.blueprint and G.GAME.dollars <= card.ability.extra.thresh and context.delatro_ease_dollars > 0 then
            card.ability.extra.payout = card.ability.extra.payout + card.ability.extra.payout_inc
            card:juice_up()
        end
    end,
    calc_dollar_bonus = function(self, card)
        local thunk = card.ability.extra.payout -- i saw this code in the extra credit mod and thought it was funny 
        card.ability.extra.payout = 0
        return thunk
    end,
}
SMODS.Joker{ -- Paycheck
    name = 'Paycheck',
    key = 'paycheck',
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=3,y=2},
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Paycheck',
        text = {
            [1] ='{C:money}+$#2#{} every {C:attention}#1#{}{C:inactive} (#3#){} hands played,',
            [2] ='increases by {C:money}$#4#{} every {C:attention}#5#{}{C:inactive} (#6#){}',
            [3] ='hands scoring a {C:attention}7{}',
        }
    },
    config = {extra = {hands_total = 14, payout = 10, c_hands = 0, payout_inc = 5, up_hands = 7, c_up_hands = 0}},
    loc_vars = function(self, info_queue, card)
        local c = card.ability.extra
        return { vars = {c.hands_total, c.payout, c.c_hands, c.payout_inc, c.up_hands, c.c_up_hands }}
    end,
    calculate = function(self,card,context)
        local c = card.ability.extra
        local bool = false
        if context.before then
            c.c_hands = c.c_hands + 1
            if c.c_hands == c.hands_total then
                c.c_hands = 0
                return{
                    dollars = c.payout,
                    message = "Paycheck!",
                    colour = G.C.MONEY,
                    card = card,
                }
            end
            for _, scoring_card in pairs(G.play.cards) do
                if scoring_card:get_id() == 7 and not scoring_card.debuff then
                    c.c_up_hands = c.c_up_hands + 1
                    if c.c_up_hands == c.up_hands then
                        c.c_up_hands = 0
                        c.payout = c.payout + c.payout_inc
                        return {
                            message = "Pay Raise",
                            colour = G.C.MONEY,
                            card = card,
                        }
                    else
                        return {
                            message = "Work Day",
                            colour = G.C.FILTER,
                            card = card,
                        }
                    end
                    break
                end
            end
        end
    end
} 
SMODS.Joker{ -- Red Joker
    name = 'Red Joker',
    key = 'red_joker',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=4,y=2},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Red Joker',
        text = {
            [1] ='{C:red}+#1#{} Mult for each',
            [2] ='card {C:attention}drawn{} to hand',
            [3] ='{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult){}'
        }
    },
    config = { extra = { mult_per_draw = 1, mult = 0, max_deck = (G.deck and G.deck.cards and #G.deck.cards) or 52 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_per_draw, card.ability.extra.mult
            } 
        }
    end,
    calculate = function(self,card,context)
        if context.setting_blind then
            card.ability.extra.max_deck = #G.deck.cards
        elseif context.end_of_round then
            card.ability.extra.mult = 0
        elseif context.hand_drawn and G.deck and G.deck.cards and #G.deck.cards > 0 then
            card.ability.extra.mult = card.ability.extra.mult_per_draw * (card.ability.extra.max_deck - #G.deck.cards)
        end
        if context.joker_main then
            return{
                mult_mod = card.ability.extra.mult,
                message = localize {type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                card = card,
            } 
        end
    end
}
SMODS.Joker{ -- Big Shot  (Potential Name Change)
    name = '[Big Shot]',
    key = 'big_shot',
    rarity = 1,
    atlas = 'Delatro1',
    pos = {x=0,y=3},
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = '[Big Shot]',
        text = {
            [1] ='{C:chips}+#2#{} Chips for each remaining {C:blue}hand{}',
            [2] ='{C:mult}+#1#{} Mult for each remaining {C:red}discard{}',
        }
    },
    config = { extra = { mult_per_discard = 3, chips_per_hand = 12}},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.mult_per_discard,card.ability.extra.chips_per_hand
            } 
        }
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return{
                mult = card.ability.extra.chips_per_hand*G.GAME.current_round.hands_left,
                chips = card.ability.extra.mult_per_discard*G.GAME.current_round.discards_left,
                card = card,
            } 
        end
    end

}
SMODS.Joker{ -- Loaded Dice
    name = 'Loaded Dice',
    key = 'loaded_dice',
    rarity = 3,
    atlas = 'Delatro1',
    pos = {x=1,y=3}, 
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Loaded Dice',
        text = {
            [1] ='#2#x all {C:attention}listed{}',
            [2] ='{C:green,E:1}Probabilities{}, {C:red,E:2}Increase{}',
            [3] ='all blind requirements by {C:green}#1#%{}',
            [4] ='{C:inactive}(+20% per probability chance){}'
        }
    },   
    config = { extra = { blind_chip_inc = 20, prob_inc = 3} },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                (card.ability.extra.blind_chip_inc * G.GAME.probabilities.normal) or 1, card.ability.extra.prob_inc
            } 
        }
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not context.blueprint then
            G.GAME.blind.chips = G.GAME.blind.chips*(card.ability.extra.blind_chip_inc*G.GAME.probabilities.normal/100 + 1)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            card:juice_up()
            return {
                message = "+" .. card.ability.extra.blind_chip_inc * G.GAME.probabilities.normal .. "%",
                card = card,
                colour = G.C.RED
            }           
        end
    end,
    add_to_deck = function(self,card,from_debuff) 
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v*card.ability.extra.prob_inc
        end
    end,
    remove_from_deck = function(self,card,from_debuff)
        for k, v in pairs(G.GAME.probabilities) do 
            G.GAME.probabilities[k] = v/card.ability.extra.prob_inc
        end
    end   
}
SMODS.Joker{ -- Red Print
    name = 'Redprint',
    key = 'redprint',
    rarity = 3,
    atlas = 'Delatro1',
    pos = {x=2,y=3},
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = 'Redprint',
        text = {
            [1] ='Coppies ability of ',
            [2] ='{C:attention}Joker{} to the left',
            [3] ='{B:1,C:white,s:0.8}#1#'
        }
    },   
    config = { extra = { desc = "", col = G.C.WHITE} },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.desc,
                colours = {
                    card.ability.extra.col,
                }
            } 
        }
    end,
    calculate = function(self,card,context)
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i-1] end
        end
        if other_joker and other_joker ~= card then
            context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
            context.blueprint_card = context.blueprint_card or card
            if context.blueprint > #G.jokers.cards + 1 then return end
            local other_joker_ret = other_joker:calculate_joker(context)
            if other_joker_ret then 
                other_joker_ret.card = context.blueprint_card or card
                other_joker_ret.colour = G.C.RED
                return other_joker_ret
            end
        end
    end,
    update = function(self, card, dt)
        if G.jokers and G.jokers.cards then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i-1] end
            end
            if other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat then
                card.blueprint_compat = true
                card.ability.extra.col = G.C.GREEN
                card.ability.extra.desc = 'Compatible'
            else
                card.blueprint_compat = false
                card.ability.extra.col = G.C.RED
                card.ability.extra.desc = 'Incompatible'
            end
        end
    end
}
SMODS.Joker{ -- Snake Eyes
    name = "Snake Eyes",
    key = "snake_eyes",
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=3,y=3},
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    loc_txt = {
        name = "Snake Eyes",
        text = {
            [1] ="Each scored card has a {C:green}#1# in #2#{}",
            [2] ="chance to retrigger {C:attention}#3#{} times",
        }
    },
    config = { extra = { retriggers = 2, odds = 6} },
    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.odds, card.ability.extra.retriggers,}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only and 
        pseudorandom('snake_eyes') < G.GAME.probabilities.normal/card.ability.extra.odds then
            return {
                message = 'Again!',
                repetitions = card.ability.extra.retriggers,
                card = card,
            }
        end
    end
}
SMODS.Joker{ -- Spawntaneity
    name = "Spawntaneity",
    key = "spawntaneity",
    rarity = 2,
    atlas = 'Delatro1',
    pos = {x=4,y=3},
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    unlocked = true,
    discovered = true,
    enhancement_gate = 'm_wild',
    loc_txt = {
        name = "Spawntaneity",
        text = {
            [1] = "Scored {C:attention}Wild{} cards have a {C:green}#1# in #2#{}",
            [2] = "chance to create a random {C:attention}consumable{}",
            [3] = "{C:inactive}(Must have space)",
        }
    },
    config = { extra = {odds = 6} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {(G.GAME.probabilities.normal or 1),card.ability.extra.odds}}
    end,
    calculate = function(self,card,context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only and 
        pseudorandom('spawntaneity') < G.GAME.probabilities.normal/card.ability.extra.odds then
            if SMODS.has_enhancement(context.other_card, "m_wild") and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                local rand = pseudorandom('spawntaneity2')
                local consume = (rand < 0.4 and {"Tarot"} or rand < 0.8 and {"Planet"} or {"Spectral"})[1]
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        local card = create_card(consume,G.consumeables, nil, nil, nil, nil, nil, 'spawntaneity')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end,
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil,{ message = localize('k_duplicated_ex') })
            end
        end
    end
}


--hook to make sure the game object is initialized with the delatro bonuses table
local IGO = Game.init_game_object
function Game.init_game_object(self)
    local ret = IGO(self)
    if ret.delatro_bonuses == nil then
        ret.delatro_bonuses = {}
    end
    return ret
end
-- hook to load the bonuses on run start or run continue
local SR = Game.start_run
function Game.start_run(self, args)
    local ret = SR(self, args)
    if G.GAME.delatro_bonuses then
        if G.GAME.delatro_bonuses.delatro_gold_bonus then
            G.P_CENTERS['m_gold'].config.h_dollars = G.GAME.delatro_bonuses.delatro_gold_bonus
        end
        if G.GAME.delatro_bonuses.delatro_steel_bonus then
            G.P_CENTERS['m_steel'].config.h_x_mult = G.GAME.delatro_bonuses.delatro_steel_bonus
        end
    end
    return ret
end
--hook to ease_dollars to get when dollars are altered
local ED = ease_dollars
function ease_dollars(mod, x)
    ED(mod, x)
    for i = 1, #G.jokers.cards do
        local effects = G.jokers.cards[i]:calculate_joker({ delatro_ease_dollars = mod})
    end
end

--[[
-- This is a test of the take_ownership function
SMODS.Enhancement:take_ownership('gold',{
    config = {extra = { h_dollars = 3 } },
        calculate = function(self, card, context)
             if context.cardarea == G.hand and context.individual and context.end_of_round and G.GAME.delatro_gold_bonus then
                return {
                    dollars = (card.ability.h_dollars or card.ability.h_dollars + G.GAME.delatro_gold_bonus) ,
                }
            end
        end        
    }
)]]

--[[
function loc_colour(_c,_default)
    G.ARGS.LOC_COLOURS = G.ARGS.LOCS_COLOURS or {
        red = G.C.RED,
        mult = G.C.MULT,
        blue = G.C.BLUE,
        chips = G.C.CHIPS,
        green = G.C.GREEN,
        money = G.C.MONEY,
        gold = G.C.GOLD,
        attention = G.C.FILTER,
        purple = G.C.PURPLE,
        white = G.C.WHITE,
        inactive = G.C.UI.TEXT_INACTIVE,
        spades = G.C.SUITS.SPADES,
        hearts = G.C.SUITS.HEARTS,
        clubs = G.C.SUITS.CLUBS,
        diamonds = G.C.SUITS.DIAMONDS,
        tarot = G.C.SECONDARY_SET.TAROT,
        planet = G.C.SECONDARY_SET.PLANET,
        spectral = G.C.SECONDARY_SET.SPECTRAL,
        edition = G.C.EDITION,
        dark_edition = G.C.DARK_EDITION,
        legendary = G.C.RARITY[4]
        enhanced = G.C.SECONDARY_SET.ENHANCED,
    }
        for _, v in ipairs(SMODS.Rarity.obj_buffer) do 
            G.ARGS.LOC_COLOURS[v:lower()] = G.C.RARITY[v]
        end
        for _, v in ipairs(SMODS.ConsumableType.ctype_buffer) do 
            G.ARGS.LOC_COLOURS[v:lower()] = G.C.SECONDARY_SET[v]
        end
        for _, v in ipairs(SMODS.Suit.obj_buffer) do 
            G.ARGS.LOC_COLOURS[v:lower()] = G.C.SUITS[v]
        end
    return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
    end
end
]]

if JokerDisplay then 
    local jd_def = JokerDisplay.Definitions
    jd_def['j_delatro_jambo'] = {
        text = {
            {text = "+"},
            {ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'chips'}
        },
        text_config = {colour = G.C.CHIPS},}
    jd_def['j_delatro_raise'] = {
        text = {
            {text = "+"},
            {ref_table = 'card.ability.extra', ref_value = 'chips', retrigger_type = 'chips'}
        },
        text_config = {colour = G.C.CHIPS},}
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
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds), card.ability.extra.odds } }
            card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
        end}
    jd_def['j_delatro_dance_recital'] = {
        text = {
            {text = "(5,6,7,8)"},
        },
        text_config = {colour = G.C.UI.TEXT_DARK, scale = 0.3},
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            return (playing_card:get_id() == 5 or playing_card:get_id() == 6 or
                    playing_card:get_id() == 7 or playing_card:get_id() == 8) and
                joker_card.ability.extra.repetitions * JokerDisplay.calculate_joker_triggers(joker_card) or 0
        end}
    jd_def['j_delatro_mult_joker'] = {
        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            local cardFound = nil
            local found = false
            for _, played_card in ipairs(scoring_hand) do
                if SMODS.has_enhancement(played_card, 'm_mult') then
                    found = true
                    cardFound = played_card
                    break
                end
            end
            return cardFound == playing_card and SMODS.has_enhancement(playing_card, 'm_mult') and found and JokerDisplay.calculate_joker_triggers(joker_card) * joker_card.ability.extra.repetitions or 0
        end}
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
                            count = count + (3 * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            a = false
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 3 and b then
                            count = count + (5 * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            b = false
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 5 and c then
                            count = count + (7 * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            c = false
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        elseif scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 7 and d then
                            count = count + (11 * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            d = false
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
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
    jd_def['j_delatro_top_10'] = {
        text = {
            {text = "+"},
            {ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'chips'}
        },
        text_config = {colour = G.C.CHIPS},
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local chips = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_hand or scoring_card.highlighted then
                        if scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() >= 1 and scoring_card:get_id() <= 10 then
                            chips = chips + (8 * JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                        end 
                    end 
                end
            end
            card.joker_display_values.chips = chips
        end}
    jd_def['j_delatro_7_iris'] = {  
        text = {
            { text = "+"},
            { ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "count" },
            { text = " Lvs",       scale = 0.35},
        },
        text_config = {scale = 0.35, colour = G.C.SECONDARY_SET.Planet},
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        reminder_text = {
            { text = "(7)" },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local count = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_card.facing and not (scoring_card.facing == 'back') and scoring_card:get_id() == 7 then
                        count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                    end
                end
            end
            card.joker_display_values.count = count
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds), card.ability.extra.odds } }
        end}
    jd_def['j_delatro_consolidation'] = {
        text = {
            {ref_table = "card.joker_display_values", ref_value = "selling_at"},
            {ref_table = "card.joker_display_values", ref_value = "sell_cost", colour = G.C.GOLD }    
        },
        text_config = { scale = 0.35 },
        reminder_text = {
            { text = "("},
            { text = "$", colour = G.C.GOLD },
            { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
            { text = ")" },
        },
        reminder_text_config = { scale = 0.35 },
        calc_function = function(card)
            if G.GAME.dollars < 1 then
                card.joker_display_values.sell_cost = "$" .. card.ability.extra.val
                card.joker_display_values.selling_at ="Selling at "
            else
                card.joker_display_values.sell_cost = ""
                card.joker_display_values.selling_at = ""
            end
        end}
    jd_def['j_delatro_divine_order'] = {
        reminder_text = {
            { text = "(7)" },
        },}
    jd_def['j_delatro_heap_leaching'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "mult" },
            { text = "x",                              scale = 0.35 },
            { text = "$",                              colour = G.C.GOLD },
            { ref_table = "card.ability.extra",        ref_value = "inc", colour = G.C.GOLD },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "leach_odds" },
                { text = ")" }
            },
            {
                { text = "(" ,colour = G.C.RED},
                { ref_table = "card.joker_display_values", ref_value = "break_odds" ,colour = G.C.RED},
                { text = ")" ,colour = G.C.RED},
            },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.25 },
        reminder_text = {
            { text = "(Leach: " },
            { ref_table = "card.joker_display_values", ref_value = "odds"},
            { text = ")" },

        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_hand or scoring_card.highlighted then
                        if scoring_card.facing and not (scoring_card.facing == 'back') and SMODS.has_enhancement(scoring_card, 'm_stone') then
                            count = count + (JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end 
                end
            end
            local minBO = math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.break_odds)
            local minLO = math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.leach_odds)
            card.joker_display_values.count = count
            card.joker_display_values.break_odds = localize { type = 'variable', key = "jdis_odds", vars = { minBO, card.ability.extra.break_odds } }
            card.joker_display_values.leach_odds = localize { type = 'variable', key = "jdis_odds", vars = { minLO, card.ability.extra.leach_odds } }
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = {(minBO * minLO), (card.ability.extra.break_odds * card.ability.extra.leach_odds)}}
        end}
    jd_def['j_delatro_stone_slag'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "mult" },
            { text = "x",                              scale = 0.35 },
            { 
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "inc" }
                }
            },
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "slag_odds" },
                { text = ")" }
            },
            {
                { text = "(" ,colour = G.C.RED},
                { ref_table = "card.joker_display_values", ref_value = "break_odds" ,colour = G.C.RED},
                { text = ")" ,colour = G.C.RED},
            },
        },
        extra_config = { colour = G.C.GREEN, scale = 0.25 },
        reminder_text = {
            { text = "(Slag: " },
            { ref_table = "card.joker_display_values", ref_value = "odds"},
            { text = ")" },

        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_hand or scoring_card.highlighted then
                        if scoring_card.facing and not (scoring_card.facing == 'back') and SMODS.has_enhancement(scoring_card, 'm_stone') then
                            count = count + (JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end 
                end
            end
            local minBO = math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.break_odds)
            local minSO = math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.slag_odds)
            card.joker_display_values.count = count
            card.joker_display_values.break_odds = localize { type = 'variable', key = "jdis_odds", vars = { minBO, card.ability.extra.break_odds } }
            card.joker_display_values.slag_odds = localize { type = 'variable', key = "jdis_odds", vars = { minSO, card.ability.extra.slag_odds } }
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = {(minBO * minSO), (card.ability.extra.break_odds * card.ability.extra.slag_odds)}}
        end}            
    jd_def['j_delatro_rebound_funds'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "payout",   retrigger_type = "mult" },
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "active",   retrigger_type = "mult" },
        },
        text_config = {colour = G.C.GOLD,},
        calc_function = function(card)
            if G.GAME.dollars < 1 then
                card.joker_display_values.active = "(Active)"
            else
                card.joker_display_values.active = ""
            end
        end}
    jd_def['j_delatro_red_joker'] = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult", retrigger_type = "mult" },
        },
        text_config = { colour = G.C.MULT },}
    jd_def['j_delatro_big_shot'] = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "mult",   retrigger_type = "mult" , colour = G.C.MULT},
            { text = " " },
            { ref_table = "card.joker_display_values", ref_value = "chips",   retrigger_type = "chips" , colour = G.C.CHIPS},
        },
        calc_function = function(card)
            card.joker_display_values.mult = "+" .. tostring(card.ability.extra.mult_per_discard * G.GAME.current_round.discards_left)
            card.joker_display_values.chips = "+" .. tostring(card.ability.extra.chips_per_hand * G.GAME.current_round.hands_left)
        end}
    jd_def['j_delatro_redprint'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "blueprint_compat", colour = G.C.RED },
            { text = ")" }
        },
        calc_function = function(card)
            local copied_joker, copied_debuff = JokerDisplay.calculate_blueprint_copy(card)
            card.joker_display_values.blueprint_compat = localize('k_incompatible')
            JokerDisplay.copy_display(card, copied_joker, copied_debuff)
        end,
        get_blueprint_joker = function(card)
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    return G.jokers.cards[i - 1]
                end
            end
            return nil
        end}
    jd_def['j_delatro_spawntaneity'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "count",   retrigger_type = "mult" },
        },
        text_config = {colour = G.C.EDITION,},
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ")" },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        reminder_text = {
            { text = "(Wild)"},
        },
        calc_function = function(card)
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local count = 0
            if text ~= 'Unknown' then
                for _, scoring_card in pairs(scoring_hand) do
                    if scoring_hand or scoring_card.highlighted then
                        if scoring_card.facing and not (scoring_card.facing == 'back') and SMODS.has_enhancement(scoring_card, 'm_wild') then
                            count = count + (JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand))
                            JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                        end
                    end 
                end
            end
            card.joker_display_values.count = count
            card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { math.min(G.GAME and G.GAME.probabilities.normal or 1, card.ability.extra.odds), card.ability.extra.odds } }
        end
    }


    end
