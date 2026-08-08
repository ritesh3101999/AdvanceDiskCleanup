# Advanced Disk Cleanup Launcher 🧹

An automated Windows System Maintenance utility built using PowerShell and hosted as a web launcher using GitHub Pages and Tailwind CSS. It allows users to safely clean system caches, temporary internet files, delivery optimization data, and residual system garbage via an interactive terminal menu.

## 🌟 Key Features
* **Web Launcher Portal:** Hosted HTML interface built with Tailwind CSS allowing users to copy one-line execution commands seamlessly.
* **Interactive Terminal UI:** Clear, color-coded menu interface with selective or bulk cleanup execution.
* **Targeted Cache Clearance:**
  * Temporary Internet Files & Browser Cache
  * DirectX Shader Cache
  * Delivery Optimization Files (Windows Update Cache)
  * User & System Temporary Directories (`%TEMP%` and `C:\Windows\Temp`)
  * Thumbnail Database Cache (`ThumbCache_*.db`)
* **Confirmation-Guarded Actions:** Clear-RecycleBin functionality guarded with explicitly confirmed prompts.
* **Error Handling:** Gracefully handles locked files without interrupting execution flow.

## 🛠️ Tech Stack
* **Scripting Language:** PowerShell 5.1 / 7.x
* **Frontend Interface:** HTML5, Tailwind CSS
* **Deployment & Hosting:** GitHub Pages

## 🚀 How to Run

1. Open **PowerShell as Administrator**.
2. Run the following command:
   ```powershell
   irm [https://raw.githubusercontent.com/ritesh3101999/AdvanceDiskClearnup/main/OptionsDiskCleanup.ps1](https://raw.githubusercontent.com/ritesh3101999/AdvanceDiskClearnup/main/OptionsDiskCleanup.ps1) | iex
