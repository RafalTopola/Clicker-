class_name UpgradeItem
extends RefCounted

static var total_upgrades_created: int = 0

var id: int
var item_name: String
var description: String
var base_cost: float
var cost_multiplier: float
var base_power: float
var icon_path: String 

var _level: int = 0
var _current_cost: float
var _item_tier: int = 1

func _init(_id: int, _name: String, _description: String, _cost: float, _mult: float, _power: float, _icon: String = ""):
	assert(_cost >= 0.0, "Koszt ulepszenia nie może być ujemny!")
	self.id = _id
	self.item_name = _name
	self.description = _description
	self.base_cost = _cost
	self.cost_multiplier = _mult
	self.base_power = _power
	self.icon_path = _icon
	self._current_cost = _cost
	UpgradeItem.total_upgrades_created += 1

# Metoda wirtualna do nadpisania w klasach potomnych (Polimorfizm)
func apply_effect():
	pass

func buy() -> bool:
	if GameManager.spend_score(_current_cost):
		apply_effect()
		_level += 1
		_current_cost = base_cost * pow(cost_multiplier, _level)
		return true
	return false

func reset_upgrade():
	_level = 0
	_current_cost = base_cost

func evolve_tier():
	if _item_tier < 3:
		_item_tier += 1
		base_power *= 2.0
		
		if id == 1:
			if _item_tier == 2: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Puppet.png"
			elif _item_tier == 3: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/PurpleGuy.png"
		elif id == 2:
			if _item_tier == 2: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/GlobalElite.png"
			elif _item_tier == 3: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Kurczak.png"
		elif id == 3:
			if _item_tier == 2: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Batarang.png"
			elif _item_tier == 3: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/PierscienZL.png"
		elif id == 4:
			if _item_tier == 2: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/DiamentowyMiecz.png"
			elif _item_tier == 3: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/NetheriteMiecz.png"
		elif id == 5:
			if _item_tier == 2: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Plaszcz.png"
			elif _item_tier == 3: icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Holocron.png"

# Gettory (Enkapsulacja)
func get_level() -> int:
	return _level

func get_current_cost() -> float:
	return _current_cost

func get_item_tier() -> int:
	return _item_tier
