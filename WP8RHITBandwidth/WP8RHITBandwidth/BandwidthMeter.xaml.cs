using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;

namespace WP8RHITBandwidth
{
    public partial class BandwidthMeter : UserControl
    {
        public BandwidthMeter()
        {
            InitializeComponent();
        }
        public static readonly DependencyProperty RedTextBlockProperty =
    DependencyProperty.Register("RedTextBlock", typeof(String), typeof(BandwidthMeter), new PropertyMetadata(default(String)));

        public String RedTextBlock
        {
            get { return (String)GetValue(RedTextBlockProperty); }
            set { SetValue(RedTextBlockProperty, value); }
        }

        public static readonly DependencyProperty YellowTextBlockProperty =
            DependencyProperty.Register("YellowTextBlock", typeof(String), typeof(BandwidthMeter), new PropertyMetadata(default(String)));

        public String YellowTextBlock
        {
            get { return (String)GetValue(YellowTextBlockProperty); }
            set { SetValue(YellowTextBlockProperty, value); }
        }

        public static readonly DependencyProperty GreenTextBlockProperty =
            DependencyProperty.Register("GreenTextBlock", typeof(String), typeof(BandwidthMeter), new PropertyMetadata(default(String)));

        public String GreenTextBlock
        {
            get { return (String)GetValue(GreenTextBlockProperty); }
            set { SetValue(GreenTextBlockProperty, value); }
        }

        public void UpdateBorder(double value, double gridHeight)
        {
            var to = value / 5000 * gridHeight;
            UsageBorder.Visibility = Visibility.Visible;
            UsageBorder.Height = to;
        }
    }
}
