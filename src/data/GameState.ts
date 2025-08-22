
import Network from "./Network";

export enum Flags {
    NextGameRoom = "nextGameRoom",
    NextGameRoomOptions = "nextGameRoomOptions"
}

export default class GameState {

    static _instance: GameState | null = null;

    static Get(): GameState {
        if (GameState._instance == null) {
            GameState._instance = new GameState();
        }

        return GameState._instance;
    }



    flags = new Map<string, any>();
    network: Network = new Network();

    setFlag<T>(name: string, value: T) {
        this.flags.set(name, value);
    }

    getFlag<T>(name: string): T | undefined {
        return this.flags.get(name) as T;
    }
}