.PHONY: all deps

all: clean deps
	./scripts/test -c nvim

deps:
	test -d /tmp/vim-gomodifytags-test/nvim-install/bin || mkdir -p /tmp/vim-gomodifytags-test/nvim-install/bin
	ln -sf /usr/local/bin/nvim /tmp/vim-gomodifytags-test/nvim-install/bin/vim
	pip install covimerage --user

clean:
	rm -f .coverage_covimerage
