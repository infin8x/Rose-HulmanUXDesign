using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TvdbLib;
using TvdbLib.Cache;

namespace TvdbAdapterConsoleTester
{
    class Program
    {
        static void Main(string[] args)
        {
            var tvdbHandler = new TvdbHandler(new XmlCacheProvider("%temp%"),"49FF3082EF06CF50");
            tvdbHandler.InitCache();
            var searchResults = tvdbHandler.SearchSeries("Big Bang");

            Console.ReadLine();
        }
    }
}
