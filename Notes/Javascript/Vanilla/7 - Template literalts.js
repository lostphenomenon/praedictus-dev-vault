const name = 'Kris';
const age = 30;
const job = 'Software Developer';
const city = 'Budapest';

// ES5 without templates
let html = '<ul><li>Name: ' + name + '</li><li>Age: ' + age + '</li><li>Job: ' + job + '</li></ul>';

html = '<ul>' +
            '<li> Name: ' + name + '</li>';
        // and so on

// ES6 template strings altgr+7
html = `
    <ul>
        <li>${name}</li>
        <li>${age}</li>
        <li>${job}</li>
        <li>${city}</li>
    </ul>
`

document.body.innerHTML = html;