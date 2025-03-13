#!/bin/bash

set -e

xmake f --yes --project_name=xmake/01-basic/B-cuda-target --verbose
xmake build --yes --verbose --diagnosis --rebuild xmake.01-basic.B-cuda-target.main
