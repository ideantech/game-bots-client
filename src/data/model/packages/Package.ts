import Attribute from "../attributes/Attribute";
import AttributeCollection from "../attributes/AttributeCollection";
import Modifier from "../modifiers/Modifier";
import PackageAddModifier from "./PackageAddModifier";
import PackageCollection from "./PackageCollection";
import PackageModifier from "./PackageModifier";

export default class Package {

    collection: PackageCollection;
    attributes = new AttributeCollection();
    modifiers: PackageModifier[] = [];

    _enabled: boolean = true;

    add(mod: PackageModifier) {
        this.modifiers.push(mod);
    }

    addAttributeModifier(name: string, modifier: Modifier<any>) {
        let mod = new PackageAddModifier(name, modifier);
        this.add(mod);
    }

    apply() {
        this.attributes.setProxyTarget(this.collection.attributes);

        for (let mod of this.modifiers) {
            mod.applyTo(this.collection, this);
        }
    }

    remove() {
    }

    setEnabled(e: boolean) {

    }
}