return {
  dir = vim.fn.stdpath("config") .. "/lua/cybertheme",
  lazy = false,
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd("colorscheme CyberTheme")
  end,
}
