import { LightningElement,api } from 'lwc';
export default class Lwcrepo extends LightningElement {
    @api showDetails = false;
    @api strName;
    @api empName;
    @api empDepartment;
    @api empLocation;
    @api empAge;
    @api empGender;
}