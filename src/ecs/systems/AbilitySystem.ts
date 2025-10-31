import { EntitySnapshot, LinkedComponent, ReactionSystem } from "tick-knock";
import AbilityComponent, { AbilityBase } from "../components/AbilityComponent";


export class AbilitySystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.hasAll(AbilityComponent));
    }

    protected entityAdded = (entity: EntitySnapshot) => {
        //entity.current.onComponentAdded.connect()
    }

    protected entityRemoved = (entity: EntitySnapshot) => {

    }

    update(dt: number): void {
        for (let entity of this.entities) {
            entity.iterate(AbilityComponent, (ability) => {
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
                else if (result.value.command == AbilityBase.ABILITY_DONE) {
                    ability.generator.return(undefined);
                    entity.pick(ability);
                }
                else if (result.value.command == AbilityBase.ABILITY_DELAY && result.value.args) {
                    ability.delay = <number> result.value.args[0];
                }
            });
        }
    }
}