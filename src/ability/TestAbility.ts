import { Entity } from "tick-knock";
import { Ability, AbilityYield } from "./Ability";
import AnimatorComponent from "../ecs/components/AnimatorComponent";
import MovementComponent from "../ecs/components/MovementComponent";
import { PlayerInputComponent } from "../ecs/components/PlayerInputComponent";

export default class TestAbility extends Ability {
    
    abilityLock: number;

    initialize(_entity: Entity): void {
        let player = <PlayerInputComponent> _entity.get(PlayerInputComponent);
        //this.abilityLock = player.abilityLock.lock(1);
    }

    cancel(entity: Entity) {
        let movement = <MovementComponent> entity.get(MovementComponent);
        let animator = <AnimatorComponent> entity.get(AnimatorComponent);
        movement.stop();
    }

    *run(_entity: Entity): Generator<AbilityYield> {
        let animator = <AnimatorComponent> _entity.get(AnimatorComponent);
        let movement = <MovementComponent> _entity.get(MovementComponent);
        let player = <PlayerInputComponent> _entity.get(PlayerInputComponent);

        //let lock = player.movementLock.lock(1);
        //let abilityLock = player.abilityLock.lock(1);

        console.log('attacking');
        animator.triggerAttack = true;
        console.log('setting impulse');
        movement.walk(1, 1);
        console.log('set');
        //yield this.delay(1);
        yield this.animationEvent('attack-2');
        console.log('done');
        movement.stop();

        //player.movementLock.unlock(lock);
        //player.abilityLock.unlock(this.abilityLock);
    }
    
}