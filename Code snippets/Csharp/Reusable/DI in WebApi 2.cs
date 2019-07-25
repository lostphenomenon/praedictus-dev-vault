// How to inject dependencies into your ASP.NET Web API controller

//      The Web API Dependency Resolver
//      Web API defines the IDependencyResolver interface for resolving dependencies.Here is the definition of the interface:

public interface IDependencyResolver : IDependencyScope, IDisposable
{
     IDependencyScope BeginScope();
}

public interface IDependencyScope : IDisposable
{
     // GetService creates one instance of a type.
     object GetService(Type serviceType);
     // GetServices creates a collection of objects of a specified type.
     IEnumerable<object> GetServices(Type serviceType);
}

// Although you could write a complete IDependencyResolver 
// implementation from scratch, the interface is really designed to act
//  as bridge between Web API and existing IoC containers.

// Wrapper implementation for Unity with IDependencyResolver::
public class UnityResolver : IDependencyResolver
{
     protected IUnityContainer container;

     public UnityResolver(IUnityContainer container)
     {
          if (container == null)
          {
               throw new ArgumentNullException("container");
          }
          this.container = container;
     }

     public object GetService(Type serviceType)
     {
          try
          {
               return container.Resolve(serviceType);
          }
          catch (ResolutionFailedException)
          {
               return null;
          }
     }

     public IEnumerable<object> GetServices(Type serviceType)
     {
          try
          {
               return container.ResolveAll(serviceType);
          }
          catch (ResolutionFailedException)
          {
               return new List<object>();
          }
     }

     public IDependencyScope BeginScope()
     {
          var child = container.CreateChildContainer();
          return new UnityResolver(child);
     }

     public void Dispose()
     {
          Dispose(true);
     }

     protected virtual void Dispose(bool disposing)
     {
          container.Dispose();
     }
}