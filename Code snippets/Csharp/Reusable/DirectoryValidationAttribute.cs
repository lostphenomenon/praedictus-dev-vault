using System;
using System.ComponentModel.DataAnnotations;
using System.IO;

namespace Infrastructure
{
    /// <summary>
    /// Validates directory name
    /// </summary>
    public class DirectoryAttribute : ValidationAttribute
    {
        /// <summary>
        /// Check if given value is valid
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public override bool IsValid(object value)
        {
            try
            {
                string path = value as string;
                Path.GetFullPath(path);
            }
            catch (Exception e)
            {
                ErrorMessage = e.Message;
                return false;
            }
            return true;
        }
    }
}
