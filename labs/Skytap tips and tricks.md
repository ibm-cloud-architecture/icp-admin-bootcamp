# Skytap tips and tricks
---
<a name="toc"></a>
### Table of contents

[1. Skytap warnings](#skytapwarnings)

[2. Desktop considerations](#desktopconsiderations)

[3. Starting up Skytap](#startskytap)

[4. Skytap notes](#skytapnotes)

[4.1 Tab key](#tabkey)

[4.2 Enter key](#enterkey)

[4.3 Direct access mode](#directaccessmode)

[4.4 Full screen mode](#fullscreenmode)

[4.5 Copy and paste text into and out of Skytap](#copypaste)

[4.6 When Skytap VMs get "wedged"](#wedgedvms)


<a name="skytapwarnings"></a>
## Skytap warnings
[TOC](#toc)
- Skytap in North America performs reasonably well.  It has also performed reasonably well in London. 
- Skytap is expensive.  Suspend your machines in the evenings.
- By default machines suspend after 2 hours of inactivity.  That may not be appropriate for classroom situations where it takes awhile to spin things back up into a stable state, e.g., IBM Cloud Private takes awhile to stabilize and it may come up in a bad state where you have to kill certain pods to get things to clean up.
- Random periods of things seeming to be stuck or incredibly slow, even at the level of keystrokes makes working with Skytap problematic. Be patient when the images have first started up.  Usually these issues dissipate once the VMs have been running for awhile.

[TOC](#toc)
<a name="desktopconsiderations"></a>
## Desktop considerations (Mac or Windows?)
[TOC](#toc)

A Mac works about as well as Windows with Skytap.

The Mac touchpad works much better with Skytap than a Lenovo machine touchpad.

External mice may not work very well with Skytap.  The VM has a difficult time tracking an external mouse.

[TOC](#toc)
<a name="startskytap"></a>
## Starting up Skytap
[TOC](#toc)

1. Open a browser on your lab machine (Firefox or Chrome seem to behave better than IE)
2. Enter the URL for your Skytap environment. You will obtain this from your instructor.
3. You should see a panel with all eight VMs listed. All the VMs should be in a stopped state.
4. Click the large Start button (not the Start button on the individual VMs).
5. The VMs will spin for awhile.  Be patient and wait for each VM to show a started state.

[TOC](#toc)
<a name="skytapnotes"></a>
## Skytap notes

[TOC](#toc)
<a name="tabkey"></a>
### Tab key

Use the Tab key to get to fields that you otherwise cannot see. If the lab instructions indicate there should be a button or fields that you need to do something with, and you can't see items described by the instructions, try hitting tab a few times to get to them.

[TOC](#toc)
<a name="enterkey"></a>
### Enter key

You may occasionally find that you need to hit the enter key to force some screen event.

[TOC](#toc)
<a name="directaccessmode"></a>
### Direct access mode

It is best to be working in "direct environment access" mode.  Click on the "Direct Environment Access" button near the top, middle of the window or near the lower right corner of the window when viewing all of the VMs.

[TOC](#toc)
<a name="fullscreenmode"></a>
### Full screen mode

Your user interface will behave better if you put the Skytap desktop in full screen mode.

[TOC](#toc)
<a name="copypaste"></a>
### Copy and paste text into and out of Skytap

[TOC](#toc)

There is a VM clipboard tool on the toolbar.  Typically copy-and-paste into and out of the Skytap VM needs to flow through this clipboard.  The VM Clipboard tool provides a staging area for copying test between the VM and your local system.  It can hold up to 32KB of plain text.  Also keep in mind **vim** does not use the system clipboard, to paste into **vim** use **Ctrl Shift V**.

We have not fully determined the circumstances when the cut-and-paste clipboard window in the Skytap tool bar may be bypassed.

To copy text from your local system to the Skytap VM highlight the text and chose **Copy** or use the shortcut **Ctrl C** or **Command C** to copy the text.  From within the VM perform a typical paste using the keyboard shortcut **Ctrl V** (the menu option is not fully supported).   Be patient there may be a delay.

To copy text from the Skytap VM to your local system, highlight the text and  use the shortcut **Ctrl C** twice in succession to copy the text.  From within your local system perform the paste as normal using the menu option or **Ctrl V** or **Command V**.

When using a Mac, you may be able to copy-and-paste content directly from a Chrome browser window on the Mac to a window on the Skytap desktop, particularly when that window is the FireFox browser on the Skytap desktop.  Go figure.

[TOC](#toc)

<a name="wedgedvms"></a>
### When Skytap VMs get "wedged"

- Depending on performance a VM can lock up.  Sometimes just waiting a minute is sufficient.

- Hitting the toolbar item that looks like a keyboard and selecting one of the command key sequences may unwedge the UI.  (TBD - Which command key sequence?)

- You may need to switch to a different VM and then come back to the one you really want to work on.

- Hit the desktop browser's refresh button.  Sometimes the lock-up is just that the browser you are using to access Skytap has not refreshed properly. 

[TOC](#toc)
