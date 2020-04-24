#! /bin/bash

# Get datetime and create dist directory
now=`date +"%Y%m%d%H%M%S"`
mkdir $now-release

if [ $# -ne 1 ]; then
    echo "Illegal number of parameters - Usage :\n package.sh file.svg"
else
    for format in "svg" "png" "pdf" "eps"
    do
        mkdir $now-release/$format
        case $format in
            png)  
                for size in 16 32 64 128 256 512 1024
                do
                    inkscape --export-png=$now-release/$format/file_$size.$format --export-width=$size --file $1
                done
                ;;
            svg)  
                cp $1 $now-release/$format/
                ;;
            pdf)  
                inkscape --export-pdf=$now-release/$format/file.$format --file $1
                ;;
            eps) 
                inkscape --export-eps=$now-release/$format/file.$format --file $1
            ;;
        esac
    done
    # Generate 16 chars random password
    pwd=`openssl rand -base64 16`
    # < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16} > /tmp/zip_pwd.txt
    echo $pwd > $now-password.txt
    zip -r $now-release.zip $now-release/ --encrypt --password $pwd
#    rm -rf $now-release/
fi

