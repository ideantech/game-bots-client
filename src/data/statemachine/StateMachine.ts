import EventEmitter from "eventemitter3";

export class StateMachineInstance {

    constructor(
        public stateMachine: StateMachine,
        public state: string,
        public context: any
    ) {
    }

    cancelTransition: boolean = false;

    trigger(name: string) {
        const key = this.state + '->' + name;
        if (!this.stateMachine.states.has(key)) return;

        let next = this.stateMachine.states.get(key);
        if (next == undefined) return;

        this.cancelTransition = false;

        this.onTransition(this.state, next);
        if (this.cancelTransition) return;

        this.onExitState(this.state);
        this.state = next;
        this.onEnterState(this.state);
    }

    onEnterState(entering: string) {
        this.stateMachine.onEnterState(entering, this);
    }

    onUpdate(state: string) {}

    onTransition(from: string, to: string) {
        this.stateMachine.onTransition(from, to, this);
    }

    onExitState(exiting: string) {
        this.stateMachine.onExitState(exiting, this);
    }

}

export default class StateMachine {

    events = new EventEmitter();
    start: string;
    states = new Map<string, string>();
    instances = new Map<number, any>();

    newInstance(data: any, preAllocated?: StateMachineInstance): StateMachineInstance {
        if (preAllocated) {
            preAllocated.stateMachine = this;
            preAllocated.state = this.start;
            return preAllocated;
        }
        else {
            return new StateMachineInstance(this, this.start, data);
        }
    }

    onEnterState(state: string, instance: StateMachineInstance) {
        this.events.emit('enter-state-' + state, instance);
    }

    onTransition(from: string, to: string, instance: StateMachineInstance) {
        this.events.emit('transition-' + from + '-' + to, instance);
    }

    onExitState(state: string, instance: StateMachineInstance) {
        this.events.emit('exit-state-' + state, instance);
    }
}