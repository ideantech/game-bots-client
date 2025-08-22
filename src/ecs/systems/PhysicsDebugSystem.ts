import {Entity, ReactionSystem} from "tick-knock";
import PhysicsDebugComponent from "../components/PhysicsDebugComponent.ts";

export default class PhysicsDebugSystem extends ReactionSystem {

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(PhysicsDebugComponent);
        });
    }

}