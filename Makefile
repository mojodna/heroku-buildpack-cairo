default: cedar-14

cedar-14: dist/cedar-14/pixman-0.34.0-1.tar.gz dist/cedar-14/freetype-2.6.5-1.tar.gz dist/cedar-14/giflib-4.2.3-1.tar.gz dist/cedar-14/pango-1.40.1-1.tar.gz dist/cedar-14/cairo-1.14.6-1.tar.gz dist/cedar-14/fontconfig-2.12.1-1.tar.gz dist/cedar-14/harfbuzz-1.3.0-1.tar.gz

dist/cedar-14/cairo-1.14.6-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/cairo-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv cairo-cedar-14.tar.gz $@

dist/cedar-14/fontconfig-2.12.1-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/fontconfig-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv fontconfig-cedar-14.tar.gz $@

dist/cedar-14/freetype-2.6.5-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/freetype-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv freetype-cedar-14.tar.gz $@

dist/cedar-14/giflib-4.2.3-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/giflib-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv giflib-cedar-14.tar.gz $@

dist/cedar-14/harfbuzz-1.3.0-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/harfbuzz-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv harfbuzz-cedar-14.tar.gz $@

dist/cedar-14/pango-1.40.1-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/pango-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv pango-cedar-14.tar.gz $@

dist/cedar-14/librsvg-2.41.1.tar.xz: cairo-cedar-14
	docker cp $<:/tmp/librsvg-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv librsvg-cedar-14.tar.gz $@

dist/cedar-14/pixman-0.34.0-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/pixman-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv pixman-cedar-14.tar.gz $@

clean:
	rm -rf src/ cedar*/*.sh dist/ cairo-cedar*/*.tar.*
	-docker rm cairo-cedar-14

src/cairo.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/cairo-1.14.6.tar.xz -o $@

src/fontconfig.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2 -o $@

src/freetype.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://download.savannah.gnu.org/releases/freetype/freetype-2.6.5.tar.bz2 -o $@

src/giflib.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL "http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgiflib%2F&ts=1384049147&use_mirror=softlayer-dal2" -o $@

src/harfbuzz.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.0.tar.bz2 -o $@

src/pango.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.1.tar.xz -o $@

src/librsvg.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL https://download.gnome.org/sources/librsvg/2.41/librsvg-2.41.1.tar.xz -o $@

src/pixman.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/pixman-0.34.0.tar.gz -o $@

.PHONY: cedar-14-stack

cedar-14-stack: cedar-14-stack/cedar-14.sh
	@docker pull daylon/$@ && \
		(docker images -q daylon/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t daylon/$@ $@

cedar-14-stack/cedar-14.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar-14.sh -o $@

.PHONY: cairo-cedar-14

cairo-cedar-14: cedar-14-stack cairo-cedar-14/pixman.tar.gz cairo-cedar-14/freetype.tar.bz2 cairo-cedar-14/giflib.tar.bz2 cairo-cedar-14/cairo.tar.xz cairo-cedar-14/pango.tar.xz  cairo-cedar-14/librsvg.tar.xz cairo-cedar-14/fontconfig.tar.bz2 cairo-cedar-14/harfbuzz.tar.bz2
	docker build --rm -t daylon/$@ $@
	-docker rm $@
	docker run --name $@ daylon/$@ /bin/echo $@

cairo-cedar-14/cairo.tar.xz: src/cairo.tar.xz
	ln -f $< $@

cairo-cedar-14/fontconfig.tar.bz2: src/fontconfig.tar.bz2
	ln -f $< $@

cairo-cedar-14/freetype.tar.bz2: src/freetype.tar.bz2
	ln -f $< $@

cairo-cedar-14/giflib.tar.bz2: src/giflib.tar.bz2
	ln -f $< $@

cairo-cedar-14/harfbuzz.tar.bz2: src/harfbuzz.tar.bz2
	ln -f $< $@

cairo-cedar-14/pango.tar.xz: src/pango.tar.xz
	ln -f $< $@

cairo-cedar-14/librsvg.tar.xz: src/librsvg.tar.xz
	ln -f $< $@

cairo-cedar-14/pixman.tar.gz: src/pixman.tar.gz
	ln -f $< $@
