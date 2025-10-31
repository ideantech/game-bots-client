
import Modifier from "../modifiers/Modifier";
import Package from "./Package";
import PackageCollection from "./PackageCollection";
import PackageModifier from "./PackageModifier";

export default class PackageAddModifier extends PackageModifier {

    constructor(
        public name: string,
        public modifier: Modifier<any>) {
        super();
    }

    applyTo(pkgs: PackageCollection, parent: Package): void {
        var attr = pkgs.attributes.find(this.name);
        if (attr) {
            this.modifier.enabled = this.modifier.enableOnAdd;
            attr.add(this.modifier);
        }
    }

    setEnabled(_e: boolean): void {
        this.modifier.enabled = _e;
    }
}