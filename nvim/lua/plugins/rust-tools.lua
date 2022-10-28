local is_rt_ok, rt = pcall(require, 'rust-tools')
if not is_rt_ok then
  return
end
