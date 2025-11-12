import ConditionRoot from "../ConditionRoot";

export default class ConditionDurationWithReset extends ConditionRoot {

    _countUp: number = 0;

    constructor(
        public duration: number, 
        public events: string[]) {
        super();
    }

    added() {
        this.onTick(this.handleTick, this);
        for (let e of this.events) {
            this.onEvent(e, this.handleEvent, this);
        }
    }

    removed() {
        this.offTick(this.handleTick, this);
        
        for (let e of this.events) {
            this.offEvent(e, this.handleEvent, this);
        }
    }

    handleTick() { this._countUp++; }

    handleEvent() {
        this._countUp = 0;
    }

    evaluate(): number {
        return (this._countUp > this.duration) ? ConditionRoot.RESULT_DISABLE : ConditionRoot.RESULT_ENABLE;
    }

}