#!/bin/bash

for directory in `find . -type d | grep "/"` ; do

    dir=${directory/.\//}
    echo
    echo ----------------------
    echo process $dir
    echo ----------------------
    echo

    for lang in de uk fr ; do
        ls -1 $dir | grep jpg | sed -e s/.jpg// -e "s/^/gallery.html $dir\//" -e s/$/_$lang.html/ | xargs -L 1 cp
    done
    
    files=`ls -1 $dir | grep jpg | sed s/.jpg//`
    len=`ls -1 $dir | grep jpg | wc -l`

    for file in $files ; do
        
        prev=`expr -1 + $file`
        prev=`printf "%2d" $prev | sed s/\ /0/`
        next=`expr 1 + $file`
        next=`printf "%2d" $next | sed s/\ /0/`
        
        for key in de_Start uk_Home fr_Accueil ; do
            home=${key/*_/}
            lang=${key/_*/}
            
            f=$dir/${file}_$lang.html

            echo prepare $f
            
            if [ $file -eq '01' ] ; then
                sed -i "s/gallery..href=.PREV_LANG.html/non-gallery/" $f
            fi
            if [ $file -eq $len ] ; then
                sed -i "s/gallery..href=.NEXT_LANG.html/non-gallery/" $f
            fi
            sed -i -e s/PICTURE/$file/ -e s/NEXT/$next/ -e s/PREV/$prev/ -e s/LANG/$lang/g -e s/HOME/$home/ $f
        done
    done
done