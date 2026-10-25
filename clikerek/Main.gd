extends Control

@onready var score_label: Label = $ScoreLabel
@onready var click_button: Button = $ClickButton
@onready var shop_panel: Panel = $CanvasLayer/ShopPanel
@onready var shop_button: Button = $CanvasLayer/ShopButton
@onready var close_button: Button = $CanvasLayer/ShopPanel/CloseButton
@onready var upgrades_container: VBoxContainer = $CanvasLayer/ShopPanel/ScrollContainer/VBoxContainer
@onready var prestige_button: Button = $CanvasLayer/ShopPanel/PrestigeButton
@onready var prestige_label: Label = $CanvasLayer/ShopPanel/PrestigePointsLabel

var all_upgrades: Array[UpgradeItem] = []

func _ready() -> void:
	GameManager.score_changed.connect(_update_ui)
	GameManager.stats_changed.connect(_update_stats_display) 
	
	click_button.pressed.connect(_on_click_pressed)
	shop_button.pressed.connect(_on_shop_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	prestige_button.pressed.connect(_on_prestige_button_pressed)
	
	shop_panel.visible = false
	close_button.visible = false
	shop_button.visible = true
	
	_define_upgrades()
	_populate_shop()
	_update_ui(GameManager.score)
	_update_stats_display()
	
	var prestige_label = Label.new()
	prestige_label.name = "PrestigePointsLabel"
	prestige_button.get_parent().add_child(prestige_label)
	prestige_label.position = prestige_button.position + Vector2(-120, 15)
	_update_prestige_display()

func _update_prestige_display():
	var label = shop_panel.get_node_or_null("PrestigePointsLabel")
	if label:
		label.text = "Pkt Prestiżu: " + str(GameManager.prestige_points)
		
func _define_upgrades():
	all_upgrades.append(UpgradeItem.new(1, "Słaby Składnik", "Mały pasywny przychód.", 10.0, 1.15, UpgradeItem.TYPE.PASSIVE_INCOME, 0.5, "res://Grafiki/Ulepszenia (przedmioty)/MaskaFreddy.png"))
	all_upgrades.append(UpgradeItem.new(2, "Miedziany Kocioł", "Lepszy pasywny przychód.", 50.0, 1.2, UpgradeItem.TYPE.PASSIVE_INCOME, 2.0, "res://Grafiki/Ulepszenia (przedmioty)/Puppet.png"))
	all_upgrades.append(UpgradeItem.new(3, "Mocniejsza Ręka", "Twoje kliknięcia liczą się podwójnie.", 100.0, 1.5, UpgradeItem.TYPE.CLICK_AMOUNT_FLAT, 1, "res://Grafiki/Ulepszenia (przedmioty)/PurpleGuy.png"))
	all_upgrades.append(UpgradeItem.new(5, "Lepszy Wzmacniacz", "Stały bonus do wartości kliknięcia.", 75.0, 1.2, UpgradeItem.TYPE.CLICK_VALUE_FLAT, 1.0))
	all_upgrades.append(UpgradeItem.new(6, "Błyskawiczny Mnożnik", "Każde kliknięcie jest o 10% mocniejsze.", 200.0, 1.3, UpgradeItem.TYPE.CLICK_VALUE_MULT, 0.1))

func _populate_shop():
	for child in upgrades_container.get_children():
		child.queue_free()
		
	for upgrade in all_upgrades:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(0, 90)
		
		var hbox = HBoxContainer.new()
		panel.add_child(hbox)
		
		var icon_rect = TextureRect.new()
		icon_rect.custom_minimum_size = Vector2(70, 70)
		icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if upgrade.icon_path != "":
			var tex = load(upgrade.icon_path)
			if tex:
				icon_rect.texture = tex
		hbox.add_child(icon_rect)
		
		var info_vbox = VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var name_label = Label.new()
		name_label.text = upgrade.item_name + " (Tier " + str(upgrade.item_tier) + ")"
		info_vbox.add_child(name_label)
		
		var status_label = Label.new()
		status_label.text = "Poziom: " + str(upgrade.level) + " | Koszt: " + str(snapped(upgrade.current_cost, 0.1))
		info_vbox.add_child(status_label)
		
		hbox.add_child(info_vbox)
		
		var buttons_vbox = VBoxContainer.new()
		
		var buy_btn = Button.new()
		buy_btn.text = "Kup"
		buy_btn.pressed.connect(_on_upgrade_bought.bind(upgrade, status_label))
		buttons_vbox.add_child(buy_btn)
		
		var evolve_btn = Button.new()
		evolve_btn.text = "Ulepsz Tier (" + str(upgrade.item_tier * 1) + " pkt)"
		evolve_btn.pressed.connect(func(): try_evolve_upgrade(upgrade))
		buttons_vbox.add_child(evolve_btn)
		
		hbox.add_child(buttons_vbox)
		
		upgrades_container.add_child(panel)

func _on_upgrade_bought(upgrade: UpgradeItem, status_label: Label):
	if upgrade.buy():
		status_label.text = "Poziom: " + str(upgrade.level) + " | Koszt: " + str(snapped(upgrade.current_cost, 0.1))
		_check_visual_unlocks(upgrade.id)

func _check_visual_unlocks(upgrade_id: int):
	match upgrade_id:
		1:
			if has_node("MaskaFreddySprite"):
				$MaskaFreddySprite.visible = true
		2:
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

func _on_prestige_button_pressed() -> void:
	if GameManager.score >= 10.0:
		GameManager.reset_for_prestige()
		
		for upgrade in all_upgrades:
			upgrade.level = 0
			upgrade.current_cost = upgrade.base_cost
			
		if has_node("MaskaFreddySprite"):
			$MaskaFreddySprite.visible = false
		if has_node("PuppetSprite"):
			$PuppetSprite.visible = false
		if has_node("PurpleGuySprite"):
			$PurpleGuySprite.visible = false
			
		_populate_shop()
		_update_ui(GameManager.score)
		_update_prestige_display()

func try_evolve_upgrade(upgrade: UpgradeItem):
	var cost_in_prestige = upgrade.item_tier * 1
	
	if GameManager.prestige_points >= cost_in_prestige:
		GameManager.prestige_points -= cost_in_prestige
		upgrade.evolve_tier()
		_populate_shop()
		_update_prestige_display()
		return true
	return false
