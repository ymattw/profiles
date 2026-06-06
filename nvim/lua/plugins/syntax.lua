return {
  -- highlight keywords
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        TODO = { icon = "\u{f4a0}", color = "info" },
      },
      highlight = {
        pattern = [[.*<(KEYWORDS)>]],
        after = "",
      },
    },
  },
}
