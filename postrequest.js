var request = require('request');
var data;
request('https://inindca.ci.cloudbees.com/job/build-web-crm/api/json', function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body) // Print the google web page.
request.post(
    'https://blazing-fire-1988.firebaseio.com/',
    body,
    function (error, response, body) {
        if (!error && response.statusCode == 200) {
            console.log(body)
        }
    }
);

  }
}).auth('daniel.hamilton@inin.com', '0cdf5f4c329942b27111f6dbe89a0013', true);