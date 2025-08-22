import {Room} from "colyseus.js";
import GameRoomState from "../../../game-bots-server/src/rooms/schema/GameRoomState.ts";
import UUID from "../../../game-bots-server/src/rooms/utils/UUID.ts";
import Command from "./commands/Command.ts";
import SyncNetworkPositionCommand from "./commands/SyncNetworkPositionCommand.ts";

export declare type PendingMessage = {
    resolve: (response: any) => void;
    reject: () => void;
}

export default class Messenger {

    uuid = new UUID();
    pending = new Map<number, PendingMessage>();

    constructor(
        public room: Room<GameRoomState>
    ) {
        this.room.onMessage('response', (data) => {
            if (!('context' in data)) return;

            let pending = this.pending.get(data.context);
            if (!pending) return;

            this.pending.delete(data.context);
            pending.resolve(data);
        });

        this.room.onMessage('sync-position', (data) => {
            this.dispatch(new SyncNetworkPositionCommand(), {
                entityId: data.entityId,
                x: data.x,
                y: data.y,
                enableSync: data.enableSync,
            });
        });
    }

    dispatch<T, K>(command: Command<T, K>, payload: K) {
        command.room = this.room as T;
        command.payload = payload;
        command.execute(payload);
    }

    sendAndExpect(messageType: string, data: any): Promise<any> {
        const context = this.uuid.next();

        data['context'] = context;

        const promise = new Promise<any>((resolve, reject) => {
            this.pending.set(context, {resolve: resolve, reject: reject});
        });

        this.room.send(messageType, data);

        return promise;
    }

    createEntity(name: string, overrides: any = {}): Promise<any> {
        return this.sendAndExpect('create-entity', {
            name: name,
            overrides: overrides
        });
    }

    requestControl(entityId: number): Promise<any> {
        return this.sendAndExpect('request-control', {
            entityId: entityId
        });
    }

    static ReleaseControl(room: Room<any>) {
        room.send('release-control',  {});
    }

    static SetEntityPosition(room: Room<any>,x: number, y: number, entityId?: number, ) {
        room.send('set-entity-position', {
            entityId: entityId,
            x: x,
            y: y
        });
    }
}