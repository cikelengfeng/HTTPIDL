if echo $1 | grep -q -E '^\d+\.\d+\.\d+$'
then
    echo unittest is running now
    if xcodebuild test -workspace HTTPIDLDemo/HTTPIDLDemo.xcworkspace -scheme HTTPIDLDemoTests -destination 'platform=iOS Simulator,name=ip6 8.1,OS=8.1' -destination 'platform=iOS Simulator,name=iPhone X,OS=12.1'
    then 
        echo target version is $1
        sed -i.bak "s/s\.version.*=.*/s.version      = \"$1\"/g" HTTPIDL.podspec
        sed -i.bak "s/pod-.*-blue\.svg/pod-$1-blue\.svg/g" README.md
        sed -i.bak "s/version='.*'/version='$1'/g" Sources/Compiler/HTTPIDL.py
        git commit -am '[MOD] version'
        git tag $1
        git push origin
        git push origin --tags
        pod trunk push
    else 
        echo unittest failed, go back and eat your shit
    fi
else
    echo argument invalid, version must match '^\d+\.\d+\.\d+$' "(e.g. 1.2.42)"
fi
