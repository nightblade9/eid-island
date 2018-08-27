extends CanvasLayer

func _ready():
	SignalManager.connect("wood_changed", self, "_update_wood_count")
	SignalManager.connect("coins_changed", self, "_update_coins_count")

func _update_wood_count(total_wood):
	$Sprite2/WoodLabel.text = "x " + str(total_wood)

func _update_coins_count(total_coins):
	$Sprite/CoinsLabel.text = "x " + str(total_coins)