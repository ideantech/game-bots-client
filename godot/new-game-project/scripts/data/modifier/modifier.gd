class_name Modifier extends Resource

var attribute: Attribute

enum ModifierType {
	REPLACE,
	ADDITIVE,
	MULTIPLICATIVE,
	
	REPLACE_STRING,
	ADDITIVE_STRING,
	MULTIPLICATIVE_STRING
}

@export var mode: ModifierType = ModifierType.REPLACE
@export var priority:int = 0
@export var enabled: bool = true
@export var value: float
@export var string_value: String

func applyTo(_to):
	if mode == ModifierType.REPLACE:
		return value
	elif mode == ModifierType.ADDITIVE:
		return _to + value
	elif mode == ModifierType.MULTIPLICATIVE:
		return _to * value
	elif mode == ModifierType.REPLACE_STRING:
		return string_value
	elif mode == ModifierType.ADDITIVE_STRING:
		return _to + string_value
	return value
