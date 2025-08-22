import NetworkMovementComponent from "../components/NetworkMovementComponent.ts";
import {Entity, EntitySnapshot, ReactionSystem} from "tick-knock";
import {getStateCallbacks, Room} from "colyseus.js";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";

export default class NetworkMovementSystem extends ReactionSystem {

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(NetworkMovementComponent);
        })
    }

    protected entityAdded = ({current}: EntitySnapshot) => {
        const network = current.get(NetworkMovementComponent) as NetworkMovementComponent;
        const entity = network.schema;
        const gameObject = network.gameObject;
        const scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;
        const $ = getStateCallbacks(scene.room as Room);

        gameObject.setX(entity.position.x);
        gameObject.setY(entity.position.y);

        network.removePositionCallback = $(entity.position).onChange(() => {
            if (network.syncPosition && !network.interpolate) {
                gameObject.setX(entity.position.x);
                gameObject.setY(entity.position.y);
            }
        });
    }

    public update(_dt: number) {
        const entities = this.entities;
        for (let i = 0; i < entities.length; i++) {
            const entity = entities[i];
            const network = entity.get(NetworkMovementComponent) as NetworkMovementComponent;
            const gameObject = network.gameObject;

            if (network.syncPosition && network.interpolate) {
                gameObject.x = Phaser.Math.Linear(gameObject.x, network.schema.position.x, network.interpolationTime);
                gameObject.y = Phaser.Math.Linear(gameObject.y, network.schema.position.y, network.interpolationTime);
            }
        }
    }

    protected entityRemoved = ({current}: EntitySnapshot) => {
        const network = current.get(NetworkMovementComponent) as NetworkMovementComponent;

        network.removePositionCallback()
    }
}