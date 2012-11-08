using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion.ViewModel
{
    public class SettingsWindowViewModel : DependencyObject
    {
        internal TvdbHandler TvdbHandler { get; private set; }
        public ObservableCollection<TvdbSeries> Shows { get; private set; }

        public SettingsWindowViewModel(TvdbHandler handler, ObservableCollection<TvdbSeries> shows)
        {
            TvdbHandler = handler;
            Shows = shows;
        }

        public List<TvdbSearchResult> SearchSeries(string searchText)
        {
            return TvdbHandler.SearchSeries(searchText);
        }

        public void AddShow(int seriesId)
        {
            Shows.Add(TvdbHandler.GetSeries(seriesId, TvdbLanguage.DefaultLanguage, true, false, false));
        }
    }
}
