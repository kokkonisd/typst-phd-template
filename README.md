# PhD doc/presentation template


## How to install

The template needs to be installed in a special directory, as described [in the
docs](https://github.com/typst/packages?tab=readme-ov-file#local-packages).

The installer in this repo assumes you have `TYPST_LOCAL_PACKAGES` defined to the correct path,
which should be something like `$HOME/.local/share/typst/packages/local` on Linux.


### Stable version

You need to clone this repo, checkout a specific version (tag), and run the install script:
```console
$ git clone git@github.com:kokkonisd/typst-phd-template.git
$ git checkout 0.1.0  # `git tag` lists the available tags
$ ./install.sh --offline
```


### Latest (non-stable) version

Here's a one-liner for a Linux installation.
```console
$ bash <(curl -s https://raw.githubusercontent.com/kokkonisd/typst-phd-template/main/install.sh)
```


## How to use

In the [examples](examples) directory, see  [report.typ](examples/report.typ) for the report
template and [presentation.typ](examples/presentation.typ) for the presentation template.
