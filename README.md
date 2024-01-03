> Old version of terranix.org. See [terranix/terranix.github.io](https://github.com/terranix/terranix.github.io) for current version.

[terranix.org](https://terranix.org) source code

```
task server  # start local server
task publish # publish code
```

## generate content/options/<module>/options.json

```shell
terranix-doc-json \
  --path /nix/store/yp1h149c9mbc4sp4c65iwwlh1rfcxh9x-terranix \
  --url https://github.com/terranix/terranix/tree/master/ \
  core-options.nix | jq '.' > core-options.json
```

`--path` is to shorten the url, just run without it, and you'll see.
