!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!             ATTENTION                !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

The game-levels on this machine were moved from the previous
games machine in November 2011. It has not been verified that
all levels work on this new machine.

If you find any problems, please report them to Steven
on irc.overthewire.org.

--[ Playing the games ]--

This machine holds several wargames. 
For a generic wargame named "somegame", the usernames are:
mygame0, mygame1, ... and most levels are stored in /mygame/.
Passwords for each level are stored in /etc/mygame_pass/.

Write-access to homedirectories is disabled. It is advised
to create a working directory with a hard-to-guess name in /tmp/.
Read-access to both /tmp/ and /proc/ is disabled so that
users can not snoop on eachother.

Please play nice:
    don't leave orphan processes running
    don't leave exploit-files laying around
    don't annoy other players
    don't post passwords or spoilers

--[ Tips ]--

This machine has a 64bit processor and many security-features
enabled by default, although ASLR has been switched off.
The following compiler flags might be interesting:

    -m32                    compile for 32bit
    -fno-stack-protector    disable ProPolice
    -Wl,-z,norelro          disable relro 

In addition, the execstack tool can be used to flag the stack
as executable on ELF binaries.

Finally, network-access is limited for most levels by a local
firewall.

--[ More information ]--

For more information regarding individual wargames, visit
http://www.overthewire.org/wargames/

For questions or comments, contact us through IRC on
irc.overthewire.org.
