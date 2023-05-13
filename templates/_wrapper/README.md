# templates/_wrapper

This directory contains wrapper flakes for the nixvim templates.
The purpose of the wrappers is to be able to run tests on templates deterministically on the branch or PR that is being worked on.
It does this by overwriting the url of nixvim and other dependencies to a path within this repo.

NOTE: It is important that we do not commit the `flake.lock` files here as that could cause problems with the check once any files are updated outside the wrapper. Also we cannot add `flake.lock` to `.gitignore` since nix will sometimes complain.
