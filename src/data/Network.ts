import { Client } from "colyseus.js";

export default class Network {

    client: Client;

    connect(url: string) {
        this.client = new Client(url);
    }

}