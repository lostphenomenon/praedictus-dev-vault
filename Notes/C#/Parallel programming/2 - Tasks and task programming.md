# Tasks in general

Task: An abstraction to group a unit of work together and thus telling the scheduler that this unit of work
can be executed on a thread.

    ## Creating tasks

        - Task.Factory.StartNew(Action action);
        - Task.Factory.StartNew(() => Console.Write("smth"));

        We are doing 2 things at a time, creating and a task and starting it immediately.
        When you declare a variable of type task [e.g.: var t = new Task(() => Dosomething());]
        it doesn't immediately start by itself, you have to call t.Start() to fire it.

        It is possible to provide de action and the argument separately via an overload.

        Example:
        public static void Write(object o)
        {
            for(int i = 0; i < 10; i++)
            {
                // You can also print the id of the currently executing task
                Console.WriteLine($"Current tasks id = {Task.CurrentId}")
                Console.WriteLine(o);
            }            
        }

        ...
            // explicit task
            Task t = new Task(Write, "hello");
            // implicit task
            Task.Factory.StartNew(Write, 12312);

        As soon as you ask a task for its result, you are basically stating that you are prepared to WAIT untill it's finished.
        Which means that waiting for a result is a blocking operation.

    ## Canceling tasks

        The TASK that you are creating has to be explicitly aware of the fact that its being cancellable and it has to perform
        actions to actually cancel itself.

        CancellationTokens are the utility to use when you want to stop execution of certain tasks.
        - CancellationTokenSource
        - CancellationToken : You have to provide a reference into the body of the task which you want to cancel.

    There are 2 ways of cancelling execution:
        - Soft failure: e.g. if(token.IsCancellationRequested) break;
        
        - Using exception: (the more canonical way, TPL recommendation): throw new OperationCanceledException();
            This is not going to cause an exception on the high level because this exception is already expected by
            the framework.

            Short version:  token.ThrowIfCancellationRequested();

        The difference in the end result lies in the TaskStatus, because if you throw the recommended exception
        the task will "know" that it is being cancelled (t.Status = Cancelled) otherwise you have to change it status.
        The main question we have to ask here if we want to know wether a TASK has been canceled.

        ### Monitoring task cancellation

            Event subscription:

            token.Register(
                () => { Console.WriteLine("Cancellation was requested); }
            );

            OR
            using wait handles

            Task.Factory.TartNew(() =>
            {
                token.WaitHandle.WaitOne();
                Console.WriteLine("Waithandle has been released");
            });

        ### Composite cancellationtokens

        - There might be cases, when you want to monitor cancellations which were planned or for preventative cases or for emergencies

        e.g.: Declare multiple cancellationToken sources and define a task that cancels in case any of those are triggered

            var planned = new CancellationTokenSource();
            var preventive = new CancellationTokenSource();
            var emergency = new CancellationTokenSource();

            var paranoidCSource = CancellationTokenSource.CreateLinkedTokenSource(
                planned.Token,
                preventive.Token,
                emergency.Token
            );

            Task.Factory.StartNew(() =>
                {
                    paranoid.Token.ThrowIfCancellationRequested();
                    DoSomething();
                }
            );

    ## Passing time

        Options:

            Thread.Sleep() : Tells the processor that this process shall stop execution for the specified time, in the meanwhile other threads can
                be executed with the proccessor

            Thread.SpinWait() : You dont give up your place in the execution schedule. You waste cycles, return is faster, avoids context switches.
            SpinWait.SpinUntil()

            Using Waithandle::
            var cts = new CancellationTokenSource();
            var token = cts.Token;
            var t = new Task(() =>
            { 
                Console.WriteLine("You have 5 seconds to disarm this bomb by pressing a key");
                // Take the waithandle wait for given time for cancellation, continue afterwards
                bool canceled = token.WaitHandle.WaitOne(5000);
                Console.WriteLine(canceled ? "Bomb disarmed." : "BOOM!!!!");
            }, token);
            
            Console.WriteLine("Are you still here?");
            Console.ReadKey();
            cts.Cancel();

    ## Waiting for TASKs

        - Task.WaitAll(taskarray)
        - Task.WaitAny(taskarray)
        - Task.Wait()