import { ReactionSystem } from "tick-knock/lib/ecs/ReactionSystem";
import RenderComponent from "../components/RenderCompnent";
import PositionComponent from "../components/PositionComponent";

export default class RenderSystem extends ReactionSystem {

    public constructor() {
        super((entity) => {
            return entity.hasAll(PositionComponent, RenderComponent)
        });
    }

    update(dt: number): void {
        
    }
    
}