local M = {}

local Split = require("nui.split")
local commands = require("sf.commands")

function M.setup(config)
  config = config or {}
  local opts = { noremap = true, silent = true }
  vim.api.nvim_create_user_command("SFDeploy", function()
    M.deploy_file()
  end, {})
  vim.keymap.set("n", "<leader>sfd", function()
    vim.cmd("SFDeploy")
  end, opts)

  vim.api.nvim_create_user_command("SFTest", function()
    M.run_test()
  end, {})
  vim.keymap.set("n", "<leader>sft", function()
    vim.cmd("SFTest")
  end, opts)

  vim.api.nvim_create_user_command("SFDeployTest", function()
    M.deploy_and_test()
  end, {})
  vim.keymap.set("n", "<leader>sfT", function()
    vim.cmd("SFDeployTest")
  end, opts)
end

function M.run_file()
  local file_path = vim.fn.expand("%")
  local cmd = commands.run_file_command(file_path)
  M.create_terminal(cmd)
end

function M.deploy_file()
  local file_path = vim.fn.expand("%")
  local cmd = commands.deploy_file_command(file_path)
  M.create_terminal(cmd)
end

function M.run_test()
  local file_path = vim.fn.expand("%:t")
  local class_name = file_path:gsub("%.cls", "")
  local cmd = commands.run_test_command(class_name, {})
  M.create_terminal(cmd)
end

function M.deploy_and_test()
  local deploy_file_path = vim.fn.expand("%")
  local deploy_cmd = commands.deploy_file_command(deploy_file_path)

  local file_path = vim.fn.expand("%:t")
  local class_name = file_path:gsub("%.cls", "")
  local test_cmd = commands.run_test_command(class_name, {})
  M.create_terminal(deploy_cmd .. " && " .. test_cmd)
end

function M.create_terminal(cmd)
  if not M.split then
    M.split = Split(M.default_split_config)
    M.split:mount()
  end

  local same_tab = false
  for _, v in ipairs(vim.fn.tabpagebuflist()) do
    if v == M.split.bufnr then
      same_tab = true
    end
  end
  if not same_tab then
    M.split:unmount()
    M.split = Split(M.default_split_config)
    M.split:mount()
  end

  local echo_and_run_cmd = "echo '" .. cmd .. "'" .. "&&" .. cmd
  local channel_id = vim.api.nvim_open_term(M.split.bufnr, {})
  vim.fn.jobstart(echo_and_run_cmd, {
    on_stdout = function(_, stdout)
      for _, v in ipairs(stdout) do
        vim.api.nvim_chan_send(channel_id, v)
      end
    end,
    on_stderr = function(_, stderr)
      for _, v in ipairs(stderr) do
        vim.api.nvim_chan_send(channel_id, v)
      end
    end,
  })
end

M.split = nil
M.default_split_config = {
  relative = "editor",
  position = "right",
  size = "40%",
  enter = false,
}

return M
