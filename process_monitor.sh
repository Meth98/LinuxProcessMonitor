#!/bin/bash

################################################################################################
## Description: Script to identify if the input process is running on the system or not
##              List of standard processes typically found on Linux:
##                 - Cron: /usr/sbin/cron, /usr/sbin/crond
##                 - SSH: /usr/sbin/sshd (note: /usr/bin/ssh is the client)
##                 - Syslog: /usr/sbin/syslogd, /usr/sbin/rsyslogd, /usr/sbin/syslog-ng
##
## Author: Matteo Z.
################################################################################################

print_usage() {
      echo -e "\nDescription:"
      echo -e "\n    Script to identify whether the input process is running on the system or not"
      echo -e "\nUsage: $0 -N <process>"
      echo -e "\nOptions:"
      echo -e "\n   -N -> to print the process name found"
      echo -e "\nOther info:"
      echo -e "\n    process"
      echo -e "\nSome examples:"
      echo -e "\n - $0 -N sshd"
      echo -e "\n - $0 -N /usr/sbin/sshd"
      echo -e "\n - $0 -N /usr/sbin/syslogd,/usr/sbin/rsyslogd,/usr/sbin/syslog-ng\n"
      exit 1
}


########## MAIN ##########

found=0

while getopts ':N:' opt; do
      case $opt in
            N)
                  process=${OPTARG} ;;
            *)
                  echo -e "\nError!! You have done something wrong!"
                  print_usage ;;
      esac
done
shift $((OPTIND-1))

if [ -z $process ]; then
     echo -e "\nError!! I don't understand which process you want to verify!"
     print_usage
else
      IFS=',' read -ra array_proc <<< "$process"

      for element in "${array_proc[@]}"; do
            # echo "Loop element: $element"
            cmd_exists=$(command -v $element)

            if [ $? -eq 0 ]; then
                  found=1; break
            fi
      done

      if [ $found ]; then
            # echo -n "Element found on system: $element "
            element=$(basename $element)
            # echo "-> $element"
      else
            echo "The system has no process with this name"
      fi
fi