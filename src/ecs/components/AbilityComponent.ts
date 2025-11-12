import { LinkedComponent } from "tick-knock";
import { Ability, AbilityYield } from "../../ability/Ability";


export default class AbilityComponent extends LinkedComponent {

    base: Ability;
    generator: Generator<AbilityYield>;

    delay: number = 0;
    waitingForEvents: string[] = [];
}