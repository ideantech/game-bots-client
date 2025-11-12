import {Entity, EntitySnapshot, ReactionSystem} from "tick-knock";
import {PlayerInputComponent} from "../components/PlayerInputComponent.ts";
import GameRoomScene from "../../scenes/gameplay/GameRoomScene.ts";
import MovementComponent from "../components/MovementComponent.ts";
import TestAbility from "../../ability/TestAbility.ts";
import AbilityComponent from "../components/AbilityComponent.ts";
import LockGroup from "../../util/LockGroup.ts";
import { Ability } from "../../ability/Ability.ts";

export default class PlayerInputSystem extends ReactionSystem {

    cursorKeys: Phaser.Types.Input.Keyboard.CursorKeys;
    spaceKey: Phaser.Input.Keyboard.Key;


    inputCache = {
        left: false,
        right: false,
        up: false,
        down: false,
    };

    activeAbility: Ability | undefined;

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

    protected entityAdded = (entity: EntitySnapshot): void => {
        let input = <PlayerInputComponent> entity.current.get(PlayerInputComponent);
        input.movementId = input.movementLock.lock(0);
        input.abilityId = input.abilityLock.lock(0);
    }

    update(_dt: number) {
        const scene = this.sharedConfig.get(GameRoomScene) as GameRoomScene;

        for (let entity of this.entities) {
            const movement = <MovementComponent> entity.get(MovementComponent);
            const input = <PlayerInputComponent> entity.get(PlayerInputComponent);

            let x = 0, y = 0;
            if (input.movementLock.active == input.movementId) {
                if (this.cursorKeys.right.isDown) x += 1;
                if (this.cursorKeys.left.isDown) x -= 1;
                if (this.cursorKeys.up.isDown) y -= 1;
                if (this.cursorKeys.down.isDown) y += 1;

                //if (x != 0 || y != 0) movement.walk(x, y);
                //else movement.stop();
            }

            if (this.activeAbility == undefined) {
                if (this.spaceKey.isDown) {
                    console.log('adding');
                    var ability = new TestAbility();
                    this.activeAbility = ability;
                    var comp = new AbilityComponent();
                    comp.base = ability;
                    entity.append(comp);

                    ability.initialize(entity);
                }
            }
        }
    }
}