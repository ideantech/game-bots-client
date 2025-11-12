import { EntitySnapshot, ReactionSystem } from "tick-knock";
import AnimatorComponent from "../components/AnimatorComponent";
import MovementComponent from "../components/MovementComponent";

export default class AnimatorSystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.hasAll(AnimatorComponent, MovementComponent));
    }

    protected entityAdded = (entity: EntitySnapshot): void => {
        let animator = <AnimatorComponent> entity.current.get(AnimatorComponent);

        animator.watchFor.set('attack-2', () => {});
        animator.sprite.setData('animator', animator);

        if (animator.watchFor.size > 0) {
            animator.sprite.on(Phaser.Animations.Events.ANIMATION_START, this.animationEventHandler, this);
            animator.sprite.on(Phaser.Animations.Events.ANIMATION_UPDATE, this.animationEventHandler, this);
            animator.sprite.on(Phaser.Animations.Events.ANIMATION_COMPLETE, this.animationEventHandler, this);
        }
    }

    animationEventHandler(animation: Phaser.Animations.Animation, frame: Phaser.Animations.AnimationFrame, gameObject: Phaser.GameObjects.GameObject) {
        let key = animation.key + "-" + frame.index;
        let animator = <AnimatorComponent> gameObject.getData('animator');
        if (animator.watchFor.has(key)) {
            console.log('animation event:', key);
            animator.events.emit(key);
        }
    }

    update(dt: number): void {
        for (let entity of this.entities) {
            const movement = <MovementComponent> entity.get(MovementComponent);
            const animator = <AnimatorComponent> entity.get(AnimatorComponent);

            if (!animator._inAttack) {
                if (movement.mode == MovementComponent.NONE) {
                    animator.sprite.play('idle', true);
                }
                else {
                    animator.sprite.play('run', true);
                }

                if (movement.x < 0)
                    animator.sprite.flipX = true;
                else if (movement.x > 0)
                    animator.sprite.flipX = false;
            }

            if (animator.triggerAttack) {
                animator.sprite.play('attack', true);

                /*animator.sprite.on(Phaser.Animations.Events.ANIMATION_START, (animation, frame, object) => {
console.log(animation.key, frame.index);
                });

                animator.sprite.on(Phaser.Animations.Events.ANIMATION_UPDATE, (animation, frame, objnect) => {
                    console.log(animation.key, frame.index);
                });

                animator.sprite.on(Phaser.Animations.Events.ANIMATION_COMPLETE, () => {
                    animator.triggerAttack = false;
                    animator._inAttack = false;
                    //movement.frozen = false;
                });*/
                //movement.frozen = true;
                animator.triggerAttack = false;
                animator._inAttack = true;
            }
        }
    }

}