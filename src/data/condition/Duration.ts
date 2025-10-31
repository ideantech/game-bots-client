import { EmptyCondition } from "./Condition";
import ConditionContext from "./ConditionContext";

export default class Duration extends EmptyCondition {
    
    countdown: number = 0;

    constructor(
        public seconds: number) {
        super();
    }

    tick() {
        this.countdown++;
    }

    connect(_context: ConditionContext): void {
        _context.root.events.on('tick', this.tick, this);
    }

    disconnect(_context: ConditionContext): void {
        _context.root.events.removeListener('tick', this.tick, this);
    }

    evaluate(_context: ConditionContext): boolean {
        return this.countdown < this.seconds;
    }

}