using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Tests.Common.Utility
{
    public static class DatabaseUtility
    {

        public static void ExecuteNonQuery(
            string connectionString,
            string scriptContent,
            int executionTimeoutSec = 60,
            Dictionary<string, object> parameters = null)
        {
            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                using (var cmd = new SqlCommand(scriptContent, connenction))
                {
                    AddParameters(cmd, parameters);

                    cmd.CommandTimeout = executionTimeoutSec;
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public static T ExecuteScalar<T>(
            string connectionString,
            string scriptContent,
            int executionTimeoutSec = 60,
            Dictionary<string, object> parameters = null)
        {
            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                using (var cmd = new SqlCommand(scriptContent, connenction))
                {
                    AddParameters(cmd, parameters);

                    cmd.CommandTimeout = executionTimeoutSec;
                    var res = cmd.ExecuteScalar();

                    if (res == null)
                    {
                        return default(T);
                    }
                    if (res is T)
                    {
                        return (T)res;
                    }
                    else
                    {
                        throw new InvalidCastException(string.Format("Return value ({0}) of statement ({1}) can not be casted to {2}", res, scriptContent, typeof(T).Name));
                    }
                }
            }
        }

        public static DataTable ExecuteTable(
            string connectionString,
            string scriptContent,
            int executionTimeoutSec = 60,
            Dictionary<string, object> parameters = null)
        {
            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                using (var cmd = new SqlCommand(scriptContent, connenction))
                {
                    AddParameters(cmd, parameters);

                    cmd.CommandTimeout = executionTimeoutSec;
                    var res = cmd.ExecuteReader();

                    var output = new DataTable();
                    output.Load(res);

                    return output;
                }
            }
        }

        public static void BcpTable(
            string connectionString,
            DataTable input,
            string targetTableName,
            int executionTimeoutSec = 60)
        {
            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                SqlBulkCopy bcp = new SqlBulkCopy(connenction);
                bcp.DestinationTableName = targetTableName;

                bcp.WriteToServer(input);
            }
        }

        public static string GetFullyQualifiedTableName(
            string connectionString,
            string tableName
            )
        {
            var sql = $@"SELECT '[' + OBJECT_SCHEMA_NAME(OBJECT_ID(@tableName)) + '].[' + OBJECT_NAME(OBJECT_ID(@tableName)) + ']'";

            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                using (var cmd = new SqlCommand(sql, connenction))
                {
                    cmd.Parameters.AddWithValue("@tableName", tableName);
                    return cmd.ExecuteScalar().ToString();
                }
            }
        }

        public static int GetDatabaseSize(
            string connectionString
            )
        {
            var sql = $@"
            SELECT SUM((size * 8) / 1024) SizeMB
                FROM sys.master_files
            WHERE DB_NAME(database_id) = @databaseName
            ";

            using (var connenction = new SqlConnection(connectionString))
            {
                connenction.Open();

                using (var cmd = new SqlCommand(sql, connenction))
                {
                    cmd.Parameters.AddWithValue("@databaseName", connenction.Database);
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private static void AddParameters(SqlCommand command, Dictionary<string, object> parameters)
        {
            if (parameters != null)
            {
                foreach (var item in parameters)
                {
                    command.Parameters.AddWithValue(item.Key, item.Value);
                }
            }
        }

        public static string Whitelist(string inputToVerify)
        {
            var exceptions = new char[] { '_' };

            return new string(inputToVerify.Where(a => char.IsLetter(a) || char.IsNumber(a) || exceptions.Contains(a)).ToArray());
        }

        public static void WipeDatabase(string connectionString)
        {
            var script = TestDataUtility.GetEmbeddedResourceContent("Tests.Common.Utility.WipeDatabase.sql", Assembly.GetExecutingAssembly());
            DatabaseUtility.ExecuteNonQuery(connectionString, script, 300);
        }
    }
}
