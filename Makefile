### Makefile for Private-key restor
# To import GPG private key from usb memory
# author Minoru Yamada. 2024.10.24

.ONESHELL:
gpg: ## Restor from USB backup media
	mkdir -p ${HOME}/backup/zsh
	cd ${HOME}/backup
	sudo cp /media/minoru/USB/secret-all.key ${HOME}/backup
	sudo cp /media/minoru/USB/env.sh ${HOME}/backup
	mv -f env.sh ${HOME}/backup/zsh

	mkdir -p ~/.gnupg/private-keys-v1.d
	chmod 700 ~/.gnupg ~/.gnupg/private-keys-v1.d
	gpg --import secret-all.key
	@read -p "Are you next sure? [y,N]:" ans;
	gpg --edit-key B5312b138834c2a3 trust quit
	gpg -k
	@read -p "The process is all done. Is this okay? [y,N]:" ans;
	sudo shred -uvz secret-all.key

dotfiles: ## Clone dotfiles from Github & git-crypt unlock
	mkdir -p ${HOME}/src
	cd ~/src
	git clone git@github.com:minorugh/dotfiles.git
	cd dotfiles
	git-crypt unlock
	thunar ~/src/dotfiles


# Back up for private key
export: ## Export private keys for primary and secondary keys
	gpg -a -o secret-all.key --export-secret-keys B5312b138834c2a3

delete: ## Delete secret key after import
	shred -uvz secret-all.key
