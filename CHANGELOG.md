elite CHANGELOG
=================

This file is used to list changes made in each version of the elite cookbook.

0.7.0
-----
- Update tmux, zsh configurations
- Changes:
  - `elite_stumpwm` - Add `sessions_cmds` resource attribute
  - `elite::docker_host` - Set `docker`group as `system`
  - `elite_user` - Ignore failures when appending user to group
  - `elite_tmux` - Add `commands` resource attribute
  - `elite::slim` - Improved SLiM configuration template/attributes
- New recipes:
  - `elite::python` - Install python runtimes/packages from attributes

0.6.0
-----
- Dotfiles improvements
- Changes:
  - `elite_configd` - Move .config/ directory if exists
  - `elite::slim` - Set slim as default dm
  - `elite::bin` - Create bin/ in recipe instead of provider
  - `elite::stumpwm` - Deploy wallpaper from pics attributes
- New recipes:
  - `elite::docker_host` - Setup Docker host server
  - `elite::chef` - Configure Chef/ChefDK/Stove
  - `elite::irssi` - Configure Irssi
  - `elite::pentestenv` - Configure pentest-env
- New lwrp:
  - `elite_chef`
  - `elite_irssi`
  - `elite_pentestenv`

0.5.0
-----
- Changes:
  - `elite::stumpwm` - configure webjumps
  - `elite::gtk` - Fixed gtk icons
  - `elite::x` - Configures user's default X session
  - `elite::zsh` - Fixed msf plugin
  - `elite::zsh` - Fixed emacs Tramp support
- New lwrp:
  - `elite_emacs_apps` - configures emacs apps
  
0.4.0
-----
- Changes:
  - `elite::x` take now rofi configuration
  - New zsh plugin: `ascii`
  - Removed `stumpwm` bin script
  - `elite::dotfiles` improvements
  - `elite::emacs` can now configures emacs-apps
  - Install cask dependencies when emacs repos synced
- New dependencies:
  - `locales` cookbook
- New attributes:
  - `[elite][locales]`
- New recipes:
  - `elite::rofi` - Install rofi
  - `elite::locales` - Install locales
  - `elite::dotfiles_commit` - Commit in the user's dotfiles repo
- New lwrp:
  - `elite_dotfiles` - Manage user's dotfiles

0.3.0
-----
- Move ~/.config user directory in dotfiles if already exist
- Add gtk themes: Redified, Greenified, Orangified
- Refactored StumpWM setup:
  - Configure commands, font, modules, kbd from attributes or lwrp
  - All setup in ~/.stumpwmrc file
  - Add attribute to checkout contrib repository
- Fixed gtk theme rc template

0.2.0
-----
- Added recipes:
  + `elite::conky`
  + `elite::conky_dzen2`
  + `elite::dunst`
  + `elite::dzen2`
  + `elite::gtk`
  + `elite::slim`
  + `elite::stumpwm`
- Added lwrps:
  + `elite_configd`
  + `elite_sound`
  + `elite_conky`
  + `elite_conky_dzen2`
  + `elite_dunst`
  + `elite_gtk`
  + `elite_stumpwm`

0.1.0
-----
- Initial release of elite cookbook
