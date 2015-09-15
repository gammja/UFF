using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;

namespace UFF.CS
{
    static class Program
    {
        static void Main(string[] args)
        {
            const string root = @"C:\Users\sp\Source\Repos\ChangeTracking\Source";
            var excluded = new[] { @"\obj", @"\bin", @"\Properties", ".vs", @"\packages" };

            Func<string, bool> isIncluded = (name) => excluded.All(e => !name.Contains(e));

            var path = new DirectoryInfo(root)
                .GetDirectories("*", SearchOption.AllDirectories)
                .Select(di => di.FullName)
                .Where(isIncluded)
                .SelectMany(Directory.GetFiles)
                .ToList();

            XNamespace ns = "http://schemas.microsoft.com/developer/msbuild/2003";
            var csproj = path.Where(p => Path.GetExtension(p) == ".csproj");
            var used = csproj
                .Select(XElement.Load)
                .Elements(ns + "ItemGroup")
                .Elements(ns + "Compile")
                .Attributes("Include")
                .Select(a => a.Value)
                .Where(isIncluded)
                .Select(Path.GetFileName);

            var cs = path
                .Where(p => Path.GetExtension(p) == ".cs")
                .Select(Path.GetFileName);

            var unused = cs.Except(used);
            unused.ToList().ForEach(Console.WriteLine);
        }
    }
}
