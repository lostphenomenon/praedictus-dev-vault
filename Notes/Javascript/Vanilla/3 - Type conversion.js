let value = 5;

// Number to string
value = String(5);

value = String(4 + 4);
// 8, string, 1lenght

value = String(true);
// true, string, 4

value = String(new Date());
// Wed Nov 15 ... ..., string, 60

value = String([1, 2, 3, 4]);
// 1,2,3,4  string  7

// We can also use the toString function for this
value = (5).toString();
value = (true).toString();

// STRINGS to NUBMERS
value = '5';
value = Number('5');

// Booleans parse to their corresponding values 0 and 1
value = Number(true);

// null also gives 0
value = Number(null);

value = Number('hello');
value = Number([1, 2, 3, 4]);
// these give back NaN  --> not a number

// The proper method to parse string to numbers is
value = parseInt('100');
value = parseFloat('100.3');