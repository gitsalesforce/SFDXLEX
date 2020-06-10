import { LightningElement,track} from 'lwc';
import Movie from './movie';
export default class Fetch extends LightningElement {
	
	
	@track movies;
	
	handleCallout(){
		fetch('https://api.themoviedb.org/3/movie/now_playing?api_key=52121b8ffd37db19123c9f47321e259c&region=IN',
		{
			method : "GET",
			headers : {
				"Content-Type": "application/json",
				"Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MjEyMWI4ZmZkMzdkYjE5MTIzYzlmNDczMjFlMjU5YyIsInN1YiI6IjVjNDc0NWFmMGUwYTI2NDk2NWNhNGFhZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.tdMnNkQfXU__PtQSCyB-XPBJ3FJtIVwlU86LBJHeURU"
			}
		}).then(function(response) {
			return response.json();
		})
		.then((myJson) =>{
			// console.log('%%%%'+JSON.stringify(myJson));
			let movies_list = [];
			for(let v of Object.values(myJson.results)){
				// console.log('%%%%'+JSON.stringify(v.title));
				// console.log('$$$$'+v.title);
				movies_list.push(new Movie(v.Id, v.title, v.original_language, v.overview, v.vote_average, v.release_date, v.poster_path));
			}
			
			// console.log('*****'+JSON.stringify(movies_list));
			
			this.movies = movies_list;
			
		})
		.catch(e=>console.log(e));
	}
}