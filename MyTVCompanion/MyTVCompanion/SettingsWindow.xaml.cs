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
        public ObservableCollection<TvdbSeries> Shows { get { return ((App)Application.Current).Shows; } }
        private TvdbHandler TvdbHandler { get { return ((App)Application.Current).TvdbHandler; } }

        public SettingsWindow()
        {
            InitializeComponent();
        }

        private void SearchButtonClick(object sender, RoutedEventArgs e)
        {
            SearchResults.ItemsSource = TvdbHandler.SearchSeries(SearchBox.Text);
        }

        private void AddButtonClick(object sender, RoutedEventArgs e)
        {
            if (SearchResults.SelectedIndex == -1) return;
            var selected = SearchResults.SelectedItem as TvdbSearchResult;
            Shows.Add(TvdbHandler.GetSeries(selected.Id, TvdbLanguage.DefaultLanguage, true, false, false));
        }
    }
}
