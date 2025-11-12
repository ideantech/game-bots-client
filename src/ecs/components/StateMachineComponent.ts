import { LinkedComponent } from "tick-knock";
import { StateMachineInstance } from "../../data/statemachine/StateMachine";

export default class StateMachineComponent extends LinkedComponent {

    constructor(
        public instance: StateMachineInstance
    ){
        super();
    }

}

