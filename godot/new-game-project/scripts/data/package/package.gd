class_name Package extends Resource

var root: DataRoot

@export var attributes: Array[Attribute] = []
@export var modifiers: Array[PackageModifier] = []
@export var condition: Condition

func find_attribute(name: String) -> Attribute:
    var index = attributes.find_custom(func (a: Attribute):
        return a.resource_name == name
    )
    if index == -1:
        return null
    return attributes[index]

func set_root(r: DataRoot):
    self.root = r

    if self.condition != null:
        self.condition.on_root_updated()

func initialize_resource():
    if self.condition != null:
        self.condition.package = self
        self.condition.initialize_resource()