import Condition from "./Condition";
import ConditionContext from "./ConditionContext";

export default class AnyOf extends Condition {
    
    constructor(public conditions: Condition[]) {
        super();
    }

    connect(context: ConditionContext): void {
        for (let cond of this.conditions) {
            cond.connect(context);
        }
    }

    disconnect(context: ConditionContext): void {
        for (let cond of this.conditions) {
            cond.disconnect(context);
        }
    }

    evaluate(context: ConditionContext): boolean {
        for (let cond of this.conditions) {
            if (cond.evaluate(context)) return true;
        }
        return false;
    }

}