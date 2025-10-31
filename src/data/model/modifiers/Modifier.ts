import Curve from "curves";
import Attribute from "../attributes/Attribute";

export type ModifierConfig<T> = {
    type?: number;
    priority?: number;
    value: T;
    //curve?: Curve<T> ;
    //curveKey?: string;
}

export default abstract class Modifier<T> {

    static REPLACE: number = 1;
    static ADDITIVE: number = 2;
    static MULTIPLICATIVE: number = 3;

    id: number;
    attribute: Attribute<T>;
    type: number =  Modifier.ADDITIVE;
    priority: number = 0;
    value: T;
    enabled: boolean = true;
    enableOnAdd: boolean = true;
    //curve: Curve<T> | undefined;
    //curveKey: string | undefined = undefined;

    constructor(config: ModifierConfig<T>) {
        this.type = config.type || Modifier.ADDITIVE;
        this.priority = config.priority || 0;
        this.value = config.value;
        //this.curve = config.curve;
        //this.curveKey = config.curveKey;
    }

    abstract applyTo(value: T): T;

}