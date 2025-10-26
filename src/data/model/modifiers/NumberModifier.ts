import Modifier, { ModifierConfig } from "./Modifier";

export declare type NumberModifierConfig = {
    scalar?: number;
} & ModifierConfig<number>;

export default class NumberModifier extends Modifier<number> {

    scalar: number = 1.0;

    constructor(config: NumberModifierConfig) {
        super(config);

        if (config.scalar !== undefined) this.scalar = config.scalar;
    }

    applyTo(current: number): number {
        if (!this.enabled) return current;

        return this.calculate(current, this.value);
    }

    calculate(current: number, by: number): number {
        by *= this.scalar;
        if (this.type == Modifier.ADDITIVE)
            return current + by;
        else if (this.type == Modifier.MULTIPLICATIVE)
            return current * by;
        else
            return by;
    }
    
}