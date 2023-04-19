<div align="center">

# asdf-kiota [![Build](https://github.com/andreaTP/asdf-kiota/actions/workflows/build.yml/badge.svg)](https://github.com/andreaTP/asdf-kiota/actions/workflows/build.yml) [![Lint](https://github.com/andreaTP/asdf-kiota/actions/workflows/lint.yml/badge.svg)](https://github.com/andreaTP/asdf-kiota/actions/workflows/lint.yml)


[kiota](https://aka.ms/kiota/docs) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add kiota
# or
asdf plugin add kiota https://github.com/andreaTP/asdf-kiota.git
```

kiota:

```shell
# Show all installable versions
asdf list-all kiota

# Install specific version
asdf install kiota latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kiota latest

# Now kiota commands are available
kiota --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/andreaTP/asdf-kiota/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Andrea Peruffo](https://github.com/andreaTP/)
