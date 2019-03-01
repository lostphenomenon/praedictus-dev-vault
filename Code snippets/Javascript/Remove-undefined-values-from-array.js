    // Remove undefined / null values from an array
    private removeUndefinedValuesFromArray(array: Array < any > ) {
        while (array.includes(undefined)) {
            let indexOfUndefined = array.findIndex(element => element === undefined);
            if (indexOfUndefined == -1) {
                console.log("nothing to remove");
            } else {
                console.log("Undefined element found at: " + indexOfUndefined);
                array.splice(indexOfUndefined, 2);
                console.log("Removed");
            }
        }
    }