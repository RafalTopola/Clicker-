class_name ClickUpgrade
extends UpgradeItem

enum CLICK_TYPE { FLAT, MULT, AMOUNT }
var click_type: CLICK_TYPE

func _init(_id: int, _name: String, _desc: String, _cost: float, _mult: float, _power: float, _icon: String, _type: CLICK_TYPE):
	super(_id, _name, _desc, _cost, _mult, _power, _icon)
	click_type = _type

func apply_effect() -> void:
	match click_type:
		CLICK_TYPE.FLAT:
			GameManager.add_click_value_flat(base_power)
		CLICK_TYPE.MULT:
			GameManager.add_click_value_mult(base_power)
		CLICK_TYPE.AMOUNT:
			GameManager.add_click_amount_flat(int(base_power))
