echo "> select Host,User,password_last_changed,authentication_string from user where User like 'v-%';"

mysql -uroot -p`cat .pass` -D mysql -t -e "select Host,User,password_last_changed,authentication_string from user where User like 'v-%';" 2>/dev/null

