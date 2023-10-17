#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies: xorg-xprop i3ipc nerdfonts
#
# Installation:
# Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to the i3 config
#
# Configuration:
# The default i3 config's keybingings reference workspaces by name, which is an
# issue when using this script because the "names" are constantaly changing to
# show window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1

import re
import signal
import subprocess as proc
from sys import exit
from typing import Any, NoReturn

import nerdfonts as nf  # type: ignore
import i3ipc  # type: ignore

# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# Most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_ICONS: dict[str, str] = {
    'alacritty': nf.icons['fa_terminal'],
    'blender': nf.icons['fa_cube'],
    'blueman-manager': nf.icons['fa_bluetooth'],
    'calibre-gui': nf.icons['fa_book'],
    'chromium': nf.icons['fa_chrome'],
    'cities.x64': nf.icons['md_city'],
    'clonehero': nf.icons['md_guitar_electric'],
    'code-oss': nf.icons['fa_code'],
    'vscodium': nf.icons['fa_code'],
    'cutter': nf.icons['fa_bug'],
    'darktable': nf.icons['fa_camera'],
    'discord': nf.icons['fa_comment'],
    'dwarf_fortress': nf.icons['fa_fort_awesome'],
    'easyeffects': nf.icons['fa_music'],
    'evince': nf.icons['fa_file_pdf_o'],
    'factorio': nf.icons['fa_cog'],
    'feh': nf.icons['fa_image'],
    'firefox': nf.icons['fa_firefox'],
    'firefoxdeveloperedition': nf.icons['fa_firefox'],
    'ghb': nf.icons['md_video'],
    'gimp': nf.icons['cod_file_media'],
    'gimp-2.10': nf.icons['cod_file_media'],
    'gparted': nf.icons['fa_hdd_o'],
    'gsmartcontrol': nf.icons['fa_hdd_o'],
    'inkscape': nf.icons['md_fountain_pen_tip'],
    'jetbrains-idea-ce': nf.icons['fa_code'],
    'jetbrains-studio': nf.icons['fa_code'],
    'kcharselect': nf.icons['fa_font'],
    'kicad': nf.icons['fa_microchip'],
    'ksp.x86_64': nf.icons['fa_space_shuttle'],
    'ledger live': nf.icons['md_wallet'],
    'libreoffice-calc': nf.icons['fa_file_excel_o'],
    'libreoffice-impress': nf.icons['fa_file_powerpoint_o'],
    'libreoffice-writer': nf.icons['fa_file_word_o'],
    'lutris': nf.icons['fa_gamepad'],
    'mpv': nf.icons['md_video'],
    'polymc': nf.icons['fa_cube'],
    'minecraft': nf.icons['fa_cube'],
    'mupdf': nf.icons['fa_file_pdf_o'],
    'nemiver': nf.icons['fa_bug'],
    'nm-connection-editor': nf.icons['fa_wifi'],
    'obs': nf.icons['md_video'],
    'openlens': nf.icons['md_kubernetes'],
    'pavucontrol': nf.icons['fa_volume_up'],
    'picard': nf.icons['fa_music'],
    'qbittorrent': nf.icons['fa_download'],
    'qtcreator': nf.icons['fa_code'],
    'roxterm': nf.icons['fa_terminal'],
    'seahorse': nf.icons['fa_lock'],
    'simplescreenrecorder': nf.icons['md_video'],
    'slack': nf.icons['fa_slack'],
    'spotify': nf.icons['fa_spotify'],
    'sqlitebrowser': nf.icons['fa_database'],
    'steam': nf.icons['fa_steam'],
    'surviving mars': nf.icons['fa_rocket'],
    'telegram-desktop': nf.icons['fa_telegram'],
    'terraria.bin.x86_64': nf.icons['fa_tree'],
    'thunderbird': nf.icons['fa_envelope'],
    'vim': nf.icons['fa_code'],
    'virtualbox manager': nf.icons['fa_desktop'],
    'vlc': nf.icons['md_video'],
    'wireshark': nf.icons['md_shark_fin'],
    'zathura': nf.icons['fa_file_pdf_o'],
    'zenity': nf.icons['fa_window_maximize'],
}

# This icon is used for any application not in the list above
DEFAULT_ICON = '*'


# Used so that we can keep the workspace's name when we add icons to it.
# Returns a dictionary with the following keys: 'num', 'shortname', and 'icons'
# Any field that's missing in @name will be None in the returned dict
def parse_workspace_name(name) -> dict[str, Any]:
    match = re.match(
        r'(?P<num>\d+):?(?P<shortname>\w+)? ?(?P<icons>.+)?',
        name,
    )
    if match is None:
        return {}

    return match.groupdict()


# Given a dictionary with 'num', 'shortname', 'icons',
# return the formatted name by concatenating them together.
def construct_workspace_name(parts) -> str:
    new_name: str = str(parts['num'])
    if parts['shortname'] or parts['icons']:
        new_name += ':'

        if parts['shortname']:
            new_name += parts['shortname']

        if parts['icons']:
            new_name += ' ' + parts['icons']

    return new_name + ' '


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
    classes: list[str] | None = xprop(window.window, 'WM_CLASS')
    if classes is None or len(classes) == 0:
        print(f'No icon available for: {classes}')
        return DEFAULT_ICON

    for cls in map(lambda x: x.lower(), classes):
        if 'minecraft' in cls:
            return WINDOW_ICONS['minecraft']

        if cls in WINDOW_ICONS:
            return WINDOW_ICONS[cls]
    else:
        print(f'No icon available for: {classes}')

    return DEFAULT_ICON


# renames all workspaces based on the windows present
def rename_workspaces(i3) -> None:
    for workspace in i3.get_tree().workspaces():
        if workspace.num == -1:
            continue

        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = ' '.join(
            icon_for_window(w) for w in workspace.leaves()
        )
        new_name = construct_workspace_name(name_parts)
        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')


# rename workspaces to just numbers and shortnames.
# called on exit to indicate that this script is no longer running.
def undo_window_renaming(i3) -> NoReturn:
    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = None
        new_name = construct_workspace_name(name_parts)
        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')

    i3.main_quit()
    exit(0)


if __name__ == '__main__':
    i3 = i3ipc.Connection()

    # exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: undo_window_renaming(i3))

    # call rename_workspaces() for relevant window events
    def window_event_handler(i3, e) -> None:
        if e.change in ['new', 'close', 'move']:
            rename_workspaces(i3)

    i3.on('window', window_event_handler)
    rename_workspaces(i3)
    i3.main()
