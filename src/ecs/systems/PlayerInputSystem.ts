import {Entity, ReactionSystem} from "tick-knock";
import {PlayerInputComponent} from "../components/PlayerInputComponent.ts";
import GameRoomScene from "../../scenes/gameplay/GameRoomScene.ts";
import {ClientMessages} from "../../../../game-bots-server/src/communication/Messages.ts";
import MovementComponent from "../components/MovementComponent.ts";
import AnimatorComponent from "../components/AnimatorComponent.ts";

export default class PlayerInputSystem extends ReactionSystem {

    cursorKeys: Phaser.Types.Input.Keyboard.CursorKeys;
    spaceKey: Phaser.Input.Keyboard.Key;

    inputCache = {
        left: false,
        right: false,
        up: false,
        down: false,
    };

    public constructor() {
        super((entity: Entity) => {
            return entity.hasAll(PlayerInputComponent, MovementComponent);
        });
    }

    onAddedToEngine() {
        super.onAddedToEngine();

        let scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;
        this.cursorKeys = scene.input.keyboard?.createCursorKeys() as Phaser.Types.Input.Keyboard.CursorKeys;
        this.spaceKey = <Phaser.Input.Keyboard.Key> scene.input.keyboard?.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE, true);
    }

    onRemovedFromEngine() {
    }

    update(_dt: number) {
        const scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;

        for (let entity of this.entities) {
            const movement = <MovementComponent> entity.get(MovementComponent);

            let x = 0, y = 0;
            if (this.cursorKeys.right.isDown) x += 1;
            if (this.cursorKeys.left.isDown) x -= 1;
            if (this.cursorKeys.up.isDown) y -= 1;
            if (this.cursorKeys.down.isDown) y += 1;

            if (x != 0 || y != 0) movement.walk(x, y);
            else movement.stop();

            /*if (this.spaceKey.isDown) {
                const animator = <AnimatorComponent> entity.get(AnimatorComponent);
                animator.triggerAttack = true;
            }*/
        }
    }
}