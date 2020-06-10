import { LightningElement, api } from 'lwc';

export default class MovieTile extends LightningElement {
    
    @api posterPath;
    @api title;
    @api releaseDate;
    @api vote;
    @api language;
    @api Id;
    @api overview;
}