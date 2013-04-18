require 'rake'
require 'erb'
require 'fileutils'

EXCLUDE_COMMON = %w[Rakefile README.md LICENSE TODO.md KeyRemap4MacBook bin box config ssh powerline tmp]

desc "Create symbolic links and generate files in #{ENV['HOME']} without overwriting existing files"
task '' => :install

namespace :update do
  desc "Update vundle"
  task :vundle do
    @update_vundle = true
    Rake::Task['install:vim'].invoke
  end

  desc "Update Powerline"
  task :powerline do
    puts "Updating powerline"
    update_powerline
  end

  desc "Update Homebrew"
  task :brew do
      if RUBY_PLATFORM.downcase.include?("darwin")
          puts "\nUpdate brew"
          system %Q{brew update}
          system %Q{brew upgrade}
      end
  end

  desc "Update Ruby Gems"
  task :gems do
      puts "\nUpdate gems"
      system %Q{gem update --system}
      # system %Q{gem update} # FIXME get to use global gemset before update
  end

  desc "Update Node"
  task :node do
      puts "\nUpdate node"
      system %Q{npm update npm@latest -g}
      system %Q{npm update -g}
  end

  desc "Update submodules"
  task :submodule do
      puts "Update submodules"
      system %Q{git submodule foreach git pull origin master}
  end

  desc "Update all"
  task :all => [:vundle, :powerline, :node, :brew, :gems, :submodule] do
  end
end

namespace :install do
  desc "Delete and recreate symbolic links and generated files in #{ENV['HOME']}"
  task :force do
  end

  desc "Switch to ZSH"
  task :zsh do
    switch_to_zsh
  end

  desc "Setup KeyRemap4MacBook profile"
  task :kr4mb do
    install_kr4mb if RUBY_PLATFORM.downcase.include?("darwin")
  end

  desc "Install Vundle and execute VundleInstall"
  task :vim do
    setup_vim
  end

  desc "Setup ~/bin"
  task :bin do
    install_bin
  end

  desc "Symlink dotfiles and folders to #{ENV['HOME']}"
  task :common do
    install_common_dotfiles
  end

  desc "Setup ~/.ssh folder without overwriting currently existing files"
  task :ssh do
    install_ssh
  end

  desc "Install Homebrew if OS X"
  task :brew do
    install_homebrew if RUBY_PLATFORM.downcase.include?("darwin")
  end

  desc "Install powerline"
  task :powerline do
    install_powerline
  end

  desc "Install fonts"
  task :fonts do
    install_fonts if RUBY_PLATFORM.downcase.include?("darwin")
  end

  desc "Install all"
  task :all => %w{
                  zsh
                  vim
                  kr4mb
                  bin
                  common
                  ssh
                  brew
                  fonts
                  powerline
                            } do
  end
end

desc "Create symbolic links and generate files in #{ENV['HOME']} without overwriting existing files"
task :install => ['install:all'] do
end

desc "Update everything"
task :update => ['update:all'] do

end

task :default => :install

class String
  def replace_home
    self.gsub(ENV['HOME'],'~')
  end
end

def install_homebrew
  rval = %x{which brew}
  unless $?.success?
    puts "\n======================================================"
    puts "Installing Homebrew, the OSX package manager...If it's"
    puts "already installed, this will do nothing."
    puts "======================================================"
    system %{ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"}
  end

  puts
  puts
  puts "\n======================================================"
  puts "Installing Homebrew packages...There may be some warnings."
  puts "======================================================"
  system %{brew install coreutils ctags git git-flow readline hub wget zsh vim}
  puts
end


def install_dotfile(file, target_file)
  if File.exist?(target_file)
    if File.identical? file, target_file
      puts "identical #{target_file.replace_home}"
    elsif @replace_all
      replace_file(file)
    else
      print "overwrite #{target_file.replace_home}? [ynaq] "
      case $stdin.gets.chomp
      when 'a'
        @replace_all = true
        replace_file(file)
      when 'y'
        replace_file(file)
      when 'q'
        exit
      else
        puts "skipping #{target_file.replace_home}"
      end
    end
  else
    link_file(file, target_file)
  end
end

def install_common_dotfiles
  files = Dir['*'] - EXCLUDE_COMMON - Dir['*~']
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
    puts "~/.ssh already linked"
  else
    FileUtils.mv(Dir[File.join(ENV['HOME'], '.ssh','*')], File.join(Dir.pwd, 'ssh'))
    install_dotfile(Dir['ssh'], File.join(ENV['HOME'], '.ssh'))
  end
end

def move_keys
  ssh_keys = Dir[File.join(ENV['HOME'], '.ssh', '*_rsa*')]
  FileUtils.mv(ssh_keys, File.join(Dir.pwd, 'ssh', 'keys'))
end

def install_kr4mb
  kr4mb_file = Dir['KeyRemap4MacBook/*'][0]
  install_dotfile(kr4mb_file, File.join(ENV['HOME'],'Library/Application Support', kr4mb_file))
end

def replace_file(file)
  puts "Replacing ~/.#{file}"
  system %Q{rm -rf "$HOME/.#{file.sub(/\.erb$/, '')}"}
  link_file(file)
end

def link_file(file, target = File.join(ENV['HOME'], ".#{file.sub(/\.erb$/, '')}"))
  if file =~ /.erb$/
    puts "generating #{target.replace_home}"
    File.open(target, 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking #{target.replace_home}"
    File.symlink(File.join(Dir.pwd,file), target) # system %Q{ln -s "$PWD/#{file}" "#{target}"}
  end
end

def setup_vim
  clone_vundle
  install_vim_bundles
end

def clone_vundle
  if File.exist?('vim/bundle/vundle/.git')
    puts 'Vundle already installed'
  else
    not(system %Q{git clone https://github.com/gmarik/vundle.git vim/bundle/vundle}) && 'Could not clone Vundle'
  end
end

def install_vim_bundles
  run_vim = "vim +BundleInstall! +qall"
  if @update_vundle
    puts 'Updating Vim Bundles'
    not(system run_vim) && 'Error installing bundles'
  else
    puts 'Installing Vim Bundles'
    not(system run_vim.gsub('!','')) && 'Error installing bundles'
  end
end


def switch_to_zsh
  if `ps -p #{Process::ppid}` =~ /zsh/
    puts "Already using ZSH"
  else
    print "switch to zsh? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "switching to zsh"
      system %Q{chsh -s `which zsh`}
    when 'q'
      exit
    else
      puts "skipping zsh"
    end
  end
end

def install_powerline
  puts "Installing powerline"
  system %{brew install python libgit2}
  update_powerline
  FileUtils.mkdir_p(File.join(ENV['HOME'], '.config'))
  install_dotfile(Dir['powerline'], File.join(ENV['HOME'], '.config', 'powerline'))
end

def update_powerline
  system %{pip install -U --user git+git://github.com/Lokaltog/powerline}
  system %{pip install -U pygit2 mercurial psutil}
end

def install_fonts
  puts "Installing Fonts"
  FileUtils.mkdir_p('tmp')
  %x{wget -q http://sourceforge.net/projects/sourcecodepro.adobe/files/latest/download\?source\=files -O tmp/source_code_pro_latest.zip}
  %x{unzip tmp/source_code_pro_latest.zip -d tmp/}
  font_paths = Dir['tmp/SourceCodePro*/OTF/*'] + Dir[File.join('config', 'powerline-fonts' ,'*', '*.otf')]
  FileUtils.cp(font_paths, File.join(ENV['HOME'], 'Library', 'Fonts'))
  clean_temp
end

def clean_temp
  puts "Cleaning tmp"
  FileUtils.rm_r(Dir['tmp/*'])
end
