    // It's currently solved with usage of moment.js, change that if you don't want to use it
    function dateDiff(startTime) {
        if (startTime) {
            // Why is it so difficult to get a UTC timestamp?
            // this part is vanilla tough
            var now = new Date(new Date().getTime() + (new Date().getTimezoneOffset() * 60000));

            // Compare dates and return the total in minutes
            var duration = moment.duration(moment(now).diff(startTime));
            var minutes = duration.asMinutes();
            return Math.floor(minutes);
        }
    }