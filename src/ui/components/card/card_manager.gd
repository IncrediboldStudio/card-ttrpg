class_name CardManager

extends Control

signal on_start_hover_card(card : Card)
signal on_end_hover_card(card : Card)
signal on_grab_card(card : Card)
signal on_release_card(card : Card)
signal on_play_card(card : CardData)

@export var hand_position_path: String = "HandPosition"
@export var select_position_path: String = "SelectPosition"

@onready var hand_position: Control = get_node(hand_position_path)
@onready var select_position: Control = get_node(select_position_path)

const card_scene: PackedScene = preload("res://src/ui/components/card/card.tscn")

var current_card: Card
var selected_card: Card
var hovered_cards: Array[Card]

func _ready() -> void:
    on_start_hover_card.connect(start_hover_card)
    on_end_hover_card.connect(end_hover_card)
    on_grab_card.connect(grab_card)
    on_release_card.connect(release_card)
    
func fill_hand(cards_data: Array[CardData]) -> void:
    var card_count: int = cards_data.size()
    var current_card: int = 0

    for data: CardData in cards_data:
        var card: Card = card_scene.instantiate()
        var collision: CollisionShape2D = card.get_node("CollisionShape2D")
        var shape: Shape2D = collision.get_shape()
        var card_width: float = shape.get_rect().size.x
        card.position = hand_position.position - Vector2(card_width * 1.5, 0) + Vector2(card_width * current_card, 0)
        card.bind(data, self)
        add_child(card)
        current_card += 1
        
    
func _process(delta: float) -> void:
    if current_card == null:
        if hovered_cards.size() > 0:
            update_hovered_card()
        return
        
    match current_card.current_state:
        Card.State.HOVERED:
            update_hovered_card()
        Card.State.GRABBED:
            update_grabbed_card()

func update_hovered_card() -> void:
    if hovered_cards.is_empty():
        return
    elif hovered_cards.size() == 1:
        if current_card == null and hovered_cards[0].current_state == Card.State.NONE:
            set_hovered_card(hovered_cards[0])
        return
    
    var mouse_position: Vector2 = get_viewport().get_mouse_position()
    var shortest_distance: float = 1000
    var new_card: Card
    for card: Card in hovered_cards:
        var distance: float = abs(card.global_position.x - mouse_position.x)
        if distance < shortest_distance:
            shortest_distance = distance
            new_card = card
    if new_card == current_card or new_card.current_state != Card.State.NONE:
        return
    
    if current_card != null:
        current_card.set_state(Card.State.NONE)
    set_hovered_card(new_card)
        
func update_grabbed_card() -> void:
    current_card.follow_mouse()
    
func set_hovered_card(card: Card) -> void:
    current_card = card
    current_card.set_state(Card.State.HOVERED)
    
func start_hover_card(card: Card) -> void:
    if card == selected_card or card.current_state != Card.State.NONE:
        return

    hovered_cards.append(card)
    if current_card == null:
        set_hovered_card(card)
    
func end_hover_card(card: Card) -> void:
    hovered_cards.erase(card)
    if card.current_state != Card.State.HOVERED:
        return
        
    if card != current_card:
        return
        
    current_card.set_state(Card.State.NONE)
    current_card = null
    update_hovered_card()
        
func grab_card(card: Card) -> void:
    if card != current_card:
        return
        
    match current_card.current_state:
        Card.State.HOVERED:
            current_card.set_state(Card.State.GRABBED)
          
func release_card(card: Card) -> void:
    if card != current_card:
        return
    
    current_card = null
    
    var distance: float = card.original_position.y - card.position.y
    if distance < 200:
        card.set_state(Card.State.RESETTING)
    else:
        if selected_card != null:
            selected_card.set_state(Card.State.RESETTING)
        card.set_state(Card.State.SELECTED)
        selected_card = card
        hovered_cards.erase(card)
        
    update_hovered_card()
