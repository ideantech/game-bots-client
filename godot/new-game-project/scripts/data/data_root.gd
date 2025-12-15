class_name DataRoot extends Resource

static var EVENT_TICK: String = 'tick'

var events: DynamicSignalCollection = DynamicSignalCollection.new()
var signals: Utl_Signals
var attributes_map: Dictionary[String, Attribute] = {}

# todo: OPTIMIZATION: provide a dictionary backing and or ability to flatten to direct references
@export var attributes: Array[Attribute] = []
@export var packages: Array[Package] = []


func on(event: String, callable: Callable, flags: int = 0):
	if not has_user_signal(event):
		add_user_signal(event)
		
	connect(event, callable, flags)
	
func off(event: String, callable: Callable):
	if not has_user_signal(event): return
	
	disconnect(event, callable)

func emit(event: String, args):
	if not has_user_signal(event): return
	
	if args.size() == 0:
		emit_signal(event)
	elif args.size() == 1:
		emit_signal(event, args[0])

func initialize_resource():
	var temp_attributes = self.attributes
	for attr in temp_attributes:
		self.add_attribute(attr)

	var temp_packages = self.packages
	self.packages = []
	for pkg in temp_packages:
		self.add_package(pkg)

func get_attribute_value(name: String, def: Variant) -> Variant:
	var attr := self.find_attribute(name)
	if attr == null:
		return def
	return attr.value

func find_attribute(name: String) -> Attribute:
	var index = attributes.find_custom(func (a: Attribute):
		return a.name == name
	)
	if index == -1:
		return null
	return attributes[index]

func add_attribute(attr: Attribute):
	attr.root = self
	self.attributes.push_back(attr)
	self.attributes_map.set(attr.resource_name, attr);
	attr.update()
	pass

func add_attribute_as(attr: Attribute, name: String):
	attr.root = self
	attr.name = name
	self.attributes.push_back(attr)
	self.attributes_map.set(name, attr);
	attr.update()

func add_package(package: Package):
	package.root = self

	var regex = RegEx.new()
	regex.compile("@\\[(.*)\\]")

	# attributes
	for attr in package.attributes:
		var failed := false
		var add_as := attr.resource_name

		if attr.resource_name.begins_with('@'):
			continue

		for result in regex.search_all(attr.resource_name):
			var self_attr = package.find_attribute('@' + result.get_string(1))
			if self_attr == null:
				failed = true
				break

			var value_attr = self_attr.value
			add_as = add_as.replace('@[' + result.get_string(1) + ']', value_attr)

		if failed:
			continue

		self.add_attribute_as(attr, add_as)

	# package modifiers
	for mod in package.modifiers:
		mod.apply_to(self, package)
			

	self.packages.push_back(package)
