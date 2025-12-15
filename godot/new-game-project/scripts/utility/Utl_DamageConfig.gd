class_name Utl_DamageConfig
extends RefCounted

var source: IndexNode
var target: IndexNode
var amount: int = 0
var type: int = 0
var hit_location: Vector2

var override_amount: bool = false
var override_apply: bool = false
var override_killed: bool = false
var override_vfx: bool = false
