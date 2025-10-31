import Attribute from "../../data/model/attributes/Attribute";


export default class MovementComponent {

    static NONE: number = 0;
    static WALK: number = 1;
    static RUN: number = 2;

    frozen: boolean = false;
    mode: number = MovementComponent.NONE;
    x: number = 0;
    y: number = 0;

    _speed: Attribute<number>;

    walk(x: number, y: number) {
        this.x = x; this.y = y;
        this.mode = MovementComponent.WALK;
    }

    stop() {
        this.mode = MovementComponent.NONE;
    }
}