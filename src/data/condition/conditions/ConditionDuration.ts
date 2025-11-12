import DataRoot from "../../model/DataRoot";
import ConditionRoot from "../ConditionRoot";

export default class ConditionDuration extends ConditionRoot {
    
    _countUp: number = 0;

    constructor(
        public duration: number = 1) {
        super();
    }

    evaluate(): number {
        return (this._countUp > this.duration) ? ConditionRoot.RESULT_DISABLE : ConditionRoot.RESULT_ENABLE;
    }

    added() {
        this.onTick(this.handleTick, this);
    }

    removed() {
        this.offTick(this.handleTick, this);
    }

    handleTick() {
        this._countUp++;
    }

    reset() {
        this._countUp = 0;
    }
}