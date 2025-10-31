import ConditionContext from "./ConditionContext";

export default abstract class Condition {

    abstract evaluate(context: ConditionContext): boolean;
    abstract connect(context: ConditionContext): void;
    abstract disconnect(context: ConditionContext): void;

}

export class EmptyCondition extends Condition {
    evaluate(_context: ConditionContext): boolean {
        return false;
    }

    connect(_context: ConditionContext): void {
    }

    disconnect(_context: ConditionContext): void {
    }

}