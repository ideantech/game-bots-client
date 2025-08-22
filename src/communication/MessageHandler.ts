import {GameRoomScene} from "../scenes/gameplay/GameRoomScene.ts";
import {ServerMessages} from "../../../game-bots-server/src/communication/Messages.ts";
import Command from "./commands/Command.ts";
import SyncNetworkPositionCommand from "./commands/SyncNetworkPositionCommand.ts";

export default class MessageHandler {

    constructor(
        public scene: GameRoomScene
    ) {}

    configure() {
        this.scene.room.onMessage(ServerMessages.SyncPosition, (data) => {
            this.dispatch(new SyncNetworkPositionCommand(), { entityId: data.entityId, x: data.x, y: data.y, enableSync: data.enableSync});
        });
    }

    dispatch<T, K>(command: Command<T, K>, payload: K) {
        command.room = this.scene.room as T;
        command.payload = payload;
        command.execute(payload);
    }
}