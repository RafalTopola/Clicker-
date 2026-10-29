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
			if _item_tier == 2:
				item_name = "Puppet"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Puppet.png"
			elif _item_tier == 3:
				item_name = "Purple Guy"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/PurpleGuy.png"
		elif id == 2:
			if _item_tier == 2:
				item_name = "Global Elite"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/GlobalElite.png"
			elif _item_tier == 3:
				item_name = "Kurczak"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Kurczak.png"
		elif id == 3:
			if _item_tier == 2:
				item_name = "Batarang"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Batarang.png"
			elif _item_tier == 3:
				item_name = "Pierścień ZL"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/PierscienZL.png"
		elif id == 4:
			if _item_tier == 2:
				item_name = "Diamentowy Miecz"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/DiamentowyMiecz.png"
			elif _item_tier == 3:
				item_name = "Netherite Miecz"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/NetheriteMiecz.png"
		elif id == 5:
			if _item_tier == 2:
				item_name = "Płaszcz"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Plaszcz.png"
			elif _item_tier == 3:
				item_name = "Holocron"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Holocron.png"
		elif id == 6:
			if _item_tier == 2:
				item_name = "Atomówka"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Atomowka.png"
			elif _item_tier == 3:
				item_name = "Pip-Boy"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/PipBoy.png"
		elif id == 7:
			if _item_tier == 2:
				item_name = "SCP-096"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/SCP096.png"
			elif _item_tier == 3:
				item_name = "Identyfikator"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/IdentyfikatorSCP.png"
		elif id == 8:
			if _item_tier == 2:
				item_name = "Młot"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Mlot.png"
			elif _item_tier == 3:
				item_name = "Rękawica"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Rekawica.png"
		elif id == 9:
			if _item_tier == 2:
				item_name = "Figurka Fizza"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/FizzFigurka.png"
			elif _item_tier == 3:
				item_name = "Plecak"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Plecak.png"
		elif id == 10:
			if _item_tier == 2:
				item_name = "Red Space Marine"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/RedSpaceMarine.png"
			elif _item_tier == 3:
				item_name = "Horus Lupercal"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/HorusLupercal.png"
		elif id == 11:
			if _item_tier == 2:
				item_name = "Srebrny Miecz"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/SrebnyMiecz.png"
			elif _item_tier == 3:
				item_name = "Jednorożec"
				icon_path = "res://Grafiki/Ulepszenia (przedmioty)/Jednorozec.png"

# Gettory (Enkapsulacja)
func get_level() -> int:
	return _level

func get_current_cost() -> float:
	return _current_cost

func get_item_tier() -> int:
	return _item_tier
