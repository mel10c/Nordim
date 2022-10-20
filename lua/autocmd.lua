-- ===============================================================================
-- ================================ AUTO CMDs ====================================
-- ===============================================================================

local exec = vim.api.nvim_exec
local autocmd = vim.api.nvim_create_autocmd

-- ------------------------------ Trim White Space -------------------------------
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- ------------------------------ Filetype Setting -------------------------------
--- Set spelling
autocmd("FileType", {
   pattern = { "markdown", "tex", "telekasten", "Rmd" },
   callback = function()
      vim.opt_local.spell = true
   end,
})

autocmd("FileType", {
   pattern = { "tex", "tex", },
   callback = function()
       vim.cmd[[set ft=latex]]
   end,
})

-- ----------------------------- DASHBOARD or TREE -------------------------------
vim.cmd
[[
if index(argv(), ".") >= 0
  autocmd VimEnter * NvimTreeOpen
  bd1
elseif len(argv()) == 0
  autocmd VimEnter * Dashboard
endif
]]

-- ---------------------------- Highlight Yank Area ------------------------------
autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
   end,
})

-- -------------------------- Disable comment new line ---------------------------
autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove { "c", "r", "o" }
    end,
})

-- ------------------------------- Open Daily Note -------------------------------
-- local Spawn_note_window = exec(
--     [[
--     function! Spawn_note_window() abort
--     let path = "~/melaneyroot.github.io/Journal/"
--     let file_name = path.strftime("%Y-%m-%d.md")
--     " Empty buffer
--     let buf = nvim_create_buf(v:false, v:true)
--     " Get current UI
--     let ui = nvim_list_uis()[0]
--     " Dimension
--     let width = (ui.width/2 + ui.width/5)
--     let height = (ui.height/2)
--     " Options for new window
--     let opts = {'relative': 'editor',
--     \ 'width': width,
--     \ 'height': height,
--     \ 'col': (ui.width - width)/2,
--     \ 'row': (ui.height - height)/2,
--     \ 'anchor': 'NW',
--     \ 'style': 'minimal',
--     \ 'border': 'single',
--     \ }
--     " Spawn window
--     let win = nvim_open_win(buf, 1, opts)
--     " Now we can actually open or create the note for the day?
--     if filereadable(expand(file_name))
--         execute "e ".fnameescape(file_name)
--         let column = 80
--         execute "set textwidth=".column
--         execute "set colorcolumn=".column
--         execute "norm G"
--         execute "norm zz"
--         " execute "startinsert"
--     else
--         execute "e ".fnameescape(file_name)
--         let column = 80
--         execute "set textwidth=".column
--         execute "set colorcolumn=".column
--         execute "norm Gi= ".strftime("%Y-%m-%d")." ="
--         execute "norm G2o"
--         execute "norm Gi- "
--         execute "norm zz"
--         execute "startinsert"
--         endif
--         endfunction
--     ]],
--     true
-- )

-- ------------------------------Go to Next indent -------------------------------
vim.cmd
    [[
    function! GoToNextIndent(inc)
        " Get the cursor current position
        let currentPos = getpos('.')
        let currentLine = currentPos[1]
        let matchIndent = 0

        " Look for a line with the same indent level whithout going out of the buffer
        while !matchIndent && currentLine != line('$') + 1 && currentLine != -1
            let currentLine += a:inc
            let matchIndent = indent(currentLine) == indent('.')
        endwhile

        " If a line is found go to this line
        if (matchIndent)
            let currentPos[1] = currentLine
            call setpos('.', currentPos)
        endif
    endfunction
    ]]
