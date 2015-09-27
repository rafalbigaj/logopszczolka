#!/bin/bash

SITE_DIR=beta.logopszczolka.pl
ASSETS_DIR=logopszczolka-irl.s3.amazonaws.com

function mirror_site() {
    rm -rf *.html *.txt theme content
    wget -D $SITE_DIR,$ASSETS_DIR -k -H -r -l inf -p -R "*_admin.html,favicon*,android-chrome-*,apple-touch-icon-*" -X locomotive -E http://$SITE_DIR
    find . -type d -empty -delete
    SITE_ID=$(ls $ASSETS_DIR/sites)
    ASSETS_SITE_DIR=$ASSETS_DIR/sites/$SITE_ID
}

function cut_assets_timestamp() {
    for asset in $(find $ASSETS_DIR -type f); do
        if [[ $asset = *\?* ]]; then
            mv $asset ${asset/\?*/}
        fi
    done
}

function move_assets() {
    mkdir $SITE_DIR/content
    mv $ASSETS_SITE_DIR/theme $SITE_DIR
    for content in $ASSETS_SITE_DIR/content*; do
        mv $content/* $SITE_DIR/content
    done
    rm -rf $ASSETS_DIR
}

function clone_index() {
    cp $SITE_DIR/index.html $SITE_DIR/gabinet_logopedyczny_pszczola.html
}

function rewrite_paths() {
    local HTML_FILES=$SITE_DIR/*.html
    local ASSETS_PATH=\\.\\./$ASSETS_SITE_DIR

    sed --in-place -e "s|$ASSETS_PATH/theme|theme|g" \
		   -e "s|$ASSETS_PATH/content_entry[0-9a-z]*|content|g" \
                   -e "s|\(src=.*\)%3F|\1?|g" \
                   -e "s|href=\"http://$SITE_DIR|href=\"|g" \
                   -e "s|index.html|gabinet_logopedyczny_pszczola.html|g" \
                   $HTML_FILES
}

function move_site_to_root() {
        mv $SITE_DIR/* .
        rm -rf $SITE_DIR
}

mirror_site
cut_assets_timestamp
move_assets
clone_index
rewrite_paths
move_site_to_root

git status
