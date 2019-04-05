#!/bin/bash

# Reads Daedalus Project Docs sitemap.xml and creates NGINX locations containing preload links.

TMPFOLDER=/var/tmp/xml2preloadlinks
LINKS=$TMPFOLDER/links
VHOSTLOCATIONS=$TMPFOLDER/vhostlocations

SITEMAP_XML=$1

PUBLIC_PATH=$(echo $SITEMAP_XML | sed  's/\/[^\/]\+$//g')

mkdir -p $TMPFOLDER

rm -f $VHOSTLOCATIONS
touch  $VHOSTLOCATIONS

if [ -f $SITEMAP_XML ]; then
    xmllint --format $SITEMAP_XML -o $TMPFOLDER/sitemap.xml
    locations=$(xmlstarlet sel -t -v '//*[local-name()="loc"]' /var/tmp/xml2preloadlinks/sitemap.xml  | grep -v "/tags/\|/categories/")
    for location in $locations
    do
        INDEXTOPROCESS="$PUBLIC_PATH$location"index.html
        if [ -f $INDEXTOPROCESS ]; then
            rm -f $LINKS
            for link in $(grep -o "src=[^>]*.js>" $INDEXTOPROCESS | sed 's/^src=\([^>]*\)>$/\1/')
            do
                echo "        add_header Link \"<$link>; rel=preload; as=script\";"; 
            done > $LINKS
            for link in $(grep -o "href=[^>]*.css" $INDEXTOPROCESS | sed 's/^href=\([^>]*\)$/\1/')
            do
                echo "        add_header Link \"<$link>; rel=preload; as=style\";"
            done >> $LINKS
            for link in $(grep -o "href=[^>]*type=image" $INDEXTOPROCESS | sed 's/^href=\([^ ]*\) type=image$/\1/')
            do
                echo "        add_header Link \"<$link>; rel=preload; as=image\";"
            done >> $LINKS
            for link in $(grep -o "img src=[^ ]*" $INDEXTOPROCESS | sed 's/^img src=\([^ ]*\)$/\1/')
            do
                echo "        add_header Link \"<$link>; rel=preload; as=image\";"
            done >> $LINKS

            if [ -f $LINKS ]; then
                echo "    location $location {" >> $VHOSTLOCATIONS
                echo "        index index.html;" >> $VHOSTLOCATIONS
                cat $LINKS >> $VHOSTLOCATIONS
                echo -e "    }\n" >> $VHOSTLOCATIONS
            fi
        fi
    done
    cp $VHOSTLOCATIONS vhostlocations.conf
else
    (>&2 echo "$SITEMAP_XML not found.")
    exit 1
fi
