default: cedar cedar-14

cedar: dist/cedar/pixman-0.32.6-1.tar.gz dist/cedar/freetype-2.5.3-1.tar.gz dist/cedar/giflib-4.2.3-1.tar.gz dist/cedar/cairo-1.12.16-1.tar.gz

cedar-14: dist/cedar-14/pixman-0.32.6-1.tar.gz dist/cedar-14/freetype-2.5.3-1.tar.gz dist/cedar-14/giflib-4.2.3-1.tar.gz dist/cedar-14/cairo-1.12.16-1.tar.gz

dist/cedar/cairo-1.12.16-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/cairo-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv cairo-cedar.tar.gz $@

dist/cedar/freetype-2.5.3-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/freetype-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv freetype-cedar.tar.gz $@

dist/cedar/giflib-4.2.3-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/giflib-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv giflib-cedar.tar.gz $@

dist/cedar/pixman-0.32.6-1.tar.gz: cairo-cedar
	docker cp $<:/tmp/pixman-cedar.tar.gz .
	mkdir -p $$(dirname $@)
	mv pixman-cedar.tar.gz $@

dist/cedar-14/cairo-1.12.16-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/cairo-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv cairo-cedar-14.tar.gz $@

dist/cedar-14/freetype-2.5.3-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/freetype-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv freetype-cedar-14.tar.gz $@

dist/cedar-14/giflib-4.2.3-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/giflib-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv giflib-cedar-14.tar.gz $@

dist/cedar-14/pixman-0.32.6-1.tar.gz: cairo-cedar-14
	docker cp $<:/tmp/pixman-cedar-14.tar.gz .
	mkdir -p $$(dirname $@)
	mv pixman-cedar-14.tar.gz $@

clean:
	rm -rf src/ cedar*/*.sh dist/ cairo-cedar*/*.tar.*
	-docker rm cairo-cedar
	-docker rm cairo-cedar-14

src/cairo.tar.xz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/cairo-1.12.16.tar.xz -o $@

src/freetype.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL http://download.savannah.gnu.org/releases/freetype/freetype-2.5.3.tar.bz2 -o $@

src/giflib.tar.bz2:
	mkdir -p $$(dirname $@)
	curl -sL "http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgiflib%2F&ts=1384049147&use_mirror=softlayer-dal2" -o $@

src/pixman.tar.gz:
	mkdir -p $$(dirname $@)
	curl -sL http://cairographics.org/releases/pixman-0.32.6.tar.gz -o $@

.PHONY: cedar-stack

cedar-stack: cedar-stack/cedar.sh
	@(docker images -q mojodna/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t mojodna/$@ $@

cedar-stack/cedar.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar.sh -o $@

.PHONY: cedar-14-stack

cedar-14-stack: cedar-14-stack/cedar-14.sh
	@(docker images -q mojodna/$@ | wc -l | grep 1 > /dev/null) || \
		docker build --rm -t mojodna/$@ $@

cedar-14-stack/cedar-14.sh:
	curl -sLR https://raw.githubusercontent.com/heroku/stack-images/master/bin/cedar-14.sh -o $@

.PHONY: cairo-cedar

cairo-cedar: cedar-stack cairo-cedar/pixman.tar.gz cairo-cedar/freetype.tar.bz2 cairo-cedar/giflib.tar.bz2 cairo-cedar/cairo.tar.xz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

cairo-cedar/cairo.tar.xz: src/cairo.tar.xz
	ln -f $< $@

cairo-cedar/freetype.tar.bz2: src/freetype.tar.bz2
	ln -f $< $@

cairo-cedar/giflib.tar.bz2: src/giflib.tar.bz2
	ln -f $< $@

cairo-cedar/pixman.tar.gz: src/pixman.tar.gz
	ln -f $< $@

.PHONY: cairo-cedar-14

cairo-cedar-14: cedar-14-stack cairo-cedar-14/pixman.tar.gz cairo-cedar-14/freetype.tar.bz2 cairo-cedar-14/giflib.tar.bz2 cairo-cedar-14/cairo.tar.xz
	docker build --rm -t mojodna/$@ $@
	-docker rm $@
	docker run --name $@ mojodna/$@ /bin/echo $@

cairo-cedar-14/cairo.tar.xz: src/cairo.tar.xz
	ln -f $< $@

cairo-cedar-14/freetype.tar.bz2: src/freetype.tar.bz2
	ln -f $< $@

cairo-cedar-14/giflib.tar.bz2: src/giflib.tar.bz2
	ln -f $< $@

cairo-cedar-14/pixman.tar.gz: src/pixman.tar.gz
	ln -f $< $@
