if echo $1 | grep -q -E '^\d+\.\d+\.\d+$'
then
    echo target version is $1
    sed -i.bak "s/s\.version.*=.*/s.version      = \"$1\"/g" HTTPIDL.podspec
    sed -i.bak "s/pod-.*-blue\.svg/pod-$1-blue\.svg/g" README.md
    git commit -am '[MOD] version'
    git tag $1
    git push origin --tags
    pod trunk push
else
    echo argument invalid, version must match '^\d+\.\d+\.\d+$' "(e.g. 1.2.42)"
fi
