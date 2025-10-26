import DataRoot from "../DataRoot";
import Attribute from "./Attribute";

export default class AttributeCollection {

    root: DataRoot;
    items = new Map<string, Attribute<any>>();
    proxyTo: AttributeCollection;

    toString(): string {
        let ret = '';

        for (let key of this.items.keys()) {
            ret = key + '=' + this.items.get(key)?.value; + '\n';
            console.log(ret);
        }

        return ret;
    }

    find<T>(id: string): Attribute<T> | undefined {
        return this.items.get(id);
    }

    findAll(pattern: string): Attribute<any>[] {
        return [];
    }

    add(attr: Attribute<any>) {
        attr.attributes = this;
        this.items.set(attr.id, attr);
        attr.update();
    }

    addAs(id: string, attr: Attribute<any>) {
        attr.originalId = attr.id;
        attr.originalAttributes = attr.attributes;
        attr.attributes = this;
        this.items.set(id, attr);
    }
    
    create<T>(id: string, baseValue: T): Attribute<T> {
        let attr = new Attribute<T>();
        attr.id = id;
        attr.baseValue = baseValue;
        attr.update();
        this.add(attr);
        return attr;
    }

    setProxyTarget(attrs: AttributeCollection) {
        this.proxyTo = attrs;

        let pattern: RegExp = /@\[(.*)\]/g;

        for (let attr of this.items.keys()) {
            if (attr.startsWith('@')) continue;
            let addAs = attr;
            let failed = false;

            let matches = attr.matchAll(pattern);
            for (const match of matches) {
                if (!this.items.has('@' + match[1])) {
                    failed = true;
                    break;
                }

                let valAttr = this.items.get('@' + match[1]);
                let value = <string> valAttr?.value;
                addAs = addAs.replace('@[' + match[1] + ']', value);
            }

            if (failed) continue;

            this.proxyTo.addAs(addAs, <Attribute<any>> this.items.get(attr));
        }
    }

}