import {type Player} from "../../../../game-bots-server/src/rooms/schema/GameRoomState.ts";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";
import {getStateCallbacks} from "colyseus.js";


export default class PlayerSchemaHandler {

    static Configure(scene: GameRoomScene, player: Player) {
        const $ = getStateCallbacks(scene.room);

        $(player).listen('controlling', (value, _previousValue) => {
            console.log('now controlling:', value, '<-', _previousValue);
        });
    }

}