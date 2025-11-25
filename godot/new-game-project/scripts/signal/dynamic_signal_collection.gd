class_name DynamicSignalCollection
extends Object

var events: Dictionary[String, Signal] = {}

func get_event(event: String) -> Signal:
	return self.events.get(event)

func emit(event: String, ... varargs):
	if not self.events.has(event):
		return
	
	var sig := self.get_event(event)
	sig.emit.callv(varargs)

func on(event: String, registration: SignalRegistration, flags:int = 0):
	if not self.events.has(event):
		self.events.set(event, Signal())

	var sig := self.get_event(event)
	sig.connect(registration.callable, flags)
	registration.is_bound = true
	registration.sig = sig
	
func on2(event: String, callable: Callable, flags: int = 0):
	if not self.events.has(event):
		self.events.set(event, Signal())
		
	var sig := get_event(event)
	sig.connect(callable, flags)
	
func off(event: String, callable: Callable):
	if not self.events.has(event):
		return
	
	var sig := self.get_event(event)
	sig.disconnect(callable)

	if not sig.has_connections():
		self.events.erase(event)
