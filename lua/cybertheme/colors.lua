local lush = require('lush')
local hsl = lush.hsl

local colors = {
  bg          = hsl("#010203"),
  blue        = hsl("#6495ED"), -- Cornflower
  yellow      = hsl("#FFFF66"), -- Laser Lemon
  yellow_soft = hsl("#FFCB37"),
  cyan        = hsl("#52FFF8"),
  red         = hsl("#F7635D"),
  green       = hsl("#3DD553"),
}

local spec = lush(function(injected_functions)
  local sym = injected_functions.sym
  return {
    Normal       { bg = colors.bg, fg = colors.yellow }, 
    
    CursorLine   { bg = colors.bg.li(5) }, 
    ColorColumn  { bg = colors.bg.li(3) },
    
    Comment      { fg = colors.blue.de(40).da(30), gui = "italic" }, 
    
    LineNr       { fg = colors.blue.da(50) },
    CursorLineNr { fg = colors.cyan, gui = "bold" },

    Pmenu        { bg = colors.bg.li(10), fg = colors.blue.li(20) },
    PmenuSel     { bg = colors.blue, fg = colors.bg, gui = "bold" },

    Keyword      { fg = colors.yellow_soft, gui = "bold" },
    Statement    { fg = colors.yellow_soft },
    Function     { fg = colors.cyan },
    String       { fg = colors.green },
    Number       { fg = colors.red.li(10) },
    Type         { fg = colors.blue.li(10) },
    Identifier   { fg = colors.yellow },
    
    Search       { bg = colors.red.da(20), fg = colors.yellow.li(20) },
    IncSearch    { bg = colors.yellow, fg = colors.bg },
    
    Visual       { bg = colors.blue.da(60) }, -- Subdued blue selection

    WinSeparator { fg = colors.blue.da(40) },
  }
end)

return spec

