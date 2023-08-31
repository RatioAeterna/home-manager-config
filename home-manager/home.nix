{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jason";
  home.homeDirectory = "/home/jason";

  # Packages that should be installed to the user profile.
  home.packages = [                               
    pkgs.htop
    pkgs.fortune
    pkgs.btop
    pkgs.redshift
    pkgs.feh
    pkgs.firefox
    pkgs.picom
    pkgs.tree
    pkgs.rofi
    pkgs.alacritty
    pkgs.rustc
    pkgs.cargo
    pkgs.gcc
    pkgs.python3
    pkgs.polybar
    pkgs.gnumake
    pkgs.ripgrep
    pkgs.zathura
    pkgs.unzip
    pkgs.texlive.combined.scheme-full
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
      update = "sudo nixos-rebuild switch";
      hmupdate = "home-manager switch --flake /home/jason/.config/home-manager/";
      hmedit = "nvim /home/jason/.config/home-manager/home.nix";
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

  programs.neovim = {
    enable = true;
    #extraConfig = builtins.readFile "/home/jason/nvim-configs/dotfiles/nvim/init.lua";
    extraConfig = "
        set nu
	set shiftwidth=4
        set runtimepath+=~/.config/nvim/colors
	au VimEnter * lua require('toggleterm').setup{}
	command! T ToggleTerm
        command! F NERDTreeFocus
        colorscheme inuyasha
    ";
    plugins = [
	pkgs.vimPlugins.vim-airline
	pkgs.vimPlugins.catppuccin-nvim
        pkgs.vimPlugins.nerdtree
        pkgs.vimPlugins.toggleterm-nvim
	pkgs.vimPlugins.nvim-lspconfig
	pkgs.vimPlugins.cmp-path
	pkgs.vimPlugins.cmp-cmdline
        pkgs.vimPlugins.nvim-cmp
        pkgs.vimPlugins.lightspeed-nvim
        pkgs.vimPlugins.tokyonight-nvim
        pkgs.vimPlugins.nvim-tree-lua
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.telescope-nvim
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
