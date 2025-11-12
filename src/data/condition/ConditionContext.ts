import { Entity } from "tick-knock";
import DataRoot from "../model/DataRoot";
import Package from "../model/packages/Package";

export default class ConditionContext {

    package: Package;
    root: DataRoot;
    //entity: Entity | undefined;

}