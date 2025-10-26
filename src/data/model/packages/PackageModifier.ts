
import Package from "./Package";
import PackageCollection from "./PackageCollection";

export default abstract class PackageModifier {

    abstract applyTo(pkgs: PackageCollection, parent: Package): void;

}