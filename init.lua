if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.swapfile = false

local function setup_nvim()
  print("Welcome!")
  vim.cmd("enew")
  vim.cmd("Neotree<cr>")
  vim.cmd("ToggleTerm size=10 direction=horizontal")
end

vim.api.nvim_create_user_command("Setup", setup_nvim, {
  nargs = 0,
  bang = false,
  register = false,
})

for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
      vim.log.levels.ERROR
    )
  end
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
