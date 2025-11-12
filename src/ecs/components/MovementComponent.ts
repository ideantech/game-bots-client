import Attribute from "../../data/model/attributes/Attribute";


export default class MovementComponent {

    static NONE: number = 0;
    static WALK: number = 1;
    static RUN: number = 2;
    static IMPULSE: number = 3;

    frozen: boolean = false;
    mode: number = MovementComponent.NONE;
    x: number = 0;
    y: number = 0;
    impulseCurrent: number = 0;
    impulseDrag: number = 2;
    _speed: Attribute<number>;

    impulse(x: number, y: number, amount: number) {
        this.mode = MovementComponent.IMPULSE;
        this.impulseCurrent = amount;
        this.x = x;
        this.y = y;
    }

    walk(x: number, y: number) {
        this.x = x; this.y = y;
        this.mode = MovementComponent.WALK;
    }

    stop() {
        this.mode = MovementComponent.NONE;
    }

}