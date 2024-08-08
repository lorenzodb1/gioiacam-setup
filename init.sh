#!/usr/bin/bash

# Source: https://forums.raspberrypi.com/viewtopic.php?t=361778

echo "Starting setup for GioiaCam"

sudo apt-get update -y && sudo apt-get full-upgrade -y
sudo apt install -y codeblocks
sudo apt install -y libopencv-dev
sudo apt install -y python3-opencv

# https://qengineering.eu/install-gstreamer-1.18-on-raspberry-pi-4.html
sudo apt-get install libx264-dev libjpeg-dev
sudo apt-get install -y libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3

# https://www.raspberrypi.com/documentation/computers/camera_software.html#building-libcamera
sudo apt install -y python3-pip git python3-jinja2
sudo apt install -y libboost-dev
sudo apt install -y libgnutls28-dev openssl libtiff5-dev pybind11-dev
sudo apt install -y qtbase5-dev libqt5core5a libqt5gui5 libqt5widgets5
sudo apt install -y meson cmake
sudo apt install -y python3-yaml python3-ply
sudo apt install -y libglib2.0-dev libgstreamer-plugins-base1.0-dev

git clone https://github.com/raspberrypi/libcamera.git
cd libcamera
meson setup build --buildtype=release -Dpipelines=rpi/vc4,rpi/pisp -Dipas=rpi/vc4,rpi/pisp -Dv4l2=true -Dgstreamer=enabled -Dtest=false -Dlc-compliance=disabled -Dcam=disabled -Dqcam=disabled -Ddocumentation=disabled -Dpycamera=enabled
ninja -C build
sudo ninja -C build install
cd ~

# https://www.raspberrypi.com/documentation/computers/camera_software.html#building-libepoxy
sudo apt install -y libegl1-mesa-dev
git clone https://github.com/anholt/libepoxy.git
cd libepoxy
mkdir _build
cd _build
meson
ninja
sudo ninja install
cd ~

# https://www.raspberrypi.com/documentation/computers/camera_software.html#building-rpicam-apps
sudo apt install -y cmake libboost-program-options-dev libdrm-dev libexif-dev
sudo apt install -y meson ninja-build
git clone https://github.com/raspberrypi/rpicam-apps.git
cd rpicam-apps
meson setup build -Denable_libav=disabled -Denable_drm=enabled -Denable_egl=disabled -Denable_qt=disabled -Denable_opencv=disabled -Denable_tflite=disabled
meson compile -C build
sudo meson install -C build
sudo ldconfig
cd ~

sudo apt install -y python3-picamera2

echo "Setup complete"