#!/usr/bin/env bash

# Switch user so stuff actually installs for the user.
oldHome=$HOME
su vagrant
export HOME="/home/vagrant"

# Add additional apt-get repositories
sudo apt-add-repository -y ppa:wpilib/toolchain
sudo apt-get -yq update

# Setup vimrc
git clone git://github.com/amix/vimrc.git vim_runtime
sh vim_runtime/install_basic_vimrc.sh
rm -rf vim_runtime

# Install Java 8, for Bazel
sudo apt-get -yq install openjdk-8-jdk

# Install Other Bazel Dependencies
sudo apt-get -yq install pkg-config zip g++ zlib1g-dev unzip

# Install Bazel
wget -nv https://github.com/bazelbuild/bazel/releases/download/0.3.0/bazel-0.3.0-installer-linux-x86_64.sh
chmod +x bazel-0.3.0-installer-linux-x86_64.sh
./bazel-0.3.0-installer-linux-x86_64.sh --user
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
rm -f bazel-0.3.0-installer-linux-x86_64.sh
sudo chmod 775 ~/bin # Need to fix permissions so we can write swift to this later
sudo chown -R vagrant bin

# Install FRC C++ Linux Toolchains
sudo apt-get -yq install frc-toolchain

# Install Swift Dependencies
sudo apt-get -yq install clang libicu-dev

# Install Swift
swiftURL="https://swift.org/builds/swift-2.2.1-release/ubuntu1510/swift-2.2.1-RELEASE/swift-2.2.1-RELEASE-ubuntu15.10.tar.gz"
swiftFile=$(basename $swiftURL)
swiftDir="${swiftFile/.tar.gz/}"
wget -nv $swiftURL
tar xzf $swiftFile --directory ~/bin
rm -f $swiftFile
echo 'export PATH=$PATH:$HOME/bin/'$swiftDir'/usr/bin' >> ~/.bashrc

# Setup python to use python3
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2

# Install Numpy, Scipy, matplotlib
sudo apt-get -yq install python3-numpy python3-scipy python3-matplotlib

# Install pip, for slycot package
sudo apt-get -yq install python3-pip

# Install slycot dependencies
sudo apt-get -yq install gfortran
sudo apt-get -yq install liblapack-dev

# Install slycot
sudo pip3 install slycot -q

# Install misc.
sudo apt-get -yq install htop

# Switch back to root. Probably doesn't matter, but it is symmetric.
sudo su
export HOME=$oldHome