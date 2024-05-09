{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jason";
  home.homeDirectory = "/home/jason";

  # Packages that should be installed to the user profile.
  home.packages = [                               
    pkgs.alacritty
    pkgs.alsa-lib
    pkgs.btop
    pkgs.cargo
    pkgs.coq
    pkgs.cmake
    pkgs.dolphin-emu
    pkgs.feh
    pkgs.firefox
    pkgs.chromium
    pkgs.fortune
    pkgs.gcc
    pkgs.gdb
    pkgs.gnumake
    pkgs.htop
    pkgs.picom
    pkgs.polybar
    pkgs.protonvpn-gui
    pkgs.python3
    pkgs.redshift
    pkgs.ripgrep
    pkgs.rofi
    pkgs.rustc
    #pkgs.rustup
    pkgs.texlive.combined.scheme-full
    pkgs.unzip
    pkgs.zathura
    pkgs.pkg-config
    pkgs.alsa-lib
    pkgs.libudev-zero
    #pkgs.llvmPackages_rocm.clang-tools-extra
    pkgs.protonvpn-gui
    pkgs.alsaLib
    pkgs.xorg.libX11
    pkgs.xorg.libXcursor
    pkgs.xorg.libXrandr
    pkgs.xorg.libXi
    pkgs.xclip
    pkgs.rust-analyzer
    pkgs.fltk
    pkgs.racket
    pkgs.z3
    pkgs.nodejs_20
    pkgs.zip
    pkgs.obs-studio
    pkgs.vlc
    pkgs.sage
    #linuxKernel.packages.linux_6_1.perf
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake /etc/nixos/";
      hmupdate = "home-manager switch --flake /home/jason/.config/home-manager/#jason";
      hmedit = "nvim /home/jason/.config/home-manager/home.nix";
      tsc = "/home/jason/.npm-global/bin/tsc";
      http-server = "/home/jason/.npm-global/bin/http-server";
      
    };
    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";
    oh-my-zsh = {
        enable = true;
        theme = "norm";
    };
  };


  # Ensure we load special fonts on login
  systemd.user.services = {
    fc-cache = {
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.fontconfig}/bin/fc-cache -f";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };

  # Source font files from ~/.config/fonts/
  home.file."${config.home.homeDirectory}/.local/share/fonts/Agave-Regular.ttf".source = ../fonts/Agave-Regular.ttf;
  home.file."${config.home.homeDirectory}/.local/share/fonts/Agave-Bold.ttf".source = ../fonts/Agave-Bold.ttf;
  home.file."${config.home.homeDirectory}/.local/share/fonts/Agave-Regular-slashed.ttf".source = ../fonts/Agave-Regular-slashed.ttf;
  home.file."${config.home.homeDirectory}/.local/share/fonts/Agave-Bold-slashed.ttf".source = ../fonts/Agave-Bold-slashed.ttf;


  home.file."${config.home.homeDirectory}/.config/nvim/lua/nvim-dap.lua".text = ''
    local dap = require("dap")
    dap.adapters.rust_gdb = {
      type = "executable",
      command = "rust-gdb",
      args = { "-i", "dap" }
    }
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" }
    }
    dap.configurations.rust = {
      {
	name = "Debug with rust_gdb",
	type = "rust_gdb",
	request = "launch",
	program = function()
	  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
	end,
	cwd = vim.fn.getcwd(),
      },
    }
    dap.configurations.c = {
      {
	name = "Launch",
	type = "gdb",
	request = "launch",
	program = function()
	  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
	end,
	cwd = vim.fn.getcwd(),
	stopAtBeginningOfMainSubprogram = false,
      },
    }
  '';

  home.file."${config.home.homeDirectory}/.config/nvim/lua/cmp_config.lua".text = ''
      local cmp = require'cmp'

      cmp.setup({
	snippet = {
	  -- REQUIRED - you must specify a snippet engine
	  expand = function(args)
	    require('luasnip').lsp_expand(args.body) -- luasnip users
	  end,
	},
	window = {
	  -- completion = cmp.config.window.bordered(),
	  -- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
	  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-f>'] = cmp.mapping.scroll_docs(4),
	  ['<C-Space>'] = cmp.mapping.complete(),
	  ['<C-e>'] = cmp.mapping.abort(),
	  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	  ['<Tab>'] = cmp.mapping.select_next_item(),
	  ['<S-Tab>'] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
	  { name = 'nvim_lsp' },
	  { name = 'vsnip' }, -- For vsnip users.
	  -- { name = 'luasnip' }, -- For luasnip users.
	  -- { name = 'ultisnips' }, -- For ultisnips users.
	  -- { name = 'snippy' }, -- For snippy users.
	}, {
	  { name = 'buffer' },
	})
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
	  { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
	  { name = 'buffer' },
	})
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
	  { name = 'buffer' }
	}
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
	  { name = 'path' }
	}, {
	  { name = 'cmdline' }
	})
      })

      -- Set up lspconfig.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      require('lspconfig')['clangd'].setup {
	capabilities = capabilities
      }

      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end


	local nvim_lsp = require('lspconfig')

	-- Rust settings (using rust-analyzer)
	nvim_lsp.rust_analyzer.setup({
	    capabilities = capabilities,
	    on_attach = function(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local opts = { noremap=true, silent=true }
		
		-- Mappings.
		buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		-- Add more mappings as needed
	    end,
	    settings = {
		["rust-analyzer"] = {
		    assist = {
			importGranularity = "module",
			importPrefix = "by_self",
		    },
		    cargo = {
			loadOutDirsFromCheck = true
		    },
		    procMacro = {
			enable = true
		    },
		}
	    }
	})

  '';


  programs.neovim = {
    enable = true;
    extraConfig = ''
	set clipboard+=unnamedplus
        set nu
	set shiftwidth=4
        set runtimepath+=~/.config/nvim/colors
        set runtimepath+=~/.config/nvim/lua
	au VimEnter * lua require('toggleterm').setup{}
	command! T ToggleTerm
        command! F NERDTreeFocus
        colorscheme inuyasha
	luafile ~/.config/nvim/lua/cmp_config.lua
	luafile ~/.config/nvim/lua/nvim-dap.lua

	inoremap <expr> <TAB> pumvisible() ? "<C-y>" : "<TAB>"

	" Function to set Coq mappings
	function! SetCoqMappings()
	    " Set buffer-local mappings for Coq
	    nnoremap <buffer> <Tab> :CoqNext<CR>
	    nnoremap <buffer> <S-Tab> :CoqUndo<CR>
	endfunction

	" Autocommand that sets the Coq mappings when a Coq buffer is detected
	augroup CoqMappings
	    autocmd!
	    autocmd FileType coq call SetCoqMappings()
	augroup END 
    '';

    plugins = [
	pkgs.vimPlugins.Coqtail
	pkgs.vimPlugins.catppuccin-nvim
	pkgs.vimPlugins.vim-airline
        pkgs.vimPlugins.nerdtree
        pkgs.vimPlugins.toggleterm-nvim
	pkgs.vimPlugins.nvim-lspconfig
	pkgs.vimPlugins.cmp-nvim-lsp
        pkgs.vimPlugins.nvim-cmp
	pkgs.vimPlugins.cmp-path
	pkgs.vimPlugins.cmp-cmdline
	pkgs.vimPlugins.cmp_luasnip
	pkgs.vimPlugins.luasnip
        pkgs.vimPlugins.lightspeed-nvim
        pkgs.vimPlugins.nvim-tree-lua
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.tokyonight-nvim
	pkgs.vimPlugins.vimspector
	pkgs.vimPlugins.nvim-dap
        {
          plugin = pkgs.vimPlugins.vim-startify;
          config = "let g:startify_change_to_vcs_root = 0";
        }
        {
          plugin = pkgs.vimPlugins.vimtex;
          config = "let g:vimtex_view_method = 'zathura'";
        }
    ];
  };

  # todo put alacritty stuff in here eventually

  services.gpg-agent = {                          
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
}
