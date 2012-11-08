using System;
using System.Windows;
using MyTVCompanion.ViewModel;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public static readonly DependencyProperty ViewModelProperty =
            DependencyProperty.Register("ViewModel", typeof(MainWindowViewModel),
                typeof(MainWindow), new PropertyMetadata(default(MainWindowViewModel)));

        public MainWindowViewModel ViewModel
        {
            get { return (MainWindowViewModel)GetValue(ViewModelProperty); }
            set { SetValue(ViewModelProperty, value); }
        }

        public MainWindow()
        {
            ViewModel = new MainWindowViewModel();
            InitializeComponent();
            Calendar.SelectedDate = DateTime.Today;
            Application.Current.Exit += (sender, args) => ViewModel.Exit();
        }

        private void OnSettingsButtonClick(object sender, RoutedEventArgs e)
        {
            var window = new SettingsWindow(ViewModel.TvdbHandler, ViewModel.Shows);
            window.Closed += (o, k) =>
                ViewModel.GetDayEpisodes(Calendar.SelectedDate.GetValueOrDefault());
            window.Owner = this;
            window.Show();
        }

        private void CalendarSelectedDatesChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            ViewModel.GetDayEpisodes((DateTime)e.AddedItems[0]);
        }
    }
}
