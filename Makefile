.PHONY: all deps

all: deps
	./scripts/test -c nvim

deps:
	test -d /tmp/vim-go-test/nvim-install/bin || mkdir -p /tmp/vim-go-test/nvim-install/bin
	ln -sf /usr/local/bin/nvim /tmp/vim-go-test/nvim-install/bin/vim
	pip install covimerage --user
