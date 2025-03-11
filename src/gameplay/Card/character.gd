class_name Character

extends Node

@export var card_deck : Array[CardData]
@export var manager : CardManager

func _ready() -> void:
    manager.fill_hand(card_deck)

#func prepare_card(card: CardData) -> void:
#    CardManager.on_prepare_card.emit(card)

#func play_card(card: CardData) -> void:
#    CardManager.on_play_card.emit(card)
