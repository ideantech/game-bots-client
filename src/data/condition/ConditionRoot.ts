import DataRoot from "../model/DataRoot";
import Package from "../model/packages/Package";
import ConditionContext from "./ConditionContext";

export declare type OnTickHandler = () => void;

export default class ConditionRoot {

    static RESULT_DISABLE: number = 0;
    static RESULT_ENABLE: number = 1;
    static RESULT_NOACTION: number = 2;

    package: Package;

    added() {}

    removed() {}

    reset() {}

    onEvent(event: string, handler: any, context: any) {
        this.package.collection.root.events.addListener(event, handler, context);
    }

    offEvent(event: string, handler: any, context: any) {
        this.package.collection.root.events.removeListener(event, handler, context);
    }

    onTick(handler: OnTickHandler, context: any) {
        this.package.collection.root.events.addListener(DataRoot.EVENT_TICK, handler, context);
    }

    offTick(handler: OnTickHandler, context: any) {
        this.package.collection.root.events.removeListener(DataRoot.EVENT_TICK, handler, context);
    }

    evaluate(): number {
        return ConditionRoot.RESULT_ENABLE;
    }
}