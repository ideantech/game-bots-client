class_name Condition
extends Resource

enum ConditionResult {
    ENABLE,
    DISABLE,
    NOACTION
}

var package: Package

func evaluate() -> ConditionResult:
    return ConditionResult.ENABLE

func on_event(event: String, reg: SignalRegistration, flags: int = 0):
    if self.package == null or self.package.root == null:
        return
    self.package.root.events.on(event, reg, flags)

func initialize_resource():
    pass
