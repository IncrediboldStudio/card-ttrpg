extends Node

class_name character

var card_deck : Array[Card]

func prepare_card(card: Card):
    CardManager.on_prepare_card.emit(card)

func play_card(card: Card):
    CardManager.on_play_card.emit(card)
