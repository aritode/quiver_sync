Quiver Sync
============

Quiver Sync allows you to use [Quiver](http://happenapps.com/#quiver), an awesome note-taking app for programmers, on the go. Access a read-only version of all of your notes from the web, synced automatically.

# Install
## Server Setup
Set up a folder (with password protection if you like) with your web server of choice (mine is NGINX) and copy the files from the repo into the folder. Take note of the path of the folder since you will need to enter it into the sync script that we will install on the mac.

1. Install the quiver2html node module. Version 0.2.1 (which is the current version at the time of writing), uses Mixed Content to fetch external scripts and stylesheets, like those used for syntax highlighting and LaTeX processing. I have submitted a Pull Request to fix those changes, but in the mean time you can use the fix below.
```
git clone https://github.com/tpaulus/quiver2html.git
cd quiver2html/
npm install
```
2. You will want to set up Apache, NGINX, or your web server of choice to serve the PHP content in the folder you cloned the server files into. Google is your friend here.

When you are done, navigate to the URL for your folder and you should see something like this.
![Server Setup Complete](https://tompaulus.com/wp-content/uploads/2016/07/quiver_sync-Server-Setup-Complete-1080x995.png)

## Mac Setup
We need to configure the computer to sync the Notebook Library automatically and request that the server convert the library into HTML. This is achieved with a simple shell script that is run every 5 minutes by launchctl, Apple’s version of CRON on newer OSs. Launchctl uses specialized plist files (which can be created with launched) to tell it when to run what command.

1. Update the script’s variables to suite your installation.
```
QUIVERLIB_LOC="Path/to/Quiver.qvlibrary"
SERVER="lorien" # Host Name of your server, as set in .ssh/config
SRV_DEST="/srv/notes/" # Public HTTP Directory where Notebooks folder is
```
2. Copy the shell script to your local/bin folder.
```
sudo cp quiver_sync.sh /usr/local/bin/quiverSync
sudo chmod +x /usr/local/bin/quiverSync
```
The advantage with placing the file in your local bin folder is that you can call “quiverSync” at anytime from your command line to toggle a sync. Now would be a good time to test the script to see if it works before continuing. Take a look at the website and you should see something like this.
![Mac Complete](https://tompaulus.com/wp-content/uploads/2016/07/quiver_sync-Mac-Complete-1080x995.png)

3. If everything is working the way it should, place the launchctl script into the Launch Agents folder. If the “~/Library/LaunchAgents” does not yet exists, you can create it with “mkdir”. There are several Launch Agent folders on your computer, the folder in your user library only runs when you are logged in, which is what we want, since you will likely not be making changes to your quiver notes while you are not logged in.
```
sudo cp com.whitestarsystems.quiver_sync.plist ~/Library/LaunchAgents/com.whitestarsystems.quiver_sync.plist
launchctl load -w ~/Library/LaunchAgents/com.whitestarsystems.quiver_sync.plist
```
