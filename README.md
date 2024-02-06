# PhD doc/presentation template


## How to install

The template needs to be installed in a special directory, as described [in the
docs](https://github.com/typst/packages?tab=readme-ov-file#local-packages).

Here's a one-liner for a Linux installation (assuming you have `TYPST_LOCAL_PACKAGES` defined,
which should be set to something like `$HOME/.local/share/typst/packages/local`):
```console
$ bash <(curl -s https://raw.githubusercontent.com/kokkonisd/typst-phd-template/main/install.sh)
```

And then import it using the version in [VERSION]("VERSION"):
```typst
#import "@local/phd-template:0.1.0" as template
```


## How to use
TODO
