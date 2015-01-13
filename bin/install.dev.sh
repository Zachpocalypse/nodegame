#!/bin/bash
# nodeGame install development version from sources script
# Copyright(c) 2015 Stefano Balietti
# MIT Licensed


# Add symbolic links to given dependencies that are in nodegame/node_modules
# (e.g. JSUS, NDDB).
function link_deps {
    mkdir -p node_modules
    (
        cd node_modules
        for dep in "$@"
        do  ln -s "../../$dep" .
        done
    )
}


# List of all sub-modules on GitHub to clone:
gitmodules="nodegame-client nodegame-server nodegame-window nodegame-widgets "\
"JSUS NDDB shelf.js descil-mturk nodegame-db nodegame-mongodb"


# Clone the repo, copy Git hooks.
git clone git@github.com:nodeGame/nodegame.git
cd nodegame
cp git-hooks/* .git/hooks/

# Install the dependencies.
mkdir -p node_modules
cd node_modules
for module in $gitmodules; do git clone "git@github.com:nodeGame/${module}.git"; done
npm install smoosh
npm install ya-csv
npm install commander
npm install docker

# Install sub-dependencies, link to tracked dependencies.
(
    cd JSUS
    npm install
)

(
    cd descil-mturk
    link_deps JSUS NDDB
    npm install
)

(
    cd nodegame-mongodb
    npm install
)

(
    cd nodegame-client
    link_deps JSUS NDDB shelf.js
    npm install
)

(
    cd nodegame-server
    link_deps JSUS NDDB shelf.js nodegame-widgets
    npm install

    # Patch express connect.
    patch node_modules/express/node_modules/connect/lib/middleware/static.js < \
      bin/ng.connect.static.js.patch

    # Rebuild js files.
    node bin/make.js build-client -a -o nodegame-full
)

# Copy Git hooks.
for module in $gitmodules
do  cp ../git-hooks/* "${module}/.git/hooks/"
done

# Install ultimatum game under nodegame/games.
cd ..
git clone git@github.com:nodeGame/ultimatum games/ultimatum
cp git-hooks/* games/ultimatum/.git/hooks/


# Execute the following commands to try out the ultimatum game.

# Start the ultimatum game:
# node start/ultimatum-server

# Open two browser tabs for two players at the address:
# http://localhost:8080/ultimatum/
# Open the admin console at:
# http://localhost:8080/ultimatum/monitor.htm
# See the wiki documentation to modify settings.
