import os
import sys
import requests
from tqdm import tqdm
import tkinter as tk
from tkinter import ttk
from PIL import Image, ImageTk
import subprocess

# For PyInstaller to work correctly with data files
def resource_path(relative_path):
    """ Get absolute path to resource, works for dev and for PyInstaller """
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)

GITHUB_RAW_URL = "https://raw.githubusercontent.com/sellenth/ZINGER/main/"
ENGINE_FILENAME = "engine.exe"
GAME_FILENAME = "engine.pck"

def download_file(url, filename):
    response = requests.get(url, stream=True)
    total_size = int(response.headers.get('content-length', 0))
    
    with open(filename, "wb") as file, tqdm(
        desc=filename,
        total=total_size,
        unit='iB',
        unit_scale=True,
        unit_divisor=1024,
    ) as progress_bar:
        for data in response.iter_content(chunk_size=1024):
            size = file.write(data)
            progress_bar.update(size)

def check_and_download_engine():
    if not os.path.exists(ENGINE_FILENAME):
        print("Downloading engine...")
        download_file(GITHUB_RAW_URL + "dist/" + ENGINE_FILENAME, ENGINE_FILENAME)
    else:
        print("Engine already exists.")

def download_latest_game():
    print("Downloading latest game.pak...")
    download_file(GITHUB_RAW_URL + "dist/" + GAME_FILENAME, GAME_FILENAME)

class ZingerLauncher(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("ZINGER Launcher")
        self.geometry("400x400")

        self.label = tk.Label(self, text="ZINGER", font=("Arial", 24))
        self.label.pack(pady=20)

        # Load screenshot using resource_path
        screenshot_path = resource_path("screenshot.png")
        self.screenshot = Image.open(screenshot_path)
        self.screenshot = ImageTk.PhotoImage(self.screenshot)
        self.screenshot_label = tk.Label(self, image=self.screenshot)
        self.screenshot_label.pack(pady=10)

        self.progress = ttk.Progressbar(self, orient="horizontal", length=300, mode="determinate")
        self.progress.pack(pady=20)

        self.status_label = tk.Label(self, text="Ready to launch")
        self.status_label.pack()

    def update_progress(self, value):
        self.progress['value'] = value
        self.update_idletasks()

    def update_status(self, status):
        self.status_label.config(text=status)

    def start_game(self):
        self.update_status("Launching game...")
        subprocess.Popen([ENGINE_FILENAME, "--main-pack", GAME_FILENAME])
        self.destroy()  # Close the launcher window

def main():
    launcher = ZingerLauncher()
    
    launcher.update_status("Checking engine...")
    check_and_download_engine()
    launcher.update_progress(50)

    launcher.update_status("Downloading latest .pck...")
    download_latest_game()
    launcher.update_progress(100)

    launcher.update_status("Ready to play!")
    launcher.start_game()

if __name__ == "__main__":
    main()
