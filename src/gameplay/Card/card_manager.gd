extends Node

signal on_start_hover_card(card : Card)
signal on_end_hover_card(card : Card)
signal on_prepare_card(card : CardData)
signal on_play_card(card : CardData)

var current_card: Card
var hovered_cards: Array[Card]

func _ready() -> void:
    on_start_hover_card.connect(start_hover_card)
    on_end_hover_card.connect(end_hover_card)
    
func _process(delta: float) -> void:
    if current_card == null:
        return
        
    match current_card.current_state:
        Card.State.HOVERED:
            update_hovered_card()

func update_hovered_card() -> void:
    if hovered_cards.is_empty():
        return
    elif hovered_cards.size() == 1:
        if current_card == null:
            current_card = hovered_cards[0]
            current_card.set_state(Card.State.HOVERED)
        return
    
    var mouse_position: Vector2 = get_viewport().get_mouse_position()
    var shortest_distance: float = 1000
    var new_card: Card
    for card: Card in hovered_cards:
        var distance: float = abs(card.global_position.x - mouse_position.x)
        if distance < shortest_distance:
            shortest_distance = distance
            new_card = card
    if (new_card != current_card):
        current_card.set_state(Card.State.NONE)
        current_card = new_card
        current_card.set_state(Card.State.HOVERED)
    
func start_hover_card(card: Card) -> void:
    if card.current_state != Card.State.NONE:
        return

    hovered_cards.append(card)
    update_hovered_card()
    
func end_hover_card(card: Card) -> void:
    hovered_cards.erase(card)
    if current_card.current_state != Card.State.HOVERED:
        return
        
    if card == current_card:
        current_card.set_state(Card.State.NONE)
        current_card = null
        update_hovered_card()
