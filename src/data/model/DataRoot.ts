import Curve, { NumberKeyframe } from "curves";
import {Easing} from "eaz";
import AttributeCollection from "./attributes/AttributeCollection";
import NumberCurveModifier from "./modifiers/NumberCurveModifier";
import NumberCurveAttributeModifier from "./modifiers/NumberCurveAttributeModifier";
import NumberAttributeModifier from "./modifiers/NumberAttributeModifier";
import PackageCollection from "./packages/PackageCollection";
import Package from "./packages/Package";
import PackageAddModifier from "./packages/PackageAddModifier";
import NumberModifier from "./modifiers/NumberModifier";
import Modifier from "./modifiers/Modifier";
import Attribute from "./attributes/Attribute";
import { DataRootEvents } from "./RootEvents";
import EventEmitter from "eventemitter3";

class TestWeapon extends Package {

    constructor() {
        super();

        this.attributes.create('equipment/@[slot]/name', 'TestWeapon');
        this.attributes.create('equipment/@[slot]/type', 'weapon');
        this.attributes.create('@slot', 'weapon');

        this.addAttributeModifier(
            "stats/attack",
            new NumberModifier({value: 1.2, type: Modifier.MULTIPLICATIVE, priority: 1})
        );

        this.addAttributeModifier(
            "stats/attack/ice",
            new NumberModifier({value: 1.2, type: Modifier.MULTIPLICATIVE, priority: 1})
        );
    }

}

export default class DataRoot {

    events = new EventEmitter();
    attributes = new AttributeCollection();
    packages = new PackageCollection();

    constructor() {
    
        this.packages.attributes = this.attributes;
        this.attributes.root = this;

        this.attributes.create('stats/health', 23);
        this.attributes.create('stats/maxhealth', 1);
        this.attributes.create('stats/level', 55);
        this.attributes.create('misc/speed', 10);
    }


}