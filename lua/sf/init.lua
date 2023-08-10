local M = {}

local Split = require("nui.split")
local commands = require("sf.commands")

function M.setup(config)
  config = config or {}
  local user_cmd = vim.api.nvim_create_user_command

  -- SF CLI commands
  user_cmd("SFRun", M.run_file, {})
  user_cmd("SFTest", M.run_test, {})
  user_cmd("SFDeploy", M.deploy_file, {})
  user_cmd("SFDeployTest", M.deploy_and_test, {})

  -- Split buffer commands
  user_cmd("SFShow", M.show_split, {})
  user_cmd("SFHide", M.hide_split, {})
end

function M.run_file()
  local file_path = vim.fn.expand("%")
  local cmd = commands.run_file_command(file_path)
  M.run_cmd_in_split(cmd)
end

function M.deploy_file()
  local file_path = vim.fn.expand("%")
  local cmd = commands.deploy_file_command(file_path)
  M.run_cmd_in_split(cmd)
end

function M.run_test()
  local file_path = vim.fn.expand("%:t")
  local class_name = file_path:gsub("%.cls", "")
  local cmd = commands.run_test_command(class_name, {})
  M.run_cmd_in_split(cmd)
end

function M.deploy_and_test()
  local deploy_file_path = vim.fn.expand("%")
  local deploy_cmd = commands.deploy_file_command(deploy_file_path)

  local file_path = vim.fn.expand("%:t")
  local class_name = file_path:gsub("%.cls", "")
  local test_cmd = commands.run_test_command(class_name, {})
  M.run_cmd_in_split(deploy_cmd .. " && " .. test_cmd)
end

M.hide_split = function()
  if not M.split then
    vim.api.nvim_err_writeln("sf.nvim: No split found")
    return
  end
  M.split:hide()
end

M.show_split = function()
  if not M.split then
    vim.api.nvim_err_writeln("sf.nvim: No split found")
    return
  end
  M.split:show()
end

function M.run_cmd_in_split(cmd)
  -- Setup split buffer
  M._mount_split()
  M._clean_buffer_lines()
  M._append_cmd_to_buffer(cmd)

  -- Run command
  vim.fn.jobstart(cmd, {
    on_stdout = function(_, stdout)
      M._append_lines_to_buffer(stdout)
    end,
    on_stderr = function(_, stderr)
      M._append_lines_to_buffer(stderr)
    end,
  })
end

M._mount_split = function()
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
end

M._clean_buffer_lines = function()
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(M.split.bufnr, 0, -1, false, {})
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", false)
end

M._append_cmd_to_buffer = function(cmd)
  local start_line = vim.api.nvim_buf_line_count(M.split.bufnr) - 1
  local end_line = start_line + 1
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(M.split.bufnr, start_line, end_line, false, { "$ " .. cmd })
  vim.api.nvim_buf_add_highlight(M.split.bufnr, -1, "Visual", start_line, 2, -1)
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", false)
end

M._append_lines_to_buffer = function(lines)
  local start_line = vim.api.nvim_buf_line_count(M.split.bufnr)
  local end_line = start_line + vim.fn.len(lines)
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", true)
  vim.api.nvim_buf_set_lines(M.split.bufnr, start_line, end_line, false, lines)
  vim.api.nvim_buf_set_option(M.split.bufnr, "modifiable", false)
end

M.split = nil
M.default_split_config = {
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

return M
