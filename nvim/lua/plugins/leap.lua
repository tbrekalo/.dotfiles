local is_leap_ok, leap = pcall(require, 'leap')
if not is_leap_ok then
  return
end

-- leap.add_default_mappings()
