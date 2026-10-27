class_name PassiveUpgrade
extends UpgradeItem

# Przesłonięcie metody apply_effect (Polimorfizm)
func apply_effect() -> void:
	GameManager.add_passive_income(base_power)
