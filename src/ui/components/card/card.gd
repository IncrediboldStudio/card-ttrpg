class_name Card

extends Area2D

enum State{
    NONE,
    HOVERED,
    GRABBED,
    SELECTED,
    RESETTING,
}

const title_path: String = "Background/Foreground/Title"
const description_path: String = "Background/Foreground/Description"

var title: Label
var description: Label

var current_state: State = State.NONE
var card_manager: CardManager
var data: CardData
var original_position: Vector2
var tween: Tween

func bind(card_data: CardData, manager: CardManager) -> void:
    data = card_data
    title = get_node(title_path)
    description = get_node(description_path)
    set_text_from_data()
    original_position = position
    card_manager = manager

func _on_mouse_entered() -> void:
    card_manager.on_start_hover_card.emit(self)

func _on_mouse_exited() -> void:
    card_manager.on_end_hover_card.emit(self)
    
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is not InputEventMouseButton:
        return
    
    match current_state:
        State.HOVERED:
            if event.is_pressed():
                card_manager.on_grab_card.emit(self)
        State.GRABBED:
            if event.is_released():
                card_manager.on_release_card.emit(self)
    
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
    if tween:
        tween.kill()
    tween = get_tree().create_tween()
    
    match new_state:
        State.NONE:
            tween.tween_property(self, "scale", Vector2(1, 1), 0.05)
            z_index = 0
        State.HOVERED:
            tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.05)
            z_index = 1
        State.SELECTED:
            tween.tween_property(self, "position", Vector2(150, 300), 0.15)
            tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.05)
        State.RESETTING:
            tween.tween_property(self, "position", original_position, 0.15)
            tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
            tween.tween_callback(on_reset_complete)
        
    
    current_state = new_state
    
func follow_mouse() -> void:
    if tween:
        tween.kill()
        
    position = get_global_mouse_position()
    
func on_reset_complete() -> void:
    set_state(State.NONE)
