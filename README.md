# sf.nvim

**Minimal [SF CLI](https://github.com/salesforcecli/cli) tool wrapper for neovim.**

This plugin creates custom commands for making SF Apex development smoother in neovim.

### Commmands

-   SFRun -> Run the file at current buffer
-   SFDeploy -> Deploy the file open at current buffer to the default sf org
-   SFTest -> Run test file open at current buffer
-   SFDeployTest -> First deploy the file and then run tests
-   SFShow -> Show the SF split buffer
-   SFHide -> Hide the SF split buffer

### Installation

##### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "zahidkizmaz/sf.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  config = true,
  keys = {
    { "<leader>sfs", "<cmd>SFShow<cr>", desc = "Show sf.nvim split" },
    { "<leader>sfh", "<cmd>SFHide<cr>", desc = "Hide sf.nvim split" },
    { "<leader>sft", "<cmd>SFTest<cr>", desc = "Run test class in current buffer" },
    { "<leader>sfd", "<cmd>SFDeploy<cr>", desc = "Deploy current buffer to default sf org" },
    { "<leader>sfT", "<cmd>SFDeployTest<cr>", desc = "Deploy and run tests of the current buffer" },
  },
}
```

##### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
{
  "zahidkizmaz/sf.nvim",
  requires = { "MunifTanjim/nui.nvim" },
}
```

### Configurations

Default configuration for the split:

```lua
{
  relative = "editor",
  position = "right",
  size = "40%",
  enter = false,
  border = {
    text = {
      top = "sf.nvim",
      top_align = "center",
    },
    style = "rounded",
  },
}

```

This can be customised by passing a custom [configuration table](https://github.com/MunifTanjim/nui.nvim#split) such as:

```lua
require("sf").setup({
  split = {
    position = "left",
  }
})
```
