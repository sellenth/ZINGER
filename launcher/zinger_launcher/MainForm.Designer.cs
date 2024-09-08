namespace ZingerLauncher
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            titleLabel = new Label();
            screenshotPictureBox = new PictureBox();
            progressBar = new ProgressBar();
            statusLabel = new Label();
            updateButton = new Button();
            playButton = new Button();
            buttonPanel = new Panel();
            usernameTextBox = new TextBox();
            newsbox = new TextBox();
            ((System.ComponentModel.ISupportInitialize)screenshotPictureBox).BeginInit();
            buttonPanel.SuspendLayout();
            SuspendLayout();
            // 
            // titleLabel
            // 
            titleLabel.Dock = DockStyle.Top;
            titleLabel.Font = new Font("Arial", 24F, FontStyle.Regular, GraphicsUnit.Point, 0);
            titleLabel.Location = new Point(0, 0);
            titleLabel.Margin = new Padding(5, 0, 5, 0);
            titleLabel.Name = "titleLabel";
            titleLabel.Padding = new Padding(0, 38, 0, 38);
            titleLabel.Size = new Size(667, 162);
            titleLabel.TabIndex = 0;
            titleLabel.Text = "ZINGER";
            titleLabel.TextAlign = ContentAlignment.MiddleCenter;
            titleLabel.Click += titleLabel_Click;
            // 
            // screenshotPictureBox
            // 
            screenshotPictureBox.Dock = DockStyle.Fill;
            screenshotPictureBox.Location = new Point(0, 162);
            screenshotPictureBox.Margin = new Padding(5, 6, 5, 6);
            screenshotPictureBox.Name = "screenshotPictureBox";
            screenshotPictureBox.Padding = new Padding(17, 19, 17, 19);
            screenshotPictureBox.Size = new Size(667, 389);
            screenshotPictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            screenshotPictureBox.TabIndex = 1;
            screenshotPictureBox.TabStop = false;
            // 
            // progressBar
            // 
            progressBar.Dock = DockStyle.Bottom;
            progressBar.Location = new Point(0, 665);
            progressBar.Margin = new Padding(5, 6, 5, 6);
            progressBar.Name = "progressBar";
            progressBar.Size = new Size(667, 44);
            progressBar.TabIndex = 2;
            // 
            // statusLabel
            // 
            statusLabel.Dock = DockStyle.Bottom;
            statusLabel.Location = new Point(0, 709);
            statusLabel.Margin = new Padding(5, 0, 5, 0);
            statusLabel.Name = "statusLabel";
            statusLabel.Padding = new Padding(0, 0, 0, 19);
            statusLabel.Size = new Size(667, 60);
            statusLabel.TabIndex = 3;
            statusLabel.Text = "Ready to launch";
            statusLabel.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // updateButton
            // 
            updateButton.Location = new Point(17, 10);
            updateButton.Margin = new Padding(5, 6, 5, 6);
            updateButton.Name = "updateButton";
            updateButton.Size = new Size(125, 58);
            updateButton.TabIndex = 4;
            updateButton.Text = "Update";
            updateButton.UseVisualStyleBackColor = true;
            updateButton.Click += updateButton_Click;
            // 
            // playButton
            // 
            playButton.Location = new Point(525, 10);
            playButton.Margin = new Padding(5, 6, 5, 6);
            playButton.Name = "playButton";
            playButton.Size = new Size(125, 58);
            playButton.TabIndex = 5;
            playButton.Text = "Play";
            playButton.UseVisualStyleBackColor = true;
            playButton.Click += playButton_Click;
            // 
            // buttonPanel
            // 
            buttonPanel.Controls.Add(updateButton);
            buttonPanel.Controls.Add(playButton);
            buttonPanel.Controls.Add(usernameTextBox);
            buttonPanel.Dock = DockStyle.Bottom;
            buttonPanel.Location = new Point(0, 551);
            buttonPanel.Margin = new Padding(5, 6, 5, 6);
            buttonPanel.Name = "buttonPanel";
            buttonPanel.Size = new Size(667, 114);
            buttonPanel.TabIndex = 6;
            // 
            // usernameTextBox
            // 
            usernameTextBox.Location = new Point(500, 77);
            usernameTextBox.Margin = new Padding(5, 6, 5, 6);
            usernameTextBox.Name = "usernameTextBox";
            usernameTextBox.PlaceholderText = "Username";
            usernameTextBox.Size = new Size(331, 31);
            usernameTextBox.TabIndex = 7;
            // 
            // newsbox
            // 
            newsbox.Enabled = false;
            newsbox.Location = new Point(47, 375);
            newsbox.Multiline = true;
            newsbox.Name = "newsbox";
            newsbox.Size = new Size(558, 167);
            newsbox.TabIndex = 7;
            newsbox.TextChanged += textBox1_TextChanged;
            // 
            // MainForm
            // 
            AutoScaleDimensions = new SizeF(10F, 25F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(667, 769);
            Controls.Add(newsbox);
            Controls.Add(screenshotPictureBox);
            Controls.Add(buttonPanel);
            Controls.Add(titleLabel);
            Controls.Add(progressBar);
            Controls.Add(statusLabel);
            Margin = new Padding(5, 6, 5, 6);
            Name = "MainForm";
            Text = "ZINGER Launcher";
            ((System.ComponentModel.ISupportInitialize)screenshotPictureBox).EndInit();
            buttonPanel.ResumeLayout(false);
            buttonPanel.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private System.Windows.Forms.Label titleLabel;
        private System.Windows.Forms.PictureBox screenshotPictureBox;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Label statusLabel;
        private System.Windows.Forms.Button updateButton;
        private System.Windows.Forms.Button playButton;
        private System.Windows.Forms.Panel buttonPanel;
        private System.Windows.Forms.TextBox usernameTextBox;
        private TextBox newsbox;
    }
}