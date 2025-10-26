import NumberModifier, { NumberModifierConfig } from "./NumberModifier";

export type NumberAttributeModifierConfig = {
    from: string
} & NumberModifierConfig;

export default class NumberAttributeModifier extends NumberModifier {

    from: string;

    constructor(config: NumberAttributeModifierConfig) {
        super(config);

        this.from = config.from;
    }

    applyTo(current: number): number {
        if (!this.enabled) return current;

        let attr = this.attribute.attributes.find(this.from);
        if (!attr || typeof attr.value !== 'number') return current;

        this.attribute.attributes.root.events.on('attribute-changed-' + this.from, this.onAttributeChanged, this);

        return this.calculate(current, attr.value);
    }

    onAttributeChanged(name: string) {
        this.attribute.update();
    }

}