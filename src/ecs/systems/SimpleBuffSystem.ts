import { ReactionSystem } from "tick-knock";
import SimpleBuffComponent from "../components/SimpleBuffComponent";
import Package from "../../data/model/packages/Package";
import Modifier from "../../data/model/modifiers/Modifier";

export default class SimpleBuffSystem extends ReactionSystem {

    constructor() {
        super((entity) => entity.hasAll(SimpleBuffComponent));
    }

    update(dt: number): void {
        for (let entity of this.entities) {
            entity.iterate(SimpleBuffComponent, (buff) => {
                if (buff.duration > 0) {
                    buff.countdown += dt;

                    if (buff.countdown > buff.duration) {
                        if (buff.target instanceof Package) {
                            (<Package> buff.target).setEnabled(false);
                        }
                        else if (buff.target instanceof Modifier) {
                            (<Modifier<any>> buff.target).enabled = false;
                        }

                        entity.pick(buff);
                    }
                }
            });
        }
    }

}