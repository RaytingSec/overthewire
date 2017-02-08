Writeup
===================

## Foreword

I attempt to blaze through the Bandit wargame at OverTheWire.org with minimal help from online sources. Here, I document my attempt.

## 0

This level is to enter the wargame via ssh, a familiar command with the syntax `ssh user@somemachine`.

bandit0

## 0 -> 1

After ssh-ing in, I paste: `alias ll='ls -alhF'; ll`. ll is a common Debian/Ubuntu default alias that displays dir contents in a particular way. Pasting this ensures the alias is what I'm used to and unaltered, while listing the contents to give an idea of what's on the remote machine.

Anyways, the readme file immediately stands out. The lvl1's page explains the readme file contains the password. Simple: `cat readme` returns the password.

boJ9jbbUNNfktd78OOpsqOltutMc3MY1

## 1 -> 2

Next level's password is in a file with a '-' user name. Hm. Tab autocompletion showes it as an option, but tty waits for further input. Quotes and backslash escape char don't work. I recall this level from before, and I resort to Google. First link explains dashes are used as input for programs, such as `ls -a`, and the current path `./` is necessary. And with `cat ./-` it works.

CV1DtqXWVFXTvM2F0k09SHz0YwRINYA9

## 2 -> 3

There's the file "spaces in this filename". From previous experience, \ will escape spaces, but autocomplete does the heavy lifting for you. `cat sp`, tab, enter, and I'm done here. Otherwise if autocomplete doesn't work, a \ goes before each space in the filename.

UmHadQclWmgdLOKQ3YNgjWxGoRMb5luK

## 3 -> 4

A directory "inhere"? Aw, `tree` isn't installed. `ll inhere/` shows ".hidden", and `cat inhere/.hidden` finishes the job.

pIwrPrtPN36QITSp3EQaw936yaFoFgAB

## 4 -> 5

There's another inhere dir, but with "-file00" through "-file09". `cat ./*` and, ... oh, there's binary in here, or at least, there's some non-printable data. Try `file ./*` instead. Bingo, "-file07" is text, other files are labeled as data.

koReBOKuIDDepwhWk7jZC0RTdopnAYKh


## 5 -> 6

It gets interesting. Password is in "inhere directory and has all of the following properties: - human-readable - 1033 bytes in size - not executable". `ll` and `file` don't show easy solutions like before (although `ll * | grep 1033` says reveals the file name is .file2, but the containing dir isn't known). I know `find` has a lot of parameters, and the man pages would help.

`find` doesn't seem to have flags for human-readable, and while I can use `-exec` and pipe the output to/from `file` for a complicated bash command, it'd be easier to use just the size and executable parameters, and maybe they'll be enough.

Turns out `find . -size 1033c` is already enough. Note that `c` signifies bytes. Or `find . -size 1033c -exec cat {} \;` will `cat` the password.

DXjZPULLxYr17uwoI01bNLQbtFemEgo7

## 6 -> 7

Now it's "somewhere on the server and has all of the following properties: - owned by user bandit7 - owned by group bandit6 - 33 bytes in size"

From previous man page exploration, `find` has parameters for user and group. Previous experiences on my own machine says there'll be a lot of restricted permission files, but let's give it a try. Using size and user in the command `find / -user bandit7 -size 33c` and digging through "Permission denied" messages, /etc/bandit_pass/bandit7 and /var/lib/dpkg/info/bandit7.password stand out, the former being the central password repository and off limits of course. So, the /var/ one it is!

Side note: from a bit of Google-ing, grep -v can be used to exclude results, but apparently doesn't work in this case for some reason. However, prefixing the parameters `! -readable -prune` to find will exclude higher privilege directories.

HKBPTKQnIay4Fw76bEy8PVxKEDQRKTzs

## 7 -> 8

There's a giant plaintext file "data.txt", and the password is next to millionth. First see if I can find millionth and ... oh, the password is right there. `grep "millionth" data.txt` did the trick.

Further inspection shows data.txt contains a bunch of text (4184396 bytes) with one word and a potential password on each line. `grep` simply prints the line with the matching word, so it did the trick.

cvX2JJa4CFALtqS87jk27qwqGhBM9plV

## 8 -> 9

Similar to the previous level, but the target line "is the only line of text that occurs only once". The suggested commands include sort and uniq, which look helpful. To the man pages!

`uniq` looks promising. For starters, what does`uniq -c data.txt` output? After dumping giant blocks of text, I realize `uniq` searches for adjacent lines only. This is where `sort` comes in then.

`sort data.txt | uniq -c` reveals a bunch of text is duplicated 10 times, with one occuring just once. changing the `uniq` flag to `-u` displays lines occurring once, neatly returning the password.

UsvVyFSfZZWbi6wgC7dAFyFuR6jQQUhR

## 9 -> 10

Similar again, but `file data.txt` reveals it's a bunch of data now. The level prompt says the password is "in one of the few human-readable `strings`, beginning with several ‘=’ characters", and I know strings might help, so I give it a try. And `strings data.txt` ruins the fun, with the password appearing front and center.

Making sure, I pipe it to `grep -in "="`.

truKLdjsbJ5g7yyJ2X2R0o3a5HQJFuLk

## 10 -> 11

data.txt is base64 encoded this time. Again, man page for `base64`. Play around to familiarize, and try piping data.txt in.

IFukwKGsFW8MOq3IRFqrxE1hxTNEbUPR

## 11 -> 12

Pretty much same as before, the characters are "rotated by 13 positions" (rot13), but there's no man page for rot13. `tr` is a suggested command, and after some trial and error, I figure out how to get rot13 to work, and get the password with `cat data.txt | tr a-zA-Z n-za-mN-ZA-M`.

5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu

## 12 -> 13

This one was a bit of a mess. The password is in data.txt, but onion wrapped in various compression methods. After copying to a dir in temp, `xxd -r data.txt data.out` to get the compressed file.

From here on, `file` to identify which compression method, use the man page, mv to rename the extension if necessary, and decompress the file. Each method, gzip, bzip2, and tar, have peculiarities and extensions may or may not matter. 10 or so decompressions later, the final file is plaintext with the password.

8ZjyCRiBWFYkneahHwxCv3wb2a1ORpYL

## 13 -> 14

Provided this time is "sshkey.private", which is a private key. ssh's man page reveals -i can specify a key file, so `ssh bandit14@localhost -i sshkey.private` is used. The level prompt reveals the password location at /etc/bandit_pass/bandit14.

4wcYUJFw0k0XLShlDzztnTBHiqxU3b3e

## 14 -> 15

I admit I got a bit lost here. The goal is to "[submit] the password of the current level to port 30000 on localhost". There's the authorized_keys file in .ssh which didn't reveal anything. I didn't find much in netcat's man pages, and I tried ssh and telnet to local host. Eventually I gave `nmap -p30000 -sV localhost` a try, which hanged. Google saved the day, and I found out I can simply send data with netcat. I could just `echo "payload" | nc localhost 30000`, which succeeded.

BfMYroe26WYalil77FoDi9qh59eK5xNr

## 15 -> 16

Now, add on ssl to the connection and with port 30001 this time. Searching for ssl in the man pages didn't yield much except with openssl and s_client. Evidently, s_client doesn't work alone, and is combined with openssl. Some trial and error later, I come up with `openssl s_client -connect localhost:30001`, with a "HEARTBEATING" response that the level prompt indicates to solve with `-ign_eof`, and the password is returned.

Searching online reveals that it might have to do with the openssl source code, and -ign_eof takes it down a different branch that successfully returns the password.

cluFn7wTiGryunymYOu4RcffSxQluehd

## 16 -> 17

This time the port is in the range 31000-32000 and needs to be discovered. Nmap was the first option that came to mind, but I thought I'd first give `netstat -tulpn | grep 3` a go before doing `nmap -T5 -p31000-32000 localhost`. nmap showed a much more concise result, so I dug further.

Unfortunately the -sV flag, telling nmap to identify the services on particular ports, would cause nmap to hang. Another solution is needed. But suprisingly, I left an nmap with -sV and it actually does deliver, but the OverTheWire server is slow or something. However, now I know three of the open ports are probably running "echo", and two are "msdtc", or "Microsoft Distributed Transaction Coordinator (error)".

```
PORT      STATE SERVICE VERSION
31046/tcp open  echo
31518/tcp open  msdtc   Microsoft Distributed Transaction Coordinator (error)
31691/tcp open  echo
31790/tcp open  msdtc   Microsoft Distributed Transaction Coordinator (error)
31960/tcp open  echo
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows
```

Echo probably returns what you send it, but when I try connecting as before with `openssl s_client -connect localhost:someportnumber`, 31046 fails to even connect while 31518 replies with what I sent it. It appears echo ports are decoys while msdtc is the actual target, as port 31790 was correct. Unexpectedly, I got a private key instead of a password as I expected.

A few minutes were spent at a dead end assuming the private key was the same as ".ssl-cert-snakeoil.key", but it turns out to be different. So, I use /tmp to save the private key, thanks to the previous decompression level's hint about using /tmp. `ssh -i privkey.key bandit17@localhost`, hold your breath, and success, no password needed!

## 17 -> 18

There's two plaintext password files, and "the password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new". Diff would probably be a good choice, and `diff passwords.old passwords.new` shows a line changed BS8... to kfB... in passwords.new

```
bandit17@melinda:~$ diff passwords.old passwords.new 
42c42
< BS8bqB1kqkinKJjuxL6k072Qq9NRwQpR
---
> kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd
```

It works! ... Sort of. Next level prompt explains what's wrong.

kfBf3eYk5BPBRzwjqutbbfE887SVc5Yd

## 18 -> 19

The password "is stored in a file readme in the homedirectory", but connections are automatically terminated immediately after connecting. I previously explored how to use ssh to send a command and disconnect, so I refer back to the man pages. Using `ssh bandit18@bandit.labs.overthewire.org 'somecommand'` to execute `ls -alhF`, `file readme`, and `cat readme`, I obtain the password.

IueksS7Ubh8G3DCwVzrTd8rAVOwq3M5x

## 19 -> 20

There's an executable "bandit20-do", and executing directly returns the following.

```
bandit19@melinda:~$ ./bandit20-do 
Run a command as another user.
  Example: ./bandit20-do id
bandit19@melinda:~$ ./bandit20-do whoami
bandit20
```

As the help prompt says, the executable allows running a command as bandit20. The level's prompt reminds of /etc/bandit_pass, holding all the levels' passwords. Simply executing `./bandit20-do cat /etc/bandit_pass/bandit20` returns the password.

GbKksEFF4yrVs6il55v6gwY5aVje5f0j

## 20 -> 21

A binary is provided that, from the prompt, connects to a port on local host, and will reply the next level's password if given the current one's. The first hint cleared it up, saying "you need to login twice: once to run the setuid command, and once to start a network daemon to which the setuid will connect". Note that the binary I encountered is `suconnect`, and not `setuid`.

First thing that came to mind was netcat, so I looked through the man pages. I failed with the first command or two, but corrected it to `nc -l localhost 32100` to create a listening connection, and ran `./suconnect` with the respective port. I sent the bandit20 password, and got the next level's.

First session:
```
bandit20@melinda:~$ nc -l localhost 32100
GbKksEFF4yrVs6il55v6gwY5aVje5f0j
gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr
bandit20@melinda:~$ 
```

Second session:
```
bandit20@melinda:~$ ./suconnect 32100
Read: GbKksEFF4yrVs6il55v6gwY5aVje5f0j
Password matches, sending next password
bandit20@melinda:~$ 
```

gE269g2h3mw3pwgrj0Ha9Uoqen1c9DGr

## 21 -> 22

Cron jobs! I knew a little about them, so I referred briefly to the man pages. Seems like /etc/cron.d/ is where all running jobs are stored. Inside were several jobs, and four for the bandit wargame. Chances are cronjob_bandit22 is what I'm looking for.

```
-rw-r--r--   1 root root   61 Nov 14  2014 cronjob_bandit22
-rw-r--r--   1 root root   62 Nov 14  2014 cronjob_bandit23
-rw-r--r--   1 root root   61 May  3  2015 cronjob_bandit24
-rw-r--r--   1 root root   62 May  3  2015 cronjob_bandit24_root
```

It ran a bash script and sent all output to /dev/null, silencing its output. The script itself writes the bandit22 password into a file in /tmp, and since the script also marks it as readable, I could read the password.

Yk7owGAcWjwMVRwrTesJEwB7WVOiILLI

## 22 -> 23

This one starts off the same, but the bash script it ran is a bit more complicated, but dealing with bash scripts a lot in the past has its benefits. The password this time is in a file in `/tmp`. The name is the result of the following operation:`$(echo I am user $myname | md5sum | cut -d ' ' -f 1)`, with the `$()` symbols denoting that the contents are evaluated and stored into the mytarget variable. So the md5 of "I am user " is generated, the result is split by spaces, and the first element is chosen, or the md5 sum.

But there's a problem in that $myname doesn't exist for bandit22. I can infer that for bandit23 the myname variable is simply bandit23. This is confirmed with `echo I am user bandit23 | md5sum`, and seeing if the password is in that file. Alternatively for a concise command, `cat /tmp/$(echo I am user bandit23 | md5sum | cut -d ' ' -f 1)`

jc1udXuA1tiHqjIsL8yaapX5XIAI6i0n

## 23 -> 24

Two cron jobs were running this time, a bandit24 and bandit24_root. The root one is off limits, but the regular bandit could be read. It was pretty well documented, and self explanatory. It appears to run all scripts in `/var/spool/bandit24` and deletes them after 60 seconds.

I ended up with the following code. Note that it needs to be marked executable, or you might spend quite some time wondering how your code is broken. It isn't, just `chmod +x` it.

```bash
#!/bin/bash
datfile=/tmp/gitsum
echo $(whoami) > $datfile
ls -alhF >> $datfile
cat /etc/bandit_pass/$(whoami) >> $datfile
```

And I used `clear && ll && file /tmp/gitsum` to check the status. After it was done, I cat the file for the password.

UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ

## 24 -> 25

Port 30002 on localhost can be connected to using netcat. Bandit24's password is provided, along with a 4 digit pin that needs to be bruteforced. I first netcat-ed in to get an idea how it works, before coming up with the following:

```
echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ 0000" | nc localhost 30002
```

I came up with a script that would go in a loop through all pin numbers. A loop would test a pin in a background process, and if the message returned is different from the generic error, save that pin. There were a few iterations due to overloading the system's resources and various small bugs.

looper.sh
``` bash
#!/bin/bash
# Bruteforce pin codes

outFile=result

test_pin() {
    outFile=result
    pin=$1
    error="Wrong! Please enter the correct pincode. Try again."

    response=$(echo "UoMYTrfrBFHyQXmg6gzctqAwOmw1IohZ $pin" | nc localhost 30002)
    # response=$error #debugging

    echo "test pin" $pin

    # response check
    if [[ "$response" != *"$error"* ]]; then 
        echo $pin >> $outFile
        echo $response >> $outFile
    fi
}

echo "start" >> $outFile

for d1 in $( seq 0 9 ); do
    for d2 in $( seq 0 9 ); do
        for d3 in $( seq 0 9 ); do
            for d4 in $( seq 0 9 ); do
                test_pin $d1$d2$d3$d4 &
                sleep 0.02 # Prevent overloading resources
            done
        done
    done
    echo "checked "$d1"000 pins" >> $outFile
done

echo "job done" >> $outFile
```

After a while of it running, the result file contains the following lines.

```
...
5669
I am the pincode checker for user bandit25. Please enter the password for user bandit24 and the secret pincode on a single line, separated by a space. Correct! The password of user bandit25 is uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG Exiting.
...
```

uNG9O58gUE7snukf3bvZ0rxhtnjzSGzG

## 25 -> 26

The home directory has an ssh key for bandit26. Connecting will immediately kick you out. As the prompt indicates, bandit26 uses a different shell. Searching online revealed the default shells are in "/etc/passwd", and bandit26 uses "/usr/bin/showtext", which simply executes "more ~/text.txt".

I had difficulty here, and found out that more will be interrupted if the terminal window is small enough, as more controls the ouput of text for someone to view. Apparently the window needs to be resized long before before ssh to bandit26 is even done. Anyways, from that point it was a lot of manual reading before discovering `v` enters vi mode to view the "text.txt" file. `more` can't do much, but vi is fairly powerful and the `:r` command can read files. Opening /etc/bandit_pass/bandit26 revealed the password.

5czgV9L3Xx8JPOyRbXh6lQbmIOWvPT6Z

alias ll='ls -alhF'; ll
