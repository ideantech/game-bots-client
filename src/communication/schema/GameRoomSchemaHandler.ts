
import {getStateCallbacks} from "colyseus.js";
import {Entity} from "tick-knock";
import NetworkMovementComponent from "../../ecs/components/NetworkMovementComponent.ts";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";
import PlayerSchemaHandler from "./PlayerSchemaHandler.ts";
import PhysicsDebugSchemaHandler from "./PhysicsDebugSchemaHandler.ts";

export default class GameRoomSchemaHandler {

    static Configure(scene: GameRoomScene) {
        const $ = getStateCallbacks(scene.room);

        $(scene.room.state).players.onAdd((player, index) => {
            console.log('player added:', player.id, index);
            PlayerSchemaHandler.Configure(scene, player);
        });

        $(scene.room.state).entities.onAdd((entity, index) => {
            console.log('entity added', entity, index);
            let localEntity = new Entity();
            let localGameObject = scene.add.container();

            let localText = scene.make.text({text: "Hello"});
            localGameObject.add(localText);

            localEntity.add(new NetworkMovementComponent(entity, localGameObject));
            localEntity.add(localGameObject);

            scene.world.addEntity(localEntity);

            scene.remoteToLocalEntities.set(Number(entity.id), localEntity.id);
        });

        $(scene.room.state).physicsDebug.onAdd((debug, index) => {
            console.log('physics debug added', debug, index);

            PhysicsDebugSchemaHandler.Configure(scene, debug);
        });

        $(scene.room.state).physicsDebug.onRemove((debug, _index) => {
            let gameObject = debug.userData as Phaser.GameObjects.GameObject;
            gameObject.destroy(true);
        })
    }

}
