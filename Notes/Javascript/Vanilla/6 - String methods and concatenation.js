const firstName = 'Kristof';
const lastName = 'Toth';

let val;

// concatenation
val = firstName + lastName;
val = firstName + ' ' + lastName;

// appending (adding on)
val = 'Kristof ';
val += ' Toth';

// escaping
val = "That's awesome, I can't wait!";
val = 'That\'s awesome, I can\'t wait!';

// retrieving length of a string
let len = firstName.length;

// concatenation through string methods
val = firstName.concat(' ', lastName);

// change case
val = firstName.toUpperCase();
val = firstName.toLocaleLowerCase();

// get certain character
val = firstName[0];

// find the index of a value
val = firstName.indexOf('f');
// find the last occurrence
val = firstName.lastIndexOf('f');

// retrieves the third character
val = firstName.charAt(2);

// get substring of a string
val = firstName.substring(0,4);

// slice() is mostly used on arrays
val = firstName.slice(0,4);
// slices from the back and gets 3 elements
val = firstName.slice(-3);

// splitting strings at certain characters
val = firstName.split('s');

console.log(val);