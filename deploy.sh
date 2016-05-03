#!/bin/sh

set +x
set -o errexit -o nounset

if [ "$TRAVIS_BRANCH" != "travis" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

# Error out if $GH_TOKEN is empty or unset
: ${GH_TOKEN:?"GH_TOKEN needs to be uploaded via travis-encrypt"}

# Print a hash of the token for debugging
echo Token MD5: $(echo $GH_TOKEN | md5sum)

rev=$(git rev-parse --short HEAD)

# Clone the destination repository into $HOME/out without echoing the token
cd ..
git clone --branch=gh-pages "https://${GH_TOKEN}@github.com/euanh/planex-release" out | sed -e "s/$GH_TOKEN/!REDACTED!/g"
set -x

# Set up git
git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

# Commit the updated repository metadata
cd out
rm -rf *
cp -r ../planex-release/release .
cp -r ../planex-release/unstable .
touch .nojekyll
ln -s release/deb deb
ln -s release/rpm rpm

git add -A .
git commit -m "Update gh-pages branch for commit ${rev}"
git log --oneline -10

set +x
git push origin gh-pages 2>&1 | sed -e "s/$GH_TOKEN/!REDACTED!/g"
