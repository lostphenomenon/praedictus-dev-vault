## Parallel Programming in .NET

# High-level overview of the parallel programming architecture in the .NET Framework:
![Image](https://docs.microsoft.com/en-us/dotnet/standard/parallel-programming/media/tpl-architecture.png)

# Technologies:
    - Task Parallel Library (TPL)
    - Parallel LINQ (PLINQ)

# TPL - Data parallellism

You write the loop logic for a Parallel.For or Parallel.ForEach loop much as you would write a sequential loop. You do not have to create threads or queue work items. In basic loops, you do not have to take locks. The TPL handles all the low-level work for you.

// Sequential version            
foreach (var item in sourceCollection)
{
    Process(item);
}

// Parallel equivalent
Parallel.ForEach(sourceCollection, item => Process(item));