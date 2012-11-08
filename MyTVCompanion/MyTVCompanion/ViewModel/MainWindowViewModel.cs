using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.IO.IsolatedStorage;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Text;
using System.Threading.Tasks;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion.ViewModel
{
    public class MainWindowViewModel
    {
        private IsolatedStorageFile _isolatedStorage;
        private const String ShowsFileName = "mydata.bin";

        internal TvdbHandler TvdbHandler { get; private set; }
        public ObservableCollection<TvdbSeries> Shows { get; private set; }
        public ObservableCollection<String> SelectedDayEpisodes { get; private set; }

        public MainWindowViewModel()
        {
            TvdbHandler = new TvdbHandler("49FF3082EF06CF50");
            GetShowsFromIsolatedStorage();
            SelectedDayEpisodes = new ObservableCollection<String>();
            GetDayEpisodes(DateTime.Today);
        }

        public void GetDayEpisodes(DateTime day)
        {
            SelectedDayEpisodes.Clear();
            var seriesThatAirToday = Shows.Where(series => series.AirsDayOfWeek == day.DayOfWeek).ToList();

            var episodesToSort = (from series in seriesThatAirToday
                                  let episode =
                                      series.GetEpisodes(series.NumSeasons).FindLast((ep) => ep.FirstAired == day.Date)
                                  where episode != default(TvdbEpisode)
                                  select new EpisodeToSort() { Episode = episode, Series = series })
                                  .ToList();

            episodesToSort.Sort((c1, c2) =>
            {
                var c1Time = DateTime.Parse(c1.Series.AirsTime);
                var c2Time = DateTime.Parse(c2.Series.AirsTime);
                if (c1Time < c2Time) return -1;
                if (c1Time > c2Time) return 1;
                return 0;
            });

            foreach (var e in episodesToSort)
                SelectedDayEpisodes.Add(e.Series.AirsTime + " - " + e.Series.SeriesName + ": " + e.Episode.EpisodeName);
        }

        private struct EpisodeToSort
        {
            public TvdbSeries Series;
            public TvdbEpisode Episode;
        }

        #region Isolated Storage
        private void GetShowsFromIsolatedStorage()
        {
            _isolatedStorage = IsolatedStorageFile.GetUserStoreForAssembly();
            if (_isolatedStorage.FileExists(ShowsFileName))
            {
                using (var stream = _isolatedStorage.OpenFile(ShowsFileName, FileMode.Open))
                {
                    var deserializer = new BinaryFormatter();
                    Shows = (ObservableCollection<TvdbSeries>)deserializer.Deserialize(stream);
                }
            }
            else
            {
                Shows = new ObservableCollection<TvdbSeries>();
            }
        }

        public void Exit()
        {
            var isolatedStorage = IsolatedStorageFile.GetUserStoreForAssembly();
            new BinaryFormatter().Serialize(isolatedStorage.CreateFile(ShowsFileName), Shows);
        }
        #endregion
    }
}
