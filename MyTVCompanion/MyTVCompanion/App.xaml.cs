using System;
using System.Collections.ObjectModel;
using System.IO;
using System.IO.IsolatedStorage;
using System.Runtime.Serialization.Formatters.Binary;
using System.Windows;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        private readonly IsolatedStorageFile _isolatedStorage;
        private const String ShowsFileName = "mydata.bin";

        public ObservableCollection<TvdbSeries> Shows { get; private set; }
        public TvdbHandler TvdbHandler { get; private set; }
        public App()
        {
            TvdbHandler = new TvdbHandler("49FF3082EF06CF50");
            _isolatedStorage = IsolatedStorageFile.GetUserStoreForAssembly();
            if (_isolatedStorage.FileExists(ShowsFileName))
            {
                using (var stream = _isolatedStorage.OpenFile(ShowsFileName, FileMode.Open))
                {
                    var deserializer = new BinaryFormatter();
                    Shows = (ObservableCollection<TvdbSeries>)deserializer.Deserialize(stream);
                }
            }
            else { Shows = new ObservableCollection<TvdbSeries>(); }
        }

        private void AppExit(object sender, ExitEventArgs e)
        {
            var isolatedStorage = IsolatedStorageFile.GetUserStoreForAssembly();
            new BinaryFormatter().Serialize(isolatedStorage.CreateFile(ShowsFileName), Shows);
        }
    }
}
