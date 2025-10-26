import AttributeCollection from "../attributes/AttributeCollection";
import Package from "./Package";

export default class PackageCollection {

    attributes: AttributeCollection;
    items: Package[] = [];

    add(pkg: Package) {
        pkg.collection = this;
        pkg.attributes.proxyTo = this.attributes;
        pkg.apply();
        this.items.push(pkg);
    }

}