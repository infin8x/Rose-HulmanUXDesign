using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;

namespace WP8RHITBandwidth
{
    using System.IO.IsolatedStorage;
    using System.Threading;

    using RoseHulmanBandwidthMonitorApp;

    public partial class MainPage : PhoneApplicationPage
    {
        public ImageBrush PanoramaBackgroundImage
        {
            get
            {
                var lightThemeEnabled = (Visibility)Application.Current.Resources["PhoneLightThemeVisibility"] ==
                                        Visibility.Visible;
                var url = lightThemeEnabled ? "/Assets/background_light.jpg" : "/Assets/background.jpg";
                return new ImageBrush() { ImageSource = new BitmapImage(new Uri(url, UriKind.Relative)) };
            }
        }

        public MainPage()
        {
            InitializeComponent();

            Loaded += MainPageLoaded;
        }

        private void MainPageLoaded(object sender, RoutedEventArgs e)
        {
            var settings = IsolatedStorageSettings.ApplicationSettings;

            if (settings.Contains("BandwidthClass"))
                UpdateUi(BandwidthResults.RetrieveFromIsolatedStorage(), false);

            var indicator = new ProgressIndicator
            {
                IsVisible = true,
                Text = "Updating usage...",
                IsIndeterminate = true
            };
            SystemTray.ProgressIndicator = indicator;

            new Thread(Scraper.Scrape).Start(this);
        }

        public void UpdateUi(BandwidthResults bandwidthResults, bool fromNetwork)
        {
            foreach (var control in
               new Dictionary<BandwidthMeter, String> { 
    { PolicyDown, bandwidthResults.PolicyReceived },
    { PolicyUp, bandwidthResults.PolicySent }, 
    { ActualDown, bandwidthResults.ActualReceived },
    { ActualUp, bandwidthResults.ActualSent } })
            {
                control.Key.UpdateBorder(GetBandwidthNumberFromString(control.Value), PolicyDown.ActualHeight);
                control.Key.UsageTextBlock.Text =
                    control.Value;
            }

            var tileData = new FlipTileData()
            {
                BackContent = GetBandwidthStringForTile(bandwidthResults),
                Title = "Bandwidth Monitor"
            };
            var primaryTile = ShellTile.ActiveTiles.First();
            primaryTile.Update(tileData);

            if (fromNetwork)
                SystemTray.ProgressIndicator.IsVisible = false;
        }

        private static double GetBandwidthNumberFromString(String str)
        {
            return Double.Parse(str.Split(' ')[0]);
        }

        internal void ReportCredentialsError()
        {
            Dispatcher.BeginInvoke(() =>
            {
                MessageBox.Show(
                    "The credentials you entered don't seem to be working, or we can't find the bandwidth tool right now.");
                NavigationService.Navigate(new Uri("/SettingsPage.xaml", UriKind.Relative));
            });
        }
        
        private static String GetBandwidthStringForTile(BandwidthResults results)
        {
            var received = Convert.ToInt32(GetBandwidthNumberFromString(results.PolicyReceived)) + " MB";
            var sent = Convert.ToInt32(GetBandwidthNumberFromString(results.PolicySent)) + " MB";
            return results.BandwidthClass + "\r\nD: " + received + "\r\nU: " + sent;
        }

        private void SettingsButtonClick(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/SettingsPage.xaml", UriKind.Relative));
        }

        // Load data for the ViewModel Items
        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            if (!App.ViewModel.IsDataLoaded)
            {
                App.ViewModel.LoadData();
            }
        }
    }
}