import { ReactionSystem } from "tick-knock";
import StateMachineComponent from "../components/StateMachineComponent";

export default class StateMachineSystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.has(StateMachineComponent));
    }

}