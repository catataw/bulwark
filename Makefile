all:
	@npm install


test: deps
	@rm -f nss-debug.log
	@$(PREFIX) node --expose-gc ./node_modules/.bin/lab -m 60000 -v


cover: deps
	@rm -f nss-debug.log cover.html
	@$(PREFIX) node --expose-gc ./node_modules/.bin/lab -m 60000 -s -c -r html -o cover.html


docs: deps
	@echo -n Generating docs...
	@rm -rf docs
	@./node_modules/.bin/jsdoc -r -d docs lib README.md
	@echo " done!"


deps:
	@if [ ! -d node_modules ]; then \
		echo "Installing dependencies.."; \
		npm install --silent; \
	fi


install-nss:
	@echo "Building NSS 3.17.4"
	@rm -rf ./tmp/nss-build
	@mkdir -p ./tmp/nss-build
	@echo "Downloading NSS source..."
	@curl -k -o ./tmp/nss-build/nss.tar.gz \
		https://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_3_17_4_RTM/src/nss-3.17.4-with-nspr-4.10.7.tar.gz
	@echo "Extracting tarball..."
	@tar -zxf ./tmp/nss-build/nss.tar.gz -C ./tmp/nss-build
	@echo "Applying Yosemite build fix patch..."
	@echo "Building source...  This might take a little bit."
	@cd ./tmp/nss-build/nss-3.17.4/nss && BUILD_OPT=1 NSS_USE_SYSTEM_SQLITE=1 USE_64=1 NSDISTMODE=copy make nss_build_all
	@echo "Moving files into place..."
	@mkdir -p /usr/local/lib
	@mkdir -p /usr/local/include/nss
	@mkdir -p /usr/local/bin
	@cp -Rf ./tmp/nss-build/nss-3.17.4/dist/*.OBJ/bin/* /usr/local/bin/
	@cp -Rf ./tmp/nss-build/nss-3.17.4/dist/*.OBJ/include/* /usr/local/include/nss/
	@cp -Rf ./tmp/nss-build/nss-3.17.4/dist/*.OBJ/lib/* /usr/local/lib/
	@rm -rf ./tmp
	@echo "NSS built successfully and installed into /usr/local"


create-nss-db:
	@rm -rf $(HOME)/.nssdb && \
	mkdir -p $(HOME)/.nssdb && \
	$(PREFIX) modutil -dbdir $(HOME)/.nssdb -create -force && \
	echo changeit > /tmp/nsspin && \
	$(PREFIX) modutil -dbdir $(HOME)/.nssdb -changepw "NSS Certificate DB" -newpwfile /tmp/nsspin -force > /dev/null && \
	rm /tmp/nsspin


.PHONY: all test cover docs deps install-nss create-nss-db