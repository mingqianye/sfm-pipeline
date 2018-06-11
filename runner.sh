#!/bin/bash
docker build -t sfm . && docker run --rm -v `pwd`:/datasets sfm xuti/ xuti_output/
