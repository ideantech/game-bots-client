import NumberCurveModifier, { NumberCurveModifierConfig } from "./NumberCurveModifier";

export type NumberCurveAttributeModiferConfig = {
    from: string
} & NumberCurveModifierConfig;

export default class NumberCurveAttributeModifer extends NumberCurveModifier {

    from: string;

    constructor(config: NumberCurveAttributeModiferConfig) {
        super(config);

        this.from = config.from;
    }

    applyTo(current: number): number {
        if (!this.enabled) return current;

        let attr = this.attribute.attributes.find(this.from);
        if (!attr || typeof attr.value !== 'number') return current;

        let v = this.curve.evaluate(attr.value);
        return this.calculate(current, v);
    }

}