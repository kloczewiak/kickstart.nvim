-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    -- Typescript plugin
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        jsx_close_tag = {
          enable = true,
          filetypes = { 'javascriptreact', 'typescriptreact' },
        },
      },
    },
  },
  {
    -- Uses correct comments for most file types
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    },
    config = function()
      local get_option = vim.filetype.get_option
      --- @diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or get_option(filetype, option)
      end
    end,
  },
  {
    'luckasRanarison/tailwind-tools.nvim',
    name = 'tailwind-tools',
    build = ':UpdateRemotePlugins',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
      'neovim/nvim-lspconfig', -- optional
    },
    opts = {},
  },
  {
    'akinsho/toggleterm.nvim',
    opts = {
      -- <C-_> for Windows
      -- <C-/> for MacOS
      -- because Control forwardslash on windows reports as <C-_> for some reason
      open_mapping = { '<C-_>', '<C-/>' },
    },
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      -- 'nvim-lua/plenary.nvim',
      -- Uncomment whichever supported plugin(s) you use
      -- "nvim-tree/nvim-tree.lua",
      'nvim-neo-tree/neo-tree.nvim',
      -- "simonmclean/triptych.nvim"
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      vim.keymap.set('n', '<leader>tm', ':MarkdownPreviewToggle<CR>', { desc = '[T]oggle [M]arkdown Preview' })
    end,
    ft = { 'markdown' },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          keymap = {
            open = '<M-/>',
          },
          layout = {
            position = 'right',
            ratio = 0.4,
          },
        },
        suggestion = {
          auto_trigger = true,
          hide_during_completion = false,
          keymap = {
            accept = '<M-CR>',
            accept_word = '<M-l>',
            accept_line = '<M-j>',
          },
        },
      }
    end,
    init = function()
      vim.keymap.set('n', '<M-/>', require('copilot.panel').open, { desc = '[copilot] (panel) open' })
      vim.keymap.set('n', '<leader>tc', require('copilot.suggestion').toggle_auto_trigger, { desc = '[T]oggle [C]opilot Suggestions' })
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    init = function()
      require('which-key').add {
        { '<leader>cc', group = '[C]opilot [C]hat', mode = { 'n', 'v' } },
      }

      local chat = require 'CopilotChat'

      vim.keymap.set({ 'n', 'v' }, '<leader>ccq', function()
        local input = vim.fn.input 'Quick Chat: '
        if input ~= '' then
          local select = require 'CopilotChat.select'
          chat.ask(input, { selection = select.visual or select.buffer })
        end
      end, { desc = '[C]opilot [C]hat [Q]uick Chat' })

      vim.keymap.set({ 'n', 'v' }, '<leader>cch', function()
        local actions = require 'CopilotChat.actions'
        require('CopilotChat.integrations.telescope').pick(actions.help_actions())
      end, { desc = '[C]opilot [C]hat [H]elp Actions' })

      vim.keymap.set({ 'n', 'v' }, '<leader>ccp', function()
        local actions = require 'CopilotChat.actions'
        require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
      end, { desc = '[C]opilot [C]hat [P]rompt Actions' })
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
