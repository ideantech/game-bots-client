import { Entity, ReactionSystem } from "tick-knock";
import MovementComponent from "../components/MovementComponent";
import PositionComponent from "../components/PositionComponent";

export default class MovementSystem extends ReactionSystem {

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(PositionComponent, MovementComponent);
        });
    }

    update(deltaSec: number): void {


        for (let entity of this.entities) {
            let movement = <MovementComponent> entity.get(MovementComponent);
            let position = <PositionComponent> entity.get(PositionComponent);
            let speed = 10;

            if (movement.mode == MovementComponent.WALK) {
                let dx = position.transform.x + speed * deltaSec * movement.x;
                let dy = position.transform.y + speed * deltaSec * movement.y;
                position.transform.x = dx;
                position.transform.y = dy;
            }
        }
    }

}
