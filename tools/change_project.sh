#!/bin/bash
if [ -z "${1}" ]; then 
  path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
  dir=`dirname $path`;
else
  dir=$1; 
fi

while true; do
    read -p "Does it correct path [$dir] to root dir of your project? [yes/no] " yn
    case $yn in
        [Yy]* ) echo "Ok"; break;;
        [Nn]* ) echo "Please put correct path when you run this script like:\n bash change_project.sh /var/www/magento\n"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Please enter OLD name for magento project or will've been used [milcrew] : ";
read old_project_name
while true; do
    read -p "You've entered: [$old_project_name] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ -z "${old_project_name}" ]; then
   old_project_name="milcrew";
fi

echo "Please enter NEW name for magento project : ";
read project_name
while true; do
    read -p "You've entered: [$project_name] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Renaming default file milcrew.sql to $project_name.sql" &&
mv $dir/schema/$old_project_name.sql $dir/schema/$project_name.sql &&
echo "Changing data in schema/$project_name.sql" &&
sed -i '' 's/'$old_project_name'/'$project_name'/g' $dir/schema/$project_name.sql &&
echo "Done files preparing successfully";

if [ $? -ne 0 ]
then
    exit 1
fi

echo "Please enter your db name: ";
read db_name
while true; do
    read -p "You've entered: [$db_name] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Please enter your db user name: ";
read db_user_name
while true; do
    read -p "You've entered: [$db_user_name] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Please enter your db password: ";
read db_user_password
while true; do
    read -p "You've entered: [$db_user_password] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

sed -i '' '/\<username\>\([^ ]*\)\<\/username\>/ s//<username><![CDATA['$db_user_name']]><\/username>/g' app/etc/local.xml &&
sed -i '' '/\<password\>\([^ ]*\)\<\/password\>/ s//<password><![CDATA['$db_user_password']]><\/password>/g' app/etc/local.xml &&
sed -i '' '/\<dbname\>\([^ ]*\)\<\/dbname\>/ s//<dbname><![CDATA['$db_name']]><\/dbname>/g' app/etc/local.xml && 
echo "Changing credentials done successfull\n";

if [ $? -ne 0 ]
then
   exit 1
fi

echo "Please put your mysql command or will've been used default [mysql]: ";
read mysql_command
while true; do
    read -p "You've entered: [$mysql_command] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ -z "${mysql_command}" ]; then
  mysql_command="mysql" 
fi


$mysql_command -u $db_user_name -p$db_user_password -e "drop database if exists $db_name; create database if not exists $db_name;" &&
$mysql_command -u $db_user_name -p$db_user_password $db_name < $dir/schema/$project_name.sql &&
wget http://$project_name.in -O /dev/null &&
$mysql_command -u $db_user_name -p$db_user_password -e "use $db_name;drop table xmlconnect_images;" &&
$mysql_command -u $db_user_name -p$db_user_password $db_name < $dir/schema/$project_name.sql &&
echo "Database prepared successfully\n";

if [ $? -ne 0 ]
then
    exit 1
fi

echo "Everything done successfully";
