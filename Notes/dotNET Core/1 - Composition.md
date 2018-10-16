# .NET Core Composition:
.NET Core is composed of the following parts:

- The .NET Core runtime, which provides a type system, assembly loading, a garbage collector, native interop and other basic services. .NET Core framework libraries provide primitive data types, app composition types and fundamental utilities.
- The ASP.NET runtime, which provides a framework for building modern cloud based internet connected applications, such as web apps, IoT apps and mobile backends.
- The .NET Core CLI tools and language compilers (Roslyn and F#) that enable the .NET Core developer experience.
The dotnet tool, which is used to launch .NET Core apps and CLI tools. It selects the runtime and hosts the runtime, provides an assembly loading policy and launches apps and tools.

### Comparison with .NET Framework
The major differences between .NET Core and the .NET Framework:
- App-models -- .NET Core does not support all the .NET Framework app-models. In particular, it doesn't support ASP.NET Web Forms and MVC. It was announced that .NET Core 3 will support WPF and Windows Forms.
- APIs -- .NET Core contains a large subset of .NET Framework Base Class Library, with a different factoring (assembly names are different; members exposed on types differ in key cases). These differences require changes to port source to .NET Core in some cases (see microsoft/dotnet-apiport). .NET Core implements the .NET Standard API specification.
Subsystems -- .NET Core implements a subset of the subsystems in the .NET Framework, with the goal of a simpler implementation and programming model. For example, Code Access Security (CAS) is not supported, while reflection is supported.
- Platforms -- The .NET Framework supports Windows and Windows Server while .NET Core also supports macOS and Linux.
- Open Source -- .NET Core is open source, while a read-only subset of the .NET Framework is open source.

### Comparison with Mono
The major differences between .NET Core and Mono:

- App-models -- Mono supports a subset of the .NET Framework app-models (for example, Windows Forms) and some additional ones (for example, Xamarin.iOS) through the Xamarin product. .NET Core doesn't support these.
- APIs -- Mono supports a large subset of the .NET Framework APIs, using the same assembly names and factoring.
- Platforms -- Mono supports many platforms and CPUs.
- Open Source -- Mono and .NET Core both use the MIT license and are .NET Foundation projects.
- Focus -- The primary focus of Mono in recent years is mobile platforms, while .NET Core is focused on cloud and desktop workloads.