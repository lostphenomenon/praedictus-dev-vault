private static int FindNthOccurrenceOfCharacterInString(char ch, string str, int n = 2)
{
    var result = str
    .Select((c, i) => new { c, i })
    .Where(x => x.c == ch)
    .Skip(n - 1)
    .FirstOrDefault();
    return result != null ? result.i : -1;
}
