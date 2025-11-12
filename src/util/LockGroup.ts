
declare type LockGroupEntry = {
    priority: number;
    identifier: number;
}

export default class LockGroup {

    static PRIORITY_MIN = 0;
    static PRIORITY_MAX = 9999;

    active: number = -1;
    activeEntry: LockGroupEntry | undefined;
    pending: LockGroupEntry[] = [];
    _next: number = 0;

    constructor() {}

    refresh() {
        if (this.pending.length == 0) {
            this.active = -1;
            this.activeEntry = undefined;
            return;
        }

        if (this.activeEntry == undefined || this.pending[0].identifier != this.activeEntry.identifier) {
            this.activeEntry = this.pending[0];
            this.active = this.activeEntry.identifier;
        }
    }

    sort() {
        this.pending.sort((a, b) => b.priority - a.priority);

        this.refresh();
    }

    lock(priority: number): number {
        this._next++;
        let entry = {
            priority: priority,
            identifier: this._next
        };

        this.pending.push(entry)
        this.sort();

        return entry.identifier;
    }

    unlock(identifier: number) {
        let index = this.pending.findIndex((a) => a.identifier == identifier);
        if (index == -1) return;

        this.pending.splice(index, 1);
        this.refresh();
    }
}