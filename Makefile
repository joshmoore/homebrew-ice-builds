OUT?=mkfile1_34
DIR?=Ice-3.4.2
PKG?=zeroc-ice34
BZ2?=$(DIR).tar.bz2
MD5?=$(BZ2).md5
SSH?=josh@example.com
WWW?=/var/www/www.glencoesoftware.com/html/mac/10.7

scp: $(OUT)/$(BZ2) $(OUT)/$(MD5)
	scp $(OUT)/$(BZ2) $(SSH):$(WWW) &&\
	scp $(OUT)/$(MD5) $(SSH):$(WWW) &&\
	ssh $(SSH) openssl md5 $(WWW)/$(DIR).tar.bz2 &&\
	cat $(OUT)/$(MD5)

$(OUT)/$(MD5): $(OUT)/$(BZ2)
	openssl md5 $(OUT)/$(BZ2)> $(OUT)/$(MD5)

$(OUT)/$(BZ2): $(OUT)/$(DIR) readme test
	tar cjf $(OUT)/$(BZ2) $(OUT)/$(DIR)

test: $(OUT)/$(DIR)
	export PATH=$(OUT)/$(DIR)/bin/:$(PATH);\
	export DYLD_LIBRARY_PATH=$(OUT)/$(DIR)/lib;\
	export PYTHONPATH=$(OUT)/$(DIR)/python;\
	slice2java --version;\
	python -c "import Ice; print Ice.stringVersion()"

readme: $(OUT)/$(DIR)
	sh readme.sh > $(OUT)/$(DIR)/README

$(OUT)/$(DIR): $(OUT) install
	test -e $(OUT)/$(DIR) || cp -r `brew --prefix $(PKG)` $(OUT)/$(DIR)

$(OUT):
	test -e $(OUT) || mkdir -p $(OUT)

install:
	brew install $(PKG)

clean:
	rm -rf $(OUT)

.PHONY: test install clean
