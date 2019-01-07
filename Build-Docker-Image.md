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
   * libc++-dev
   * libc++abi-dev
   * devscripts
   * dh-systemd
   * libpq-dev
   * libsodium-dev
 * Link /usr/bin/clang to /usr/local/bin/clang
 * Clone https://github.com/danielnapierski/packages
 * Clone https://github.com/danielnapierski/stellar-core-alt
 * Copy the `debian` folder from the packages/stellar-core folder into the stellar-core-alt folder
 * Change the `control` and `changelog` files in the `debian` folder. Be sure to change the maintainer name and e-mail address in both. Take note of the version number which is recorded in the changelog file, this will be the package version.
 * Create a GPG key with those exact name and e-mail. Make sure the key is loaded into the GPG agent.
   * gpg --gen-key
     * Real name: ONFO Package Builder
     * Email: onfo@onfo.com
   * If gpg hangs, RNG entropy probably needs to be increased. This can be done by installing `rng-tools`.
   * Whatever data is entered for the PGP key data also needs to be included verbatim in the `changelog` and `control` files, in the format "ONFO Package Builder <onfo@onfo.com>". It must be formatted exactly like that.
   * If the PGP key is protected by a password, gpg-agent should be configured to cache keys, as described here: https://wiki.archlinux.org/index.php/GnuPG#gpg-agent , and the key should be pre-added by encrypting a message to yourself, as described here: https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages
 * Run `./autogen.sh`
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
