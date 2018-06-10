#!/bin/bash
docker build -t sfm . && docker run --rm -v `pwd`:/datasets sfm cup/ o3/
