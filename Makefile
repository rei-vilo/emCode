all:
	@echo "=== Build MkDocs"
	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs build
#	~/.local/bin/mkdocs build
#	bash /Users/ReiVilo/Documents/emCode/MkDocs/MkDocs/do_build.sh
#   python -m mkdocs build # Windows
	@echo "=== Build done"

serve:
	@echo "=== Serve MkDocs"
#	open http://127.0.0.1:8000
	firefox http://127.0.0.1:8000 &
	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs serve
#	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs serve --dirtyreload
#	bash /Users/ReiVilo/Documents/emCode/MkDocs/MkDocs/do_serve.sh
#   python -m mkdocs serve # Windows
#	~/.local/bin/mkdocs serve
	@echo "=== Serve done"

github:
	@echo "=== GitHub MkDocs"
	~/.venvs/mkdocs/bin/python ~/.venvs/mkdocs/bin/mkdocs gh-deploy
	@echo "=== GitHub done"

update:
	echo "=== Update MkDocs"
	mkdir -p ~/.venvs
	python3 -m venv ~/.venvs/mkdocs
	~/.venvs/mkdocs/bin/python -m pip install --upgrade --upgrade-strategy only-if-needed mkdocs mkdocs-material mkdocs-plugin-progress mkdocs-htmlproofer-plugin mkdocs-macros-plugin mkdocs-git-revision-date-localized-plugin mkdocs-material-extensions
#	/usr/local/bin/pip install --user --upgrade --upgrade-strategy only-if-needed mkdocs
#	/usr/local/bin/pip install --user --upgrade --upgrade-strategy only-if-needed mkdocs-material
#	pip install --upgrade --upgrade-strategy only-if-needed mkdocs mkdocs-material mkdocs-plugin-progress mkdocs-htmlproofer-plugin mkdocs-macros-plugin
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-material
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-plugin-progress
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-htmlproofer-plugin
# 	pip install --upgrade --upgrade-strategy only-if-needed mkdocs-macros-plugin
#
	@echo "=== Update done"

.PHONY: all, serve, update
