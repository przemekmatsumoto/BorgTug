
SECTION 1 - Creating the remote-backup user

    1. Add remote-backup user:
    sudo adduser remote-backup 

SECTION 2 - Generate ssh key and create a config file as remote-backup user

    1. Switch to the remote-backup user:
    su remote-backup

    2. Create the .ssh directory and set permissions if it doesn’t exist:
    mkdir -p ~/.ssh && chmod 700 ~/.ssh

    3. Generate ssh key as remote-backup user (change your_name_for_key):
    ssh-keygen -t ed25519 -f /home/remote-backup/.ssh/your_name_for_key -N "" 

SECTION 3.1 - Part of how to setup client

    1. Copy the ssh public key (change your_name_for_key):
    cat /home/remote-backup/.ssh/your_name_for_key.pub

    4. Create config file:
    touch /home/remote-backup/.ssh/config

    5. Add configuration depending on the number of clients (See example -> Linux (debian) server structure -> home -> .ssh -> config)

SECTION 3 - Install borgbackup and socat

    1. Update repositories:
    sudo apt update

    2. Install borgbackup and socat as a user with root privileges:
    sudo apt install borgbackup socat

SECTION 4 - Create borgbackup repository

    1. Create directory where we’ll initialize the borgbackup repository as root user (change name /path/to/your/new/borgbackup/repository):
    sudo mkdir /path/to/your/new/borgbackup/repository

    2. Grant permissions to the new borgbackup repository. As root user execute (change name /path/to/your/new/borgbackup/repository):
    sudo chown remote-backup:remote-backup /path/to/your/new/borgbackup/repository

    3. Switch to remote-backup user:
    su remote-backup

    4. In the backup location, initialize the borgbackup repository as remote-backup user (change name /path/to/your/new/borgbackup/repository):
    borg init --encryption=repokey-blake2 /path/to/your/new/borgbackup/repository

    You’ll be asked for a password to secure the repository, enter it and confirm with Enter

    5. (Optional) test if the repository works:
    borg list /path/to/your/new/borgbackup/repository

SECTION 5 - Create service and socket

    1. As root user, create a service (change name your_service_name):
    sudo touch /etc/systemd/system/your_service_name@.service

    2. After creating the file, write your configuration there (See example -> Linux (debian) server structure -> etc -> systemd -> system -> example@.service). (change name 2x your_socket_name.socket and /path/to/your/borgbackup/repository)

    3. As root user, create a socket (change name your_name_for_socket):
    sudo touch /etc/systemd/system/your_name_for_socket.socket

    4. After creating the file, write your configuration there (See example -> Linux (debian) server structure -> etc -> systemd -> system -> example.socket). (change name your_service_name@.service and /path/where/the/sock/will/be/created.sock)

    WARNING!
    The remote-backup user must have permissions to the directory where the .sock will be created /path/where/the/sock/will/be/created.sock
    You can change permissions to that directory by executing the following command as root: sudo chown remote-backup:remote-backup /path/where/the/sock/will/be/

SECTION 6 - Create backup configuration file, backup script, and restore script

    1. Switch to remote-backup user:
    su remote-backup

    2. As remote-backup user, create ‘backup’ directory in the home folder:
    mkdir ~/backup

    3. Change permissions to the created directory:
    chmod 700 ~/backup

    4. Create backup config file and write your configuration (See example -> Linux (debian) server structure -> home -> backup -> backup.conf):
    nano ~/backup/backup.conf

    5. Create backup script and paste example (See example -> Linux (debian) server structure -> home -> backup -> run_backup.sh):
    nano ~/backup/run_backup.sh

    6. Create restore backup script and paste example (See example -> Linux (debian) server structure -> home -> backup -> run_restore.sh):
    nano ~/backup/run_restore.sh

    7. Set permissions for the created files:
    chmod 640 ~/backup/backup.conf
    chmod 755 ~/backup/run_backup.sh 
    chmod 750 ~/backup/run_restore.sh 

    8. Assign files to specific owners (execute these commands as root user (su your_root_user)):
    sudo chown root:remote-backup /home/remote-backup/backup/backup.conf
    sudo chown root:root /home/remote-backup/backup/run_backup.sh 
    sudo chown root:remote-backup /home/remote-backup/backup/run_restore.sh 

    WARNING!
    After applying the changes from steps 7 and 8, some files will require root privileges for editing.

    9. As root user, add permission for remote-backup user to edit backup.conf as root:
    sudo nano /etc/sudoers
    OR
    sudo visudo (if not installed, install with: sudo apt install visudo)

    10. Add the line:
    remote-backup ALL=(ALL) /home/remote-backup/backup/change_backup_hour.sh, /usr/bin/nano backup.conf

SECTION 7 - Install crudini for reading/modifying ini files (backup script) and curl for sending Slack notifications

    1. Update repositories:
    sudo apt update

    2. Install crudini and curl:
    sudo apt install crudini curl

SECTION 8 - Create service, timers for automatic backup and script to change backup hours

    1. As root user, create a service to trigger backup at specific times:
    sudo touch /etc/systemd/system/backup@.service

    2. Paste your configuration in the file created above (See example -> Linux (debian) server structure -> etc -> systemd -> system -> backup@.service):
    sudo nano /etc/systemd/system/backup@.service

    3. Create .timer, paste config and set the time for backup (See example -> Linux (debian) server structure -> etc -> systemd -> system -> backup@example.timer):
    sudo nano /etc/systemd/system/backup@example.timer

    WARNING!
    In backup@example.timer the name ‘example’ should match the one in Linux (debian) server structure -> home -> backup -> backup.conf depending on the client name there, e.g., [debian1]. Example correct naming: backup@debian1.timer

    Also adjust line ‘Description=Daily backup for client1’ in backup@example.timer. Change client1 to the appropriate name from backup.conf, e.g., [debian1]. Example correct change: Description=Daily backup for debian1

    4. Create script to change backup hours and paste according to pattern (See example Linux (debian) server structure -> home -> backup -> change_backup_hour.sh):
    sudo nano /home/remote-backup/backup/change_backup_hour.sh

    5. Set permissions and change owner of the script:
    sudo chmod 755 /home/remote-backup/backup/change_backup_hour.sh
    sudo chown root:root /home/remote-backup/backup/change_backup_hour.sh

    6. As root user, allow change_backup_hour.sh to be executed as root:
    sudo nano /etc/sudoers
    OR
    sudo visudo (if not installed, install with: sudo apt install visudo)

    7. Add the line:
    remote-backup ALL=(ALL) /home/remote-backup/backup/change_backup_hour.sh

SECTION 9 - Set timers to autostart

    1. Enable timer to start at system boot (Change your_timer_name to the appropriate client name -> see SECTION 8 point 3):
    sudo systemctl enable backup@your_timer_name.timer