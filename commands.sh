#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the primary process and put it in the background
#./my_main_process &

su - sonarqube -c "sudo systemctl restart sonarqube" &
  
# Start the helper process
#./my_helper_process

systemctl restart nginx
  
# the my_helper_process might need to know how to wait on the
# primary process to start before it does its work and returns
  
  
# now we bring the primary process back into the foreground
# and leave it there
fg %1


#su - sonarqube -c "sudo systemctl restart sonarqube" &
#systemctl restart nginx
#systemctl status sonarqube
#systemctl status nginx
