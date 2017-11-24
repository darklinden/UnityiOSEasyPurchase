#/bin/sh
# -sdk $simulatorsdk clean build

simulatorsdk=$(/usr/bin/xcodebuild -showsdks | grep iphonesimulator | awk -F ' ' '{ print $NF }')
iossdk=$(/usr/bin/xcodebuild -showsdks | grep iphoneos | awk -F ' ' '{ print $NF }')

echo "use simulatorsdk "$simulatorsdk
echo "use iossdk "$iossdk

libDir='lib'
if [ ! -d "$libDir" ]; then
    mkdir $libDir
fi

name="EasyPurchase"

prj=$name".xcodeproj"
tag=$name

cnf='Debug'
build='build/'$cnf'-iphonesimulator/lib'$name'.a'

rm -rf build

libx64=$libDir'/iOSx64.a'
echo "build lib x64"
/usr/bin/xcodebuild \
-project $prj \
-target $tag -configuration $cnf \
-sdk $simulatorsdk build \
-arch 'x86_64' IPHONEOS_DEPLOYMENT_TARGET='7.0' \
OTHER_CFLAGS="-fembed-bitcode" \
ONLY_ACTIVE_ARCH=NO VALID_ARCHS="x86_64"

cp -rp $build $libx64


libx86=$libDir'/iOSx86.a'
echo "build lib x86"
/usr/bin/xcodebuild \
-project $prj \
-target $tag -configuration $cnf \
-sdk $simulatorsdk build \
-arch 'i386' IPHONEOS_DEPLOYMENT_TARGET='7.0' \
OTHER_CFLAGS="-fembed-bitcode" \
ONLY_ACTIVE_ARCH=NO VALID_ARCHS="i386"

cp -rp $build $libx86


cnf='Release'
build='build/'$cnf'-iphoneos/lib'$name'.a'

libarm64=$libDir'/iOSa64.a'
echo "build lib arm64"
/usr/bin/xcodebuild \
-project $prj \
-target $tag -configuration $cnf \
-sdk $iossdk build \
-arch 'arm64' IPHONEOS_DEPLOYMENT_TARGET='7.0' \
OTHER_CFLAGS="-fembed-bitcode" \
ONLY_ACTIVE_ARCH=NO VALID_ARCHS="arm64"

cp -rp $build $libarm64


libarmv7=$libDir'/iOSa7.a'
echo "build lib armv7"
/usr/bin/xcodebuild \
-project $prj \
-target $tag -configuration $cnf \
-sdk $iossdk build \
-arch 'armv7' IPHONEOS_DEPLOYMENT_TARGET='7.0' \
OTHER_CFLAGS="-fembed-bitcode" \
ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7"

cp -rp $build $libarmv7

echo 'lipo final lib'
lipo -create $libx64 $libx86 $libarm64 $libarmv7 -o "lib"$name".a"

rm -rf build
rm -rf $libDir
