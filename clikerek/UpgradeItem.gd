extends RefCounted
class_name UpgradeItem

enum TYPE {PASSIVE_INCOME, CLICK_VALUE_FLAT, CLICK_VALUE_MULT, CLICK_AMOUNT_FLAT}

var id: int
var item_name: String
var description: String
var base_cost: float
var cost_multiplier: float
var effect_type: TYPE
var base_power: float
var icon_path: String 

var level: int = 0
var current_cost: float
var item_tier: int = 1

func _init(_id: int, _name: String, _description: String, _cost: float, _mult: float, _type: TYPE, _power: float, _icon: String = ""):
	self.id = _id
	self.item_name = _name
	self.description = _description
	self.base_cost = _cost
	self.cost_multiplier = _mult
	self.effect_type = _type
	self.base_power = _power
	self.icon_path = _icon
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
			GameManager.add_passive_income(base_power)
		TYPE.CLICK_VALUE_FLAT:
			GameManager.add_click_value_flat(base_power)
		TYPE.CLICK_VALUE_MULT:
			GameManager.add_click_value_mult(base_power)
		TYPE.CLICK_AMOUNT_FLAT:
			GameManager.add_click_amount_flat(int(base_power))

func evolve_tier():
	item_tier += 1
	base_power *= 2.0 # Każdy tier podwaja skuteczność bazową ulepszenia!
