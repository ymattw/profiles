local function toggle_status()
  local flags = {
    not vim.o.ignorecase and "\u{eab1}" or nil,
    vim.o.paste and "\u{f0ea}" or nil,
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
        { "filename" },
        { toggle_status, color = { fg = "#b58900" } },
      },
      lualine_x = { "encoding", "filetype" },
    },
  },
}
