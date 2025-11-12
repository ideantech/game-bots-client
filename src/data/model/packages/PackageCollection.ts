import ConditionContext from "../../condition/ConditionContext";
import AttributeCollection from "../attributes/AttributeCollection";
import DataRoot from "../DataRoot";
import Package from "./Package";

export default class PackageCollection {

    root: DataRoot;
    attributes: AttributeCollection;
    items: Package[] = [];

    add(pkg: Package) {
        pkg.collection = this;
        pkg.attributes.proxyTo = this.attributes;
        pkg.apply();
        this.items.push(pkg);

        if (pkg.condition != null) {
            pkg.condition.package = pkg;
            pkg.condition.added();
        }

        pkg.evaluate();
    }

}