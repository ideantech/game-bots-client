import {type EntitySchema} from "../../../../game-bots-server/src/rooms/schema/GameRoomState.ts";

export default class NetworkMovementComponent {

    syncPosition: boolean = true;
    interpolate: boolean = true;
    interpolationTime: number = 0.2;

    removePositionCallback: () => void;

    public constructor(
        public schema: EntitySchema,
        public gameObject: Phaser.GameObjects.Container
    ) {}
}