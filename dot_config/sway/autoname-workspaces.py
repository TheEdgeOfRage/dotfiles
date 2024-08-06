#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs. It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies: xorg-xprop i3ipc fontawesome
#
# Installation:
# Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to the i3 config
#
# Configuration:
# The default i3 config's keybingings reference workspaces by name, which is an
# issue when using this script because the "names" are constantaly changing to
# show window icons. Instead, you'll need to change the keybindings to
# reference workspaces by number. Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1

import re
import signal
import subprocess as proc
from types import FrameType
from typing import Any, Callable

import nerdfonts as nf
from i3ipc import Connection

# Add icons here for common programs you use. The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# These icons are from the Nerd Font patch set.
# You can find a list of all here: https://www.nerdfonts.com/cheat-sheet
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_ICONS: dict[str, str] = {
    'alacritty': nf.icons['fa_terminal'],
    'blender': nf.icons['fa_cube'],
    'blueman-manager': nf.icons['fa_bluetooth'],
    'brave-browser': nf.icons['fa_globe'],
    'calibre-gui': nf.icons['fa_book'],
    'chromium': nf.icons['fa_chrome'],
    'cities.x64': nf.icons['md_city'],
    'clonehero': nf.icons['md_guitar_electric'],
    'code-oss': nf.icons['fa_code'],
    'vscodium': nf.icons['fa_code'],
    'cutter': nf.icons['fa_bug'],
    'darktable': nf.icons['md_camera'],
    'discord': nf.icons['fa_comment'],
    'dk.gqrx.gqrx': nf.icons['cod_radio_tower'],
    'dwarf_fortress': nf.icons['fa_fort_awesome'],
    'com.github.wwmm.easyeffects': nf.icons['fa_music'],
    'evince': nf.icons['seti_pdf'],
    'factorio': nf.icons['fa_cog'],
    'feh': nf.icons['md_image'],
    'firefox': nf.icons['fa_firefox'],
    'firefoxdeveloperedition': nf.icons['fa_firefox'],
    'gamescope': nf.icons['md_steam'],
    'ghb': nf.icons['md_video'],
    'gimp': nf.icons['fa_paint_brush'],
    'gimp-2.10': nf.icons['fa_paint_brush'],
    'gparted': nf.icons['fa_hdd_o'],
    'gsmartcontrol': nf.icons['fa_hdd_o'],
    'hoppscotch-app': nf.icons['md_ufo'],
    'inkscape': nf.icons['md_fountain_pen_tip'],
    'insomnium': nf.icons['md_graphql'],
    'kcharselect': nf.icons['fa_font'],
    'kicad': nf.icons['fa_microchip'],
    'ksp.x86_64': nf.icons['fa_space_shuttle'],
    'ledger live': nf.icons['md_wallet'],
    'libreoffice-calc': nf.icons['fa_file_excel_o'],
    'libreoffice-impress': nf.icons['fa_file_powerpoint_o'],
    'libreoffice-writer': nf.icons['fa_file_word_o'],
    'lutris': nf.icons['fa_gamepad'],
    'mpv': nf.icons['md_video'],
    'polymc': nf.icons['md_minecraft'],
    'minecraft': nf.icons['md_minecraft'],
    'mupdf': nf.icons['seti_pdf'],
    'nemiver': nf.icons['fa_bug'],
    'nm-connection-editor': nf.icons['fa_wifi'],
    'obs': nf.icons['md_video'],
    'openlens': nf.icons['md_kubernetes'],
    'org.gnome.nautilus': nf.icons['fa_folder'],
    'oversteer': nf.icons['md_gamepad_variant'],
    'pavucontrol': nf.icons['fa_volume_up'],
    'picard': nf.icons['fa_music'],
    'qbittorrent': nf.icons['fa_download'],
    'qtcreator': nf.icons['fa_code'],
    'sdl application': nf.icons['md_steam'],
    'seahorse': nf.icons['fa_lock'],
    'simplescreenrecorder': nf.icons['md_video'],
    'slack': nf.icons['fa_slack'],
    'spotify': nf.icons['fa_spotify'],
    'sqlitebrowser': nf.icons['fa_database'],
    'steam': nf.icons['md_steam'],
    'steam_app_671860': nf.icons['md_pistol'],  # battlebit
    'steam_app_1336490': nf.icons['fae_storm'],  # against the storm
    'steam_app_599140': nf.icons['md_coffin'],  # graveyard keeper
    'steam_app_284160': nf.icons['md_car'],  # beamng.drive
    'steam_app_1250410': nf.icons['md_airplane'],  # microsoft flight simulator
    'surviving mars': nf.icons['fa_rocket'],
    'telegram-desktop': nf.icons['fa_telegram'],
    'terraria.bin.x86_64': nf.icons['fa_tree'],
    'thunderbird': nf.icons['fa_envelope'],
    'vim': nf.icons['fa_code'],
    'virtualbox manager': nf.icons['fa_desktop'],
    'vlc': nf.icons['md_video'],
    'wireshark': nf.icons['md_shark_fin'],
    'org.pwmt.zathura': nf.icons['seti_pdf'],
    'zenity': nf.icons['fa_window_maximize'],
}


# This icon is used for any application not in the list above
DEFAULT_ICON = '*'


# Used so that we can keep the workspace's name when we add icons to it.
# Returns a dictionary with the 'num' and 'icons' keys
# Any field that's missing in @name will be None in the returned dict
def parse_workspace_number(name: str) -> str | None:
    match = re.match(
        r'(?P<num>\d+):? ?(?P<icons>.+)?',
        name,
    )
    if match is None:
        return None

    return match.groupdict()['num']


# Given a dictionary with 'num', 'icons',
# return the formatted name by concatenating them together.
def construct_workspace_name(num: str, icons: list[str] | None) -> str:
    new_name: str = str(num)
    if icons:
        new_name += ':'
        for icon in icons:
            new_name += ' ' + icon

    return new_name


# Returns an array of the values for the given property from xprop.  This
# requires xorg-xprop to be installed.
def xprop(win_id, property):
    try:
        prop = proc.check_output(
            ['xprop', '-id', str(win_id), property],
            stderr=proc.DEVNULL,
        )
        prop = prop.decode('utf-8')
        return re.findall('"([^"]+)"', prop)

    except proc.CalledProcessError:
        print(f'Unable to get property for window "{win_id}"')
        return None


def icon_for_window(window) -> str:
    app_id = window.app_id
    if window.app_id is None or window.app_id == '':
        classes: list[str] | None = xprop(window.window, 'WM_CLASS')
        if classes is None or len(classes) == 0:
            print(f'No class set for window: {xprop(window.window, "WM_NAME")}')
            return DEFAULT_ICON
        else:
            app_id = classes[1].lower()
    else:
        app_id = window.app_id.lower()

    if 'minecraft' in app_id:
        return WINDOW_ICONS["minecraft"]

    if app_id in WINDOW_ICONS:
        return WINDOW_ICONS[app_id]
    else:
        print(f'No icon configured for: {app_id}')

    return DEFAULT_ICON


# renames all workspaces based on the windows present
def rename_workspaces(i3) -> None:
    for workspace in i3.get_tree().workspaces():
        if workspace.num == -1:
            continue

        num = parse_workspace_number(workspace.name)
        icons = [
            icon_for_window(w) for w in workspace.leaves()
        ]
        icons += [icon_for_window(w) for w in workspace.floating_nodes]
        if num is None:
            new_name = str(workspace.num)
        else:
            new_name = construct_workspace_name(num, icons)

        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')


# rename workspaces to just numbers
# called on exit to indicate that this script is no longer running.
def undo_window_renaming(i3) -> None:
    for workspace in i3.get_tree().workspaces():
        if workspace.num == -1:
            continue

        num = parse_workspace_number(workspace.name)
        icons = None
        if num is None:
            new_name = str(workspace.num)
        else:
            new_name = construct_workspace_name(num, icons)

        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')

    i3.main_quit()


def get_signal_handler(i3) -> Callable[[int, FrameType | None], Any]:
    def signal_handler(*_) -> None:
        undo_window_renaming(i3)

    return signal_handler


def main():
    i3 = Connection()

    # exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, get_signal_handler(i3))

    # call rename_workspaces() for relevant window events
    def window_event_handler(i3, e) -> None:
        if e.change in ['new', 'close', 'move']:
            rename_workspaces(i3)

    i3.on('window', window_event_handler)
    rename_workspaces(i3)
    i3.main()


if __name__ == '__main__':
    main()
