class_name ConditionDuration extends Condition

@export var duration: int = -1
var _countUp: int = 0

var tickReg := SignalRegistration.new()

func initialize():
	self.tickReg.callable = self.on_tick

func evaluate() -> ConditionResult:
	return ConditionResult.ENABLE if self._countUp <= self.duration else ConditionResult.DISABLE

func on_root_updated():
	self.tickReg.release()
	self.on_event(DataRoot.EVENT_TICK, self.tickReg)
	
func handle_tick():
	self._countUp += 1
