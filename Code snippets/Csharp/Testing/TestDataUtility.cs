using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Tests.Common.Utility
{
    public static class TestDataUtility
    {
        public static string GetEmbeddedResourceContent(string resourcePath, Assembly assembly)
        {
            var stream = assembly.GetManifestResourceStream(resourcePath);

            if (stream == null)
            {
                throw new ArgumentException(string.Format("The specified embedded resource {0} in assembly {1} could not be found", resourcePath, assembly.FullName));
            }

            using (var reader = new StreamReader(stream))
            {
                return reader.ReadToEnd();
            }
        }

        /// <summary>
        /// Compares two XML results.
        /// </summary>
        /// <param name="expected">The expected xml</param>
        /// <param name="actual">The actual xml</param>
        /// <param name="tagsToExclude">List of tags to exclude</param>
        /// <returns>Comparison result</returns>
        public static bool CompareXml(string expected, string actual, List<string> tagsToExclude)
        {
            expected = RemoveTags(expected, tagsToExclude);
            actual = RemoveTags(actual, tagsToExclude);

            return XmlComparer.AreIsomorphic(expected, actual);
        }

        /// <summary>
        /// Removes the specified tags from the specified XML
        /// </summary>
        /// <param name="document">The xml to remove tags from</param>
        /// <param name="tagsToExclude">The tags to remove</param>
        /// <returns>Processed xml</returns>
        public static string RemoveTags(string document, List<string> tagsToExclude)
        {
            var xmlDocument = new XmlDocument();
            xmlDocument.LoadXml(document);

            foreach (var item in tagsToExclude)
            {
                for (XmlNodeList nodes; (nodes = xmlDocument.GetElementsByTagName(item)) != null && nodes.Count > 0;)
                {
                    var xmlNode = nodes[0];
                    xmlNode.ParentNode.RemoveChild(xmlNode);
                }
            }

            return xmlDocument.OuterXml;
        }
    }
}
