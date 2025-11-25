class_name PackageAddModifier extends PackageModifier

@export var modifier: Modifier

func apply_to(root: DataRoot, _parent: Package):
	if modifier == null:
		return
	var attr = root.find_attribute(self.resource_name)
	if attr == null:
		return
	attr.add(modifier)
	
