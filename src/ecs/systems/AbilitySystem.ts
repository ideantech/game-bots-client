import { EntitySnapshot, LinkedComponent, ReactionSystem } from "tick-knock";
import AbilityComponent from "../components/AbilityComponent";
import { Ability } from "../../ability/Ability";
import AnimatorComponent from "../components/AnimatorComponent";


export class AbilitySystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.hasAll(AbilityComponent));
    }

    protected entityAdded = (entity: EntitySnapshot) => {
        //entity.current.onComponentAdded.connect()
    }

    protected entityRemoved = (entity: EntitySnapshot) => {

    }

    handleComponentRemoved(component: AbilityComponent) {
        // todo: if we were waiting for events, cleanup the handlers
    }

    handleAnimationEvent() {

    }

    update(dt: number): void {
        for (let entity of this.entities) {
            entity.iterate(AbilityComponent, (ability) => {

                ability.base.lifetime -= dt;
                if (ability.base.lifetime <= 0) {
                    console.log('!! ability timed out, cancelling');
                    ability.base.cancel(entity);
                    entity.pick(ability);
                }

                if (ability.waitingForEvents.length > 0) return;

                if (ability.generator == undefined) {
                    ability.generator = ability.base.run(entity);
                }

                // if the ability is delayed then check for timer expiration
                if (ability.delay > 0) {
                    ability.delay -= dt;
                    if (ability.delay > 0) return;
                }

                // run the ability
                let result = ability.generator.next();

                // check the result from the ability
                if (result.done == true) {
                    entity.pick(ability);
                }
                // done
                else if (result.value.command == Ability.ABILITY_DONE) {
                    ability.generator.return(undefined);
                    entity.pick(ability);
                }
                // ability wants a delay
                else if (result.value.command == Ability.ABILITY_DELAY && result.value.args) {
                    ability.delay = <number> result.value.args[0];
                }
                // ability wants to wait for an animation event
                else if (result.value.command == Ability.ABILITY_ANIMATION_EVENT) {
                    if (result.value.args) {
                        let event = <string> result.value.args[0];
                        let animator = <AnimatorComponent> entity.get(AnimatorComponent);

                        console.log('waiting for event:', event);
                        ability.waitingForEvents = [event];
                        animator.events.once(event, this.handleAnimationEvent, this);
                    }
                }
            });
        }
    }
}