# darkmaster's no6tem @grm34

# Nushell config
$env.config.show_banner = false
$env.config.buffer_editor = "helix"

# Global vars
load-env {
  "LANG": "en_US.UTF-8",
  "KEYMAP": "fr",
  "TERM": "kitty",
  "EDITOR": "helix",
  "PAGER": "most",
  "DELTA_PAGER": "less -R",
  "DIFFPROG": "delta"
}

# PATH
$env.PATH ++= ["~/.cargo/bin"]

# Aliases
alias c = clear
alias q = exit
alias hx = helix
alias yz = yazi
alias cp = cp -p
alias ld = ls -d
alias lsa = ls -a
alias lsd = ls -da
alias gl = git log --oneline
alias gs = git status
alias gd = git diff
alias net = ss -tulpn
alias ch = chezmoi
alias vimdiff = delta

# Completions
use "~/dev/nu_scripts/custom-completions/adb/adb-completions.nu"
use "~/dev/nu_scripts/custom-completions/bat/bat-completions.nu"
use "~/dev/nu_scripts/custom-completions/cargo/cargo-completions.nu"
use "~/dev/nu_scripts/custom-completions/curl/curl-completions.nu"
use "~/dev/nu_scripts/custom-completions/fastboot/fastboot-completions.nu"
use "~/dev/nu_scripts/custom-completions/gh/gh-completions.nu"
use "~/dev/nu_scripts/custom-completions/git/git-completions.nu"
use "~/dev/nu_scripts/custom-completions/less/less-completions.nu"
use "~/dev/nu_scripts/custom-completions/man/man-completions.nu"
use "~/dev/nu_scripts/custom-completions/reflector/reflector-completions.nu"
use "~/dev/nu_scripts/custom-completions/rustup/rustup-completions.nu"
use "~/dev/nu_scripts/custom-completions/ssh/ssh-completions.nu"
use "~/dev/nu_scripts/custom-completions/tar/tar-completions.nu"
use "~/dev/nu_scripts/custom-completions/zellij/zellij-completions.nu"

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Vivid
$env.LS_COLORS = (vivid generate molokai | str trim)

# Broot
use '/home/keyzer/.config/broot/launcher/nushell/br' *

# [ no6tem dotfiles manager ]
def dotfiles [option: string] {
  if $option != "init|update|push" {
    print "Error: nu::parser::invalid_option"
    print "\nUse `--help` for more information."
  }
}

# Initializes dotfiles repository (chezmoi). 
def "dotfiles init" [] {
  rm -rf $"($env.HOME)/.local/share/chezmoi"
  chezmoi init https://github.com/grm34/no6tem
  chezmoi apply -v  
}

# Updates no6tem dotfiles changes (local).
def "dotfiles update" [] {
  let dotfiles = [
    $"($env.HOME)/.no6tem"
    $"($env.HOME)/.bash_profile"
    $"($env.HOME)/.bashrc"
    $"($env.HOME)/.gitconfig"
    $"($env.HOME)/.gtkrc-2.0"
    $"($env.HOME)/.icons/default"
    $"($env.HOME)/.config/bat"
    $"($env.HOME)/.config/broot"
    $"($env.HOME)/.config/btop"
    $"($env.HOME)/.config/cromite"
    $"($env.HOME)/.config/electron-flags.conf"
    $"($env.HOME)/.config/gtk-2.0"
    $"($env.HOME)/.config/gtk-3.0"
    $"($env.HOME)/.config/gtk-4.0"
    $"($env.HOME)/.config/helix"
    $"($env.HOME)/.config/hypr"
    $"($env.HOME)/.config/hyprpanel"
    $"($env.HOME)/.config/kitty"
    $"($env.HOME)/.config/macchina"
    $"($env.HOME)/.config/mimeapps.list"
    $"($env.HOME)/.config/neofetch"
    $"($env.HOME)/.config/nushell"
    $"($env.HOME)/.config/nwg-look"
    $"($env.HOME)/.config/qt5ct"
    $"($env.HOME)/.config/qt6ct"
    $"($env.HOME)/.config/sirula"
    $"($env.HOME)/.config/starship"
    $"($env.HOME)/.config/user-dirs.dirs"
    $"($env.HOME)/.config/xsettingsd"
    $"($env.HOME)/.config/zellij"
    $"($env.HOME)/pictures/icons"
    $"($env.HOME)/pictures/wallpapers"
  ]
  let ch_path = $"($env.HOME)/.local/share/chezmoi"
  let ch_files = ls $"($ch_path)"
  for $entry in $ch_files.name {
    if $entry not-in [
      $"($ch_path)/README.md",
      $"($ch_path)/no6tem.png"
    ] { rm -rf $entry }
  }
  print "Updating chezmoi dotfiles..."
  for $entry in $dotfiles {
    chezmoi add $entry
    print $"  added ==> ($entry)"
  }
  print "Everything is up to date!"
}

# Pushes no6tem dotfiles changes (github).
def "dotfiles push" [] {
  print "Pushing dotfiles changes..."
  chezmoi git -- add -A
  chezmoi git -- commit -m "auto-update"
  chezmoi git -- push -f origin main
}

# Zoxide
source ~/.zoxide.nu

