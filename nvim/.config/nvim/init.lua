vim.loader.enable(true)

vim.g.mapleader = " "

-- Disable the default file explorer (netrw) because other file explorer plugins will be used in its place
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Track codecompanion state
vim.g.codecompanion_thinking = false

vim.t.is_fullscreen = false

-- Quick way to enter Normal mode without having to reach for <ESC>
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit Insert Mode" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert Mode" })
vim.keymap.set("i", "kj", "<Esc>", { desc = "Exit Insert Mode" })

-- Do the same for select mode (inside snippets)
vim.keymap.set("s", "jk", "<Esc>", { desc = "Exit Select Mode" })
vim.keymap.set("s", "jj", "<Esc>", { desc = "Exit Select Mode" })
vim.keymap.set("s", "kj", "<Esc>", { desc = "Exit Select Mode" })

-- Quick way to move around in insert mode without having to leave the hjkl home row
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move right in insert mode" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move left in insert mode" })

vim.keymap.set("n", "<C-a>", "gg0VG$", { desc = "Select All" })

vim.keymap.set("n", "<C-t>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<C-x>", "<cmd>tabclose<cr>", { desc = "Close current tab" })

-- Quick way to navigate a qflist
vim.keymap.set("n", "<M-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<cr>")

-- The highlights after searching stay on which can be annoying. Pressing escape will clear it now, like most other editors
-- Also exit snippet mode and clear those highlights, if active
vim.keymap.set("n", "<ESC>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
        return
    end
    return "<ESC>"
end, { expr = true })

vim.keymap.set("n", "<C-w>f", function()
    local is_fullscreen = vim.t and vim.t.is_fullscreen
    if not is_fullscreen then
        local keys = vim.api.nvim_replace_termcodes("<C-w>|<C-w>_", true, true, true)
        vim.api.nvim_feedkeys(keys, "n", false)
        vim.t.is_fullscreen = true
    else
        local keys = vim.api.nvim_replace_termcodes("<C-w>=", true, true, true)
        vim.api.nvim_feedkeys(keys, "n", false)
        vim.t.is_fullscreen = false
    end
end, { silent = true, desc = "Toggle Fullscreen" })

-- LSP Specific Bindings

-- Navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

vim.keymap.set("n", "<leader>gd", function()
    vim.cmd("vsplit")
    vim.lsp.buf.definition()
end, { desc = "LSP definition split" })

-- Info
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- Actions
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- Formatting
vim.keymap.set({ "n", "v" }, "<leader>F", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format file" })

--Diagnostic
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "See diagnostics on current line" })

-- End of LSP Bindings

vim.opt.mouse = "a"

vim.opt.autoread = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.termguicolors = true
vim.opt.hidden = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.wrap = true
vim.opt.linebreak = true

vim.opt.clipboard = "unnamedplus"

vim.opt.confirm = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.timeoutlen = 300

vim.opt.updatetime = 500

vim.opt.laststatus = 3

vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "algorithm:histogram",
    "indent-heuristic",
}

vim.diagnostic.config({
    float = {
        border = "rounded",
    },
    underline = true,
    virtual_text = false,
    severity_sort = true,
    update_in_insert = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    },
})

vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DapBreakpointSign",
})

vim.fn.sign_define("DapBreakpointCondition", {
    text = "",
    texthl = "DapBreakpointConditionSign",
})

vim.fn.sign_define("DapBreakpointRejected", {
    text = "",
    texthl = "DapBreakpointRejectedSign",
})

vim.fn.sign_define("DapLogPoint", {
    text = "󰍩",
    texthl = "DapLogPointSign",
})

vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "DapStoppedSign",
})

vim.opt.viewoptions = { "folds", "cursor" } -- If the view is ever saved - save these two things only (saving local options can make things weird to debug)
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

local foldColumnValue = "1"
vim.opt.foldcolumn = foldColumnValue

-- Registering custom filetypes (eg. for treesitter parsing)
vim.filetype.add({
    extension = {
        ftl = "ftl",
        ftlh = "ftlh",
    },
})

vim.treesitter.language.register("html", { "ftl", "ftlh" })

-- Function to load secrets from a secret manager (eg. pass) and set them as environment variables, so that they can be loaded by plugins that need them (like CodeCompanion)
-- If the GPG Agent has dropped the variable from the cache, stop trying - better to authorize the passphrase in a different terminal session than within neovim
local function load_secret_env(env_name, pass_name)
    -- Check if the env is already loaded in terminal context
    if vim.env[env_name] then
        return
    end

    -- If either pass_name or env_name is blank - exit
    if not pass_name or pass_name == "" or not env_name or env_name == "" then
        return
    end

    -- Check if pass executable exists
    if vim.fn.executable("pass") == 0 then
        return
    end

    -- We will use the secret if it is cached, if not - give up instead of opening the pinentry prompt in neovim
    vim.env["PASSWORD_STORE_GPG_OPTS"] = "--batch --pinentry-mode loopback"

    -- Try loading it from pass
    vim.system({ "pass", "show", pass_name }, { text = true }, function(result)
        vim.schedule(function()
            if result.code == 0 then
                vim.env[env_name] = vim.trim(result.stdout)
                return
            end
            vim.notify("Failed to load " .. env_name, vim.log.levels.WARN)
        end)
    end)
end

-- Colors --
--
-- Some colorschemes I like:
-- slate (the theme the colors in the config are based on)
-- desert
-- habamax
-- quiet
-- retrobox (Amazing!)
-- sorbet
-- unokai
vim.cmd("colorschem slate")

-- Increase contrast of line numbers
vim.api.nvim_set_hl(0, "LineNrNC", { fg = "#8b949e" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#8b949e" })

vim.api.nvim_set_hl(0, "NormalNC", { bg = "#353535" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#555555" })

vim.opt.cursorline = true

vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#d19a66",
    bold = true,
})

vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#353535",
})

vim.opt.guicursor = {
    "n-v-c:block",
    "i-ci:ver75",
    "r-cr:hor60",
}

vim.api.nvim_set_hl(0, "Folded", { bg = "#2d3648", fg = "#a9b8d0" })

vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1f2330", fg = "#7a8f47" })

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#6bcf24" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ff9f00" })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#e51b2a" })
vim.api.nvim_set_hl(0, "GitSignsTopDelete", { fg = "#e51b2a" })
vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { fg = "#bb471d" })
vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = "#b5f7ff" })

vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "GitSignsStagedChange", { fg = "#a352ba" })
vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { fg = "#900c00" })
vim.api.nvim_set_hl(0, "GitSignsStagedTopDelete", { fg = "#be5046" })
vim.api.nvim_set_hl(0, "GitSignsStagedChangeDelete", { fg = "#b9085e" })
vim.api.nvim_set_hl(0, "GitSignsStagedUntracked", { fg = "#167e86" })

-- TODO: Maybe add custom colors of my own later
vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "MiniHipatternsHack", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "MiniHipatternsTodo", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "MiniHipatternsNote", { link = "DiagnosticHint" })

-- Some languages (more specifically treesitter parsers for those languages) - have their own TODO highlighting rules which link to neovim's default color group - Todo
-- We will clear that since TODO highlighting is being handled externally with plugins
vim.api.nvim_set_hl(0, "Todo", {})

-- Sets the color of the scrollbar in floating windows
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#847e56" })

-- Dynamically set the color of the current line number based on the current mode
local function set_line_nr_color(mode)
    if mode == "n" then
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d19a66", bold = true })
    elseif mode == "i" then
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#61afef", bold = true })
    elseif mode == "v" or mode == "V" or mode == "\22" then
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ba73d0", bold = true })
    elseif mode == "R" then
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e03a48", bold = true })
    elseif mode:match("[sS\19]") then
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ba73d0", bold = true })
    else
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#cdd6f4", bold = true })
    end
end

vim.api.nvim_set_hl(0, "IblIndent", { fg = "#2a2f3a", bold = false })

vim.api.nvim_set_hl(0, "Structure", {
    fg = "#89b4fa",
})

vim.api.nvim_set_hl(0, "CopilotSuggestion", {
    fg = "#8cb7ff",
    italic = true,
})

-- Setting colors for breakpoints
vim.api.nvim_set_hl(0, "DapBreakpointSign", {
    fg = "#d16969",
    bg = "NONE",
})

vim.api.nvim_set_hl(0, "DapBreakpointConditionSign", {
    fg = "#d7ba7d",
    bg = "NONE",
})

vim.api.nvim_set_hl(0, "DapBreakpointRejectedSign", {
    fg = "#5a5a5a",
    bg = "NONE",
})

vim.api.nvim_set_hl(0, "DapLogPointSign", {
    fg = "#569cd6",
    bg = "NONE",
})

vim.api.nvim_set_hl(0, "DapStoppedSign", {
    fg = "#4ec9b0",
    bg = "NONE",
})

-- Make comments brighter
vim.api.nvim_set_hl(0, "Comment", {
    fg = "#8b949e",
    italic = true,
})

vim.api.nvim_set_hl(0, "NeoTreeDimText", { fg = "#8b949e" })
vim.api.nvim_set_hl(0, "NeoTreeDotFile", { fg = "#8b949e" })
vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#ffffff" })
vim.api.nvim_set_hl(0, "NeoTreeMessage", { fg = "#8b949e" })
vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#ffffff" })

vim.api.nvim_set_hl(0, "Conceal", { fg = "#8b949e" })

vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = true })

vim.api.nvim_set_hl(0, "Visual", { bg = "#4a6508", fg = "#d1d6db" })

vim.api.nvim_set_hl(0, "HydraStatusLineRed", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "HydraStatusLineBlue", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "HydraStatusLineAmar", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "HydraStatusLineTeal", { link = "StatusLine" })
vim.api.nvim_set_hl(0, "HydraStatusLinePink", { link = "StatusLine" })

vim.api.nvim_set_hl(0, "CodeCompanionChatTokens", { fg = "#dff5e1" })

-- Colors during searching

-- Search - color of OTHER matches during IncSearch
-- vim.api.nvim_set_hl(0, "Search", { fg = "#ffffff", bg = "#d7875f", bold = true })

-- IncSearch - current match while typing
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#ffffff", bg = "#4a6508" })

-- CurSearch - Current match after pressing Enter (navigating)
vim.api.nvim_set_hl(0, "CurSearch", { fg = "#ffffff", bg = "#004400" })

-- End of color section

-- Only apply the cursor line to the text line and not the left side
vim.opt.cursorlineopt = "line"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.fillchars = {
    eob = " ",
    fold = " ",
    foldopen = " ",
    foldclose = "󰍟",
    foldsep = " ",
    vert = "┃",
    horiz = "━",
    verthoriz = "╋",
}

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

vim.opt.smartindent = true

vim.opt.showmode = false

local ui_group = vim.api.nvim_create_augroup("UserUI", { clear = true })
local reload_group = vim.api.nvim_create_augroup("UserAutoReload", { clear = true })
local java_group = vim.api.nvim_create_augroup("UserJava", { clear = true })

-- To stop blank [No Name] buffers getting created - happens when file tree plugins are toggled sometimes
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    group = ui_group,
    callback = function(args)
        local buf = args.buf
        local name = vim.api.nvim_buf_get_name(buf)
        local bt = vim.bo[buf].buftype
        local ft = vim.bo[buf].filetype

        if (name == "" or name == "[No Name]") and (ft == "netrw" or bt ~= "") then
            vim.bo[buf].buflisted = false
            vim.bo[buf].bufhidden = "wipe"
        end
    end,
})

-- Sometimes neotree on startup shows files which should be ignored (probably .gitignore rules haven't been applied yet)
-- This just refreshes it once after 100ms to make things clean again
vim.api.nvim_create_autocmd("VimEnter", {
    group = ui_group,
    callback = function()
        vim.defer_fn(function()
            require("neo-tree.sources.manager").refresh("filesystem")
            require("neo-tree.sources.manager").refresh("git_status")
        end, 100)
    end,
})

-- Reload file when changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter", "CursorHold" }, {
    group = reload_group,
    command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = reload_group,
    callback = function()
        print("File reloaded from disk")
    end,
})

-- Call previously declared function to set the new color of current line number when mode is changed
vim.api.nvim_create_autocmd("ModeChanged", {
    group = ui_group,
    callback = function()
        set_line_nr_color(vim.fn.mode())
    end,
})

-- Custom autocmd to start jdtls
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    group = java_group,
    callback = function()
        local jdtls = require("jdtls")

        local root_dir = require("jdtls.setup").find_root({
            ".git",
            "mvnw",
            "gradlew",
            "pom.xml",
            "build.gradle",
        })

        -- Make a persistent workspace directory for the project, instead of remaking one every time
        local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

        -- The bundle contains premade java debug configs - we need to provide it as a table and not a string, hence the split
        local bundles = vim.split(
            vim.fn.glob(
                vim.fn.stdpath("data")
                    .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
            ),
            "\n"
        )

        -- Filter out empty values
        bundles = vim.tbl_filter(function(b)
            return b ~= ""
        end, bundles)

        local config = {
            cmd = {
                "jdtls",
                "-data",
                workspace_dir,
            },
            root_dir = root_dir,
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            init_options = {
                bundles = bundles,
            },
        }

        jdtls.start_or_attach(config)

        jdtls.setup_dap({ hotcodereplace = "auto" })
    end,
})

-- Set up DAP once JDTLS has attached
vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    group = java_group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "jdtls" then
            vim.defer_fn(function()
                require("jdtls.dap").setup_dap_main_class_configs()

                -- Add custom debugging config(s)
                local dap = require("dap")
                dap.configurations.java = dap.configurations.java or {}

                table.insert(dap.configurations.java, {
                    type = "java",
                    request = "attach",
                    name = "Attach to Running JVM Process :5005",
                    hostName = "127.0.0.1",
                    port = 5005,
                })
            end, 3000)
        end
    end,
})

-- Custom User Event "AfterVeryLazy" - triggered 2 seconds after VeryLazy
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
        vim.defer_fn(function()
            vim.api.nvim_exec_autocmds("User", {
                pattern = "AfterVeryLazy",
            })
        end, 2000)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "AfterVeryLazy",
    once = true,
    callback = function()
        -- Load secrets after all plugins have loaded
        load_secret_env("OPENAI_API_KEY", "openai/api_key")
        load_secret_env("ANTHROPIC_API_KEY", "anthropic/claude_code")
        load_secret_env("OPENROUTER_API_KEY", "openrouter/api_key")
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    callback = function()
        vim.g.codecompanion_thinking = true
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionRequestFinished", "CodeCompanionRequestError" },
    callback = function()
        vim.g.codecompanion_thinking = false
    end,
})

-- Set initial color of the line number
set_line_nr_color(vim.fn.mode())

vim.w.hide_gutter = false

-- My own variable to track if debug DAP REPL is open (to implement toggling)
vim.w.repl_open = false

-- A quick way to clear the left side of numbers/foldsigns/gitgutter/diagnostics - mainly to copy code using the tmux copy mode (it copes all text on screen)
vim.api.nvim_create_user_command("ToggleGutter", function()
    if vim.w.hide_gutter then
        vim.wo.number = true
        vim.wo.relativenumber = true
        vim.wo.foldcolumn = foldColumnValue
    else
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.foldcolumn = "0"
    end

    vim.w.hide_gutter = not vim.w.hide_gutter
    vim.notify("Gutter visibility toggled", vim.log.levels.INFO)
end, { desc = "Toggle sign and line number visibility in the left gutter (current window only)" })

-- A user command to toggle wrapping for a specific window
vim.api.nvim_create_user_command("ToggleWrap", function()
    local wrap = vim.wo.wrap

    if wrap == true then
        vim.wo.wrap = false
    else
        vim.wo.wrap = true
    end

    vim.notify("Wrapping toggled", vim.log.levels.INFO)
end, { desc = "Toggle text wrapping (current window only)" })

-- Keymap to do it quickly
vim.keymap.set("n", "<M-z>", "<cmd>ToggleWrap<cr>")

-- User command to open a diff view of unsaved changes VS saved file on disk (very useful for long sessions or when not using git)
vim.api.nvim_create_user_command("DiffSaved", function()
    vim.cmd("leftabove vnew [Original]")
    vim.bo.buftype = "nofile"
    vim.cmd("read #")
    vim.bo.bufhidden = "wipe"
    vim.bo.swapfile = false
    vim.cmd("0d_")
    vim.cmd("diffthis")
    vim.cmd("wincmd p")
    vim.cmd("diffthis")
end, { desc = "View a diffsplit of unsaved changes vs original file" })

local function user_options_picker()
    local actions = {

        "Toggle Gutter",
        "Toggle Wrapping",
        "View Diff (Saved vs Unsaved)",
        "Toggle Treesitter Context",
    }
    vim.ui.select(actions, {
        prompt = "Choose Action",
    }, function(choice)
        if choice == nil then
            return
        end

        if choice == actions[1] then
            vim.cmd("ToggleGutter")
        elseif choice == actions[2] then
            vim.cmd("ToggleWrap")
        elseif choice == actions[3] then
            vim.cmd("DiffSaved")
        elseif choice == actions[4] then
            vim.cmd("TSContext toggle")
        end
    end)
end

vim.api.nvim_create_user_command("UserOptions", user_options_picker, {
    desc = "Open custom options picker",
})

vim.keymap.set("n", "<leader>oo", "<cmd>UserOptions<cr>", {
    desc = "Open user options picker",
})

local function user_lsp_picker()
    local actions = {

        "Format using Conform/LSP",
    }
    vim.ui.select(actions, {
        prompt = "Choose LSP Action",
    }, function(choice)
        if choice == nil then
            return
        end

        if choice == actions[1] then
            require("conform").format({
                async = true,
                lsp_format = "fallback",
            })
        end
    end)
end

vim.api.nvim_create_user_command("UserOptionsLSP", user_lsp_picker, {
    desc = "Open custom LSP options picker",
})

vim.keymap.set("n", "<leader>ol", "<cmd>UserOptionsLSP<cr>", {
    desc = "Open custom lsp options picker",
})

-- Lazy Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- List of Plugins
require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPre",
        branch = "master", -- IMPORTANT: for Neovim 0.10
        build = ":TSUpdate",
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "java",
                    "javadoc",
                    "xml",
                    "bash",
                    "json",
                    "css",
                    "csv",
                    "diff",
                    "dockerfile",
                    "gitignore",
                    "html",
                    "ini",
                    "javascript",
                    "typescript",
                    "jinja",
                    "markdown",
                    "markdown_inline",
                    "sql",
                    "regex",
                    "yaml",
                },

                highlight = {
                    enable = true,
                },

                indent = {
                    enable = true,
                },
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },

    {
        "numToStr/Comment.nvim",
        event = "BufReadPre",
        config = function()
            local comment = require("Comment")
            local ft = require("Comment.ft")

            ft.set("ftl", "<#-- %s -->")
            ft.set("ftlh", "<#-- %s -->")

            comment.setup({
                pre_hook = function()
                    local filetype = vim.bo.filetype
                    if filetype == "ftl" or filetype == "ftlh" then
                        return "<#-- %s -->"
                    end
                end,
            })
        end,
    },

    {
        "tpope/vim-sleuth",
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local function codecompanion_state()
                if vim.g.codecompanion_thinking then
                    return "󰚩 Thinking"
                else
                    return ""
                end
            end
            local function supermaven_status()
                local ok, api = pcall(require, "supermaven-nvim.api")
                if not ok then
                    return "NOT OK"
                end
                if api.is_running() then
                    return "󰚩 supermaven"
                else
                    return "INACTIVE"
                end
            end
            require("lualine").setup({
                options = {
                    theme = "onedark",
                    section_separators = "",
                    component_separators = "",
                    globalstatus = true,
                },
                sections = {
                    lualine_c = {
                        "filename",
                        {
                            "lsp_status",
                            icon = "",
                            color = { fg = "#61afef", bg = "#2c323c" },

                            -- symbols = {
                            --     separator = " | ",
                            -- },
                        },
                        supermaven_status,
                    },
                    lualine_x = {
                        {
                            "searchcount",
                            color = { fg = "#61afef", bg = "#2c323c" },
                            fmt = function(str)
                                if str ~= "" then
                                    return "SearchCount: " .. str
                                end
                            end,
                        },
                        codecompanion_state,
                        "encoding",
                        "fileformat",
                        "filetype",
                    },
                },
                tabline = {
                    lualine_a = {
                        {
                            "tabs",
                            mode = 1,

                            tab_max_length = 25, -- max width of each tab label
                            max_length = 75, -- max total width of the tabs component

                            -- optional
                            path = 0,
                            show_modified_status = true,
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.8",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },
        config = function()
            local builtin = require("telescope.builtin")
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    preview = {
                        treesitter = true,
                    },
                    buffer_previewer_maker = function(filepath, bufnr, opts)
                        require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)

                        if filepath:match("%.ftlh$") then
                            vim.bo[bufnr].filetype = "ftlh"
                        elseif filepath:match("%.ftl$") then
                            vim.bo[bufnr].filetype = "ftl"
                        end
                    end,
                },

                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ["ui-select"] = require("telescope.themes").get_dropdown({}),
                },

                pickers = {
                    find_files = {
                        hidden = true,
                        file_ignore_patterns = { "^%.git/" },
                    },
                    buffers = {
                        mappings = {
                            n = {
                                ["d"] = actions.delete_buffer,
                            },
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")

            vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Telescope file finder" })
            vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
            vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Telescope buffer list" })

            vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope git status" })
            vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Telescope git branches" })

            vim.keymap.set("n", "<leader>D", builtin.diagnostics, { desc = "Telescope diagnostics in current file" })

            vim.keymap.set("n", "<leader>p", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })
            vim.keymap.set(
                "n",
                "<leader>P",
                builtin.lsp_dynamic_workspace_symbols,
                { desc = "Telescope workspace symbols" }
            )
        end,
    },

    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        version = "v2.5",
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "basedpyright",
                "jdtls",
                "vtsls",
                "lemminx",
                "html",
                "cssls",
                "jsonls",
                "tailwindcss",

                -- TODO: Add shellcheck for bash script LSP
            },
            automatic_enable = false,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)

            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            local capabilities = require("blink.cmp").get_lsp_capabilities()

            lspconfig.basedpyright.setup({})
            lspconfig.vtsls.setup({})
            lspconfig.html.setup({
                -- filetypes = { "html", "ftlh", "ftl" },
            })
            lspconfig.cssls.setup({})

            lspconfig.emmet_language_server.setup({
                capabilities = capabilities,
                filetypes = {
                    "html",
                    "css",
                    "javascriptreact",
                    "typescriptreact",
                    "javascript",
                },
            })

            lspconfig.lemminx.setup({
                capabilities = capabilities,
            })

            lspconfig.jsonls.setup({
                capabilities = capabilities,
            })

            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
            })
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({

                close_if_last_window = false,
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,

                window = {
                    ---@diagnostic disable-next-line: assign-type-mismatch
                    width = "25%",
                    mappings = {
                        ["l"] = "open",
                        ["h"] = "close_node",
                        ["<cr>"] = "open",

                        ["s"] = "open_split",
                        ["v"] = "open_vsplit",
                        ["t"] = "open_tabnew",

                        ["a"] = {
                            "add",
                            config = {
                                show_path = "relative",
                            },
                        },

                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                        ["."] = "toggle_hidden",
                        ["R"] = "refresh",
                        ["Y"] = function(state)
                            local node = state.tree:get_node()
                            if not node or not node.path then
                                return
                            end

                            local rel_path = vim.fn.fnamemodify(node.path, ":.")
                            vim.fn.setreg("+", rel_path)
                            vim.notify("Copied relative path: " .. rel_path)
                        end,
                    },
                },

                filesystem = {
                    hijack_netrw_behavior = "open_default",
                    use_libuv_file_watcher = true,
                    follow_current_file = {
                        enabled = true,
                        leave_dirs_open = false,
                    },
                },

                default_component_configs = {
                    indent = {
                        with_expanders = true,
                        expander_collapsed = "󰍝",
                        expander_expanded = "󰍟",
                    },
                    -- git_status = {
                    --     symbols = {
                    --         added = "",
                    --         modified = "",
                    --         deleted = "✖",
                    --         renamed = "",
                    --         untracked = "",
                    --         ignored = "",
                    --         unstaged = "",
                    --         staged = "",
                    --         conflict = "",
                    --     },
                    -- },
                },
            })

            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>")
        end,
    },

    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        config = function()
            local ufoObj = require("ufo")

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                -- local suffix = (' 󰁂 %d lines'):format(endLnum - lnum)
                local suffix = (" >...< %d lines"):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, "MoreMsg" })
                return newVirtText
            end

            ufoObj.setup({

                fold_virt_text_handler = handler,
                open_fold_hl_timeout = 0,

                ---@diagnostic disable-next-line: unused-local
                provider_selector = function(_, filetype, buftype)
                    if buftype == "nofile" then
                        return { "indent" }
                    end
                    return { "treesitter", "indent" }
                end,

                preview = {
                    win_config = {
                        border = "rounded",
                        winblend = 0,
                        winhighlight = "Normal:Folded,FloatBorder:FloatBorder,CursorLine:Visual",
                        maxheight = 20,
                    },
                    mappings = {
                        scrollU = "<C-u>",
                        scrollD = "<C-d>",
                    },
                },
            })

            vim.keymap.set("n", "zR", ufoObj.openAllFolds)
            vim.keymap.set("n", "zM", ufoObj.closeAllFolds)

            vim.keymap.set("n", "K", function()
                local winId = ufoObj.peekFoldedLinesUnderCursor()
                if not winId then
                    vim.lsp.buf.hover()
                end
            end)
        end,
    },

    {
        "luukvbaal/statuscol.nvim",
        config = function()
            local builtin = require("statuscol.builtin")
            local statuscolObj = require("statuscol")

            statuscolObj.setup({
                relculright = true,
                segments = {
                    {
                        sign = { namespace = { "gitsigns" }, maxwidth = 1, colwidth = 1 },
                        condition = {
                            function()
                                return not vim.w.hide_gutter
                            end,
                        },
                        click = "v:lua.ScSa",
                    },

                    {
                        sign = {
                            namespace = { ".*diagnostic.*", "vim.diagnostic.*" },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = false,
                            wrap = false,
                        },
                        condition = {
                            function()
                                return not vim.w.hide_gutter
                            end,
                        },
                        click = "v:lua.ScSa",
                    },

                    -- Segment to add extra space between diagnostic signs and other signs like breakpoints - looks cleaner
                    {
                        text = { " " },
                    },

                    {
                        sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true, wrap = false },
                        condition = {
                            function()
                                return not vim.w.hide_gutter
                            end,
                        },
                        click = "v:lua.ScSa",
                    },

                    {
                        -- Need a custom function for line numbers to apply highlighting to the current line no.
                        -- Since we set vim.opt.cursorlineopt = "line", it is not going to apply highlighting to the numberline
                        text = {

                            function(args)
                                local ft = vim.bo[args.buf].filetype
                                local bt = vim.bo[args.buf].buftype

                                if bt ~= "" or ft == "neo-tree" then
                                    return ""
                                end

                                if args.virtnum ~= 0 then
                                    return "%="
                                end

                                -- respect :set nonu and :set nornu
                                if not args.nu and not args.rnu then
                                    return ""
                                end

                                local num
                                if args.rnu then
                                    if args.relnum == 0 then
                                        num = args.nu and args.lnum or 0
                                    else
                                        num = args.relnum
                                    end
                                else
                                    num = args.nu and args.lnum or 0
                                end

                                if num == 0 then
                                    return ""
                                end

                                local numstr = tostring(num)
                                local pad = string.rep(" ", math.max(args.nuw - #numstr, 0))

                                if args.relnum == 0 then
                                    return "%#CursorLineNr#%=" .. pad .. numstr .. "%* "
                                else
                                    return "%#LineNr#%=" .. pad .. numstr .. "%* "
                                end
                            end,
                        },
                        click = "v:lua.ScLa",
                    },

                    {
                        text = { builtin.foldfunc, " " },
                        click = "v:lua.ScFa",
                        hl = "FoldColumn",
                    },
                },
            })

            vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#44e62f", bg = "NONE" })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            local gsObj = require("gitsigns")
            gsObj.setup({
                attach_to_untracked = true,

                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "󰍵" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "│" },
                    untracked = { text = "┆" },
                },

                signs_staged = {
                    add = { text = "┃" },
                    change = { text = "┃" },
                    delete = { text = "󰐊" },
                    topdelete = { text = "╍" },
                    changedelete = { text = "┃" },
                    untracked = { text = "┇" },
                },

                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,

                current_line_blame = false,
                current_line_blame_opts = {
                    delay = 500,
                    virt_text_pos = "eol",
                },

                -- Follows vim.api.nvim_open_win() specs
                preview_config = {
                    border = "rounded",
                    style = "minimal",
                    relative = "cursor",
                    -- title = "Hey there",
                    -- width = 30,
                    -- height = 20,
                    focusable = true,
                },
            })

            vim.keymap.set("n", "]h", function()
                gsObj.nav_hunk("next")
            end, { desc = "Next hunk" })
            vim.keymap.set("n", "[h", function()
                gsObj.nav_hunk("prev")
            end, { desc = "Previous hunk" })

            vim.keymap.set("n", "<leader>hp", gsObj.preview_hunk, { desc = "Preview Hunk" })
            vim.keymap.set("n", "<leader>hi", gsObj.preview_hunk_inline, { desc = "Preview Hunk Inline" })
            vim.keymap.set("n", "<leader>hs", gsObj.stage_hunk, { desc = "Stage/Unstage Hunk" })
            vim.keymap.set("n", "<leader>hr", gsObj.reset_hunk, { desc = "Reset Hunk" })
            vim.keymap.set("n", "<leader>hb", gsObj.blame_line, { desc = "Blame Line" })

            -- vim.keymap.set("n", "<leader>hd", gsObj.diffthis, {desc = "Diff current file"} )

            vim.keymap.set("n", "<leader>hd", function()
                if vim.wo.diff then
                    local current_win = vim.api.nvim_get_current_win()
                    local tab_wins = vim.api.nvim_tabpage_list_wins(0)

                    for _, win in ipairs(tab_wins) do
                        if win ~= current_win then
                            -- Check if that window is also in diff mode
                            local is_diff = vim.api.nvim_get_option_value("diff", { scope = "local", win = win })
                            if is_diff then
                                vim.api.nvim_win_close(win, true)
                            end
                        end
                    end
                    vim.cmd("diffoff")
                else
                    gsObj.diffthis()
                end

                print("Diff view toggled")
            end, { desc = "Toggle diff view for current file" })

            vim.keymap.set("v", "<leader>hs", function()
                gsObj.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "Stage Partial Hunk" })

            vim.keymap.set("v", "<leader>hr", function()
                gsObj.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "Reset Partial Hunk" })
        end,
    },

    {
        "echasnovski/mini.hipatterns",
        event = "BufReadPre",
        config = function()
            local hipatterns = require("mini.hipatterns")

            hipatterns.setup({
                highlighters = {
                    -- Highlight words like TODO, FIXME, HACK, NOTE
                    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                    -- Highlight hex colors using that actual color
                    hex_color = hipatterns.gen_highlighter.hex_color(),

                    -- Highlight Freemarker comments in .ftl / .ftlh
                    freemarker_comment = {
                        pattern = function(buf_id)
                            local ft = vim.bo[buf_id].filetype
                            if ft ~= "ftl" and ft ~= "ftlh" then
                                return nil
                            end

                            return "()<#%-%-.-%-%->()"
                        end,
                        group = "Comment",
                    },
                },
            })
        end,
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "markdown", "codecompanion" },
        opts = {
            file_types = { "markdown", "codecompanion" },
            render_modes = true,

            sign = { enabled = false },
            code = {
                enabled = false,
            },
        },
    },

    {
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets", version = "v2.*" },
        version = "1.*",
        opts = {
            keymap = {
                -- Preset options for keybindids - can be "enter", "default", "super-tab", "none"
                preset = "none",

                ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },

                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },

                ["<C-e>"] = { "hide", "fallback" },

                ["<C-y>"] = { "accept" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            -- Signature help feature (Press <C-k> in insert mode) is currently experimental, so keeping it disabled
            -- Docs are enough
            -- signature = {
            --     enabled = true
            -- },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,

                    window = {
                        -- Can be "rounded", "single", "double", "solid", "shadow", "none"
                        border = "rounded",
                    },
                },
                list = {
                    selection = {

                        -- This is important! as, as per default settings sometimes pressing enter accepts a random suggestion when I just want a new line
                        -- Having to cancel the completion menu everytime is bad ux, hence the first completion is manually selected with <TAB> OR <C-n>
                        preselect = false,
                    },
                },

                ghost_text = {
                    enabled = false,
                },

                -- For customizing the main completion menu
                menu = {
                    border = "none",
                },
            },

            snippets = {
                preset = "luasnip",
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            -- cmdline = {
            --     sources = {},
            -- },
        },
    },

    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")
            ls.setup({
                -- NOTE: Commenting these out until needed:
                --
                -- region_check_events = "CursorMoved,CursorMovedI,InsertEnter",
                -- delete_check_events = "TextChanged,InsertLeave",
                --
                -- link_roots = false,
                -- exit_roots = true
            })
            require("luasnip.loaders.from_vscode").lazy_load()

            -- Explicit keymaps to exit snippets manually, if required
            vim.keymap.set({ "i", "s" }, "<C-g>", function()
                if ls.in_snippet() then
                    ls.unlink_current()
                end
            end, { desc = "Exit current snippet" })

            vim.keymap.set({ "i", "s" }, "<Esc>", function()
                if ls.in_snippet() then
                    ls.unlink_current()
                end
                return "<ESC>"
            end, { expr = true, desc = "Exit current snippet and enter normal mode" })
        end,
    },

    {
        "karb94/neoscroll.nvim",
        config = function()
            local ns = require("neoscroll")
            ns.setup({
                easing_function = "linear",
                duration_multiplier = 0.2,
            })
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = false },
        },
    },

    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        opts = {
            formatters_by_ft = {
                python = { "ruff_fix", "ruff_format" },
                -- python = { "ruff_format" },
                lua = { "stylua" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                css = { "prettierd", "prettier", stop_after_first = true },
                markdown = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },

                -- TODO: Add shfmt for formatting shell scripts
            },

            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = {
                timeout_ms = 1000,
            },
            notify_on_error = true,
            notify_no_formatters = false,
        },
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                    })
                end,
                mode = { "n", "v" },
                desc = "Format file or range",
            },
        },
    },

    {
        "mfussenegger/nvim-dap",
        keys = {
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "Debug Continue",
            },
            {
                "<F6>",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<F7>",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<F8>",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
            {
                "<F9>",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<F10>",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Conditional Breakpoint",
            },
            {
                "<leader><F6>",
                function()
                    local dap = require("dap")
                    if vim.w.repl_open then
                        dap.repl.close()
                        vim.w.repl_open = false
                    else
                        dap.repl.open()
                        vim.w.repl_open = true
                    end
                end,
                desc = "Toggle DAP REPL",
            },

            {
                "<leader><F5>",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<leader><F7>",
                function()
                    require("dapui").toggle()
                end,
                desc = "Toggle DAP UI",
            },
            {
                "<leader><F8>",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate DAP Session",
            },
        },
    },

    {
        "mfussenegger/nvim-dap-python",
        dependencies = "mfussenegger/nvim-dap",
        config = function()
            require("dap-python").setup("python")
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },

    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")

            -- Linters per filetype
            lint.linters_by_ft = {
                -- python = { "ruff" },
                -- add later:
                -- javascript = { "eslint_d" },
                -- typescript = { "eslint_d" },
            }

            -- Augroup (prevents stacking)
            local group = vim.api.nvim_create_augroup("UserLint", { clear = true })

            -- Run linting on events
            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                group = group,
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    {
        "nvim-telescope/telescope-ui-select.nvim",
    },

    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = {
            "DiffviewOpen",
            "DiffviewClose",
            "DiffviewFileHistory",
            "DiffviewFocusFiles",
            "DiffviewToggleFiles",
            "DiffviewRefresh",
        },
        keys = {
            { "<leader>go", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
            { "<leader>gO", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
            { "<leader>gc", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
            { "<leader>gC", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview Repo History" },
        },
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            local noiceObj = require("noice")
            noiceObj.setup({
                lsp = {
                    hover = {
                        enabled = true,
                        opts = {
                            border = {
                                style = "rounded",
                            },
                        },
                    },
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    signature = {
                        enabled = true,
                        auto_open = {
                            enabled = false,
                        },
                    },
                    progress = {
                        enabled = false,
                    },
                },
                cmdline = {
                    enabled = true,
                    view = "cmdline",
                    opts = {},
                    format = {},
                },
                messages = {
                    enabled = true,
                    view = "mini",
                    view_error = "notify",
                    view_warn = "notify",
                    view_history = "messages",
                    view_search = false,
                },
                -- popupmenu = {
                --
                --     enabled = false,
                --     backend = "nui",
                --     kind_icons = {},
                -- },
                presets = {
                    bottom_search = true,
                    command_palette = false,
                    long_message_to_split = true,
                    lsp_doc_border = true,
                },
                commands = {
                    all = {
                        view = "vsplit",
                        opts = {
                            enter = true,
                            format = "details",
                        },
                    },
                    history = {
                        view = "vsplit",
                        opts = {
                            enter = true,
                            format = "details",
                        },
                    },
                },
                views = {
                    hover = {
                        win_options = {
                            winhighlight = { Normal = "Normal", NormalNC = "NormalNC" },
                        },
                    },
                    split = {
                        win_options = {
                            winhighlight = { Normal = "Normal", NormalNC = "NormalNC" },
                        },
                    },
                },
            })

            vim.keymap.set({ "n", "i" }, "<C-k>", function()
                vim.lsp.buf.signature_help()
            end, { desc = "Signature Help (noice.nvim)" })
            vim.keymap.set({ "n", "v" }, "<leader>x", function()
                vim.cmd("Noice dismiss")
            end, { desc = "Dismiss all notifications" })
        end,
    },

    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false,
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<M-y>",
                        accept_word = "<M-w>",
                        accept_line = "<M-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<M-c>",
                    },
                },
                filetypes = {
                    markdown = true,
                    gitcommit = true,
                    yaml = true,
                    help = false,
                    lua = true,
                    java = true,
                    python = true,
                    javascript = true,
                    typescript = true,
                    html = true,
                    css = true,
                },
            })
        end,
    },

    {
        "olimorris/codecompanion.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },

        keys = {
            { "<leader>cA", "<cmd>CodeCompanionActions<cr>", desc = "AI Actions" },
            { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
            { "<leader>ci", ":CodeCompanion ", mode = { "n", "v" }, desc = "AI Inline" },
            { "<leader>ce", ":'<,'>CodeCompanion /explain<cr>", mode = "v", desc = "Explain selection" },

            { "<leader>:", ":CodeCompanionCmd ", desc = "Generate a neovim command with a natural language prompt " },
        },
        opts = {
            display = {
                chat = {
                    -- Removes the "Welcome to CodeCompanion" message at the start of every chat
                    intro_message = "",
                },
                action_palette = {
                    opts = {
                        show_preset_actions = true,
                        show_preset_prompts = true,
                        show_preset_rules = true,
                        title = "CodeCompanion Actions",
                    },
                },
            },
            prompt_library = {
                -- Some custom prompts which can be called using :CodeCompanion /prompt
                -- These also show up in Action Palette
                ["Generate Commit Message"] = {
                    interaction = "chat",
                    description = "Generate a commit message from staged changes",
                    opts = {
                        alias = "commit_custom",
                        auto_submit = true,
                    },
                    prompts = {
                        {
                            role = "system",
                            content = "You are capable of writing high-quality Git commit messages.\n"
                                .. "Make sure to include both a commit title and a commit body.\n"
                                .. "In the commit body keep separate changes in bullet points.\n"
                                .. "Only reply with the commit text.\n"
                                .. "This should be the format for the commit message:\n"
                                .. "<Commit Title>\n\n<Commit Body>",
                        },
                        {
                            role = "user",
                            content = function()
                                local function is_git_repo()
                                    local result = vim.system(
                                        { "git", "rev-parse", "--is-inside-work-tree" },
                                        { text = true }
                                    )
                                        :wait()
                                    return result.code == 0 and vim.trim(result.stdout) == "true"
                                end

                                if not is_git_repo() then
                                    return "The current directory is not a git repository. Tell the user to initialize a git repository first. Only output one sentence"
                                end

                                local diff = vim.trim(
                                    vim.system({ "git", "diff", "--cached", "--no-ext-diff" }, { text = true })
                                        :wait().stdout
                                )
                                if diff == nil or diff == "" then
                                    return "There are no staged changes. Tell the user to stage files first. Only output one sentence."
                                end
                                return "Generate a commit message for the staged changes. Find the diff below:\n"
                                    .. "`````diff\n"
                                    .. diff
                                    .. "\n`````"
                            end,
                        },
                    },
                },
                ["Generate Conventional Commit Message"] = {
                    interaction = "chat",
                    description = "Generate a commit message from staged change (in conventional commit standard)",
                    opts = {
                        alias = "commit_custom_conventional",
                        auto_submit = true,
                    },
                    prompts = {
                        {
                            role = "system",
                            content = "You are an expert Git commit message writer.\n"
                                .. "\n"
                                .. "Generate commit messages that strictly follow the Conventional Commits specification.\n"
                                .. "\n"
                                .. "Format:\n"
                                .. "<type>[optional scope]: <description>\n"
                                .. "\n"
                                .. "Allowed types:\n"
                                .. "- feat: a new feature\n"
                                .. "- fix: a bug fix\n"
                                .. "- docs: documentation-only changes\n"
                                .. "- style: formatting, whitespace, missing semicolons, etc. with no code behavior change\n"
                                .. "- refactor: code change that neither fixes a bug nor adds a feature\n"
                                .. "- perf: performance improvement\n"
                                .. "- test: adding or correcting tests\n"
                                .. "- build: build system, dependency, packaging, or external tooling changes\n"
                                .. "- ci: CI/CD configuration changes\n"
                                .. "- chore: maintenance tasks that do not modify src/test behavior\n"
                                .. "- revert: reverts a previous commit\n"
                                .. "\n"
                                .. "Rules:\n"
                                .. "- Use lowercase type.\n"
                                .. "- Use an optional lowercase scope only when it is clear from the diff.\n"
                                .. "- Keep the subject concise, preferably under 72 characters.\n"
                                .. "- Use imperative mood.\n"
                                .. "- Do not capitalize the first word of the description.\n"
                                .. "- Do not end the subject with a period.\n"
                                .. "- Base the message only on the provided staged diff.\n"
                                .. "- Do not mention files mechanically unless the file name is important.\n"
                                .. "- Add a body to explain important context, motivation, or impact.\n"
                                .. "- Use bullet points in the body only for multiple distinct changes.\n"
                                .. "- Do not wrap the commit text inside markdown.\n"
                                .. "- Do not invent changes that are not present.\n"
                                .. "- Reply only in plaintext. No emojis.\n"
                                .. "\n"
                                .. "Breaking changes:\n"
                                .. "- If the change is breaking, append ! after the type or scope.\n"
                                .. "- Include a footer starting with BREAKING CHANGE: followed by the explanation.\n"
                                .. "- Example: feat(api)!: remove legacy auth flow\n"
                                .. "\n"
                                .. "Footers:\n"
                                .. "- Use footers only when relevant.\n"
                                .. "- For breaking changes, use: BREAKING CHANGE: ...\n"
                                .. "\n"
                                .. "If multiple valid commit messages are possible, choose the one that best describes the primary user-facing or code-behavior impact.\n",
                        },
                        {
                            role = "user",
                            content = function()
                                local function is_git_repo()
                                    local result = vim.system(
                                        { "git", "rev-parse", "--is-inside-work-tree" },
                                        { text = true }
                                    )
                                        :wait()
                                    return result.code == 0 and vim.trim(result.stdout) == "true"
                                end

                                if not is_git_repo() then
                                    return "The current directory is not a git repository. Tell the user to initialize a git repository first. Only output one sentence"
                                end

                                local diff = vim.trim(
                                    vim.system({ "git", "diff", "--cached", "--no-ext-diff" }, { text = true })
                                        :wait().stdout
                                )
                                if diff == nil or diff == "" then
                                    return "There are no staged changes. Tell the user to stage files first. Only output one sentence."
                                end
                                return "Generate a commit message for the staged changes. Find the diff below:\n"
                                    .. "`````diff\n"
                                    .. diff
                                    .. "\n`````"
                            end,
                        },
                    },
                },
            },
            adapters = {
                http = {
                    openai_responses_custom = function()
                        local adapter = require("codecompanion.adapters").extend("openai_responses", {
                            name = "openai_responses_custom",
                            formatted_name = "OpenAI Responses Custom",

                            schema = {
                                -- Most modern models don't use top_p - disabling it to avoid errors about invalid parameters
                                -- Ideally this should have been handled automatically in the codecompanion default adapter (it is only disabled for GPT 5.4 Nano and not others like GPT 5.4 Mini, GPT 5.4 and GPT 5.3 Codex so using those models was causing an error "top_p not supported") - hence disabling it for the entire adapter
                                top_p = {
                                    optional = true,
                                    enabled = function()
                                        return false
                                    end,
                                },

                                model = {
                                    default = "gpt-5.4-nano",
                                },
                            },
                        })
                        adapter.schema.model.choices = {
                            ["gpt-5.4-nano"] = {
                                formatted_name = "01. GPT 5.4 Nano",
                                opts = {
                                    can_reason = false,
                                    has_vision = true,
                                    can_use_tools = true,
                                },
                            },
                            ["gpt-5.4-mini"] = {
                                formatted_name = "02. GPT 5.4 Mini",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5.6-luna"] = {
                                formatted_name = "03. GPT 5.6 Luna",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5.3-codex"] = {
                                formatted_name = "04. GPT 5.3 Codex",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5.6-terra"] = {
                                formatted_name = "05. GPT 5.6 Terra",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5.6-sol"] = {
                                formatted_name = "06. GPT 5.6 Sol",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5.1-codex"] = {
                                formatted_name = "07. GPT 5.1 Codex",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5"] = {
                                formatted_name = "08. GPT 5",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                            ["gpt-5-mini"] = {
                                formatted_name = "09. GPT 5 Mini",
                                opts = {
                                    can_reason = false,
                                    has_vision = false,
                                    can_use_tools = true,
                                },
                            },
                            ["gpt-5.4-pro"] = {
                                formatted_name = "10. GPT 5.4 Pro",
                                opts = { can_reason = true, has_vision = true, can_use_tools = true },
                            },
                        }
                        return adapter
                    end,
                },
            },

            interactions = {
                chat = {
                    adapter = {
                        name = "openai_responses_custom",
                        model = "gpt-5.4-nano",
                    },
                    tools = {
                        ["run_command"] = {
                            opts = {
                                allowed_in_yolo_mode = true,
                                require_approval_before = true,
                                require_cmd_approval = false,
                            },
                        },
                    },
                },
                inline = {
                    adapter = {
                        name = "openai_responses_custom",
                        model = "gpt-5.4-nano",
                    },
                },
                cmd = {
                    adapter = {
                        name = "openai_responses_custom",
                        model = "gpt-5.4-nano",
                    },
                },
            },
            rules = {
                opts = {
                    -- show_presets = false,
                    chat = { autoload = "custom" },
                },
                custom = {
                    description = "My rules",
                    files = {
                        ".clinerules",
                        ".cursorrules",
                        ".goosehints",
                        ".rules",
                        ".windsurfrules",
                        ".github/copilot-instructions.md",
                        "AGENT.md",
                        { path = "AGENTS.md", parser = "claude" },
                        { path = "CLAUDE.md", parser = "claude" },
                        { path = "CLAUDE.local.md", parser = "claude" },
                        { path = "~/.claude/CLAUDE.md", parser = "claude" },
                    },
                },
            },
        },
    },

    -- This plugin will be used in another plugin (hydra) so no keybindings here
    {
        "mrjones2014/smart-splits.nvim",
        opts = {},
    },

    {
        "nvimtools/hydra.nvim",
        config = function()
            local Hydra = require("hydra")
            local ss = require("smart-splits")

            Hydra({
                name = "Resize Splits",
                mode = "n",
                body = "<C-w>,",
                heads = {
                    { "h", ss.resize_left, desc = "Resize Left" },
                    { "l", ss.resize_right, desc = "Resize Right" },
                    { "j", ss.resize_down, desc = "Resize Down" },
                    { "k", ss.resize_up, desc = "Resize Up" },
                    { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
                    { "<Esc>", nil, { exit = true, nowait = true, desc = "Exit" } },
                },

                config = {
                    hint = {
                        -- Possible types are "statusline", "cmdline", "window" - the statusline seemed the cleanest to me
                        type = "statusline",
                    },
                    invoke_on_body = true,
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            enable = true,
            max_lines = 1,
            multiline_threshold = 1,
            min_window_height = 20,

            -- Changing line_numbers here won't affect if you are rendering line numbers externally (like a plugin eg. statuscol.nvim)
            line_numbers = true,

            -- Possible values: "inner", "outer"
            trim_scope = "outer",

            -- Possible values: "cursor" or "topline"
            mode = "cursor",
            separator = "╌",
        },
        config = function(_, opts)
            require("treesitter-context").setup(opts)

            vim.keymap.set("n", "gC", function()
                require("treesitter-context").go_to_context(vim.v.count1)
            end, {
                desc = "Go to treesitter context",
            })
        end,
    },

    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                    accept_suggestion = "<M-y>",
                    clear_suggestion = "<M-c>",
                    accept_word = "<M-w>",
                },

                ignore_filetypes = { help = true, codecompanion = true, markdown = true },
                color = {
                    suggestion_color = "#95b2e4",
                    cterm = 244,
                },
                log_level = "error", -- set to "off" to disable logging completely

                disable_inline_completion = false, -- disables inline completion for use with cmp

                disable_keymaps = false, -- disables built in keymaps for more manual control
                -- condition = function()
                --     return false
                -- end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
            })
        end,
    },
}, {
    performance = {
        rtp = {
            reset = false,
        },
        cache = {
            enabled = true,
        },
        compile = {
            enabled = true, -- or disable if you want zero compile step
        },
        max_jobs = 9, -- tune for your CPU
    },
})
