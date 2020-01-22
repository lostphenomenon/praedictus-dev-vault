using System;
using System.Security.Cryptography;
using System.Text;
namespace Reusable.Code {
    public class Md5EncryptionService : IEncryptionService
    {
        public string Encrypt(string token)
        {
            if (token == null) throw new ArgumentNullException(nameof(token));
            if (string.IsNullOrWhiteSpace(token)) throw new ArgumentOutOfRangeException($"Value cannot be empty string or whitespace.{Environment.NewLine}Parameter name: {nameof(token)}");
            using (var cryptoServiceProvider = new MD5CryptoServiceProvider())
            {
                var sb = new StringBuilder();
                var hash = cryptoServiceProvider.ComputeHash(new UTF8Encoding().GetBytes(token));

                foreach (var b in hash)
                {
                    sb.Append(b.ToString("x2").ToLower());
                }

                var encryptedString = sb.ToString();
                return encryptedString;
            }
        }
    }
}