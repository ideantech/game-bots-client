import { LinkedComponent } from "tick-knock";
import Modifier from "../../data/model/modifiers/Modifier";
import Package from "../../data/model/packages/Package";

export default class SimpleBuffComponent extends LinkedComponent {

    countdown: number = 0;

    constructor(
        public target: Package | Modifier<any>,
        public duration: number
    ) {
        super();
    }

    reset() {
        if (this.duration > 0) { this.countdown = 0; }
    }
}