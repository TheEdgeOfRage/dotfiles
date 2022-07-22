#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
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
# show window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1

import re
import signal
import subprocess as proc
import sys

import fontawesome as fa  # type: ignore
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
WINDOW_ICONS = {
    'alacritty': fa.icons['terminal'],
    'blender': fa.icons['cube'],
    'blueman-manager': fa.icons['bluetooth'],
    'calibre-gui': fa.icons['book'],
    'chromium': fa.icons['chrome'],
    'cities.x64': fa.icons['city'],
    'clonehero': fa.icons['guitar'],
    'code-oss': fa.icons['code'],
    'vscodium': fa.icons['code'],
    'cutter': fa.icons['bug'],
    'darktable': fa.icons['camera'],
    'discord': fa.icons['comment'],
    'dwarf_fortress': fa.icons['fort-awesome'],
    'evince': fa.icons['file-pdf'],
    'factorio': fa.icons['cog'],
    'feh': fa.icons['image'],
    'firefox': fa.icons['firefox'],
    'firefoxdeveloperedition': fa.icons['firefox'],
    'ghb': fa.icons['video'],
    'gimp': fa.icons['file-image'],
    'gimp-2.10': fa.icons['file-image'],
    'gparted': fa.icons['hdd'],
    'gsmartcontrol': fa.icons['hdd'],
    'inkscape': fa.icons['pen-nib'],
    'jack-rack': fa.icons['volume-up'],
    'jetbrains-studio': fa.icons['code'],
    'kicad': fa.icons['microchip'],
    'ksp.x86_64': fa.icons['space-shuttle'],
    'ledger live': fa.icons['wallet'],
    'libreoffice-calc': fa.icons['file-excel'],
    'libreoffice-impress': fa.icons['file-powerpoint'],
    'libreoffice-writer': fa.icons['file-alt'],
    'lutris': fa.icons['gamepad'],
    'mpv': fa.icons['video'],
    'multimc': fa.icons['cube'],
    'mupdf': fa.icons['file-pdf'],
    'nemiver': fa.icons['bug'],
    'nm-connection-editor': fa.icons['wifi'],
    'obs': fa.icons['video'],
    'pavucontrol': fa.icons['volume-up'],
    'picard': fa.icons['music'],
    'qbittorrent': fa.icons['download'],
    'qtcreator': fa.icons['code'],
    'roxterm': fa.icons['terminal'],
    'seahorse': fa.icons['lock'],
    'simplescreenrecorder': fa.icons['video'],
    'slack': fa.icons['slack'],
    'spotify': fa.icons['spotify'],
    'sqlitebrowser': fa.icons['database'],
    'steam': fa.icons['steam'],
    'surviving mars': fa.icons['rocket'],
    'telegram-desktop': fa.icons['telegram'],
    'terraria.bin.x86_64': fa.icons['tree'],
    'thunderbird': fa.icons['envelope'],
    'vim': fa.icons['code'],
    'virtualbox manager': fa.icons['desktop'],
    'vlc': fa.icons['video'],
    'wireshark': fa.icons['network-wired'],
    'zathura': fa.icons['file-pdf'],
    'zenity': fa.icons['window-maximize'],
}

# This icon is used for any application not in the list above
DEFAULT_ICON = '*'


# Used so that we can keep the workspace's name when we add icons to it.
# Returns a dictionary with the following keys: 'num', 'shortname', and 'icons'
# Any field that's missing in @name will be None in the returned dict
def parse_workspace_name(name):
    match = re.match(
        r'(?P<num>\d+):?(?P<shortname>\w+)? ?(?P<icons>.+)?',
        name,
    )
    return match.groupdict()


# Given a dictionary with 'num', 'shortname', 'icons',
# return the formatted name by concatenating them together.
def construct_workspace_name(parts):
    new_name = str(parts['num'])
    if parts['shortname'] or parts['icons']:
        new_name += ':'

        if parts['shortname']:
            new_name += parts['shortname']

        if parts['icons']:
            new_name += ' ' + parts['icons']

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


def icon_for_window(window):
    classes = xprop(window.window, 'WM_CLASS')
    if classes is not None and len(classes) > 0:
        for cls in classes:
            cls = cls.lower()  # case-insensitive matching
            if cls in WINDOW_ICONS:
                return WINDOW_ICONS[cls]

        print(f'No icon available for: {classes}')

    return DEFAULT_ICON


# renames all workspaces based on the windows present
def rename_workspaces(i3):
    for workspace in i3.get_tree().workspaces():
        if (
            workspace.name == ''
            or workspace.name == ''
            or workspace.name == ''
        ):
            continue

        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = ' '.join(
            icon_for_window(w) for w in workspace.leaves()
        )
        new_name = construct_workspace_name(name_parts)
        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')


# rename workspaces to just numbers and shortnames.
# called on exit to indicate that this script is no longer running.
def undo_window_renaming(i3):
    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = None
        new_name = construct_workspace_name(name_parts)
        i3.command(f'rename workspace "{workspace.name}" to "{new_name}"')

    i3.main_quit()
    sys.exit(0)


if __name__ == '__main__':
    i3 = i3ipc.Connection()

    # exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: undo_window_renaming(i3))

    # call rename_workspaces() for relevant window events
    def window_event_handler(i3, e):
        if e.change in ['new', 'close', 'move']:
            rename_workspaces(i3)

    i3.on('window', window_event_handler)
    rename_workspaces(i3)
    i3.main()
