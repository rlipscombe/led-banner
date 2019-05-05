# led-banner

Squirrel source code for Electric Imp-powered, WS2812 LED banner

## Overview

We want to take a string, such as 'Happy Birthday!', and convert it into
something suitable for feeding to the LED banner.

Rather than store an 8-pixel high font in the squirrel, we'll use 'figlet'
to create our pixel matrix:

    figlet -w 100 -f letter 'Hello World!  ' | \
        curl -X POST --data-binary @- $AGENT_URL

## Extra fonts

You can find extra fonts at github:cmatsuoka/figlet-fonts; the 'sans' font
below is from there, in the 'bdffonts' directory.

Or, if you want to use a different font, and because some figlet fonts have
excessive padding:

    figlet -w 1000 -f sans 'Hello World!  ' | \
        awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
        awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
        head -n 8 | tee /dev/stderr | \
        curl -s -X POST $AGENT_URL --data-binary @-

**Note:** The above is handled by the `write.sh` script:

    FONTS_DIR=~/src/cmatsuoka/figlet-fonts      # e.g.
    ./write.sh $AGENT_URL $FONTS_DIR/bdffonts/sans 'Hello World!  '

## Using impt

You can use impt to manage your devices. You need to link the project with
your impCentral device group:

    impt project link --dg $DEVICE_GROUP_UUID
