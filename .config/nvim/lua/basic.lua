local o = vim.opt

-- 行号
o.relativenumber = true
-- 高亮当前行   
o.cursorline = true 

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

o.clipboard:append("unnamedplus")
