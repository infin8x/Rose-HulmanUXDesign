using System.Collections.ObjectModel;
using System.IO;
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
        public ObservableCollection<TvdbSeries> Shows { get; private set; }
        public TvdbHandler TvdbHandler { get; private set; }
        public App()
        {
            TvdbHandler = new TvdbHandler("49FF3082EF06CF50");
            if (File.Exists(".\\mydata.bin"))
            {
                using (var stream = File.OpenRead(".\\mydata.bin"))
                {
                    var deserializer = new BinaryFormatter();
                    Shows = (ObservableCollection<TvdbSeries>)deserializer.Deserialize(stream);
                }
            }
            else { Shows = new ObservableCollection<TvdbSeries>(); }
        }

        private void AppExit(object sender, ExitEventArgs e)
        {
            var serializer = new BinaryFormatter();
            serializer.Serialize(File.Create(".\\mydata.bin"), Shows);
        }

    }
}
