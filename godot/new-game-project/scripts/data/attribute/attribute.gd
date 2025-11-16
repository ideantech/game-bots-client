class_name Attribute extends Resource

enum AttributeType {
	ATTR_STRING,
	ATTR_FLOAT
}

var name: String
var value
var original_uid: String
var original_attributes
var root: DataRoot;
var attribute: Attribute

@export var attribute_type: AttributeType = AttributeType.ATTR_FLOAT
@export var base_value: float = 0.0
@export var base_string_value: String
@export var modifiers: Array[Modifier] = []

func initialize_resource():
	self.name = self.resource_name
	var temp_modifiers := self.modifiers
	self.modifiers.clear()
	for mod in temp_modifiers:
		self.add(mod)

func add(modifier: Modifier):
	modifier.attribute = self
	self.modifiers.push_back(modifier)
	self.sort()
	self.update()


func remove(modifier: Modifier):
	if not self.modifiers.has(modifier):
		return

	var index := self.modifiers.find(modifier)
	self.modifiers.remove_at(index)

func sort():
	self.modifiers.sort_custom(func (a, b):
		return a.priority < b.priority
	)

func update():
	var next_value = self.base_value
	if self.attribute_type == AttributeType.ATTR_STRING:
		next_value = self.base_string_value

	for mod in self.modifiers:
		next_value = mod.applyTo(next_value)

	self.value = next_value
