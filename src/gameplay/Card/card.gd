@tool
extends Resource

class_name Card

enum ActionType{
    MOVE,
    INTERACT,
    ATTACK,
    BUFF,
    DEBUFF,
}

enum Origin{
    USER,
    TARGET,
}

@export var action_type := ActionType.MOVE:
    set(value):
        action_type = value
        notify_property_list_changed()
       
@export var origin : Origin
@export var range : int
@export var area : int
@export var dices : Array[Dices]

func _validate_property(property: Dictionary):
    if property.name in ["origin", "area", "dices"] and action_type == ActionType.MOVE:
        property.usage = PROPERTY_USAGE_NO_EDITOR
    if property.name in ["area", "dices"] and action_type == ActionType.INTERACT:
        property.usage = PROPERTY_USAGE_NO_EDITOR
