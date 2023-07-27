local o = vim.opt

-- 行号
o.relativenumber = true
-- 高亮当前行   
o.cursorline = true 
-- 设置上下间隙
o.scrolloff = 8

-- 设置制表位长度
o.tabstop = 4
-- 设置自动缩进空格数
o.shiftwidth = 4
-- 将tab转换为空格
o.expandtab = true
-- 设置按tab时光标移动数
o.softtabstop = 4
-- 自动确定下一行缩进
o.autoindent = true
o.smartindent = true

-- 设置光标离开自动写入
o.autowrite = true
-- 持久化undo
vim.bo.undofile = true
o.undodir = vim.fn.expand("~/.cache/nvim/undofile")
-- 将-连接的单词当作同一个单词
vim.cmd([[set iskeyword+=-]])
-- 取消新行自动注释
vim.api.nvim_create_autocmd( {"FileType"}, {
    pattern = { "*" },
    command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- Highlight yanked text
local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
-- Highlight the texts when you yanked
au("TextYankPost", {
	group = ag("yank_highlight", {}),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
	end,
})

-- 启用剪贴板
o.clipboard:append("unnamedplus")

-- 语法检查
-- o.spell = true
-- o.spelllang = { "en-us" } 



