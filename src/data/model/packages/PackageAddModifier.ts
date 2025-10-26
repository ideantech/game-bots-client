import AttributeCollection from "../attributes/AttributeCollection";
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
            attr.add(this.modifier);
        }
    }
}