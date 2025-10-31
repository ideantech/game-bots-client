import { ReactionSystem } from "tick-knock";
import AnimatorComponent from "../components/AnimatorComponent";
import MovementComponent from "../components/MovementComponent";

export default class AnimatorSystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.hasAll(AnimatorComponent, MovementComponent));
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
                animator.sprite.on(Phaser.Animations.Events.ANIMATION_COMPLETE, () => {
                    animator.triggerAttack = false;
                    animator._inAttack = false;
                    movement.frozen = false;
                });
                movement.frozen = true;
                animator.triggerAttack = false;
                animator._inAttack = true;
            }
        }
    }

}