#!/usr/bin/env bash

jq 'to_entries | .[] | {
label : .key,
type : .value.type,
description : .value.description,
example: .value.example | tojson,
default: .value.default | tojson,
defined: .value.declarations[0].path,
url: .value.declarations[0].url,
}' "$1" | jq -s
