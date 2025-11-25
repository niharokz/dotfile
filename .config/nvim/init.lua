-----------------------------------------------------------
-- Catppuccin Mocha -> Terminal-matching dark-teal AMOLED
-- Paste over ~/.config/nvim/init.lua and run :Lazy sync
-----------------------------------------------------------

-- Basics
vim.g.mapleader = " "
vim.opt.syntax = "on"
vim.opt.encoding = "UTF-8"
vim.opt.title = true

-- Indentation
vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

-- Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- UI
vim.opt.laststatus = 3
vim.opt.scrolloff = 5
vim.opt.wildmenu = true
vim.opt.wrap = false
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.o.background = "dark"

-- Clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamed,unnamedplus"
end

-- Small UI tweaks
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.pumblend = 10
vim.opt.winblend = 10
vim.opt.fillchars = "eob: "

-- PATH
vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH

-----------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Palette taken from your kitty / alacritty configs
-- (cursor: #00cccc, selection: #00aaaa, fg: #dcdccc, teal/green: #339999)
-----------------------------------------------------------
local palette = {
  bg        = "#000000",  -- true black
  fg        = "#dcdccc",  -- foreground
  cursor    = "#00cccc",
  selection = "#00aaaa",
  teal      = "#339999",
  teal_bright = "#00ffff",
  accent    = "#0db5a7",  -- optional strong teal
  dim_teal  = "#0a8f85",
  comment   = "#2a5a54",
}

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require("lazy").setup({
  { "nvim-tree/nvim-web-devicons" },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,
        integrations = {
          lualine = true,
          telescope = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
        },
        highlight_overrides = {
          mocha = function(cp)
            -- Use your palette to override the default catppuccin values
            return {
              Normal = { bg = palette.bg, fg = palette.fg },
              NormalFloat = { bg = palette.bg },
              CursorLine = { bg = "#050505" },
              ColorColumn = { bg = "#070707" },
              Visual = { bg = "#0f2322" },

              -- syntax accents
              Keyword = { fg = palette.teal, italic = true },
              Function = { fg = palette.teal_bright, bold = true },
              Identifier = { fg = palette.fg },
              String = { fg = "#7fd6c7" },
              Number = { fg = "#7bd1c1" },
              Type = { fg = palette.dim_teal },

              Comment = { fg = palette.comment, italic = true },

              -- UI pieces
              LineNr = { fg = "#08383a", bg = palette.bg },
              CursorLineNr = { fg = palette.cursor, bg = palette.bg, bold = true },

              Pmenu = { bg = "#070707", fg = palette.fg },
              PmenuSel = { bg = "#0a0a0a", fg = palette.fg },

              TelescopePromptNormal = { bg = palette.bg },
              TelescopeResultsNormal = { bg = palette.bg },
              TelescopePreviewNormal = { bg = palette.bg },

              -- tree & bufferline
              NvimTreeNormal = { bg = palette.bg },
              NvimTreeEndOfBuffer = { bg = palette.bg },

              BufferLineBufferSelected = { fg = palette.fg, bg = "#050505", bold = true },
              BufferLineBuffer = { fg = "#6b7a78", bg = palette.bg },
            }
          end,
        },
      })
      vim.cmd("colorscheme catppuccin")
      -- enforce true black background (in case terminal/compositor forces gray)
      vim.api.nvim_set_hl(0, "Normal", { bg = palette.bg })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.bg })
    end
  },

  -- nvim-tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { icons = { show = { git = false } } },
        filters = { dotfiles = false },
        respect_buf_cwd = true,
        update_focused_file = { enable = true, update_cwd = false },
        sync_root_with_cwd = true,
      })
      vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = palette.bg })
      vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = palette.bg })
    end,
  },

  -- true-zen
  {
    "pocco81/true-zen.nvim",
    config = function()
      require("true-zen").setup({
        modes = { ataraxis = { margin = 1 } },
        integrations = { lualine = true, tmux = true },
      })
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "css", "html", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- css color previews (keeps your plugin)
  { "ap/vim-css-color" },

  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin" },
    config = function()
      local theme = require("lualine.themes.catppuccin") or {}
      theme.normal = theme.normal or {}
      theme.normal.c = theme.normal.c or {}
      theme.normal.c.bg = "#050505"
      theme.insert = theme.insert or {}
      theme.insert.c = theme.insert.c or {}
      theme.insert.c.bg = "#003b37"
      theme.visual = theme.visual or {}
      theme.visual.c = theme.visual.c or {}
      theme.visual.c.bg = "#064b45"
      require("lualine").setup({
        options = {
          theme = theme,
          section_separators = "", component_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { { "mode", padding = { left = 1, right = 1 } } },
          lualine_b = { "branch" },
          lualine_c = { { "filename", file_status = true, path = 1 } },
          lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          separator_style = "thin",
        },
        highlights = {
          background = { guibg = palette.bg },
        }
      })
    end,
  },

  -- telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          prompt_prefix = "❯ ",
          selection_caret = "➡ ",
          sorting_strategy = "ascending",
          layout_config = { width = 0.8, height = 0.6 },
          mappings = { i = { ["<esc>"] = actions.close } },
          winblend = 10,
        }
      })
      vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Buffers" })
    end,
  },

  -- indent-blankline v3 (ibl)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
        exclude = {
          filetypes = { "help", "terminal", "alpha" },
          buftypes = { "terminal", "nofile" },
        },
      })
    end,
  },

  -- gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        current_line_blame = false,
        numhl = false,
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          -- optionally tune highlight groups to teal
          vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = palette.teal })
          vim.api.nvim_set_hl(0, "GitSignsChange", { fg = palette.selection })
          vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#704040" })
        end,
      })
    end
  },
})

-----------------------------------------------------------
-- Keymaps (existing ones preserved)
-----------------------------------------------------------
-- NvimTree Toggle
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

-- TrueZen
vim.keymap.set("n", "<leader>g", ":TZMinimalist<CR>")

-- Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

-- General
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", "<leader>w", ":w!<CR>")
vim.keymap.set("n", "<leader>l", ":bn!<CR>")
vim.keymap.set("n", "<leader>o", ":tabnew<CR>")
vim.keymap.set("n", "<leader>y", "ggVG\"+y")
vim.keymap.set("n", "<leader>r", "ggVGd\"+P")
vim.keymap.set("n", "<leader>sh", ":terminal<CR>")

-- Splits and navigation
vim.keymap.set("n", "<leader>h", ":split<CR>")
vim.keymap.set("n", "<leader>v", ":vsplit<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize
vim.keymap.set("n", "<C-Left>",  ":vertical resize +3<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>")
vim.keymap.set("n", "<C-Up>",    ":resize +3<CR>")
vim.keymap.set("n", "<C-Down>",  ":resize -3<CR>")

-----------------------------------------------------------
-- Cache / swap / undo dirs
-----------------------------------------------------------
local cache = vim.fn.stdpath("cache")
vim.opt.directory = cache .. "/swap//"
vim.opt.backupdir = cache .. "/backup//"
vim.opt.undodir = cache .. "/undo//"
vim.opt.undofile = true

-----------------------------------------------------------
-- Headerize Command (unchanged)
-----------------------------------------------------------
vim.api.nvim_create_user_command("Headerize", function()
  local file = vim.fn.expand("%:p")
  os.execute("python3 ~/data/workspace/narch/headerize.py " .. file)
  vim.cmd("edit!")
end, {})

-- final tweaks: force teal-ish cursorline/visual and cursorline number
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#050505" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#0f2322" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.cursor, bold = true })

