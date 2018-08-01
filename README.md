# ShellChat
A simple chat server and client using Ncat ssl and AES 256 encryption. Runs in any bash enironment

## Usage:
- download chat.sh
- make it executable (chmod +x chat.sh)
- run it secifying the right arguments:
-./ShellChat [server/client] [username] [secret] [TargetIP]
  
  eg. ./ShellChat server Bob PaSsWoRd 192.168.0.1
  eg. ./ShellChat client Alice PaSsWoRd 192.168.0.1
