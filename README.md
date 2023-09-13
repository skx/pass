# Password Store Distribution

This repository contains a copy of the [password-store.sh](https://www.passwordstore.org/) application, along with bash completion, a couple of plugins and a simple wrapper.

This repository contains **zero** secrets, or passwords.



## Motivation

I want to use the same plugins on all systems, without the need to have a complicated setup.  So I created a simple wrapper-script [pass](pass) to load the `password-store.sh` script, configuring plugins appropriately.

This allows me to clone this repository, and have everything working with one operation.



## Plugins

The following plugins are included in the repository:


* [extensions/age.bash](extensions/age.bash)
  * Show the age of all password-store entries, by looking at the `git` log.
  * Written by [me](https://github.com/skx/), licensed under the terms of the GPL-3.
* [extensions/env.bash](extensions/env.bash)
  * Make passwords available as environmental variables, which is useful for scripting.
  * Written by [me](https://github.com/skx/), licensed under the terms of the GPL-3.
* [extensions/flat.bash](extensions/flat.bash)
  * Show the password-store entries, as a sorted flat list of files.
  * No "tree-like" display, and no colours.
  * Easy for grepping, and similar.
  * Written by [me](https://github.com/skx/), licensed under the terms of the GPL-3.
* [extensions/gen.bash](extensions/gen.bash)
  * Generate passwords via [sysbox](https://github.com/skx/sysbox).
  * Written by [me](https://github.com/skx/), licensed under the terms of the GPL-3.
* [extensions/otp.bash](extensions/otp.bash)
  * 2FA support, via `oauthtools`.
  * Written by [Tad Fisher](https://github.com/tadfisher/), licensed under the terms of the GPL-3.



## Installation

I clone the repository beneath `/opt/pass`, and then configure my shell to use it:

    if [ -d /opt/pass ]; then
        # Add to path.
        export PATH=/opt/pass:$PATH

        # source completion, bash-only.
        source /opt/pass/completion/pass.bash-completion
    fi

Once that has been done things work as you'd expect:

    pass [args]
