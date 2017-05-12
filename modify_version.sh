echo target version is $1
sed -i.bak "s/s\.version.*=.*/s.version      = \"$1\"/g" HTTPIDL.podspec
sed -i.bak "s/pod-.*-blue\.svg/pod-$1-blue\.svg/g" README.md
git commit -am '[MOD] version'