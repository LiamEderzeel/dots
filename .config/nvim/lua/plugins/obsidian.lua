local vaults = vim.env.HOME .. "/Documents/obsidian"

---@type LazySpec
return {
  "obsidian-nvim/obsidian.nvim",
  cmd = "Obsidian",
  event = { "BufReadPre " .. vaults .. "/**.md", "BufNewFile " .. vaults .. "/**.md" },
  opts = {
    workspaces = {
      { name = "personal", path = vaults .. "/personal" },
      { name = "work", path = vaults .. "/work" },
      { name = "rogue-trader", path = vaults .. "/rogue-trader" },
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n["<Leader>O"] = { desc = "Obsidian" }
        local keys = {
          w = { "workspace", "Switch vault" },
          t = { "tags", "Find tags" },
          f = { "quick_switch", "Find note" },
          s = { "search", "Search notes" },
          n = { "new", "New note" },
          d = { "today", "Daily note" },
          b = { "backlinks", "Backlinks" },
          l = { "links", "Links in note" },
          o = { "open", "Open in Obsidian" },
        }
        for key, v in pairs(keys) do
          maps.n["<Leader>O" .. key] = { "<Cmd>Obsidian " .. v[1] .. "<CR>", desc = v[2] }
        end
      end,
    },
  },
}
