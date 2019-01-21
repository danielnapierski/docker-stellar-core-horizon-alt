# Building the onfo/onfo-stellar-horizon Docker image

This procedure was created on Ubuntu 18.04.

## #1: Building the Debian package

 1. Install the following build dependancy packages:
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
 2. Link /usr/bin/clang to /usr/local/bin/clang
 3. Clone https://github.com/danielnapierski/packages
 4. Clone https://github.com/danielnapierski/stellar-core-alt
 5. Copy the `debian` folder from the packages/stellar-core folder into the stellar-core-alt folder
 6. Change the `control` and `changelog` files in the `debian` folder. Be sure to change the maintainer name and e-mail address in both. Take note of the latest (topmost) version number which is recorded in the changelog file, this will be the package version.
 7. Create a GPG key with those exact name and e-mail. Make sure the key is loaded into the GPG agent.
   * gpg --gen-key
     * Real name: ONFO Package Builder
     * Email: onfo@onfo.com
   * If gpg hangs, RNG entropy probably needs to be increased. This can be done by installing `rng-tools`.
   * Whatever data is entered for the PGP key data also needs to be included verbatim in the `changelog` and `control` files, in the format "ONFO Package Builder <onfo@onfo.com>". It must be formatted exactly like that.
   * If the PGP key is protected by a password, gpg-agent should be configured to cache keys, as described here: https://wiki.archlinux.org/index.php/GnuPG#gpg-agent , and the key should be pre-added by encrypting a message to yourself, as described here: https://www.digitalocean.com/community/tutorials/how-to-use-gpg-to-encrypt-and-sign-messages
 8. Run `./autogen.sh`
 9. Run `dpkg-buildpackage -b`

## #2 Upload the Debian package to GitHub or some other public storage

The Docker image build process fetches the Debian package and installs it into the image as a part of the build process. This can be done in GitHub by creating a release and attaching a binary file to the release - which is the process currently programmed into the `install` script of this repository.

 1. Go to the https://github.com/danielnapierski/stellar-core-alt repository
 2. Click on the "Releases" link (usually shown with the number of releases available, e.g. "36 Releases")
 3. Choose if you want to update an existing release - which is useful (easier) during development, or create a new one. This also influences (and is influenced by) step 6 from the package build process described above.
    * If you want to replace the package file in an existing release (usually the latest one), and the Debian package was built with the same version number, click the Edit button near the release title, delete the current package file (by clicking on the X in the list of files below the description), and upload a new one, making sure it has the same filename.
    * If you want to create a new release, with a new version number:
      1. Click on the "Draft a new release" button
      2. As the tag version enter the exact same version number as the version of the package you'll be uploading, e.g. "v0.1-2"
      3. Upload the Debian package file (named e.g. `stellar-core-onfo_0.1-2_amd64.deb`)
      4. Modify the `install` file in this repository to fetch the new package file (the `wget` line near the start of the script)

## #3 Build a Docker image

 * [Install](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04) the latest version of Docker
 * Check out https://github.com/danielnapierski/docker-stellar-core-horizon-alt
 * Change the maintainer field in the Dockerfile
 * Change the `install` file to point to the correct Debian package URL for Stellar and the archive URL for Horizon
 * Run `docker build . -t onfo/onfo-stellar-horizon` to build the Docker image

## #4 Upload the Docker image to the Docker Hub

 * Log into Docker with `docker login`
 * Upload the image with `docker push onfo/onfo-stellar-horizon`
