using System.Collections.Generic;
using System.Text;

namespace XYZ
{
    public class CSVGenerator
    {
        private char _separator = '.';
        private bool _includeNullValues = false;

        public byte[] GenerateCsvBytes<T>(IEnumerable<T> collection)
        {
            var result = GenerateCSV(collection);
            return Encoding.UTF8.GetBytes(result);
        }

        public string GenerateCSV<T>(IEnumerable<T> collection)
        {
            var csv = new StringBuilder();

            foreach (var item in collection)
            {
                var line = string.Empty;

                var itemProperties = item.GetType().GetProperties();
                foreach (var propertyInfo in itemProperties)
                {
                    var value = propertyInfo.GetValue(item);
                    if (value != null || _includeNullValues)
                        line += string.Format("{0}{1}", value, _separator);
                }

                line = line.Remove(line.Length - 1, 1);

                csv.AppendLine(line);
            }

            return csv.ToString();
        }

        public byte[] GenerateCsvBytes<T>(IEnumerable<T> collection, char separator, bool includeNullValues = false)
        {
            _separator = separator;
            _includeNullValues = includeNullValues;

            return GenerateCsvBytes<T>(collection);
        }

        public string GenerateCsvString<T>(IEnumerable<T> collection, char separator, bool includeNullValues = false)
        {
            _separator = separator;
            _includeNullValues = includeNullValues;

            return GenerateCSV<T>(collection);
        }
    }
}