using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Windows;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for SettingsWindow.xaml
    /// </summary>
    public partial class SettingsWindow : Window
    {
        private TvdbHandler _tvdbHandler;
        private List<TvdbSearchResult> results;
        public ObservableCollection<TvdbSeries> Shows { get; set; }

        public SettingsWindow()
        {
            Shows = ((App)Application.Current).Shows;
            _tvdbHandler = ((App)Application.Current).TvdbHandler;
            InitializeComponent();
        }

        private void SearchButtonClick(object sender, RoutedEventArgs e)
        {
            results = _tvdbHandler.SearchSeries(SearchBox.Text);
            SearchResults.ItemsSource = results;
        }

        private void AddButtonClick(object sender, RoutedEventArgs e)
        {
            if (SearchResults.SelectedIndex == -1) return;
            var selected = SearchResults.SelectedItem as TvdbSearchResult;
            Shows.Add(_tvdbHandler.GetSeries(selected.Id, TvdbLanguage.DefaultLanguage, true, false, false));
        }
    } 
}
