# AntonFriberg's Dotfiles

My setup on an ArchLinux machine. Currently running i3-gaps window manager with
polybar, rofi application launcher, urxvt terminal and compton compositor.

Based on the [nord colorscheme].

[nord colorscheme]: https://github.com/arcticicestudio/nord

Clean
![Clean](https://i.imgur.com/7cNYKKc.jpg)

Dirty
![Dirty](https://i.imgur.com/7T03pjZ.png)

Editor
![Editor](https://i.imgur.com/K0FzPY9.png)

I recently found a simple way to keep my dotfiles under version control on the [Atlassian developer blog]. This technique is great since according to comments on HN requires:
> No extra tooling, no symlinks, files are tracked on a version control system, you can use different branches for different computers, you can replicate you configuration easily on new installation.

## Starting from scratch
Create a bare git repository in your home catalog and alias a command to handle the git commands.

```zsh
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

echo -e 'function config {\n  /usr/bin/git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}" "${@}"\n}' >> $HOME/.zshrc
```

## Usage example
```zsh
config status
config add .zshrc
config commit -m "Add zshrc"
config add .Xresources
config commit -m "Add Xresources"
config push
```

## Installing dotfiles onto a new system
Add alias to .zshrc
```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Make sure that the source repo ignores the folder where you'll clone it, so that you don't create weird recursion problems:
```
echo ".dotfiles" >> .gitignore
```
Clone the dotfiles into a bare repository in a "dot" folder on your $HOME:
```
git clone --bare <git-repo-url> $HOME/.dotfiles
```
Source the .zshrc to add the config alias and checkout the content from the bare repository to your $HOME:
```
config checkout
```
This command might fail if you already have some configuration files present that may conflict with the ones in the Git repo. Backup the files if you care about or just run:
```
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```
Configure the git repo to not show untracked files:
```
config config --local status.showUntrackedFiles no
```
Then you are done!

Installation script for convenience:

```sh
git clone --bare git@github.com/AntonFriberg/dotfiles.git $HOME/.dotfiles
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
```
[atlassian developer blog]: https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

## External dependencies

### Nano syntax highlighting

```
git clone git@github.com:scopatz/nanorc.git ~/.nano
```
