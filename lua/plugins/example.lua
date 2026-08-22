-- Reference only. Lazy.nvim does not load any specs below.
-- Copy a needed pattern to its own file under `lua/plugins/`.
-- stylua: ignore
if true then return {} end

-- lazy.nvim imports every Lua module under `lua/plugins/`.
-- A spec can add, change, or disable a plugin, set keymaps, configure an LSP,
-- install tools, or import a LazyVim extra.
return {
  -- Add a plugin.
  { "ellisonleao/gruvbox.nvim" },

  -- Change a LazyVim option.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "gruvbox" },
  },

  -- Merge options into an existing plugin spec.
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        layout_strategy = "horizontal",
      },
    },
  },

  -- Add a keymap to an existing plugin. This config uses Telescope.
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>sp",
        function()
          require("telescope.builtin").builtin()
        end,
        desc = "Telescope Builtins",
      },
    },
  },

  -- Disable a LazyVim plugin.
  { "folke/trouble.nvim", enabled = false },

  -- Configure an LSP server. mason-lspconfig installs enabled servers.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
      },
    },
  },

  -- Use LazyVim extras for language integration when they fit.
  -- The TypeScript extra uses vtsls by default and can use tsgo.
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },

  -- LazyVim appends this list to its default Treesitter parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "tsx", "typescript" },
    },
  },

  -- Change nested options when table merging is not enough.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "example"
        end,
      })
    end,
  },

  -- Install non-LSP command-line tools through Mason.
  -- LazyVim uses the mason-org repository, not williamboman/mason.nvim.
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "shellcheck", "shfmt" },
    },
  },
}
