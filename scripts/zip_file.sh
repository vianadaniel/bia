#!/bin/bash

cd ..

zip -r bia.zip . -x "node_modules/*" -x "dist/*" -x "scripts/*" -x "dist/*"
