extends Node

signal score_changed(new_score)
signal stats_changed # Sygnał informujący UI, że statystyki się zmieniły (np. dochód na sek)

var score: float = 0.0
var base_click_value: float = 1.0
var click_value_flat_bonus: float = 0.0
var click_value_mult_bonus: float = 1.0 # Mnożnik (1.0 = x1)
var click_amount_bonus: int = 1 # Ilość kliknięć (np. x2)

var passive_income: float = 0.0

func _process(delta: float) -> void:
	if passive_income > 0.0:
		add_score(passive_income * delta)

# Funkcja wywoływana przez przycisk klikania
func handle_click():
	# Składamy wartość jednego kliknięcia
	var single_click_value = (base_click_value + click_value_flat_bonus) * click_value_mult_bonus
	
	# Mnożymy przez ilość kliknięć (np. double click)
	var final_click_score = single_click_value * click_amount_bonus
	
	add_score(final_click_score)

func add_score(amount: float) -> void:
	score += amount
	score_changed.emit(score)

func spend_score(amount: float) -> bool:
	if score >= amount:
		score -= amount
		score_changed.emit(score)
		return true
	return false

# Funkcje wywoływane przez UpgradeItem do aplikowania efektów
func add_passive_income(value: float):
	passive_income += value
	stats_changed.emit()

func add_click_value_flat(value: float):
	click_value_flat_bonus += value
	stats_changed.emit()

func add_click_value_mult(value: float):
	click_value_mult_bonus += value # Np. +0.1 do mnożnika
	stats_changed.emit()

func add_click_amount_flat(value: int):
	click_amount_bonus += value # Np. +1 do ilości (z x1 na x2)
	stats_changed.emit()
