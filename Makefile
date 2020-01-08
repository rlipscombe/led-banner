LIBS := $(wildcard lib/*.nut)

all: build run

build: agent.nut_ device.nut_

agent.nut_: agent.nut $(LIBS)
device.nut_: device.nut $(LIBS)

# We use 'Builder' to preprocess the nut files.
# See https://github.com/electricimp/Builder
# You need to "npm install -g Builder"
PLEASEBUILD_OPTS := -l --lib builder/shift.js --lib builder/to_array.js
PLEASEBUILD := pleasebuild $(PLEASEBUILD_OPTS)

# .nut -> .nut_
%.nut_: %.nut
	$(PLEASEBUILD) $< >$@

# We use 'impt' to push the code.
# See https://github.com/electricimp/imp-central-impt
# You need to "npm install -g imp-central-impt"
IMPT := impt

run:
	$(IMPT) build run

run-log:
	$(IMPT) build run --log
