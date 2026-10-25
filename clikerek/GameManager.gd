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
		score += passive_income * delta
		score_changed.emit(score)

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
var prestige_points: int = 0
# Słownik przechowujący wyższe tiery ulepszeń, np. { id_ulepszenia: poziom_tieru }
var upgraded_tiers: Dictionary = {} 

func do_prestige():
	# 1. Warunek prestiżu (np. czy gracz ma odpowiednio dużo punktów na reset)
	if score < 1000: # Próg przykładowy, możesz dostosować
		return
		
	# 2. Przyznanie punktu/punktów prestiżu
	prestige_points += 1
	
	# 3. Reset standardowego postępu
	score = 0.0
	# (Wszystkie poziomy ulepszeń w tablicy all_upgrades też trzeba będzie wyzerować)
	
	score_changed.emit(score)
	

func reset_for_prestige():
	# Przyznajemy punkty prestiżu np. na podstawie tego, ile punktów gracz zdobył (np. 1 punkt za każde 1000 punktów)
	# Na razie dla testów możemy dać sztywno +1 punkt albo wyliczać z wzoru:
	var earned_points = int(score / 100.0) # Przykładowy próg do testów
	if earned_points < 1: 
		earned_points = 1 # Żeby zawsze coś wpadło przy teście
		
	prestige_points += earned_points
	print("Przyznano punktów prestiżu: ", earned_points, " | Łącznie: ", prestige_points)

	score = 0.0
	passive_income = 0.0  
	base_click_value = 1.0
	click_value_flat_bonus = 0.0  
	click_value_mult_bonus = 1.0 
	click_amount_bonus = 1       

	score_changed.emit(score)
