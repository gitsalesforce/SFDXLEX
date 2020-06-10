({
    handleAjaxRequest : function(component, event, helper) {
        const xhr = new XMLHttpRequest();
        const number = component.get('v.number');
        const url = 'http://api.icndb.com/jokes/random/' + number;
        xhr.open('GET', url, true);//open action
        xhr.onload = function() {
            if(this.status === 200) {
                const response = JSON.parse(this.responseText);
                let output = '<ul class=\'slds-list--dotted\'>';
                if(response.type === 'success') {
                    response.value.forEach(function(joke){
                        output += `<li>${joke.joke}</li>`;
                    });
                }
                output += '<ul>';
                component.set('v.html', output);
            }
        };
        xhr.send();
    },
    handleAjaxRequest1 : function(component, event, helper) {
        const xhr = new XMLHttpRequest();
        const number = component.get('v.string');
        const newsapiv1 = 'https://newsapi.org/v2/top-headlines?country='+number+'&apiKey=30774dadf4b64b75b6d8c5f9acb34201';
        console.log(newsapiv1);
        xhr.open('GET', newsapiv1, true);//open action
        xhr.onload = function() {
            if(this.status === 200) {
                const response = JSON.parse(this.responseText);
                let output = '<ul class=\'slds-list--dotted\'>';
                if(response.type === 'success') {
                    response.value.forEach(function(article){
                        output += `<li>${article.title}</li>`;
                    });
                }
                output += '<ul>';
                component.set('v.html1', output);
            }
        };
        xhr.send();
    }
})