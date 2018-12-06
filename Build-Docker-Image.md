# Building the onfo/onfo-stellar-horizon Docker image

This procedure was created on Ubuntu 18.04.

## #1: Building the Debian package

 * Install the following build dependancy packages:
   * clang
   * build-essential
   * pkg-config
   * automake
   * autoconf
   * libutil
   * bison
   * flex
   * pandoc
   * perl
   * dpkg-dev
 * Link /usr/bin/clang to /usr/local/bin/clang
 * Clone https://github.com/danielnapierski/packages
 * Clone https://github.com/danielnapierski/stellar-core-alt
 * Copy the `debian` folder from the packages/stellar-core folder into the stellar-core-alt folder
 * Change the `control` and `changelog` files in the `debian` folder. Be sure to change the maintainer name and e-mail address in both. Take note of the version number which is recorded in the changelog file, this will be the package version.
 * Create a GPG key with those exact name and e-mail. Make sure the key is loaded into the GPG agent.
 * Run `dpkg-buildpackage -b`

## #2 Upload the Debian package to GitHub or some other public storage

 * This can be done in GitHub by creating a release and attaching a binary file to the release.

## #3 Build a Docker image

 * Check out https://github.com/danielnapierski/docker-stellar-core-horizon-alt
 * Change the maintainer field in the Dockerfile
 * Change the `install` file to point to the correct Debian package URL for Stellar and the archive URL for Horizon
 * Run `docker build . -t onfo/onfo-stellar-horizon` to build the Docker image

## #4 Upload the Docker image to the Docker Hub

 * Log into Docker with `docker login`
 * Upload the image with `docker push onfo/onfo-stellar-horizon`
