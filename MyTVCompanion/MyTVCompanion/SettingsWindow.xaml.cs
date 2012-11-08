using System.Collections.ObjectModel;
using System.Windows;
using MyTVCompanion.ViewModel;
using TvdbLib;
using TvdbLib.Data;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for SettingsWindow.xaml
    /// </summary>
    public partial class SettingsWindow : Window
    {
        public static readonly DependencyProperty ViewModelProperty =
            DependencyProperty.Register("ViewModel", typeof (SettingsWindowViewModel), typeof (SettingsWindow), new PropertyMetadata(default(SettingsWindowViewModel)));

        public SettingsWindowViewModel ViewModel
        {
            get { return (SettingsWindowViewModel) GetValue(ViewModelProperty); }
            set { SetValue(ViewModelProperty, value); }
        }

        public SettingsWindow(TvdbHandler handler, ObservableCollection<TvdbSeries> shows)
        {
            ViewModel = new SettingsWindowViewModel(handler, shows);
            InitializeComponent();
        }

        private void SearchButtonClick(object sender, RoutedEventArgs e)
        {
            SearchResults.ItemsSource = ViewModel.SearchSeries(SearchBox.Text);
        }

        private void AddButtonClick(object sender, RoutedEventArgs e)
        {
            if (SearchResults.SelectedIndex == -1) return;
            var selected = SearchResults.SelectedItem as TvdbSearchResult;
            ViewModel.AddShow(selected.Id);
        }
    }
}
