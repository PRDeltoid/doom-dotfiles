# Doom Dotfiles

Domain-specific configuration should be in a child folder with the domain's
name. Use git submodules to separate config version control. Submodules can be private.

To make git automatically pull submodules recursively, use:
`git config --global submodule.recurse true`
