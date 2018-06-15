#!/bin/sh
# Shell script to install s3f3 and fuse
#=====================================================================
#=====================================================================
# Set the following variables to your system needs
#=====================================================================

S3BUCKET="yourbucketname"
S3MOUNT="/mys3bucket"
S3IAMROLE="some-S3Role"
#=====================================================================
# DONE
#=====================================================================

yum update -y

yum remove fuse fuse-s3fs -y

yum install fuse* fuse-libs fuse-devel libcurl gcc-c++ libcurl-devel libxml2 libxml2-devel libtool gettext gettext-devel openssl unzip openssl-devel gcc libstdc++-devel gcc-c++ curl curl* curl-devel libxml2 libxml2* libxml2-developenssl-devel mailcap make pkg-config automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config wget automake -y

cd /usr/local/src
wget https://github.com/libfuse/libfuse/releases/download/fuse-3.0.0rc2/fuse-3.0.0rc2.tar.gz
tar -xzf fuse-3.0.0rc2.tar.gz
rm fuse-3.0.0rc2.tar.gz
cd fuse
./configure --prefix=/usr
make && install
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig/
ldconfig

cd /usr/local/src
wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.80.tar.gz
wget https://github.com/s3fs-fuse/s3fs-fuse/archive/master.zip
tar -xzvf v1.80.tar.gz
rm v1.80.tar.gz
mv s3fs-fuse-1.80 s3fs
cd s3fs
./autogen.sh
./configure --prefix=/usr
make
make install
cd ..
cd s3fs-fuse-master
./autogen.sh
./configure --prefix=/usr/local
make
make install

##### Omit ######
#git clone https://github.com/s3fs-fuse/s3fs-fuse.git
#cd ..
#cd s3fs-fuse
#./autogen.sh
#./configure --prefix=/usr
#make
#make install


## Check S3MOUNT Directory exists then creates the S3fs directory if not created.

if [ ! -e "$S3MOUNT" ]; then

mkdir -p "$S3MOUNT"

fi

# S3 is mounted to the 
s3fs -o allow_other -o nonempty -o use_sse="1" -o iam_role="$S3IAMROLE" $S3BUCKET $S3MOUNT
df -h

# To unmount S3Bucket
#  fusermount -u /<s3mountpoint>