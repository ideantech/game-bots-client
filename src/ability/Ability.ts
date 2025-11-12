import { Entity } from "tick-knock";

export declare type AbilityYield = {
    command: number;
    args?: any[];
}

export class Ability {
    static ABILITY_DONE: number = 0;
    static ABILITY_DELAY: number = 1;
    static ABILITY_ANIMATION_EVENT: number = 2;

    lifetime: number = 5;

    initialize(_entity: Entity) {}

    *run(_entity: Entity): Generator<AbilityYield> {
    }
    
    cancel(_entity: Entity) {
    }

    done(): AbilityYield { return { command: Ability.ABILITY_DONE }}
    delay(seconds: number): AbilityYield { return { command: Ability.ABILITY_DELAY, args: [seconds] }}
    animationEvent(event: string) { return { command: Ability.ABILITY_ANIMATION_EVENT, args: [event] }}
    
}