#! /usr/bin/env bash

upgradeSystem() {
    ###############################################################################
    #                   Updating all the system                                   #
    ###############################################################################
    sudo rm /etc/apt/sources.list

    if [ -f "stable_sources.list" ]; then
        sudo cp stable_sources.list /etc/apt/sources.list
    else
        sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list
    fi

    print_log "\n###############################################################
##    Upgrading the entire system preparation...             ##
###############################################################\n"
    sudo apt update
    # sudo dpkg --add-architecture i386 #Add x86 Architecture (Needed for Steam-Installer)
    sudo apt dist-upgrade -y
    sudo apt autoremove -y
}

vaapiOnFirefox() {
    # Define the preference setting
    PREFERENCE_SETTING='user_pref("media.ffmpeg.vaapi.enabled", true);'

    # Path to the Firefox preferences file
    PREFS_FILE="$HOME/.mozilla/firefox/*.default/prefs.js"

    # Check if the preferences file exists
    if [ -f "$PREFS_FILE" ]; then
        # Update the preference setting in the Firefox preferences file
        sed -i "/media.ffmpeg.vaapi.enabled/c\\$PREFERENCE_SETTING" "$PREFS_FILE"
    fi
}

installDependencies() {
    print_log "\n###############################################################
##                Installing Dependencies                    ##
###############################################################\n"
    sudo apt install -y nala bpytop neofetch git mpv mesa-opencl-icd bash-completion vulkan-tools vainfo firmware-linux firmware-linux-free firmware-linux-nonfree firmware-amd-graphics pulseaudio-utils libnotify-bin libzstd-dev python3.11-venv zenity
    sudo apt install -y lm-sensors gnome-shell-extension-dashtodock gnome-shell-extension-appindicator
    sudo apt clean
    sudo apt autoremove
    vaapiOnFirefox
    #Enabling user-theme Extensions
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
}

enablePlaymouth() {
    # Path to GRUB configuration file
    GRUB_CONFIG_FILE="/etc/default/grub"

    # New line to be inserted
    NEW_GRUB_LINE='GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"'

    # Replace line in GRUB configuration file
    sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$NEW_GRUB_LINE|" $GRUB_CONFIG_FILE
    sudo update-grub
}

addMesaSource(){
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB8B81E14DA65431D7504EA8F63F0F2B90935439
    sudo rm /etc/apt/trusted.gpg.d/slack.gpg
    sudo apt-key export 90935439 | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/slack.gpg
    sudo echo -e "\ndeb [arch=amd64] https://ppa.launchpadcontent.net/kisak/kisak-mesa/ubuntu jammy main " | sudo tee -a /etc/apt/sources.list
}

switchToTestingSource() {
    sudo rm /etc/apt/sources.list
    sudo echo -e "\ndeb http://deb.debian.org/debian testing main non-free-firmware contrib non-free" | sudo tee -a /etc/apt/sources.list
}

switchToSidSource() {
    sudo rm /etc/apt/sources.list
    sudo echo -e "\ndeb http://deb.debian.org/debian sid main non-free-firmware contrib non-free" | sudo tee -a /etc/apt/sources.list
}

rollBackSource() {
    ###############################################################################
    #                   Rollback - remove Testing branch                          #
    ###############################################################################
    print_log "\n###############################################################
##         Rollingback -> removing Testing branch            ##
###############################################################\n"
    sudo rm /etc/apt/sources.list
    sudo wget https://github.com/BenyHdezM/Debian4Gamers/raw/main/stable_sources.list -O /etc/apt/sources.list
    sudo apt update
    sudo apt autoremove -y
}

installFlatpak() {
    ###############################################################################
    #                   Installing Flatpak and Flathub Store                      #
    ###############################################################################
    print_log "\n###############################################################
##           Installing Flatpak and Flathub Store            ##
###############################################################\n"

    #TODO: whiptail Selector for all flatpaks
    sudo apt install -y flatpak gnome-software-plugin-flatpak
    sudo apt clean
    ## sudo apt install plasma-discover-backend-flatpak  ## TODO: Identify if plasma-discover is installed
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    #Install Discord, Spotify and ProtonUp-Qt
    print_log "\n###############################################################
##         Installing Discord, Spotify and ProtonUp-Qt       ##
###############################################################\n"
}