/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {BaseEntity} from "./baseentity";

class OrderItem extends BaseEntity{
    constructor($injector){
        super($injector);
    }
}
export {
    OrderItem
}