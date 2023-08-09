# sf.nvim

##### Minimal [SF CLI](https://github.com/salesforcecli/cli) tool wrapper for neovim.

This plugin creates custom commands for making SF Apex development smoother in neovim.

### Commmands

1. SFDeploy -> Deploy the file open at current buffer to the default sf org
1. SFTest -> Run test file open at current buffer
1. SFDeployTest -> First deploy the file and then run tests

### Installation

##### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "zahidkizmaz/sf.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = true,
  event = "VeryLazy",
}
```

##### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
{
  "zahidkizmaz/sf.nvim",
  requires = { "MunifTanjim/nui.nvim" },
}
```
