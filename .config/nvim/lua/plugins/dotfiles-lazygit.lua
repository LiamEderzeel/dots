local home = vim.env.HOME

-- Folders where <Leader>gg opens the bare dotfiles repo instead
local dots_dirs = {
  [home .. "/.config"] = true,
  [home .. "/.nixos"] = true,
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@param opts AstroCoreOpts
  opts = function(_, opts)
    opts.mappings.n["<Leader>gg"] = {
      function()
        local cmd = "lazygit"
        if dots_dirs[vim.fn.getcwd()] then
          cmd = ("lazygit --git-dir=%s/.dots --work-tree=%s"):format(home, home)
        end
        require("astrocore").toggle_term_cmd { cmd = cmd, direction = "float" }
      end,
      desc = "ToggleTerm lazygit (dotfiles-aware)",
    }
  end,
}
