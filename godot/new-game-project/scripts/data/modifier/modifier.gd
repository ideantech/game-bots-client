class_name Modifier extends Resource

var attribute: Attribute

enum ModifierType {
    REPLACE,
    ADDITIVE,
    MULTIPLICATIVE
}

@export var mode: ModifierType = ModifierType.REPLACE
@export var priority:int = 0
@export var enabled: bool = true
@export var value: float
@export var string_value: String

func applyTo(_to):
    if string_value != null:
        return string_value
    return value