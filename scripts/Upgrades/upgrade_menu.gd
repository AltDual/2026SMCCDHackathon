extends CanvasLayer

signal upgrade_chosen(upgrade: UpgradeResource)

@onready var card1: Button = $Panel/HBoxContainer/Card1
@onready var card2: Button = $Panel/HBoxContainer/Card2
@onready var card3: Button = $Panel/HBoxContainer/Card3

var cards: Array[Button]
var offered_upgrades: Array[UpgradeResource] = []

func _ready() -> void:
	cards = [card1, card2, card3]
	visible = false

func show_upgrades(upgrades: Array[UpgradeResource]) -> void:
	offered_upgrades = upgrades
	for i in range(cards.size()):
		var card = cards[i]
		var upgrade = upgrades[i]
		# Update card UI — adjust node paths to match your scene
		card.get_node("Label").text = upgrade.upgrade_name
		card.get_node("Description").text = upgrade.description
		if upgrade.icon:
			card.get_node("Icon").texture = upgrade.icon
		card.pressed.connect(_on_card_pressed.bind(i), CONNECT_ONE_SHOT)
	visible = true
	get_tree().paused = true

func _on_card_pressed(index: int) -> void:
	get_tree().paused = false
	visible = false
	upgrade_chosen.emit(offered_upgrades[index])
