# Compare ./theme/base.html
# with /home/reivilo/.venvs/mkdocs/lib/python3.11/site-packages/material/base.html

all:
	@echo "=== Build MkDocs"
	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs build
#	~/.local/bin/mkdocs build
#	bash /Users/ReiVilo/Documents/emCode/MkDocs/MkDocs/do_build.sh
#   python -m mkdocs build # Windows
	@echo "=== Build done"

build: all

serve:
	@echo "=== Serve MkDocs"
#	open http://127.0.0.1:8000
	firefox http://127.0.0.1:8000 &
	# ~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs serve
	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs serve --dirtyreload
#	bash /Users/ReiVilo/Documents/emCode/MkDocs/MkDocs/do_serve.sh
#   python -m mkdocs serve # Windows
#	~/.local/bin/mkdocs serve
	@echo "=== Serve done"

github:
	@echo "=== Generate GitHub MkDocs"

	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs gh-deploy
	@echo "=== Generate GitHub done"

FILE1=$(shell pwd)/theme/base.html
FILE2=/home/reivilo/.venvs/mkdocs/lib/python3.11/site-packages/material/templates/base.html

update:
	echo "=== Update MkDocs"
	mkdir -p ~/.venvs
	python3 -m venv ~/.venvs/mkdocs
	~/.venvs/mkdocs/bin/python -m pip install --upgrade --upgrade-strategy only-if-needed mkdocs mkdocs-material mkdocs-plugin-progress mkdocs-htmlproofer-plugin mkdocs-macros-plugin mkdocs-git-revision-date-localized-plugin pymdown-extensions
#	/usr/local/bin/pip install --user --upgrade --upgrade-strategy only-if-needed mkdocs
#	/usr/local/bin/pip install --user --upgrade --upgrade-strategy only-if-needed mkdocs-material
#	pip install --upgrade --upgrade-strategy only-if-needed mkdocs mkdocs-material mkdocs-plugin-progress mkdocs-htmlproofer-plugin mkdocs-macros-plugin
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-material
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-plugin-progress
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-htmlproofer-plugin
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-macros-plugin
#
#	@echo "Compare ./theme/base.html"
#	@echo "with /home/reivilo/.venvs/mkdocs/lib/python3.11/site-packages/material/base.html"
	@echo "Compare $(FILE1)"
	@echo "with $(FILE2)"
	meld $(FILE1) $(FILE2)
	@echo "=== Update done"

.PHONY: all, serve, update
