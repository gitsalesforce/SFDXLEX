export default class Movie{
	
	constructor(Id, title, original_language, overview, vote_average, release_date, poster_path) {
		this._id = Id;
		this._title = title;
		this._original_language = original_language;
		this._overview = overview;
		this._vote_average = vote_average;
		this._release_date = release_date;
		this._poster_path  = "https://image.tmdb.org/t/p/w300"+poster_path;
	}
}