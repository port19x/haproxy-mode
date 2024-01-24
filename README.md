# haproxy-mode.el --- major mode for editing haproxy config files

Copyright 2024 port19 <port19@port19.xyz>

* Author: port19 <port19@port19.xyz>
* Maintainer: port19 <port19@port19.xyz>
* Created: 24 Jan 2024
* Keywords: haproxy

available from https://github.com/port19x/haproxy-mode

[![MELPA](https://melpa.org/packages/haproxy-mode-badge.svg)](https://melpa.org/#/haproxy-mode)
[![MELPA Stable](https://stable.melpa.org/packages/haproxy-mode-badge.svg)](https://stable.melpa.org/#/haproxy-mode)

Licensed under the [GPL version 3](http://www.gnu.org/licenses/) or later.

# Commentary

This is a quick mode for editing HAProxy config files, as no appropiate mode existed before.

Many thanks to the author of `nginx-mode.el`, from where this is a direct fork.
Most of the code of this package is just adapted from nginx-mode.

# Usage

For the antique emacser, put this file into your `load-path` and the following into your `~/.emacs`:
```lisp
  (require 'haproxy-mode)
```

For the modern emacser, here is how that's done with `use-package`:
```
(use-package haproxy-mode)
```

The mode automatically activates for files called `haproxy.cfg`
