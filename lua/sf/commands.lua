local M = {}

function M.run_file_command(file_path)
  return "sf run file --file " .. file_path
end

function M.deploy_file_command(file_path)
  return "sf project deploy start -d " .. file_path
end

function M.run_test_command(class_name, opts)
  local code_coverage = opts.code_coverage or true

  local cmd = "sf apex run test --result-format human --synchronous"
  if code_coverage then
    cmd = cmd .. " --code-coverage"
  end

  return cmd .. " --tests " .. class_name
end

return M
