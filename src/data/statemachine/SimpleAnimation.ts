import AnimationStateMachine from "./AnimationStateMachine";
import { StateMachineInstance } from "./StateMachine";

export default class SimpleAnimation extends AnimationStateMachine {

    constructor() {
        super();
    }

    onEnterState(state: string, instance: StateMachineInstance): void {
        let sprite = <Phaser.GameObjects.Sprite> instance.context;
    }
}