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
import EventEmitter from "eventemitter3";
import BehaviourTreeCondition from "../condition/btree/BehaviourTreeCondition";
import ConditionDuration from "../condition/conditions/ConditionDuration";
import ConditionRoot from "../condition/ConditionRoot";
import ConditionDurationWithReset from "../condition/conditions/ConditionDurationWithReset";

const tree_test = `root {
    parallel {
        sequence {
            action [disableWhenRunning]
            parallel {
                sequence {
                    action [forDuration, 12]
                    action [disableWhenRunning]
                }
                sequence {
                    action [waitForEvents, "event-basic-attack"]
                    action [resetUptime]
                }
            }
        }
    }
}`;

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

        let definition = `root {
            sequence {
                action [enableWhenRunning]
                action [restartOnFail, false]
                action [debug, "waiting"]
                action [waitForEvents, "damaged"]
                action [debug, "here"]
                action [forceFail]
            }
        }`;

        //this.condition = new BehaviourTreeCondition(tree_test);
        //this.condition = new ConditionDuration(12);
        this.condition = new ConditionDurationWithReset(12, ["event-basic-attack", "event-heavy-attack"]);
    }

}

export default class DataRoot {

    static ATTR_HEALTH = 'stats/health';
    static ATTR_MAXHEALTH = 'stats/maxhealth';
    static ATTR_LEVEL = 'stats/level';

    static ATTR_WALKSPEED = 'misc/walk-speed';
    static ATTR_RUNSPEED = 'misc/run-speed';

    static EVENT_ACTION_BASIC_ATTACK = 'event-basic-attack';
    static EVENT_DAMAGED = 'event-damaged';
    static EVENT_TICK = 'event-tick';

    events = new EventEmitter();
    attributes = new AttributeCollection();
    packages = new PackageCollection();

    constructor() {
    
        this.packages.attributes = this.attributes;
        this.packages.root = this;
        this.attributes.root = this;

        this.attributes.create('stats/health', 23);
        this.attributes.create('stats/maxhealth', 1);
        this.attributes.create('stats/level', 55);
        this.attributes.create('misc/walk-speed', 100);

        /*BehaviourTreeCondition.Initialize();

        let p = new TestWeapon();
        this.packages.add(p);

        this.events.emit('event-basic-attack');
        p.evaluate();
        for (let i = 0; i < 11; i++)
            this.events.emit('event-tick');
        p.evaluate();
        this.events.emit('event-tick');
        p.evaluate();
        this.events.emit('event-tick');
        p.evaluate();
        this.events.emit('event-tick');
        p.evaluate();
        this.events.emit('event-basic-attack');
        p.evaluate();*/
    }


}