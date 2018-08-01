#@author Stefano Sesia 31st July 2018
# A simple AES 256 encrypted chat over TCP. Powered by netcat and openssl

delimiter=": "
serverColour='\033[0;32m'
clientColour='\033[0;34m'
noColour='\0033[0m'

function server {
  echo '*************************************'
  echo '************ >shell chat ************'
  echo '*************************************'
  echo '> Welcome to the chatroom Server'
  echo -e "> Your username is: $username"
  echo "> Connecting to: $serverIP"
  echo '#####################################'
  echo ''
  while true; do
    read incoming_message;
    outgoing_message=$username$delimiter$incoming_message
    echo -e ${serverColour}$outgoing_message${noColour} | openssl enc -aes-256-ctr -a -k $secret;
  done | ncat -l -p 6890 --allow $serverIP --ssl|
  while read so; do
    decoded_message= echo -e $so | openssl enc -d -a -aes-256-ctr -k $secret;
  done
}

function client {
  echo '*************************************'
  echo '************ >shell chat ************'
  echo '*************************************'
  echo '> Welcome to the chatroom Client'
  echo -e "> Your username is: $username"
  echo -e "> Connecting to: $serverIP"
  echo '#####################################'
  echo ''
  while true; do
    read -n30 incoming_message;
    outgoing_message=$username$delimiter$incoming_message
    echo -e ${clientColour}$outgoing_message${noColour} | openssl enc -aes-256-ctr -a -k $secret;
  done | ncat $serverIP 6890 --ssl|
  while read packet; do
    decoded_message= echo -e $packet | openssl enc -d -a -aes-256-ctr -k $secret;
  done
}

function help {
  echo '*************************************'
  echo '************ >shell chat ************'
  echo '*************************************'
  echo '> Welcome to the chatroom'
  echo "> usage: ./ShellChat [server/client] [username] [secret] [TargetIP]*"
  echo "> *specify IP address only in client mode"
  echo "> eg. ./ShellChat server Bob PaSsWoRd 192.168.0.1"
  echo "> eg. ./ShellChat client Alice PaSsWoRd 192.168.0.1 "
  echo '#####################################'
}

if [[ $# -lt 4 ]]; then
  help

else
  secret=$3
  serverIP=$4
  username=$2

  if [[ $1 = "server" ]]; then
    server
  fi

  if [[ $1 = "client" ]]; then
    client
  fi

fi
