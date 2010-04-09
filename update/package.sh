#!/bin/sh

#########clear the current files#########
rm -Rf MPlayerX.app
rm -Rf MPlayerX.zip
rm -Rf ../../releases/MPlayerX.zip

#########copy the newly release app#########
cp -R ../MPlayerX/build/Release/MPlayerX.app ./MPlayerX.app

##########zip it#########
zip -ry MPlayerX.zip MPlayerX.app > /dev/null

##########get the create time#########
ruby GetTime.rb "./MPlayerX.zip"
echo

##########get the version#########
ruby GetBundleVersion.rb "./MPlayerX.app"
echo

##########get the size#########
ruby GetFileSize.rb "./MPlayerX.zip"
echo

##########get the signature#########
echo "Sign:"
security find-generic-password -g -s "MPlayerX Private Key" 1>/dev/null | ruby parsePriKey.rb | sed 's/\\012/\n/g' > key.txt
openssl dgst -sha1 -binary "./MPlayerX.zip" | openssl dgst -dss1 -sign key.txt | openssl enc -base64
#cat ../../../a.txt | ruby parsePriKey.rb | sed 's/\\012/\n/g' > key.txt
#openssl dgst -sha1 -binary "./MPlayerX.zip" | openssl dgst -dss1 -sign key.txt | openssl enc -base64

echo "diff:"
diff key.txt "../Sparkle.framework/Extras/Signing Tools/dsa_priv.pem"
rm -Rf key.txt

######### ruby "../Sparkle.framework/Extras/Signing Tools/sign_update.rb" "./MPlayerX.zip" "../Sparkle.framework/Extras/Signing Tools/dsa_priv.pem"

mv MPlayerX.zip ../../releases/

rm -Rf MPlayerX.app
rm -Rf ../MPlayerX/build/Release/MPlayerX.app