import { Entity, EntitySnapshot, ReactionSystem } from "tick-knock";
import MovementComponent from "../components/MovementComponent";
import PositionComponent from "../components/PositionComponent";
import DataRoot from "../../data/model/DataRoot";
import Attribute from "../../data/model/attributes/Attribute";

export default class MovementSystem extends ReactionSystem {

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(PositionComponent, MovementComponent);
        });
    }

     protected entityAdded = (entity: EntitySnapshot) => {
        
        let movement = <MovementComponent> entity.current.get(MovementComponent);
        if (!movement?._speed) {
            let data = <DataRoot> entity.current.get(DataRoot);
            movement._speed = <Attribute<number>> data.attributes.find(DataRoot.ATTR_WALKSPEED);
        }

    }

    update(deltaSec: number): void {

        for (let entity of this.entities) {
            let movement = <MovementComponent> entity.get(MovementComponent);
            if (movement.frozen) continue;

            let position = <PositionComponent> entity.get(PositionComponent);
            let speed = movement._speed.value;

            if (movement.mode == MovementComponent.WALK) {
                let dx = position.transform.x + speed * deltaSec * movement.x;
                let dy = position.transform.y + speed * deltaSec * movement.y;
                position.transform.x = dx;
                position.transform.y = dy;
            }
            else if (movement.mode == MovementComponent.IMPULSE) {
                console.log('impulse');
                let dx = position.transform.x + movement.impulseCurrent * deltaSec * movement.x;
                let dy = position.transform.y + movement.impulseCurrent * deltaSec * movement.y;
                position.transform.x = dx;
                position.transform.y = dy;

                console.log(movement.impulseCurrent);

                let newImpulse = (1 - (movement.impulseDrag * deltaSec)) * movement.impulseCurrent;
                movement.impulseCurrent = newImpulse;
            }
        }
    }

}
