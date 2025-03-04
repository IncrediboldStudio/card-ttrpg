class_name Card

extends Area2D

enum State{
    NONE,
    HOVERED,
    GRABBED,
    SELECTED,
}

@export var data: CardData
@export var title_path: String = "Background/Title"
@export var description_path: String = "Background/Description"

@onready var title: Label = get_node(title_path)
@onready var description: Label = get_node(description_path)

var current_state: State = State.NONE
var original_position: Vector2

func _ready() -> void:
    original_position = position
    set_text_from_data()

func _on_mouse_entered() -> void:
    CardManager.on_start_hover_card.emit(self)

func _on_mouse_exited() -> void:
    CardManager.on_end_hover_card.emit(self)
    
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is not InputEventMouseButton:
        return
    
    match current_state:
        State.HOVERED:
            if event.is_pressed():
                CardManager.on_grab_card.emit(self)
        State.GRABBED:
            if event.is_released():
                CardManager.on_release_card.emit(self)
    
func set_text_from_data() -> void:
    title.text = data.name

    var text: String = ""
    text += "Origin = " + data.Origin.find_key(data.origin) + "\n"
    text += "Range = " + str(data.range) + "\n"
    text += "Area = " + str(data.area) + "\n"
    
    for dice: Dices in data.dices:
        var min: int = dice.count
        var max: int = min * dice.dices
        text += str(min) + "-" + str(max) + " " + Dices.Type.find_key(dice.type) + "\n"
    
    description.text = text

func set_state(new_state: State) -> void:
    match new_state:
        State.NONE:
            position = original_position
            scale = Vector2(1, 1)
            z_index = 0
        State.HOVERED:
            scale = Vector2(1.05, 1.05)
            z_index = 1
        State.SELECTED:
            scale = Vector2(1.2, 1.2)
            
    current_state = new_state
    
func follow_mouse() -> void:
    position = get_global_mouse_position()
