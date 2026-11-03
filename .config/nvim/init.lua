-----------------------------------------------------------------------
--  naos · nvim/init.lua · nss theme
--  Plugins via lazy.nvim. After replacing this file run :Lazy sync
-----------------------------------------------------------------------

-- nss palette (same values as nih.ar, the boot screens, kitty and xmobar)
local nss = {
  bg       = "#070B0F", -- background
  surface  = "#0F161B", -- floats, menus
  surface2 = "#152027", -- raised / selected
  line     = "#1F2C33", -- borders, separators
  fg       = "#E6ECEC", -- text
  muted    = "#8B979A", -- secondary text
  faint    = "#5C6B6A", -- comments, hints
  teal     = "#3A807A", -- accent fill
  ink      = "#66BDB3", -- readable accent (keywords)
  peri     = "#A9B8FF", -- second accent (functions)
  amber    = "#E0A63A", -- numbers, constants, warnings
  green    = "#3FB27F", -- ok / added
  red      = "#FF6B6B", -- errors / removed
  mint     = "#7FD6C7", -- strings (kept from the old teal scheme)
}

-----------------------------------------------------------------------
-- Options
-----------------------------------------------------------------------
vim.g.mapleader = " "                      -- <leader> = space
vim.g.loaded_netrw = 1                     -- nvim-tree replaces netrw
vim.g.loaded_netrwPlugin = 1

local o = vim.opt
o.title = true                             -- window title = file name

o.tabstop = 8                              -- indentation: 4 spaces, real tabs shown as 8
o.softtabstop = 0
o.expandtab = true
o.shiftwidth = 4
o.smarttab = true

o.number = true                            -- line numbers, relative to the cursor
o.relativenumber = true

o.incsearch = true                         -- search: live, highlighted, case-smart
o.hlsearch = true
o.ignorecase = true
o.smartcase = true

o.swapfile = false                         -- no swap/backup files; persistent undo instead
o.backup = false
o.writebackup = false
o.undofile = true

o.laststatus = 3                           -- one statusline for all windows
o.scrolloff = 5
o.wrap = false
o.hidden = true
o.termguicolors = true
o.background = "dark"
o.cursorline = true
o.signcolumn = "yes"                       -- keep the gutter steady for git signs
o.showmode = false                         -- lualine already shows the mode
o.pumblend = 10
o.winblend = 10
o.fillchars = { eob = " " }                -- no ~ after the end of the buffer

if vim.fn.has("clipboard") == 1 then
  o.clipboard = "unnamedplus"              -- yank/paste use the system clipboard
end

vim.env.PATH = vim.env.HOME .. "/.local/bin:" .. vim.env.PATH  -- personal scripts available to :! and plugins

-- swap/backup/undo live under ~/.cache/nvim (created if missing)
local cache = vim.fn.stdpath("cache")
for _, dir in ipairs({ "swap", "backup", "undo" }) do
  vim.fn.mkdir(cache .. "/" .. dir, "p")
end
o.directory = cache .. "/swap//"
o.backupdir = cache .. "/backup//"
o.undodir = cache .. "/undo//"

-----------------------------------------------------------------------
-- lazy.nvim bootstrap
-----------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "lazy.nvim clone failed:\n" .. out, "ErrorMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------------------
-- Plugins
-----------------------------------------------------------------------
-- Debian 13 ships nvim 0.10; newer releases of some plugins need 0.11+, so pin those on older nvim
local old_nvim = vim.fn.has("nvim-0.11") == 0
local pin = function(tag) return old_nvim and tag or nil end

require("lazy").setup({
  { "nvim-tree/nvim-web-devicons", lazy = true },   -- file icons (needs a Nerd Font in kitty)

  -- colours: catppuccin engine, nss palette
  {
    "catppuccin/nvim",
    name = "catppuccin",
    tag = pin("v1.11.0"),
    priority = 1000,                                -- load before everything else
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        color_overrides = {
          mocha = {                                 -- catppuccin roles mapped onto nss
            base = nss.bg, mantle = "#05080B", crust = "#030507",
            surface0 = nss.surface, surface1 = nss.surface2, surface2 = nss.line,
            overlay0 = "#3A4A50", overlay1 = nss.faint, overlay2 = nss.muted,
            subtext0 = nss.muted, subtext1 = "#B5C0C1", text = nss.fg,
            mauve = nss.ink,                        -- keywords
            blue = nss.peri, lavender = nss.peri,   -- functions
            green = nss.mint,                       -- strings
            peach = nss.amber,                      -- numbers, constants
            yellow = "#F2C46B",                     -- types
            teal = nss.ink, sky = "#7FD6E0", sapphire = "#7FB3F0",
            red = nss.red, maroon = "#E58A8A", pink = "#C9B8FF",
            flamingo = "#E6C9C9", rosewater = nss.fg,
          },
        },
        custom_highlights = function()
          return {
            Comment = { fg = nss.faint, italic = true },
            Keyword = { fg = nss.ink, italic = true },
            CursorLine = { bg = "#0C1317" },
            Visual = { bg = "#16302E" },
            LineNr = { fg = "#2A3A3F" },
            CursorLineNr = { fg = nss.ink, bold = true },
            WinSeparator = { fg = nss.line },
            FloatBorder = { fg = nss.line, bg = nss.surface },
            NormalFloat = { bg = nss.surface },
            Pmenu = { bg = nss.surface, fg = nss.fg },
            PmenuSel = { bg = nss.surface2, fg = nss.ink, bold = true },
            NvimTreeNormal = { bg = nss.bg },
            NvimTreeEndOfBuffer = { bg = nss.bg },
            NvimTreeWinSeparator = { fg = nss.line, bg = nss.bg },
            GitSignsAdd = { fg = nss.green },
            GitSignsChange = { fg = nss.ink },
            GitSignsDelete = { fg = nss.red },
            IblIndent = { fg = "#141D22" },
          }
        end,
        integrations = {
          gitsigns = true,
          nvimtree = true,
          telescope = { enabled = true },
          treesitter = true,
          indent_blankline = { enabled = true },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- file tree
  {
    "nvim-tree/nvim-tree.lua",
    tag = pin("v1.18.0"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = { width = 30 },
      renderer = { icons = { show = { git = false } } },
      filters = { dotfiles = false },
      respect_buf_cwd = true,
      sync_root_with_cwd = true,
      update_focused_file = { enable = true, update_root = false },
    },
  },

  -- distraction-free mode
  {
    "pocco81/true-zen.nvim",
    opts = {
      modes = { ataraxis = { margin = 1 } },     -- unchanged from your config
      integrations = { lualine = true, tmux = true },
    },
  },

  -- syntax via tree-sitter (pinned to master: the new main branch has a different API)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "css", "html", "javascript",
        "python", "go", "yaml", "markdown", "markdown_inline", "haskell", "sql" },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  { "ap/vim-css-color" },                             -- colour previews for #hex values

  -- statusline in nss colours
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local mode = function(col) return { a = { fg = nss.bg, bg = col, gui = "bold" } } end
      local theme = {
        normal = {
          a = { fg = nss.bg, bg = nss.ink, gui = "bold" },
          b = { fg = nss.fg, bg = nss.surface2 },
          c = { fg = nss.muted, bg = nss.surface },
        },
        insert = mode(nss.peri),
        visual = mode(nss.amber),
        replace = mode(nss.red),
        command = mode(nss.mint),
        inactive = { c = { fg = nss.faint, bg = nss.bg } },
      }
      return {
        options = { theme = theme, section_separators = "", component_separators = "", globalstatus = true },
        sections = {
          lualine_a = { { "mode", padding = { left = 1, right = 1 } } },
          lualine_b = { "branch" },
          lualine_c = { { "filename", file_status = true, path = 1 } },
          lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },

  -- buffer tabs
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        separator_style = "thin",
      },
      highlights = {
        fill = { bg = nss.bg },
        background = { fg = nss.faint, bg = nss.bg },
        buffer_visible = { fg = nss.muted, bg = nss.bg },
        buffer_selected = { fg = nss.fg, bg = nss.surface, bold = true, italic = false },
        separator = { fg = nss.line, bg = nss.bg },
        separator_selected = { fg = nss.line, bg = nss.surface },
        indicator_selected = { fg = nss.teal, bg = nss.surface },
      },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = pin("0.1.8"),
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "❯ ",
          selection_caret = "➡ ",
          sorting_strategy = "ascending",
          layout_config = { width = 0.8, height = 0.6, prompt_position = "top" },
          mappings = { i = { ["<esc>"] = actions.close } },  -- one Esc closes
          winblend = 10,
        },
      }
    end,
  },

  -- indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    tag = pin("v3.9.0"),
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
      exclude = { filetypes = { "help", "terminal", "alpha" }, buftypes = { "terminal", "nofile" } },
    },
  },

  -- git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    tag = pin("v1.0.2"),
    opts = {
      current_line_blame = false,
      numhl = false,
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}, {
  install = { colorscheme = { "catppuccin" } },     -- theme used while plugins install on first run
  change_detection = { notify = false },            -- reload silently when this file changes
})

-----------------------------------------------------------------------
-- Keymaps
-----------------------------------------------------------------------
local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc }) end

map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", "File tree")
map("n", "<leader>g", "<cmd>TZMinimalist<cr>", "Zen mode")

map("i", "jk", "<Esc>", "Leave insert mode")
map("n", "<leader>w", "<cmd>w!<cr>", "Save")
map("n", "<leader>l", "<cmd>bn!<cr>", "Next buffer")
map("n", "<leader>o", "<cmd>tabnew<cr>", "New tab")
map("n", "<leader>y", 'ggVG"+y', "Copy whole file")
map("n", "<leader>r", 'ggVGd"+P', "Replace file with clipboard")
map("n", "<leader>sh", "<cmd>terminal<cr>", "Terminal")
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

map("n", "<leader>h", "<cmd>split<cr>", "Split below")
map("n", "<leader>v", "<cmd>vsplit<cr>", "Split right")
map("n", "<C-h>", "<C-w>h", "Window left")
map("n", "<C-j>", "<C-w>j", "Window down")
map("n", "<C-k>", "<C-w>k", "Window up")
map("n", "<C-l>", "<C-w>l", "Window right")

map("n", "<C-Left>", "<cmd>vertical resize +3<cr>", "Wider")
map("n", "<C-Right>", "<cmd>vertical resize -3<cr>", "Narrower")
map("n", "<C-Up>", "<cmd>resize +3<cr>", "Taller")
map("n", "<C-Down>", "<cmd>resize -3<cr>", "Shorter")

-----------------------------------------------------------------------
-- Autocommands
-----------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {      -- flash the yanked text
  group = vim.api.nvim_create_augroup("naos_yank", { clear = true }),
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-----------------------------------------------------------------------
-- :Headerize — adds the narch header to the current file
-----------------------------------------------------------------------
vim.api.nvim_create_user_command("Headerize", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("Headerize: this buffer has no file", vim.log.levels.WARN)
    return
  end
  vim.cmd("write")                                 -- save first so unsaved edits aren't lost on reload
  local out = vim.fn.system({ "python3", vim.fn.expand("~/data/workspace/narch/headerize.py"), file })
  if vim.v.shell_error ~= 0 then
    vim.notify("Headerize failed:\n" .. out, vim.log.levels.ERROR)
    return
  end
  vim.cmd("edit!")                                 -- reload with the new header
end, { desc = "Add the narch header to this file" })
