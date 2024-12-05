local function flags_status()
  local flags = {
    -- See conform.lua for how vim.b.format_on_save is defined
    vim.b.format_on_save and "\u{f18f2}" or nil,
    not vim.o.ignorecase and "\u{eab1}" or nil,
    vim.o.paste and "\u{f0192}" or nil,
    vim.bo.fileformat == "dos" and "\u{f05b3}" or nil,
  }
  return table.concat(
    vim.tbl_filter(function(flag)
      return flag
    end, flags),
    " "
  )
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      component_separators = { left = nil, right = nil },
    },
    sections = {
      lualine_c = {
        { "filename", path = 1 },
        { flags_status, color = { fg = "#cb4b16" } }, -- solarized orange
      },
      lualine_x = { "encoding", "filetype" },
    },
  },
}
