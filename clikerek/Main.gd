extends Control

@onready var score_label: Label = $ScoreLabel
@onready var click_button: Button = $ClickButton
@onready var shop_panel: Panel = $CanvasLayer/ShopPanel
@onready var shop_button: Button = $CanvasLayer/ShopButton
@onready var close_button: Button = $CanvasLayer/ShopPanel/CloseButton
@onready var upgrades_container: VBoxContainer = $CanvasLayer/ShopPanel/ScrollContainer/VBoxContainer

var all_upgrades: Array[UpgradeItem] = []

func _ready() -> void:
	GameManager.score_changed.connect(_update_ui)
	GameManager.stats_changed.connect(_update_stats_display) 
	
	click_button.pressed.connect(_on_click_pressed)
	shop_button.pressed.connect(_on_shop_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
	shop_panel.visible = false
	close_button.visible = false
	shop_button.visible = true
	
	_define_upgrades()
	_populate_shop()
	_update_ui(GameManager.score)
	_update_stats_display()

func _define_upgrades():
	
	# ==============================================================================
# 🛠️ INSTRUKCJA: JAK DODAĆ NOWE ULEPSZENIE (UPGRADE)
#    Dobrze wiesz że o tym zapomnisz to sam sobie potem podziękujesz
# ==============================================================================
# Wszystkie ulepszenia definiujemy w funkcji _define_upgrades() za pomocą:
# all_upgrades.append(UpgradeItem.new(ID, "Nazwa", "Opis", Koszt, Mnożnik, Typ, Wartość))
#
# Szczegółowy opis argumentów:
# 1. ID (int): Unikalny numer ulepszenia (np. 1, 2, 3...)
# 2. Nazwa (String): Wyświetlana nazwa ulepszenia na przycisku
# 3. Opis (String): Tekst widoczny w dymku (tooltip) po najechaniu myszką
# 4. Koszt bazowy (float): Cena zakupu ulepszenia na 0. poziomie
# 5. Mnożnik kosztu (float): O ile rośnie cena po każdym zakupie (np. 1.15 = +15%)
# 6. Typ efektu (UpgradeItem.TYPE): Wybierz z poniższych:
#    - TYPE.PASSIVE_INCOME      -> Zwiększa pasywny zarobek na sekundę
#    - TYPE.CLICK_VALUE_FLAT    -> Dodaje stałą wartość do każdego kliknięcia (np. +1.0)
#    - TYPE.CLICK_VALUE_MULT    -> Dodaje do mnożnika wartości kliknięcia (np. +0.1 = +10%)
#    - TYPE.CLICK_AMOUNT_FLAT   -> Zwiększa liczbę punktów/mnożnik ilości kliknięć (np. +1)
# 7. Wartość efektu (float): Siła bonusu aplikowana przy każdym zakupie
# 8. Ścieszka do ikonki
# ==============================================================================
	
	all_upgrades.append(UpgradeItem.new(1, "Słaby Składnik", "Mały pasywny przychód.", 10.0, 1.15, UpgradeItem.TYPE.PASSIVE_INCOME, 0.5, "res://Grafiki/Ulepszenia (przedmioty)/MaskaFreddy.png"))
	all_upgrades.append(UpgradeItem.new(2, "Miedziany Kocioł", "Lepszy pasywny przychód.", 50.0, 1.2, UpgradeItem.TYPE.PASSIVE_INCOME, 2.0, "res://Grafiki/Ulepszenia (przedmioty)/Puppet.png"))
	all_upgrades.append(UpgradeItem.new(3, "Mocniejsza Ręka", "Twoje kliknięcia liczą się podwójnie.", 100.0, 1.5, UpgradeItem.TYPE.CLICK_AMOUNT_FLAT, 1, "res://Grafiki/Ulepszenia (przedmioty)/PurpleGuy.png"))
	all_upgrades.append(UpgradeItem.new(5, "Lepszy Wzmacniacz", "Stały bonus do wartości kliknięcia.", 75.0, 1.2, UpgradeItem.TYPE.CLICK_VALUE_FLAT, 1.0))
	all_upgrades.append(UpgradeItem.new(6, "Błyskawiczny Mnożnik", "Każde kliknięcie jest o 10% mocniejsze.", 200.0, 1.3, UpgradeItem.TYPE.CLICK_VALUE_MULT, 0.1))

func _populate_shop():
	for upgrade in all_upgrades:
		var btn = Button.new()
		btn.name = "UpgradeButton_" + str(upgrade.id)
		btn.custom_minimum_size = Vector2(0, 60)
		btn.text = " " + upgrade.item_name + " - Poz. " + str(upgrade.level) + " (" + str(snapped(upgrade.current_cost, 0.1)) + ")"
		btn.tooltip_text = upgrade.description
		
		# Sprawdzenie i wczytanie ikony
		if upgrade.icon_path != "":
			var texture = load(upgrade.icon_path)
			if texture:
				btn.icon = texture
				btn.expand_icon = true
				print("Sukces: Załadowano ikonę dla ", upgrade.item_name)
			else:
				print("BŁĄD: Nie udało się załadować tekstury ze ścieżki: ", upgrade.icon_path)
		
		btn.pressed.connect(_on_upgrade_bought.bind(upgrade, btn))
		upgrades_container.add_child(btn)

func _on_upgrade_bought(upgrade: UpgradeItem, button_instance: Button):
	if upgrade.buy():
		button_instance.text = upgrade.item_name + " - Poz. " + str(upgrade.level) + " (" + str(snapped(upgrade.current_cost, 0.1)) + ")"
	_check_visual_unlocks(upgrade.id)
	
func _check_visual_unlocks(upgrade_id: int):
	match upgrade_id:
		1:
			# Jeśli kupiono ID 1 (Słaby Składnik / Maska Freddy'ego)
			if has_node("MaskaFreddySprite"):
				$MaskaFreddySprite.visible = true
		2:
			# Jeśli kupiono ID 2 (Miedziany Kocioł / Puppet itp.)
			if has_node("PuppetSprite"):
				$PuppetSprite.visible = true
		3:
			if has_node("PurpleGuySprite"):
				$PurpleGuySprite.visible = true

func _on_click_pressed() -> void:
	GameManager.handle_click()

func _update_ui(new_score: float) -> void:
	score_label.text = "Punkty: " + str(snapped(new_score, 0.1))

func _update_stats_display():
	pass

func _on_shop_button_pressed() -> void:
	shop_panel.visible = true
	close_button.visible = true
	shop_button.visible = false

func _on_close_button_pressed() -> void:
	shop_panel.visible = false
	close_button.visible = false
	shop_button.visible = true
