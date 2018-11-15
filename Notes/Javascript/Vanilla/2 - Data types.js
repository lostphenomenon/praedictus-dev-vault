// Data types in JS

//   Primitive data types:
//     They are stored direcly on the stack.

//     string
//     number (float, decimal etc.)
//     boolean (true, false)
//     null (intentional empty value)
//     undefined (unassigned variable)
//     symbols

//   Reference data types:
//     Accessed by a reference, they are stored on the heap, they can be reached
//     through a pointer.

//     Arrays
//     Object literals
//     Functions
//     Dates
//     etc.

//   JS is dinamically typed which means that the types are associated with values and
//   not with variables.
//   The same variable can hold multiple types. (it can hold a string, then can be set to a number or anything else)
//   There is no need to specify the type of a variable. (at the definition like in c++/c#)

//    It is possible to query data types for their type.

//    e.g.:
const name = 'Asd FSD'
console.log(typeof name); // string

const age = 30;
console.log(typeof age); // number

const hasSmth = true;
console.log(typeof hasSmth); // boolean

const car = null;
console.log(typeof car); // Object

// side note: null is a primitive type, this is a bug in JS

let test;
console.log(typeof test); // undefined

const sym = Symbol();
console.log(typeof sym); // symbols

// Reference types will come back as objects.

const cars = ['Subaru', 'Toyota'];
console.log(typeof cars); // object

// Object literals
const address = {
    city: 'Boston',
    state: 'MA'
}

console.log(typeof address); // object

const today = new Date();
console.log(tyepof today); // object