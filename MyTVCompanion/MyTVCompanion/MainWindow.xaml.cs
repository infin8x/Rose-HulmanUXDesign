using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public ObservableCollection<String> SelectedDayEpisodes { get; private set; }
        public ObservableCollection<TvdbSeries> Shows { get; set; }
        private TvdbHandler _tvdbHandler;
        public MainWindow()
        {
            Shows = ((App)Application.Current).Shows;
            _tvdbHandler = ((App)Application.Current).TvdbHandler;
            SelectedDayEpisodes = new ObservableCollection<String>();
            InitializeComponent();
            GetDayEpisodes(DateTime.Today);
        }

        private void GetDayEpisodes(DateTime day)
        {
            SelectedDayEpisodes.Clear();
            var seriesThatAirToday = Shows.Where(series => series.AirsDayOfWeek == day.DayOfWeek).ToList();

            var episodesToSort = (from series in seriesThatAirToday
                                  let episode =
                                      series.GetEpisodes(series.NumSeasons).FindLast((ep) => ep.FirstAired == day.Date)
                                  where episode != default(TvdbEpisode)
                                  select new EpisodeToSort() {episode = episode, series = series})
                                  .ToList();

            episodesToSort.Sort((c1, c2) =>
            {
                var c1Time = DateTime.Parse(c1.series.AirsTime);
                var c2Time = DateTime.Parse(c2.series.AirsTime);
                if (c1Time < c2Time) return -1;
                if (c1Time > c2Time) return 1;
                return 0;
            });

            foreach (var e in episodesToSort)
                SelectedDayEpisodes.Add(e.series.AirsTime + " - " + e.series.SeriesName + ": " + e.episode.EpisodeName);
        }

        private void OnSettingsButtonClick(object sender, RoutedEventArgs e)
        {
            var window = new SettingsWindow();
            window.Closed += (o, k) =>
                GetDayEpisodes(Calendar.SelectedDate.GetValueOrDefault());
            window.Show();
        }

        private void CalendarSelectedDatesChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            GetDayEpisodes((DateTime)e.AddedItems[0]);
        }

        private struct EpisodeToSort
        {
            public TvdbSeries series;
            public TvdbEpisode episode;
        }
    }
}
