import Condition from "./Condition";
import ConditionContext from "./ConditionContext";

export default class AllOf extends Condition {

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
            if (!cond.evaluate(context)) return false;
        }
        return true;
    }
    
}