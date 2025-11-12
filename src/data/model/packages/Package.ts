
import ConditionRoot from "../../condition/ConditionRoot";
import AttributeCollection from "../attributes/AttributeCollection";
import Modifier from "../modifiers/Modifier";
import PackageAddModifier from "./PackageAddModifier";
import PackageCollection from "./PackageCollection";
import PackageModifier from "./PackageModifier";

export default class Package {

    collection: PackageCollection;
    attributes = new AttributeCollection();
    modifiers: PackageModifier[] = [];
    condition: ConditionRoot;

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

    evaluate() {
        let newState = ConditionRoot.RESULT_DISABLE;
        if (this.condition == undefined) {
            newState = (this._enabled) ? ConditionRoot.RESULT_ENABLE : ConditionRoot.RESULT_DISABLE;
        }
        else {
            newState = this.condition.evaluate();
        }

        console.log('package is:', newState);

        if (newState == ConditionRoot.RESULT_ENABLE && !this._enabled) {
            this.setEnabled(true);
        }
        else if (newState == ConditionRoot.RESULT_DISABLE && this._enabled) {
            this.setEnabled(false);
        }
    }

    setEnabled(e: boolean) {
        this._enabled = e;
        for (let mod of this.modifiers) {
            mod.setEnabled(e);
        }
    }
}