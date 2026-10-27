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
	_update_prestige_display()
	
	var prestige_label = Label.new()
	prestige_label.name = "PrestigePointsLabel"
	prestige_button.get_parent().add_child(prestige_label)
	prestige_label.position = prestige_button.position + Vector2(-120, 15)
	_update_prestige_display()
	
	var debug_btn = Button.new()
	debug_btn.text = "+1000 Pkt (Test)"
	debug_btn.pressed.connect(func(): GameManager.add_score(1000.0))
	shop_panel.add_child(debug_btn)
	debug_btn.position = Vector2(20, 600)

func _update_prestige_display():
	var label = shop_panel.get_node_or_null("PrestigePointsLabel")
	if label:
		label.text = "Pkt Prestiżu: " + str(GameManager.prestige_points)

func _define_upgrades():
	all_upgrades.append(PassiveUpgrade.new(1, "Słaby Składnik", "Mały pasywny przychód.", 10.0, 1.15, 0.5, "res://Grafiki/Ulepszenia (przedmioty)/MaskaFreddy.png"))
	all_upgrades.append(PassiveUpgrade.new(2, "Miedziany Kocioł", "Lepszy pasywny przychód.", 50.0, 1.2, 2.0, "res://Grafiki/Ulepszenia (przedmioty)/AWP.png"))
	all_upgrades.append(ClickUpgrade.new(3, "Mocniejsza Ręka", "Twoje kliknięcia liczą się podwójnie.", 100.0, 1.5, 1, "res://Grafiki/Ulepszenia (przedmioty)/SuperMan.png", ClickUpgrade.CLICK_TYPE.AMOUNT))
	all_upgrades.append(ClickUpgrade.new(4, "Lepszy Wzmacniacz", "Stały bonus do wartości kliknięcia.", 75.0, 1.2, 1.0, "res://Grafiki/Ulepszenia (przedmioty)/KamiennyMiecz.png", ClickUpgrade.CLICK_TYPE.FLAT))
	all_upgrades.append(ClickUpgrade.new(5, "Błyskawiczny Mnożnik", "Każde kliknięcie jest o 10% mocniejsze.", 200.0, 1.3, 0.1, "res://Grafiki/Ulepszenia (przedmioty)/MieczSwietlny.png", ClickUpgrade.CLICK_TYPE.MULT))

func _populate_shop():
	for child in upgrades_container.get_children():
		child.queue_free()
		
	var tier_icons = {
		1: [
			"res://Grafiki/Ulepszenia (przedmioty)/MaskaFreddy.png",
			"res://Grafiki/Ulepszenia (przedmioty)/Puppet.png",
			"res://Grafiki/Ulepszenia (przedmioty)/PurpleGuy.png"
		],
		2: [
			"res://Grafiki/Ulepszenia (przedmioty)/AWP.png",
			"res://Grafiki/Ulepszenia (przedmioty)/GlobalElite.png",
			"res://Grafiki/Ulepszenia (przedmioty)/Kurczak.png"
		],
		3: [
			"res://Grafiki/Ulepszenia (przedmioty)/SuperMan.png",
			"res://Grafiki/Ulepszenia (przedmioty)/Batarang.png",
			"res://Grafiki/Ulepszenia (przedmioty)/PierscienZL.png"
		],
		4: [
			"res://Grafiki/Ulepszenia (przedmioty)/KamiennyMiecz.png",
			"res://Grafiki/Ulepszenia (przedmioty)/DiamentowyMiecz.png",
			"res://Grafiki/Ulepszenia (przedmioty)/NetheriteMiecz.png"
		],
		5: [
			"res://Grafiki/Ulepszenia (przedmioty)/MieczSwietlny.png",
			"res://Grafiki/Ulepszenia (przedmioty)/Plaszcz.png",
			"res://Grafiki/Ulepszenia (przedmioty)/Holocron.png"
		]
	}
		
	for upgrade in all_upgrades:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(0, 90)
		
		var hbox = HBoxContainer.new()
		panel.add_child(hbox)
		
		var icon_rect = TextureRect.new()
		icon_rect.custom_minimum_size = Vector2(70, 70)
		icon_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		var current_icon_path = upgrade.icon_path
		if tier_icons.has(upgrade.id):
			var icons_array = tier_icons[upgrade.id]
			var tier_index = clamp(upgrade._item_tier - 1, 0, icons_array.size() - 1)
			current_icon_path = icons_array[tier_index]
				
		if current_icon_path != "":
			var tex = load(current_icon_path)
			if tex:
				icon_rect.texture = tex
		hbox.add_child(icon_rect)
		
		var info_vbox = VBoxContainer.new()
		info_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var name_label = Label.new()
		name_label.text = upgrade.item_name + " (Tier " + str(upgrade.get_item_tier()) + ")"
		info_vbox.add_child(name_label)
		
		var status_label = Label.new()
		status_label.text = "Poziom: " + str(upgrade.get_level()) + " | Koszt: " + str(snapped(upgrade.get_current_cost(), 0.1))
		info_vbox.add_child(status_label)
		
		hbox.add_child(info_vbox)
		
		var buttons_vbox = VBoxContainer.new()
		
		var buy_btn = Button.new()
		buy_btn.text = "Kup"
		buy_btn.pressed.connect(_on_upgrade_bought.bind(upgrade, status_label))
		buttons_vbox.add_child(buy_btn)
		
		var evolve_btn = Button.new()
		if upgrade._item_tier < 3:
			evolve_btn.text = "Ulepsz Tier (" + str(upgrade._item_tier * 1) + " pkt)"
			evolve_btn.pressed.connect(func(): try_evolve_upgrade(upgrade))
		else:
			evolve_btn.text = "MAX TIER"
			evolve_btn.disabled = true
		buttons_vbox.add_child(evolve_btn)
		
		hbox.add_child(buttons_vbox)
		
		upgrades_container.add_child(panel)
		
func _on_upgrade_bought(upgrade: UpgradeItem, status_label: Label):
	if upgrade.buy():
		status_label.text = "Poziom: " + str(upgrade._level) + " | Koszt: " + str(snapped(upgrade._current_cost, 0.1))
		_check_visual_unlocks(upgrade.id)

func _check_visual_unlocks(upgrade_id: int, tier: int = 1):
	var u_level = 0
	for u in all_upgrades:
		if u.id == upgrade_id:
			u_level = u._level
			tier = u._item_tier
			break

	match upgrade_id:
		1:
			if has_node("MaskaFreddySprite"): $MaskaFreddySprite.visible = (u_level > 0 and tier == 1)
			if has_node("PuppetSprite"): $PuppetSprite.visible = (u_level > 0 and tier == 2)
			if has_node("PurpleGuySprite"): $PurpleGuySprite.visible = (u_level > 0 and tier == 3)
		2:
			if has_node("AWPSprite"): $AWPSprite.visible = (u_level > 0 and tier == 1)
			if has_node("GlobalEliteSprite"): $GlobalEliteSprite.visible = (u_level > 0 and tier == 2)
			if has_node("KurczakSprite"): $KurczakSprite.visible = (u_level > 0 and tier == 3)
		3:
			if has_node("SuperManSprite"): $SuperManSprite.visible = (u_level > 0 and tier == 1)
			if has_node("BatarangSprite"): $BatarangSprite.visible = (u_level > 0 and tier == 2)
			if has_node("PierscienZLSprite"): $PierscienZLSprite.visible = (u_level > 0 and tier == 3)
		4:
			if has_node("KamiennyMieczSprite"): $KamiennyMieczSprite.visible = (u_level > 0 and tier == 1)
			if has_node("DiamentowyMieczSprite"): $DiamentowyMieczSprite.visible = (u_level > 0 and tier == 2)
			if has_node("NetheriteMieczSprite"): $NetheriteMieczSprite.visible = (u_level > 0 and tier == 3)
		5:
			if has_node("MieczSwietlnySprite"): $MieczSwietlnySprite.visible = (u_level > 0 and tier == 1)
			if has_node("PlaszczSprite"): $PlaszczSprite.visible = (u_level > 0 and tier == 2)
			if has_node("HolocronSprite"): $HolocronSprite.visible = (u_level > 0 and tier == 3)
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
			upgrade.reset_upgrade()
			_check_visual_unlocks(upgrade.id, upgrade.get_item_tier())
			
		_populate_shop()
		_update_ui(GameManager.score)
		_update_prestige_display()

func try_evolve_upgrade(upgrade: UpgradeItem):
	if upgrade._item_tier >= 3:
		return false
		
	var cost_in_prestige = upgrade._item_tier * 1
	
	if GameManager.prestige_points >= cost_in_prestige:
		GameManager.prestige_points -= cost_in_prestige
		upgrade.evolve_tier()
		_check_visual_unlocks(upgrade.id, upgrade._item_tier)
		_populate_shop()
		_update_prestige_display()
		return true
	return false

func debug_inspect_upgrades():
	for upgrade in all_upgrades:
		# Sprawdzamy typ w czasie działania programu (Refleksja)
		print("Obiekt klasy: ", upgrade.get_class(), " | Nazwa: ", upgrade.item_name)

		# Pobieramy listę metod dostępnych w obiekcie (Refleksja)
		if upgrade.has_method("apply_effect"):
			print("-> Posiada metodę apply_effect()")
