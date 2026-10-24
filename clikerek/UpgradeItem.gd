extends RefCounted
class_name UpgradeItem

enum TYPE {PASSIVE_INCOME, CLICK_VALUE_FLAT, CLICK_VALUE_MULT, CLICK_AMOUNT_FLAT}

var id: int
var item_name: String
var description: String
var base_cost: float
var cost_multiplier: float
var effect_type: TYPE
var effect_value: float

var level: int = 0
var current_cost: float

func _init(_id: int, _name: String, _description: String, _cost: float, _mult: float, _type: TYPE, _value: float):
	self.id = _id
	self.item_name = _name
	self.description = _description
	self.base_cost = _cost
	self.cost_multiplier = _mult
	self.effect_type = _type
	self.effect_value = _value
	self.current_cost = _cost

func buy() -> bool:
	if GameManager.spend_score(current_cost):
		apply_effect()
		level += 1
		current_cost = base_cost * pow(cost_multiplier, level)
		return true
	return false

func apply_effect():
	match effect_type:
		TYPE.PASSIVE_INCOME:
			GameManager.add_passive_income(effect_value)
		TYPE.CLICK_VALUE_FLAT:
			GameManager.add_click_value_flat(effect_value)
		TYPE.CLICK_VALUE_MULT:
			GameManager.add_click_value_mult(effect_value)
		TYPE.CLICK_AMOUNT_FLAT:
			GameManager.add_click_amount_flat(int(effect_value))
