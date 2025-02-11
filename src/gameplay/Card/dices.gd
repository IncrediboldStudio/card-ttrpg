@tool
class_name Dices

extends Resource

enum Type{
    TYPELESS,
    WEAPON,
    PIERCING,
    SLASHING,
    BLUDGEONING,
    FIRE,
    ICE,
    ELECTRICITY,
    HEAL,
}

enum Dice{
    D4 = 4,
    D6 = 6,
    D8 = 8,
    D10 = 10,
    D12 = 12,
    D20 = 20,
}

@export var dices : Dice
@export var count : int
@export var type : Type
