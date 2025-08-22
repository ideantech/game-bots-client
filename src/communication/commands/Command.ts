
export default class Command<T, K> {
    room: T;
    payload: K;

    execute(_payload: K) {}
}