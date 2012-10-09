using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using TvdbLib;
using TvdbLib.Cache;
using TvdbLib.Data;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for SettingsWindow.xaml
    /// </summary>
    public partial class SettingsWindow : Window
    {
        private TvdbHandler _tvdbHandler;

        public SettingsWindow()
        {
            InitializeComponent();
            _tvdbHandler = new TvdbHandler(new XmlCacheProvider("%temp%"), "49FF3082EF06CF50");
            _tvdbHandler.InitCache();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            
            var results = _tvdbHandler.SearchSeries(SearchBox.Text);
            SearchResults.ItemsSource= results;
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            if (SearchResults.SelectedIndex == -1) return;
            var watchedShows = new List<TvdbData>();
            //SearchResults.ItemsSource.Cast<TvdbSearchResult>().Where(());
            //watchedShows.Add(_tvdbHandler.GetSeries(,TvdbLanguage.DefaultLanguage, false,false,false));
        }
    }
}
