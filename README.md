# HAProxy Mode

*Emacs major mode for editing HAProxy config files*

<!--
[![MELPA](https://melpa.org/packages/haproxy-mode-badge.svg)](https://melpa.org/#/haproxy-mode)
[![MELPA Stable](https://stable.melpa.org/packages/haproxy-mode-badge.svg)](https://stable.melpa.org/#/haproxy-mode)
-->

## Preview

![preview](https://github.com/port19x/haproxy-mode/assets/82055622/17b2bbad-dfdb-4c92-8e80-2f8186a0d5f9)

*ef-maris-dark theme*

## Usage

For the antique emacser, put this file into your `load-path` and the following into your `~/.emacs`:
```lisp
  (require 'haproxy-mode)
```

For the modern emacser, here is how that's done with `use-package`:
```
(use-package haproxy-mode)
```

The mode automatically activates for files called `haproxy.cfg`
