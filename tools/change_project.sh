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

echo "Please enter new name for magento project : ";
read project_name
while true; do
    read -p "You've entered: [$project_name] does it correct ? [yes/no]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "Please try again from begining ..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo "Changing database name in app/etc/local.xml \n" &&
sed -i 's/cosmetiki/'$project_name'/g' $dir/app/etc/local.xml &&
echo "Changing data in schema/cosmetiki.sql \n" &&
sed -i 's/cosmetiki/'$project_name'/g' $dir/schema/cosmetiki.sql &&
echo "Renaming default file cosmetiki.sql to $project_name.sql \n" &&
mv $dir/schema/cosmetiki.sql $dir/schema/$project_name.sql &&
echo "Done successfully";
