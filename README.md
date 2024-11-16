# AbdelRMB - Menu F5

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Author](https://img.shields.io/badge/author-AbdelRMB-green)

## 🚀 Introduction
The **F5 Menu** is an interactive and customizable menu designed for **FiveM** servers, making it easier to access player information and features. Built on the **AbdelRMBUI** and **AbdelRMB-Notify** libraries, this menu is easy to integrate and customize according to your needs.

## 📋 Dependencies

This menu relies on the following libraries:

- **AbdelRMBUI**: A flexible UI Menu management library.  
  [🔗 GitHub Repository](https://github.com/Abdelrmb/AbdelRMBUI)

- **AbdelRMB-Notify**: A notification system for sleek, customizable alerts.  
  [🔗 GitHub Repository](https://github.com/Abdelrmb/AbdelRMB-Notify)

## 📦 Installation

1. **Download** the F5 menu.
2. Place the downloaded folder into your server’s `resources` directory.
3. Add the following lines to your `server.cfg` file:

    ```cfg
    ensure AbdelRMBUI
    ensure AbdelRMB-Notify
    ensure AbdelRMB-MenuF5
    ```

## 🛠️ Usage

### Initialization
Before using the menu, import the required libraries in your client script:

```lua
local AbdelRMBUI = exports['AbdelRMBUI']
local AbdelRMBNotify = exports['AbdelRMB-Notify']
```
