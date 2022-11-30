local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    vim.notify("正在安装Pakcer.nvim，请稍后...")
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim" 
  
  -- better-escape
  use {
    "max397574/better-escape.nvim",
    config = [[require('plugin_config.better_escape')]],
  }

  -- comment
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end,
  }
  
  -- toggleterm
  use {
      "akinsho/toggleterm.nvim", 
      tag = '*', 
      config = function()
        require("toggleterm").setup()
      end
  }
  
  -- mason
  use { 
      "williamboman/mason.nvim",
      config = function()
          require("mason").setup()
      end
  }



  -- 在新环境自动安装所有插件
  if packer_bootstrap then
    require('packer').sync()
  end
end)
