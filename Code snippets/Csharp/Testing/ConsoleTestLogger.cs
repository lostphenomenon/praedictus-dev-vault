public interface ITestLogger
    {
        void LogInfo(string message);

        void LogException(string message, Exception ex);

        void LogTestCaseStart(string testCaseName);

        void LogSectionStart(string sectionName);

        void LogAssertPass(string testCase, string assert);

        void LogAssertFail(string testCase, string assert, string expected, string actual);
    }

    public class ConsoleLogger : ITestLogger
    {
        public void LogAssertFail(string testCase, string assert, string expected, string actual)
        {
            var originalColour = Console.ForegroundColor;
            Console.ForegroundColor = ConsoleColor.Red;

            Console.WriteLine($"[-] { testCase } = { assert } => FAILED");
            Console.WriteLine("Expected:");
            Console.WriteLine(expected);
            Console.WriteLine("Actual:");
            Console.WriteLine(actual);

            Console.ForegroundColor = originalColour;
        }

        public void LogAssertPass(string testCase, string assert)
        {
            var originalColour = Console.ForegroundColor;
            Console.ForegroundColor = ConsoleColor.Green;

            Console.WriteLine($"[+] { testCase } = { assert } => PASSED");

            Console.ForegroundColor = originalColour;
        }

        public void LogException(string message, Exception ex)
        {
            var originalColour = Console.ForegroundColor;
            Console.ForegroundColor = ConsoleColor.DarkRed;

            Console.WriteLine($"[{DateTime.UtcNow.ToString()}] ERROR: {message} = {ex.ToString()}");

            Console.ForegroundColor = originalColour;
        }

        public void LogInfo(string message)
        {
            Console.WriteLine($"[{ DateTime.UtcNow.ToString()}] { message }");
        }

        public void LogTestCaseStart(string testCaseName)
        {
            Console.WriteLine("");
            Console.WriteLine("===================================================================");
            Console.WriteLine($"[{ DateTime.UtcNow.ToString()}] TEST CASE: {testCaseName}");
            Console.WriteLine("===================================================================");
        }

        public void LogSectionStart(string sectionName)
        {
            Console.WriteLine($"[{ DateTime.UtcNow.ToString()}] { sectionName } ===============");
        }
    }