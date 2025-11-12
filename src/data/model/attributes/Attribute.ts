import Modifier from "../modifiers/Modifier";
import AttributeCollection from "./AttributeCollection";

export default class Attribute<T> {

    attributes: AttributeCollection;
    
    name: string;
    modifiers: Modifier<T>[] = [];
    value: T;
    baseValue: T;

    originalId: string;
    originalAttributes: AttributeCollection;

    add(modifier: Modifier<T>) {
        modifier.attribute = this;
        this.modifiers.push(modifier);
        this.sort();
        this.update();
    }

    remove(modifier: Modifier<T>) {
        let index = this.modifiers.findIndex((a) => a.id = modifier.id);
        if (index != -1) {
            this.modifiers.splice(index, 1);
        }
        this.update();
    }

    sort() {
        this.modifiers.sort((a, b) => a.priority - b.priority);
    }

    update() {
        let nextValue = this.baseValue;
        for (let mod of this.modifiers) {
            nextValue = mod.applyTo(nextValue);
        }

        if (this.value !== nextValue) {
            this.value = nextValue;
            this.attributes?.root.events.emit('attribute-changed-' + this.id, this.id);
        }
    }

}