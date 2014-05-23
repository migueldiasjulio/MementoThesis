#!/bin/bash
pub build

# Clone gh-pages
git clone git@github.com:migueljulio/MementoThesis.git gh-pages
pushd gh-pages
git checkout -t origin/gh-pages

# Out with the old in with the new
rm -rf *
cp -r ../build/web/* .

# Remove dart files to keep source code private
find . -name "*.dart" -type f -delete

# Add and commit
git add -A
git commit -m "Updated build"
git push
popd

rm -rf gh-pages
