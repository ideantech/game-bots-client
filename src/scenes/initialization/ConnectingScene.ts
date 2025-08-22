
// You can write more code here

/* START OF COMPILED CODE */

/* START-USER-IMPORTS */
import GameState from "../../data/GameState";
/* END-USER-IMPORTS */

export default class ConnectingScene extends Phaser.Scene {

	constructor() {
		super("ConnectingScene");

		/* START-USER-CTR-CODE */
		// Write your code here.
		/* END-USER-CTR-CODE */
	}

	editorCreate(): void {

		// text_1
		const text_1 = this.add.text(479, 326, "", {});
		text_1.text = "Connecting...\n";
		text_1.setStyle({ "fontSize": "48px" });

		this.events.emit("scene-awake");
	}

	/* START-USER-CODE */

	// Write your code here

	create() {
		this.editorCreate();

		GameState.Get().network.connect("ws://localhost:2567");

		this.scene.start("GameRoomScene", {
			"room": "game_room_test",
			"options": {}
		});
	}

	/* END-USER-CODE */
}

/* END OF COMPILED CODE */

// You can write more code here
