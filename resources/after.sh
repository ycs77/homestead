#!/bin/sh

if [ -f ~/.homestead-features/wsl_user_name ]; then
    USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    USER_NAME=vagrant
    USER_GROUP=vagrant
fi

if [ ! -f /home/$USER_NAME/.homestead-features/custom ]; then
    echo 'Running: script: Executing custom setting...'

    # Update editor to vim
    sudo update-alternatives --set editor /usr/bin/vim.basic

    # Update php session time for phpMyAdmin
    sudo sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/php/7.4/fpm/php.ini
    sudo service php7.4-fpm restart

    # Update composer bin setting for generate windows and linux binary
    composer config -g bin-compat full

    # Update file descriptor limit to maximum
    if ! grep -q fs.inotify.max_queued_events=16384 /etc/sysctl.conf; then
        echo fs.inotify.max_queued_events=16384 | sudo tee -a /etc/sysctl.conf
    fi
    if ! grep -q fs.inotify.max_user_instances=8192 /etc/sysctl.conf; then
        echo fs.inotify.max_user_instances=8192 | sudo tee -a /etc/sysctl.conf
    fi
    if ! grep -q fs.inotify.max_user_watches=524288 /etc/sysctl.conf; then
        echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    fi
    sudo sysctl -p

    # Copy homestead certificate to public folder
    if [ -d ~/code/_public ]; then
        sudo cp /etc/ssl/certs/ca.homestead.homestead.crt ~/code/_public
    fi

    # Create certificate for localhost
    sudo /vagrant/scripts/create-certificate.sh localhost
    sudo chmod -R 644 /etc/ssl/certs/localhost.key

    sudo touch /home/$USER_NAME/.homestead-features/custom
else
    echo 'Custom settings script have been executed'
fi
