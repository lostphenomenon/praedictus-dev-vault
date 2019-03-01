// if(something){
//   do something
// } else {
//   do something else
// }

const id = 100;

// // EQUAL TO
if (id == 100) {
    console.log('CORRECT');
} else {
    console.log('INCORRECT');
}

// // NOT EQUAL TO
if (id != 101) {
    console.log('CORRECT');
} else {
    console.log('INCORRECT');
}

// // EQUAL TO VALUE & TYPE
if (id === 100) {
    console.log('CORRECT');
} else {
    console.log('INCORRECT');
}

// // EQUAL TO VALUE & TYPE
if (id !== 100) {
    console.log('CORRECT');
} else {
    console.log('INCORRECT');
}

// Test if undefined
if (typeof id !== 'undefined') {
    console.log(`The ID is ${id}`);
} else {
    console.log('NO ID');
}

// GREATER OR LESS THAN
if (id <= 100) {
    console.log('CORRECT');
} else {
    console.log('INCORRECT');
}

// IF ELSE

const color = 'yellow';

if (color === 'red') {
    console.log('Color is red');
} else if (color === 'blue') {
    console.log('Color is blue');
} else {
    console.log('Color is not red or blue');
}

// LOGICAL OPERATORS

const name = 'Steve';
const age = 70;

// AND &&
if (age > 0 && age < 12) {
    console.log(`${name} is a child`);
} else if (age >= 13 && age <= 19) {
    console.log(`${name} is a teenager`);
} else {
    console.log(`${name} is an adult`);
}

// OR ||
if (age < 16 || age > 65) {
    console.log(`${name} can not run in race`);
} else {
    console.log(`${name} is registered for the race`);
}

// TERNARY OPERATOR
console.log(id === 100 ? 'CORRECT' : 'INCORRECT');

// WITHOUT BRACES
if (id === 100)
    console.log('CORRECT');
else
    console.log('INCORRECT');

if (id === 100)
    console.log('CORRECT');
else
    console.log('INCORRECT');



const color = 'yellow';

switch (color) {
    case 'red':
        console.log('Color is red');
        break;
    case 'blue':
        console.log('Color is blue');
        break;
    default:
        console.log('Color is not red or blue');
        break;
}

let day;

switch (new Date().getDay()) {
    case 0:
        day = 'Sunday';
        break;
    case 1:
        day = 'Monday';
        break;
    case 2:
        day = 'Tuesday';
        break;
    case 3:
        day = 'Wednesday';
        break;
    case 4:
        day = 'Thursday';
        break;
    case 5:
        day = 'Friday';
        break;
    case 6:
        day = 'Saturday';
        break;
}

console.log(`Today is ${day}`);