class_name Character

extends Node

var card_deck : Array[Card]

func prepare_card(card: CardData) -> void:
    CardManager.on_prepare_card.emit(card)

func play_card(card: CardData) -> void:
    CardManager.on_play_card.emit(card)
