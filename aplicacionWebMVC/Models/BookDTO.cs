using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace aplicacionWebMVC.Models
{
    public class BookDTO
    {
        public int IdBook { get; set; }
        public string Title { get; set; }
        public string Code { get; set; }
        public int Status { get; set; }
        public DateTime DateCreate { get; set; }
        public DateTime DateUpdate { get; set; }
        public bool IsActive { get; set; }
    }
}
