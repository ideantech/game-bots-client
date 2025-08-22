
// You can write more code here

/* START OF COMPILED CODE */

/* START-USER-IMPORTS */
/* END-USER-IMPORTS */

import GameState from "../../data/GameState.ts";
import  GameRoomState from "../../../../game-bots-server/src/rooms/schema/GameRoomState";
import {Room} from "colyseus.js";
import Messenger from "../../communication/Messenger.ts";
import {Engine, Entity} from "tick-knock";
import NetworkMovementSystem from "../../ecs/systems/NetworkMovementSystem.ts";

import MessageHandler from "../../communication/MessageHandler.ts";
import GameRoomSchemaHandler from "../../communication/schema/GameRoomSchemaHandler.ts";
import Phaser from "phaser";
import PlayerInputSystem from "../../ecs/systems/PlayerInputSystem.ts";
import {PlayerInputComponent} from "../../ecs/components/PlayerInputComponent.ts";


export class GameRoomScene extends Phaser.Scene {

	messenger: Messenger;
	messageHandler: MessageHandler;
	roomName: string = "game_room_test";
	roomOptions: any = {};
	room: Room<GameRoomState>;
	world = new Engine();

	networkMovementSystem = new NetworkMovementSystem();
	playerInputSystem = new PlayerInputSystem();

	remoteToLocalEntities = new Map<number, number>();

	constructor() {
		super("GameRoomScene");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// txtGameRoom
		const txtGameRoom = this.add.text(68, 69, "", {});
		txtGameRoom.text = "GameRoom\n";
		txtGameRoom.setStyle({});

		this.events.emit("scene-awake");
	}

	/* START-USER-CODE */
	// Write your code here

	init(data: any) {
		if (data.room) this.roomName = data.room;
		if (data.options) this.roomOptions = data.options;
	}

	findLocalEntity(remoteEntityId: number): Entity | undefined {
		let localEntityId = this.remoteToLocalEntities.get(remoteEntityId);
		if (localEntityId) {
			return this.world.getEntityById(localEntityId);
		}
		return undefined;
	}

	configureRoom() {
		//const $ = getStateCallbacks(this.room);

		this.messageHandler = new MessageHandler(this);

		GameRoomSchemaHandler.Configure(this);

		this.messenger.createEntity('test').then((entity) => {
			let entityId = Number(entity.id);
			setTimeout(() => {
				this.messenger.requestControl(entityId).then((response) => {
					console.log('request control response', response);

					if ('result' in response && response['result'] === 'ok') {
						let localEntity = this.findLocalEntity(entityId);
						let control = new PlayerInputComponent();
						localEntity?.addComponent(control);
					}
				});
				//this.room.send(ClientMessages.RequestControl, { entityId: entityId });
			}, 1000);
		});

		// $(this.room.state).players.onAdd((player, index) => {
		// 	console.log('player added', player.id, index);
		//
		// 	// this is us
		// 	if (player.id === this.room.sessionId) {
		// 		$(player).listen('controlling', (value, _previousValue) => {
		// 			console.log('now controlling: ', value);
		// 		});
		// 	}
		// });
		//
		// $(this.room.state).entities.onAdd((entity, _index) => {
		// 	console.log('entity added', entity);
		// 	let localEntity = new Entity();
		// 	let localGameObject = this.add.group();
		//
		// 	let localText = this.make.text({text: "Hello"});
		// 	localGameObject.add(localText);
		//
		// 	localEntity.add(new NetworkComponent(entity, localGameObject));
		// 	this.world.addEntity(localEntity);
		//
		// 	this.remoteToLocalEntities.set(Number(entity.id), localEntity.id);
		// });
	}

	//@ts-ignore
	create() {
		this.editorCreate();

		this.world.sharedConfig.add(this);

		this.world.addSystem(this.networkMovementSystem, 10);
		this.world.addSystem(this.playerInputSystem, 20);

		GameState.Get().network.client.joinOrCreate<GameRoomState>(this.roomName, this.roomOptions).then((room) => {
			window.console.log('joined room:', this.roomName);
			this.room = room;
			this.messenger = new Messenger(this.room);

			this.configureRoom();
		});
	}

	update(time: number, delta: number) {
		super.update(time, delta);
		this.world.update(delta);
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
