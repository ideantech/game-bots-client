import { Entity, LinkedComponent } from "tick-knock";



export declare type AbilityYield = {


    command: number;
    args?: any[];
}

export class AbilityBase {
    static ABILITY_DONE: number = 0;
    static ABILITY_DELAY: number = 1;

    *run(_entity: Entity): Generator<AbilityYield> {
    }
    
    done(): AbilityYield { return { command: AbilityBase.ABILITY_DONE }}
    delay(seconds: number): AbilityYield { return { command: AbilityBase.ABILITY_DELAY, args: [seconds] }}

}

export default class AbilityComponent extends LinkedComponent {

    base: AbilityBase;
    generator: Generator<AbilityYield>;

    delay: number = 0;

}