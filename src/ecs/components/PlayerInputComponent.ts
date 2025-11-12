import LockGroup from "../../util/LockGroup";

export class PlayerInputComponent {
    movementLock = new LockGroup();
    abilityLock = new LockGroup();

    movementId: number;
    abilityId: number;
}