#!/bin/bash
export WITH_VIGRANUMPY=TRUE

# Clean up the previous build for ease of configuration
rm -rf build
source $RECIPE_DIR/build.sh
