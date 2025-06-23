
# \\_____
# // Tobias Becker / fli4l<at>becker<dot>link
#

RELEASE_TAG = v1.0.0
RELEASE_NAME = build / fli4l-fbr+2024.11.1
FOLDER = _fli4l-fbr+2024.11.1
ARCHIVE = $(FOLDER).tar.gz
ENCRYPTED = $(ARCHIVE).gpg

GITHUB_TOKEN := $(shell cat ~/.github_token)
GPG_PASSPHRASE_FILE = ~/.github_repo-fli4l-storage.gpg

pack:
	@echo "-> create $(ARCHIVE) from $(FOLDER) ..."
	@tar -czf $(ARCHIVE) $(FOLDER)

encrypt: pack
	@echo "-> encrypt $(ARCHIVE) with $(GPG_PASSPHRASE_FILE) ..."
	@gpg --batch --yes --symmetric --cipher-algo AES256 \
		--passphrase-file $(GPG_PASSPHRASE_FILE) \
		--output $(ENCRYPTED) $(ARCHIVE)

upload: encrypt
	@echo "-> auth GitHub CLI with token from ~/.git-credentials ..."
	@echo "$(GITHUB_TOKEN)" | gh auth login --with-token > /dev/null
	@echo "-> upload $(ENCRYPTED) / release $(RELEASE_TAG) ..."
	@gh release create $(RELEASE_TAG) --title "$(RELEASE_NAME)" --notes-file "RELEASE_NOTES.md" || true
	@gh release upload $(RELEASE_TAG) $(ENCRYPTED) --clobber

all: upload

clean:
	@rm -f $(ARCHIVE) $(ENCRYPTED)

# ---//
