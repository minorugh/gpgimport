### Makefile for Private-key restor
# To import GPG private key from usb memory
# author Minoru Yamada. 2024.10.24

.ONESHELL:
gpg: ## Restor from USB backup media
	sudo apt install gnupg git-crypt
	mkdir -p ${HOME}/backup
	cd ${HOME}/backup
	sudo cp /media/minoru/USB/secret-all.key ${HOME}/backup

	mkdir -p ~/.gnupg/private-keys-v1.d
	chmod 700 ~/.gnupg ~/.gnupg/private-keys-v1.d
	gpg --import secret-all.key
	@read -p "Are you next sure? [y,N]:" ans;
	gpg --edit-key B5312b138834c2a3 trust quit
	gpg -k
	@read -p "The process is all done. Is this okay? [y,N]:" ans;
	sudo shred -uvz secret-all.key

dotfiles: ## Clone dotfiles from Github & git-crypt unlock
	mkdir -p ${HOME}/src/github.com/minorugh
	cd ~/src/github.com/minorugh
	git clone git@github.com:minorugh/dotfiles.git
	cd dotfiles
	git-crypt unlock
	thunar ~/src/github.com/minorugh/dotfiles

# Change shell to zsh after run make of dotfiles
# | chsh -s /usr/bin/zsh


# Back up for private key
export: ## Export private keys for primary and secondary keys
	gpg -a -o secret-all.key --export-secret-keys B5312b138834c2a3

delete: ## Delete secret key after import
	shred -uvz secret-all.key
