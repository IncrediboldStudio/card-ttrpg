class_name Card

extends Area2D

@export var data: CardData
@export var title_path: String = "Background/Title"
@export var description_path: String = "Background/Description"

@onready var title: Label = get_node(description_path)
@onready var description: Label = get_node(description_path)

func _ready() -> void:
    set_text_from_data()

func _on_mouse_entered() -> void:
    scale = Vector2(1.05, 1.05)
    position += Vector2(0, -200)

func _on_mouse_exited() -> void:
    scale = Vector2(1.05, 1.05)
    position += Vector2(0, 200)
    
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
    
    
