import { LightningElement, wire, api } from 'lwc';
//import { getRecord } from 'lightning/uiRecordApi';
import getProductList from '@salesforce/apex/productListExt.getProductList';

export default class ProductList extends LightningElement {
    @api recordId;
    @wire(getProductList, {acctId: '$recordId'})
    products;
}
function openUrl(id)
{
 window.location = "http://localhost/"+ id + '/view';
}