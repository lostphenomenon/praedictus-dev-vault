using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;

namespace XYZ
{
    public class ExcelGenerator
    {
        public byte[] GenerateXlsx<T>(IEnumerable<T> collection)
        {
            return GenerateXlsxWithSum(collection, string.Empty, null);
        }

        public byte[] GenerateXlsxWithSum<T>(IEnumerable<T> collection, string summary)
        {
            return GenerateXlsxWithSum(collection, summary, null);
        }

        public byte[] GenerateXlsxWithSum<T>(IEnumerable<T> collection, string summary, int[] sumPlace,  string currency = "€")
        {
            using (var ms = new MemoryStream())
            {
                var excelPackage = new ExcelPackage(ms);
                var workSheet = excelPackage.Workbook.Worksheets.Add("Export");

                GenerateHeader(typeof(T), workSheet);
                Generate(collection, workSheet, sumPlace, summary, currency);

                excelPackage.Save();

                return ms.ToArray();
            }
        }

        private void Generate<T>(
            IEnumerable<T> collection,
            ExcelWorksheet workSheet,
            int[] sumPlace,
            string summary,
            string currency)
        {
            int row = GenerateRows(collection, workSheet);

            row++;

            if (sumPlace != null && sumPlace.Any())
            {
                foreach (int i in sumPlace)
                {
                    var address = new ExcelAddress(3, i, row - 1, i).Address;
                    workSheet.Cells[row, i].Formula = string.Format("Sum({0})", address);
                    workSheet.Cells[row, i].Style.Font.Bold = true;
                    workSheet.Cells[row, i].Style.Numberformat.Format = currency + " #,##0.00";
                }
            }

            if (!string.IsNullOrEmpty(summary))
            {
                workSheet.Cells[row, 1].Style.Font.Bold = true;
                workSheet.Cells[row, 1].Value = summary;
            }
        }

        private void GenerateHeader(Type collectionType, ExcelWorksheet worksheet)
        {
            var properties = GetProperties(collectionType);
            int cell = 1;

            foreach (var propertyInfo in properties)
            {
                worksheet.Cells[1, cell++].Value = propertyInfo.Name;
            }
        }

        private int GenerateRows<T>(IEnumerable<T> collection, ExcelWorksheet workSheet)
        {
            int row = 3;
            var properties = GetProperties(typeof(T));
            foreach (var item in collection)
            {
                int cell = 1;

                foreach (var propertyInfo in properties)
                {
                    workSheet.Cells[row, cell++].Value = propertyInfo.GetValue(item);
                }
                row++;
            }

            return row;
        }

        private IEnumerable<PropertyInfo> GetProperties(Type type)
        {
            return type.GetProperties().OrderBy(x => x, new PropertySortOrderComparer());
        }
    }
}
