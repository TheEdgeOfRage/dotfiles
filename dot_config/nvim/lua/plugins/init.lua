return {
    -- Look and feel
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000 ,
        config = true,
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
    },
    "nvim-lualine/lualine.nvim",

    -- keymaps and functionality
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {}
    },
    "tpope/vim-surround",
    "folke/which-key.nvim",
    'andymass/vim-matchup',
    'tpope/vim-repeat',
    'mbbill/undotree',
    'jdhao/whitespace.nvim',
    'lambdalisue/suda.vim',
    'xiyaowong/nvim-cursorword',

    -- other
    'ahmedkhalf/project.nvim',
    'folke/neodev.nvim',
    'github/copilot.vim',
}
