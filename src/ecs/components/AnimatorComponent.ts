import EventEmitter from "eventemitter3";

export type AnimationEventHandler = (animation: any, frame: any, object: any, entity: any) => void;

export default class AnimatorComponent {

    sprite: Phaser.GameObjects.Sprite;
    events = new EventEmitter();

    triggerAttack: boolean;

    _inAttack: boolean;

    watchFor = new Map<string, AnimationEventHandler>();
}