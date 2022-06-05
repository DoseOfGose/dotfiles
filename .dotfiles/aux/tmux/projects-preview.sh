#!/bin/bash

name=$1

yq ".[] | select(.name == \"$name\")" projects.yaml
