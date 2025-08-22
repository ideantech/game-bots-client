import Command from "./Command.ts";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";
import NetworkComponent from "../../ecs/components/NetworkMovementComponent.ts";

export default class SyncNetworkPositionCommand
    extends Command<GameRoomScene, { entityId: number, x: number, y: number, enableSync: boolean }> {

    execute(payload: this['payload']) {
        let localEntity = this.room.findLocalEntity(payload.entityId);
        if (!localEntity) return;

        const network = localEntity.get(NetworkComponent);
        if (network) {
            network.syncPosition = payload.enableSync;
            network.gameObject.setX(payload.x);
            network.gameObject.setY(payload.y);
        }
    }

}