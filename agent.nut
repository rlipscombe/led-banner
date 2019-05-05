// Overview:
//
// We want to take a string, such as 'Happy Birthday!',
// and convert it into something suitable for feeding to the
// LED banner.
//
// Rather than store an 8-pixel high font in the squirrel, we'll
// use 'figlet' to create our pixel matrix:
//
//   figlet -w 100 -f letter 'Hello World!  ' | curl -X POST -d @- $AGENT_URL
//
// You can find extra fonts at github:cmatsuoka/figlet-fonts; the 'sans'
// font below is from there, in the 'bdffonts' directory.
//
// Or, if you want to use a different font, and because
// some figlet fonts have excessive padding:

/*
figlet -w 1000 -f sans 'Hello World!  ' | \
  awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
  awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
  head -n 8 | tee /dev/stderr | \
  curl -s -X POST $AGENT_URL --data-binary @-
*/

#require "rocky.class.nut:2.0.1"

// The message must be a multiple of 8 columns wide,
// in order for the palette to line up properly.
// This example is 48 columns.
// For other messages, device squirrel does it.
CurrentMessage <-
"#  #      # #        #  #  #          #    # #  \n" +
"#  #      # #        #  #  #          #    # #  \n" +
"####  ##  # #  ##     ## ##   ##  ### #  ### #  \n" +
"#  # #### # # #  #    ## ##  #  # #   # #  # #  \n" +
"#  # #    # # #  #    ## ##  #  # #   # #  #    \n" +
"#  #  ### # #  ##     ## ##   ##  #   #  ### #  ";
/*
          1         2         3         4       4 5
 12345678901234567890123456789012345678901234567890
 */

function postHome(context) {
    local message = context.req.rawbody;
    server.log(message);
    device.send("message", message);
    CurrentMessage = message;
    context.send(202, "Accepted\n");
}

server.log(http.agenturl());

app <- Rocky();
app.post("/", postHome);

server.log(CurrentMessage);

device.onconnect(function() {
    device.send("message", CurrentMessage);
});
