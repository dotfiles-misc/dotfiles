require 'rake'
require 'erb'
require 'psych'
$LOAD_PATH << '.'
Dir['lib/*.rb'].each { |lib| require lib }

# TODO: Refactor tasks to dynamically call methods

# List of files and folders to exclude from linking
EXCLUDE_FILES_FROM_COMMON = %w(Rakefile README.md LICENSE TODO.md bin config ssh powerline tmp lib).freeze

# Shorthand for darwin platform
OSX = RUBY_PLATFORM.downcase.include?('darwin')
MAC_OS_VERSION = `defaults read loginwindow SystemVersionStampAsString`.chomp

desc "Create symbolic links and generate files in #{ENV['HOME']} without overwriting existing files"
task '' => :install

namespace :update do
  desc 'Update vundle'
  task :vundle do
    @update_vundle = true
    Rake::Task['install:vim'].invoke
  end

  desc 'Update Powerline'
  task :powerline do
    LOGGER.info "\nUpdating powerline".blue
    update_python
    update_powerline
  end

  desc 'Update Homebrew'
  task :brew do
    if OSX
      LOGGER.info "\nUpdate brew".blue
      system %(brew update)
      system %(brew upgrade)
    end
  end

  desc 'Update Ruby Gems'
  task :gems do
    LOGGER.info "\nUpdate gems".blue
    update_gems
  end

  desc 'Update Node'
  task :node do
    LOGGER.info "\nUpdate node".blue
    # system %(npm update 2>/dev/null)
    # system %(npm -g install npm@latest 2>/dev/null)
    # system %(bin/npm-upgrade)
  end

  desc 'Update subtrees'
  task :submodule do
    Rake::Task['update:subtree'].invoke
  end

  desc 'Update subtrees'
  task :subtree  do
    LOGGER.info "\nUpdate subtrees".blue
    update_subtree('git-fzf', 'config/git-fzf')
    update_subtree('xiki', 'config/xiki')
    update_subtree('dircolors-solarized', 'config/dircolors-solarized')
    update_subtree('irssi-colors-solarized', 'config/irssi-colors-solarized')
    update_subtree('irssi-trackbar', 'config/irssi-trackbar')
  end

  desc 'Update all'
  task all: %i(vundle powerline node brew gems submodule) do
  end
end

namespace :install do
  desc "Delete and recreate symbolic links and generated files in #{ENV['HOME']}"
  task :force do
  end

  desc 'Copy and launch LaunchAgent scripts'
  task :agents do
    install_launch_agents if OSX
  end

  desc 'Install Python'
  task python: %w(packages) do
    install_python
  end

  desc 'Switch to ZSH'
  task :zsh do
    switch_to_zsh
  end

  desc 'Install Vundle and execute VundleInstall'
  task :vim do
    setup_vim
  end

  desc 'Setup ~/bin'
  task :bin do
    install_bin
  end

  desc "Symlink dotfiles and folders to #{ENV['HOME']}"
  task :common do
    install_common_dotfiles
  end

  desc "Run macOS configs"
  task :macos do
    system './config/.macos' if OSX
  end

  desc 'Setup ~/.ssh folder without overwriting currently existing files'
  task :ssh do
    install_ssh
  end

  desc 'Install Packages'
  task :packages do
    install_homebrew if OSX
    install_packages
  end

  desc 'Setup version managers'
  task version_managers: %[packages] do
    setup_asdf
  end

  desc 'Install powerline'
  task powerline: %w[python zsh] do
    install_powerline
  end

  desc 'Install xcode-select'
  task :'xcode-select' do
    system 'osascript lib/install_xcode_select.scpt' if OSX
  end

  desc 'Adds 4 Spaces'
  task :spaces do
    LOGGER.info "\nAdding 4 Spaces".blue
    system 'osascript lib/add_spaces.scpt' if OSX
  end

  desc 'Changes Caps Lock to Control'
  task :capslock do
    LOGGER.info "\nChanging Caps Lock to Control".blue
    system 'osascript bin/change_caps_lock_to_ctrl_l.scpt' if OSX
  end

  desc 'Changes to max Resolution'
  task :resolution do
    LOGGER.info "\nChanging to max resolution".blue
    system 'osascript bin/set_to_max_resolution.scpt' if OSX
    system %(osascript -e 'quit application "System Preferences"')
  end

  desc 'Set up login items'
  task :loginitems do
    LOGGER.info "\nSetting up login items".blue
    system %(brew install OJFord/formulae/loginitems)
    system %(zsh -lc 'loginitems -a Karabiner-Elements -s false')
    system %(zsh -lc 'loginitems -a Amethyst')
    system %(zsh -lc 'loginitems -a RescueTime')
    system %(zsh -lc 'loginitems -a Dropbox')
    system %(zsh -lc 'loginitems -a "Alfred 4"')
  end

  desc 'Symlink outside files'
  task :symlink do
    # dropbox_atom_path = File.join('~', '/', 'Dropbox', 'atom')
    # atom_path = File.join('~', '/', '.atom')
    # install_dotfile(dropbox_atom_path, atom_path)
    dropbox_ssh_keys_path = File.join('~', '/', 'Dropbox', 'Avaimet', 'ssh', 'keys')
    ssh_keys_path = File.join('~', '/', 'dotfiles', 'ssh', 'keys')
    install_dotfile(dropbox_ssh_keys_path, ssh_keys_path)
  end

  desc 'Install subtrees'
  task :subtree  do
    LOGGER.info "\Installing subtrees".blue
    install_subtree('solarized', 'https://github.com/altercation/solarized.git', 'config/solarized')
    install_subtree('git-fzf', 'https://gist.github.com/8b572b8d4b5eddd8b85e5f4d40f17236.git', 'config/git-fzf')
    install_subtree('xiki', 'https://github.com/trogdoro/xiki.git', 'config/xiki')
    install_subtree('dircolors-solarized', 'https://github.com/seebi/dircolors-solarized.git', 'config/dircolors-solarized')
    install_subtree('irssi-colors-solarized', 'https://github.com/huyz/irssi-colors-solarized', 'config/irssi-colors-solarized')
    install_subtree('irssi-trackbar', 'https://github.com/mjholtkamp/irssi-trackbar.git', 'config/irssi-trackbar')
  end

  desc 'Install all'
  task all: %w[
    xcode-select
    subtree
    common
    macos
    packages
    version_managers
    submodule
    zsh
    vim
    bin
    ssh
    powerline
    spaces
    symlink
    capslock
    resolution
    loginitems
    reload
  ] do
  end
end

desc "Reload ZSH session"
task :reload do
  system 'exec zsh'
end

desc "Create symbolic links and generate files in #{ENV['HOME']} without overwriting existing files"
task install: ['install:all']

desc 'Update everything'
task update: ['update:all']

task default: :install

Rake::Task['install:packages'].enhance do
  restart_quicklook
  system %(sudo xcodebuild -license accept)
  system %(open -a LastPass')
  system %(open -a Dropbox)
  system %(open -a Evernote)
  system %(open -a 'Google Chrome')
  system %(python -m pip install --upgrade pip setuptools wheel)
end

def restart_quicklook
  system %(qlmanage -r)
end

def install_homebrew
  require 'English'
  `which brew`
  run_homebrew_install unless $CHILD_STATUS.success?
end

def run_homebrew_install
  LOGGER.info "\n======================================================".blue
  LOGGER.info 'Installing Homebrew, the OSX package manager...         '.blue
  LOGGER.info 'If it\'s already installed, this will do nothing.       '.blue
  LOGGER.info '========================================================'.blue
  system 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
end

def install_common_dotfiles
  files = Rake::FileList['*'].exclude('*.log').exclude('*~') - EXCLUDE_FILES_FROM_COMMON
  files.each do |file|
    install_dotfile(file, File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"))
  end
end

def install_bin
  bin_folder = Dir['bin'][0]
  install_dotfile(bin_folder, File.join(ENV['HOME'], bin_folder))
end

def install_ssh
  move_keys

  if File.symlink?(File.join(ENV['HOME'], '.ssh'))
    LOGGER.info '~/.ssh already linked'.green
  else
    mv(Dir[File.join(ENV['HOME'], '.ssh', '*')], File.join(Dir.pwd, 'ssh'))
    install_dotfile(Dir['ssh'][0], File.join(ENV['HOME'], '.ssh'))
  end
  ensure_ssh_keys_permissions
end

def move_keys
  ssh_keys = Dir[File.join(ENV['HOME'], '.ssh', '*_rsa*')]
  mv(ssh_keys, File.join(Dir.pwd, 'ssh', 'keys'))
end

def switch_to_zsh
  if `ps -p #{Process.ppid}` =~ /zsh/
    LOGGER.info 'Already using ZSH'.green
  else
    print 'switch to zsh? (recommended) [ynq] '
    case $stdin.gets.chomp
    when 'y'
      LOGGER.info 'switching to zsh'.blue
      system %(echo $(brew --prefix)/bin/zsh | sudo tee -a /etc/shells)
      system %(chsh -s $(brew --prefix)/bin/zsh)
    when 'q'
      exit
    else
      LOGGER.info 'skipping zsh'.blue
    end
  end
end

def install_launch_agents
  LOGGER.info "\nInstalling LaunchAgents".blue
  target_dir = File.join(ENV['HOME'], 'Library', 'LaunchAgents')
  launchagents_dir = File.join('config', 'launchAgents')
  Dir.entries(launchagents_dir).each do |file|
    if !File.directory?(file) && !file.end_with?('~')
      install_dotfile(File.join(launchagents_dir, file), File.join(target_dir, file))
      system %(launchctl load #{File.join(target_dir, file)})
    end
  end
end

def install_packages
  LOGGER.info 'Installing packages'.blue
  if OSX
    system 'brew bundle --file=config/Brewfile'
  else
    mkdir_p %w(~/local/bin ~/local/build)
    ENV['LD_LIBRARY_PATH'] = File.join(ENV['HOME'], 'local/lib')
    ENV['LD_RUN_PATH'] = ENV['LD_LIBRARY_PATH']
    ENV['LDFLAGS'] = '-L' + File.join(ENV['HOME'], 'local/lib')
    ENV['CPPFLAGS'] = '-I' + File.join(ENV['HOME'], 'local/include') + ' -fPIC'
    ENV['CXXFLAGS'] = ENV['CPPFLAGS']
    ENV['CFLAGS'] = ENV['CPPFLAGS']
    # hub
    system %(curl http://hub.github.com/standalone -sLo ~/local/bin/hub && chmod +x ~/local/bin/hub)
    # ctags
    system %(cd ~/local/build; wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz; tar -zxf ctags-5.8.tar.gz; cd ctags-5.8; ./configure --prefix=$HOME/local && make -j 3 && make install)
    # readline
    system %(cd ~/local/build; wget ftp://ftp.cwru.edu/pub/bash/readline-6.2.tar.gz; tar -zxf readline-6.2.tar.gz; cd readline-6.2; ./configure --prefix=$HOME/local && make -j 3 && make install)
    # zsh
    system %(cd ~/local/build; wget http://sourceforge.net/projects/zsh/files/zsh/5.0.2/zsh-5.0.2.tar.gz; tar -zxf zsh-5.0.2.tar.gz; cd zsh-5.0.2; ./configure --prefix=$HOME/local && make -j 3 && make install)
    # autojump
    system %(cd ~/local/build; git clone git://github.com/joelthelion/autojump.git; cd autojump; git pull origin; ./install.sh --local && ln -s ~/.autojump/bin/* ~/local/bin)
    # credential
    system %(cd ~/local/build; curl -s -O http://github-media-downloads.s3.amazonaws.com/osx/git-credential-osxkeychain; chmod u+x git-credential-osxkeychain; mv git-credential-osxkeychain "$(dirname $(which hub))/")
    # bzip2
    system %(cd ~/local/build; wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz; tar -zxf bzip-1.0.6.tar.gz; cd bzip2-1.0.6; make -j 3 && make install PREFIX=$HOME/local)
  end
end

def setup_asdf
  system 'asdf-bundle'
end

def install_omz_plugins
  omz_plugins = Dir['config/oh-my-zsh/*']
  omz_plugins.each do |plugin|
    install_dotfile(plugin, File.join(ENV['HOME'], '.oh-my-zsh', 'custom', 'plugins', plugin.split('/')[-1]))
  end
end

def install_subtree(name, repo, path)
  system "git remote add -f #{name} #{repo}"
  if !File.exist?(path)
    system "git subtree add --prefix #{path} #{name} master --squash"
  end
end

def update_subtree(name, path)
  system %(git subtree pull --prefix #{path} #{name} master --squash)
end

def ensure_ssh_keys_permissions
  system %(zsh -c 'setopt extendedglob; chmod 0700 ssh/keys/^*.pub')
end

def update_gems
  system %{zsh -lc 'gem update --system; gem update'}
end
