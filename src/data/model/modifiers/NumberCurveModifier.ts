import Curve from "curves";
import NumberModifier, { NumberModifierConfig } from "./NumberModifier";

export declare type NumberCurveModifierConfig = {
    curve: Curve<number>
} & NumberModifierConfig;

export default class NumberCurveModifier extends NumberModifier {

    curve: Curve<number>;

    constructor(config: NumberCurveModifierConfig) {
        super(config);

        this.curve = config.curve;
    }

    applyTo(current: number): number {
        if (!this.enabled) return current;

        let v = this.curve.evaluate(this.value);
        return this.calculate(current, v);
    }

}
