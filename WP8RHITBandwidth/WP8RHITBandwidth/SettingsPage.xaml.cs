using System;
using Microsoft.Phone.Controls;
using System.IO.IsolatedStorage;

namespace WP8RHITBandwidth
{
    public partial class SettingsPage : PhoneApplicationPage
    {
        public SettingsPage()
        {
            InitializeComponent();
            var settings = IsolatedStorageSettings.ApplicationSettings;
            if (settings.Contains("user"))
                UsernameTextBox.Text = (string)settings["user"];
            if (settings.Contains("pass"))
                PasswordBox.Password = (string)settings["pass"];
        }

        private void SaveClick(object sender, EventArgs e)
        {
            var settings = IsolatedStorageSettings.ApplicationSettings;
            if (settings.Contains("user"))
                settings["user"] = UsernameTextBox.Text;
            else
                settings.Add("user", UsernameTextBox.Text);
            if (settings.Contains("pass"))
                settings["pass"] = PasswordBox.Password;
            else settings.Add("pass", PasswordBox.Password);
            NavigationService.Navigate(new Uri("/MainPage.xaml", UriKind.Relative));
        }
    }
}