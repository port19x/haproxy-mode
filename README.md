# HAProxy Mode

*Emacs major mode for editing HAProxy config files*

<!--
[![MELPA](https://melpa.org/packages/haproxy-mode-badge.svg)](https://melpa.org/#/haproxy-mode)
[![MELPA Stable](https://stable.melpa.org/packages/haproxy-mode-badge.svg)](https://stable.melpa.org/#/haproxy-mode)
-->

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
