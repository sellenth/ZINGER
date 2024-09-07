using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ZingerLauncher
{
    public partial class MainForm : Form
    {
        private const string GITHUB_RAW_URL = "https://raw.githubusercontent.com/sellenth/ZINGER/main/dist/";
        private const string NEWS_FILENAME = "news.txt";
        private const string ENGINE_FILENAME = "engine.exe";
        private const string GAME_FILENAME = "engine.pck";
        private const string SCREENSHOT_FILENAME = "screenshot.png";

        public MainForm()
        {
            InitializeComponent();
            this.Load += MainForm_Load;
            LoadScreenshot();
            newsbox.Text = "Loading news...";
        }

        private void LoadScreenshot()
        {
            try
            {
                string screenshotPath = Path.Combine(AppContext.BaseDirectory, SCREENSHOT_FILENAME);

                if (File.Exists(screenshotPath))
                {
                    using (var stream = new FileStream(screenshotPath, FileMode.Open, FileAccess.Read))
                    {
                        screenshotPictureBox.Image = Image.FromStream(stream);
                    }
                }
                else
                {
                    // Try to load from embedded resources
                    using (var stream = GetType().Assembly.GetManifestResourceStream(SCREENSHOT_FILENAME))
                    {
                        if (stream != null)
                        {
                            screenshotPictureBox.Image = Image.FromStream(stream);
                        }
                        else
                        {
                            MessageBox.Show($"Screenshot file not found: {screenshotPath}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading screenshot: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private async void MainForm_Load(object sender, EventArgs e)
        {
            await CheckAndDownloadEngine();
            await CheckAndDownloadGame();
            UpdateButtonState();
        }

        private async Task FetchNews()
        {
            try
            {
                using (var client = new HttpClient())
                {
                    string newsContent = await client.GetStringAsync(GITHUB_RAW_URL + NEWS_FILENAME);
                    newsbox.Text = newsContent;
                }
            }
            catch (Exception ex)
            {
                UpdateStatus($"Error fetching news: {ex.Message}");
            }
        }

        private async Task CheckAndDownloadEngine()
        {
            if (!File.Exists(ENGINE_FILENAME))
            {
                await DownloadFile(GITHUB_RAW_URL + ENGINE_FILENAME, ENGINE_FILENAME, "Downloading engine...");
            }
            else
            {
                UpdateStatus("Engine already exists.");
            }
        }

        private async Task CheckAndDownloadGame()
        {
            if (!File.Exists(GAME_FILENAME))
            {
                await DownloadLatestGame();
            }
            else
            {
                UpdateStatus("Game file up to date.");
            }
        }

        private async Task DownloadLatestGame()
        {
            await DownloadFile(GITHUB_RAW_URL + GAME_FILENAME, GAME_FILENAME, "Downloading latest .pck...");
        }

        private async Task DownloadFile(string url, string filename, string statusMessage)
        {
            UpdateStatus(statusMessage);
            using (var client = new HttpClient())
            {
                var response = await client.GetAsync(url, HttpCompletionOption.ResponseHeadersRead);
                response.EnsureSuccessStatusCode();
                var totalBytes = response.Content.Headers.ContentLength ?? -1L;
                using (var contentStream = await response.Content.ReadAsStreamAsync())
                using (var fileStream = new FileStream(filename, FileMode.Create, FileAccess.Write, FileShare.None, 8192, true))
                {
                    var totalReadBytes = 0L;
                    var buffer = new byte[8192];
                    var isMoreToRead = true;

                    do
                    {
                        var readBytes = await contentStream.ReadAsync(buffer, 0, buffer.Length);
                        if (readBytes == 0)
                        {
                            isMoreToRead = false;
                        }
                        else
                        {
                            await fileStream.WriteAsync(buffer, 0, readBytes);
                            totalReadBytes += readBytes;
                            if (totalBytes != -1)
                            {
                                var progressPercentage = (int)((float)totalReadBytes / totalBytes * 100);
                                UpdateProgress(progressPercentage);
                            }
                        }
                    }
                    while (isMoreToRead);
                }
            }
            UpdateStatus($"Download of {filename} completed.");
            UpdateProgress(100);
        }

        private void StartGame()
        {
            if (File.Exists(ENGINE_FILENAME) && File.Exists(GAME_FILENAME))
            {
                UpdateStatus("Launching game...");
                string username = string.IsNullOrWhiteSpace(usernameTextBox.Text) ? "Username" : usernameTextBox.Text;
                Process.Start(ENGINE_FILENAME, $"--main-pack {GAME_FILENAME} --username {username}");
                this.Close();
            }
            else
            {
                MessageBox.Show("Engine or game file is missing. Please update first.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void UpdateStatus(string status)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<string>(UpdateStatus), status);
                return;
            }
            statusLabel.Text = status;
        }

        private void UpdateProgress(int value)
        {
            if (InvokeRequired)
            {
                Invoke(new Action<int>(UpdateProgress), value);
                return;
            }
            progressBar.Value = value;
        }

        private void UpdateButtonState()
        {
            playButton.Enabled = File.Exists(ENGINE_FILENAME) && File.Exists(GAME_FILENAME);
        }

        private async void updateButton_Click(object sender, EventArgs e)
        {
            updateButton.Enabled = false;
            playButton.Enabled = false;
            await DownloadLatestGame();
            UpdateButtonState();
            updateButton.Enabled = true;
        }

        private void playButton_Click(object sender, EventArgs e)
        {
            StartGame();
        }

        private void buttonPanel_Paint(object sender, PaintEventArgs e)
        {

        }

        private void titleLabel_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}