# Contributing

These are guidelines for submitting a contribution.

## Submitting a PR

### Commits

PRs can be multiple commits, and should be if making large changes.

1. Commit title should begin with the section that was changed (along with subsection if necessary), e.g.: `Languages (nix): xxx`. The section titles are not all set in stone yet so just look at the recent commit history for some examples.
2. Commit description should be a high level overview of what changed and why.
3. In a multiple commit PR, use `fixes #xx`/`closes #xx` in on the specific commit that closes an issue.

### Documentation

All documentation is done with [asciidoc](https://asciidoc.org/). The following tasks should be done when submitting a PR.

1. Please document your updates in the latest release notes. Feel free to link to your github profile.
2. If adding a new module option, it should have a clear description of what they do. You can use `description = nvim.nmd.asciiDoc "text"` for descriptions that need extra formatting. And literal expressions can use `nvim.nmd.literalAsciiDoc`.

## Managing plugins

Updating or adding plugins should reference the [update tracking issue](https://github.com/jordanisaacs/neovim-flake/issues/33) in the commit message. This is so the issue can serve as a quick feed of plugin update history. Add `#33` to the commit.

All new vim plugins should be specified as inputs to the flake, please do not use nixpkgs. Keeping the plugins pinned lets us painlessly update nixpkgs.

## Style

Formatting is done with alejandra currently which will be automatically set up if you are using the devshell editor. Additionally, new options should use the `default` attribute in `mkOption` (not a `config.nix` which is being phased out because we now have auto-generated documentation). It should be ordered as follows.

```nix
mkOption {
    description = "";
    type = "";
    default = "";
}
```

# Flake Internals

TODO: document how the flake is structure, how to use the library, best practices, etc.
