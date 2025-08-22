import {type PhysicsDebugSchema} from "../../../../game-bots-server/src/rooms/schema/GameRoomState.ts";
import {GameRoomScene} from "../../scenes/gameplay/GameRoomScene.ts";
import Color = Phaser.Display.Color;
import {getStateCallbacks} from "colyseus.js";

export default class PhysicsDebugSchemaHandler {

    static index = 0;

    static NavigationColors = [
        Color.GetColor(0.2, 0, 0),
        Color.GetColor(0, 0.2, 0),
        Color.GetColor(0, 0, 0.2)
    ];

    static Configure(scene: GameRoomScene, debug: PhysicsDebugSchema) {
        const $ = getStateCallbacks(scene.room);
        let gameObject: Phaser.GameObjects.GameObject;

        PhysicsDebugSchemaHandler.NavigationColors = [
            Color.GetColor(100, 0, 0),
            Color.GetColor(0, 100, 0),
            Color.GetColor(0, 0, 100)
        ];
        //if (debug.shape == 1 || debug.shape == 2) return;

        //if (PhysicsDebugSchemaHandler.index != 0) return;

        PhysicsDebugSchemaHandler.index += 1;

        if (debug.shape == 1) {
            gameObject = scene.add.circle(debug.x, debug.y, debug.radius, Color.GetColor(0, 255, 0));
        }
        else if (debug.shape == 2) {
            let rectangle = scene.add.rectangle(debug.x, debug.y, debug.width, debug.height, Color.GetColor(0, 200, 0), 0.5);

            if (debug.isHull) {
                rectangle.strokeColor = Color.GetColor(0, 0, 200);
                rectangle.strokeAlpha = 0.5;
                rectangle.isStroked = debug.isHull;
                rectangle.fillAlpha = 0;
            }

            rectangle.setOrigin(0, 0);
            gameObject = rectangle;
        }
        else if (debug.shape == 3) {
            let points = [];
            for (let i = 0; i < debug.points.length; i++) {
                points.push(new Phaser.Math.Vector2(debug.points[i].x, debug.points[i].y));
            }
            console.log(points);

            //points = [[0, 0], [100, 0], [100, 100], [0, 100]];
            //points = [[0, 0], [960, 0], [960, 640], [0, 640]];
            var color = PhysicsDebugSchemaHandler.NavigationColors[PhysicsDebugSchemaHandler.index % 3];
            console.log(PhysicsDebugSchemaHandler.NavigationColors);
            let polygon = scene.add.polygon(debug.x, debug.y, points, color , 0.2);
            polygon.setOrigin(0, 0);
            gameObject = polygon;
        }
        else {
            gameObject = scene.add.circle(debug.x, debug.y, 5, Color.GetColor(255, 0, 0));
        }

        debug.userData = gameObject;

        $(debug).onChange(() => {
            gameObject.x = debug.x;
            gameObject.y = debug.y;
        });
    }

}