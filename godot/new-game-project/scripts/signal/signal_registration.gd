class_name SignalRegistration extends Object

var is_bound: bool = false
var callable: Callable
var sig: Signal

func release():
	if not self.is_bound:
		return
	
	self.sig.disconnect(callable)
	self.is_bound = false
