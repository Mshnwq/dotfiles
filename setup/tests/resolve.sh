#!/usr/bin/env bash

REFERID="263d62f31cbb49e0868005059abcb0c9"
DOWNLOADSURL="https://www.blackmagicdesign.com/api/support/us/downloads.json"
SITEURL="https://www.blackmagicdesign.com/api/register/us/download"
PRODUCT="DaVinci Resolve"
VERSION="20.3.1"

USERAGENT="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.75 Safari/537.36"
REQJSON='{
  "firstname":"NixOS",
  "lastname":"Linux",
  "email":"someone@nixos.org",
  "phone":"+31 71 452 5670",
  "country":"nl",
  "street":"-",
  "state":"Province of Utrecht",
  "city":"Utrecht",
  "product":"'"$PRODUCT"'"
}'

DOWNLOADID=$(
  curl --silent --compressed "$DOWNLOADSURL" | jq --raw-output \
    '.downloads[] | .urls.Linux?[]? | select(.downloadTitle | test("^'"$PRODUCT $VERSION"'( Update)?$")) | .downloadId'
)
echo "downloadid is $DOWNLOADID"

RESOLVEURL=$(curl \
  --silent \
  --header 'Host: www.blackmagicdesign.com' \
  --header 'Accept: application/json, text/plain, */*' \
  --header 'Origin: https://www.blackmagicdesign.com' \
  --header "$USERAGENT" \
  --header 'Content-Type: application/json;charset=UTF-8' \
  --header "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
  --header 'Accept-Encoding: gzip, deflate, br' \
  --header 'Accept-Language: en-US,en;q=0.9' \
  --header 'Authority: www.blackmagicdesign.com' \
  --header 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
  --data-ascii "$REQJSON" \
  --compressed \
  "$SITEURL/$DOWNLOADID")
echo "resolveurl is $RESOLVEURL"

curl \
  --retry 3 --retry-delay 3 \
  --header "Upgrade-Insecure-Requests: 1" \
  --header "$USERAGENT" --header "Accept-Language: en-US,en;q=0.9" \
  --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
  --compressed "$RESOLVEURL" >"~/Downloads/DaVinci_Resolve_${VERSION}_Linux.run"

ujust install-resolve
