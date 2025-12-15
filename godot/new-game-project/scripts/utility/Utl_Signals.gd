class_name Utl_Signals
extends RefCounted


signal weapon_raised()
signal weapon_lowered()
signal weapon_fired()
signal damaged(config: Utl_DamageConfig)
signal killed(config: Utl_DamageConfig)


# todo: to really make this work, need to invoke add_user_signal with the appropriate
#   argument definition, optimization for later
var signals: Dictionary[String, Signal] = {}

func get_event(event: String) -> Signal:
	return self.signals.get(event)

func emit(event: String, ... varargs):
	if not self.signals.has(event):
		return
	
	var sig := self.get_event(event)
	sig.emit.callv(varargs)

func on(event: String, registration: SignalRegistration, flags:int = 0):
	if not self.signals.has(event):
		self.signals.set(event, Signal())

	var sig := self.get_event(event)
	sig.connect(registration.callable, flags)
	registration.is_bound = true
	registration.sig = sig
	
func on2(event: String, callable: Callable, flags: int = 0):
	if not self.signals.has(event):
		self.signals.set(event, Signal(self, event))
		
	var sig: Signal = signals.get(event, null)
	#print(sig.is_null())
	sig.connect(callable, flags)
	
func off(event: String, callable: Callable):
	if not self.signals.has(event):
		return
	
	var sig := self.get_event(event)
	sig.disconnect(callable)

	if not sig.has_connections():
		self.signals.erase(event)
