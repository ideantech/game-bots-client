import Condition from "./Condition";
import ConditionContext from "./ConditionContext";

export default class  AttributeValue extends Condition {

    constructor(
        public attr: string, 
        public value: number | string) {
        super();
    }

    evaluate(context: ConditionContext): boolean {
        if (this.attr.startsWith('@')) {
            const a = context.package.attributes.find(this.attr);
            if (!a || !a.value) return false;
            return a.value == this.value;
        }
        else {
            const a = context.root.attributes.find(this.attr);
            if (!a || !a.value) return false;
            return a.value == this.value;
        }
    }

    connect(context: ConditionContext): void {
        //throw new Error("Method not implemented.");
    }

    disconnect(context: ConditionContext): void {
        //throw new Error("Method not implemented.");
    }
    
}