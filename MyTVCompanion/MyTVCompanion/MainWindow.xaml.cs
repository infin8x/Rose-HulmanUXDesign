using System.Windows;

namespace MyTVCompanion
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void OnSettingsButtonClick(object sender, RoutedEventArgs e)
        {
            new SettingsWindow().Show();
        }
    }
}
