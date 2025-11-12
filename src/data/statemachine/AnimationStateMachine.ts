import StateMachine, { StateMachineInstance } from "./StateMachine";

export class AnimationStateMachineContext {
    sprite: Phaser.GameObjects.Sprite;
}

export default class AnimationStateMachine extends StateMachine {

    onEnterState(state: string, instance: StateMachineInstance): void {
        (<AnimationStateMachineContext> instance.context).sprite.play(state);
    }

}
