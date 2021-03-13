# Nihar's fybox Dotfiles

Instructions fo the dotfiles repository at <https://gitlab.com/niharokz/dotfile>.

## Introduction

The dotfiles in this repository are installed using a **bare Git repository**. 
This method does not use symlinks (like most other dotfile repositories).

After the installation, all the dotfiles will be physically present in your home folder, yet, 
you will still have them under full version control.

## Usage

Now all the dotfiles from the repository are installed in your home directory. 
However, as mentioned, you still have them under full version control via the bare Git repository in `~/.dotfiles`.

To interact with the bare Git repository, you need the following alias:

~~~bash
dot='/usr/bin/git --git-dir=$HOME/.config/.dotfile --work-tree=$HOME'
~~~


Note: the [`.alias`](https://gitlab.com/niharokz/dotfile/.config/.alias) file in the dotfiles repository already contains this alias, so you're good to go.

With the `dot` alias, you can now manage the dotfiles via the bare Git repository, just as you would with the `git` command:

Edited your dotfiles? No problem, commit and push the changes:

~~~bash
dot add ~/.vimrc
dot commit -m "Edit .vimrc"
dot push
~~~

Pushed changes to the remote repository from another machine? Easy, just pull down the new version:

~~~bash
dot pull
~~~

Want to know what's going on?

~~~bash
dot status
~~~

Don't want to see untracked files:

~~~bash
dot config status.showUntrackedFiles no
~~~

## Checkout
While installing dot files in a new system:
~~~bash
git clone --bare https://gitlab.com/niharokz/dotfile.git $HOME/.config/.dotfile
dot='/usr/bin/git --git-dir=$HOME/.config/.dotfile --work-tree=$HOME'
dot checkout
~~~

## References

Using a bare Git repository is described here:

- <https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/>
