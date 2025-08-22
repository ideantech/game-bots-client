import {Entity, ReactionSystem} from "tick-knock";
import {PlayerInputComponent} from "../components/PlayerInputComponent.ts";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";
import {ClientMessages} from "../../../../game-bots-server/src/communication/Messages.ts";

export default class PlayerInputSystem extends ReactionSystem {

    cursorKeys: Phaser.Types.Input.Keyboard.CursorKeys;

    inputCache = {
        left: false,
        right: false,
        up: false,
        down: false,
    };

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(PlayerInputComponent);
        });
    }

    onAddedToEngine() {
        super.onAddedToEngine();

        let scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;
        this.cursorKeys = scene.input.keyboard?.createCursorKeys() as Phaser.Types.Input.Keyboard.CursorKeys;
    }

    onRemovedFromEngine() {
    }

    update(_dt: number) {
        const scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;

        for (let i = 0; i < this.entities.length; i++) {
            //const entity = this.entities[i];

            this.inputCache.left = this.cursorKeys.left.isDown;
            this.inputCache.right = this.cursorKeys.right.isDown;
            this.inputCache.up = this.cursorKeys.up.isDown;
            this.inputCache.down = this.cursorKeys.down.isDown;

            //console.log(this.inputCache);
            scene.room.send(ClientMessages.PlayerInput, this.inputCache);

            break;
        }
    }
}