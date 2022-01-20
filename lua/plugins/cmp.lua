-- ---------------------------- Completion Config --------------------------------
-- ===============================================================================

-- initialize
local present, cmp = pcall(require, "cmp")
if not present then
    return
end


vim.opt.completeopt = "menuone,noselect"
-- nvim-cmp setup
cmp.setup {
    snippet = {
        expand = function(args)
            -- require("luasnip").lsp_expand(args.body)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    sources = {
        { name = 'calc' },
        { name = "ultisnips" },
        { name = "nvim_lsp", max_item_count = 10 },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "buffer", keyword_length = 3, max_item_count = 3, },
        { name = 'look', keyword_length=4, max_item_count = 3,
            options={ convert_case=true, loud=true }
        },
    },
    formatting = {
        format = function(entry, vim_item)
            -- load lspkind icons
            vim_item.kind = string.format(
            "%s %s",
            require("plugins.lspkind_icons").icons[vim_item.kind],
            vim_item.kind
            )

            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lua = "[API]",
                buffer = "[BUF]",
                path = "[PAT]",
                ultisnips = "[SNI]",
                luasnip = "[LLL]",
                calc = "[CAL]",
                look = "[SPL]",
            })[entry.source.name]

            return vim_item
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<up>"] = cmp.mapping.scroll_docs(-4),
        ["<down>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, true, true), "n")
                -- elseif require("luasnip").expand_or_jumpable() then
                --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if vim.fn.pumvisible() == 1 then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n")
            elseif vim.fn.complete_info()["selected"] == -1 and vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                -- press("<C-R>=UltiSnips#ExpandSnippet()<CR>")
                -- elseif require("luasnip").jumpable(-1) then
                --    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
                fallback()
            end
        end,
    },
    documentation = {
        border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    }
}
