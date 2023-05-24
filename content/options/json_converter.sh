#!/usr/bin/env bash

cat "$1" | jq 'to_entries | .[] | {
label : .key,
type : .value.type,
description : .value.description,
example: .value.example | tojson,
default: .value.default | tojson,
defined: .value.declarations[0].path,
url: .value.declarations[0].url,
}' | jq -s
