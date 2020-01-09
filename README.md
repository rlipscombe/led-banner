# led-banner

Squirrel source code for Electric Imp-powered, WS2812 LED banner

    source .env     # set AGENT_URL
    curl -X POST $AGENT_URL -d 'Hello World!  '

## Using impt

You can use impt to manage your devices. You need to link the project with
your impCentral device group:

    impt project link --dg $DEVICE_GROUP_UUID

    impt build run --log
