import {State, BehaviourTree} from "mistreevous";
import ConditionRoot from "../ConditionRoot";
import ConditionContext from "../ConditionContext";
import { ActionResult, Agent } from "mistreevous/dist/Agent";
import { CompleteState } from "mistreevous/dist/State";

declare type ConditionAgent = {
    enabledWhenRunning: boolean;
    restartOnFail: boolean;
    context: ConditionContext | null;
    uptime: number;
    lastState: State;
};

export default class BehaviourTreeCondition extends ConditionRoot {
 
    static NewAgent(): ConditionAgent {
        return {
            enabledWhenRunning: true,
            restartOnFail: true,
            context: null,
            uptime: 0,
            lastState: State.READY
        }
    }

    static _initialized = false;

    static Initialize() {
        if (BehaviourTreeCondition._initialized) return;
        BehaviourTreeCondition._initialized = true;

        BehaviourTree.register('enableWhenRunning', (agent: Agent): ActionResult => {
            (<ConditionAgent> agent).enabledWhenRunning = true;
            return State.SUCCEEDED;
        });

        BehaviourTree.register('disableWhenRunning', (agent: Agent): ActionResult => {
            (<ConditionAgent> agent).enabledWhenRunning = false;
            return State.SUCCEEDED;
        });

        BehaviourTree.register('forDuration', (agent: Agent, duration: number): ActionResult => {
            let ca = <ConditionAgent> agent;
            console.log(ca.uptime, duration);
            return (ca.uptime <= duration) ? State.RUNNING : State.SUCCEEDED;
        });

        BehaviourTree.register('restartOnFail', (agent: Agent, e: boolean) => {
            let ca = <ConditionAgent> agent;
            ca.restartOnFail = e;
            return State.SUCCEEDED;
        });

        BehaviourTree.register('forceFail', (agent: Agent) => {
            return State.FAILED;
        })

        BehaviourTree.register('resetUptime', (agent: Agent) => {
            let ca = <ConditionAgent> agent;
            ca.uptime = 0;
            return State.SUCCEEDED;
        })

        //@ts-ignore
        BehaviourTree.register('waitForEvents', (agent: Agent, events: string) => {
            let ca = <ConditionAgent> agent;
            let myResolve: ((value: State | PromiseLike<State>) => void) | undefined = undefined;

            let p = new Promise((resolve, _reject) => {
                myResolve = resolve;
            });

            let handler = () => {
                if (myResolve) {
                    console.log('resolving');
                    myResolve(State.SUCCEEDED);
                }
                ca.context?.root.events.removeListener(events, handler);
            }

            ca.context?.root.events.addListener(events, handler);
            
            return p;
        });

        BehaviourTree.register('debug', (_agent: Agent, message: string) => {
            console.log(message);
            return State.SUCCEEDED;
        })
    }

    tree: BehaviourTree;
    agent: ConditionAgent;

    constructor(definition: string) {
        super();

        this.agent = BehaviourTreeCondition.NewAgent();
        this.tree = new BehaviourTree(definition, this.agent);
    }

    tick() {
        this.agent.uptime++;
    }

    evaluate(c: ConditionContext): boolean {
        this.agent.context = this.context;

        if (this.agent.lastState == State.FAILED && !this.agent.restartOnFail) {
            return false;
        }

        this.tree.step();
        let state = this.tree.getState();
        this.agent.lastState = state;

        if (state == State.SUCCEEDED || (this.agent.enabledWhenRunning && state == State.RUNNING)) {
            return true;
        }
        else if (state == State.FAILED || (!this.agent.enabledWhenRunning && state == State.RUNNING)) {
            return false;
        }

        return false;
    }

}