# heroku-buildpack-cairo

I am a Heroku buildpack that installs [Cairo](http://cairographics.org/) and
its dependencies ([Pixman](http://pixman.org/) and
[FreeType](http://www.freetype.org/)) into a dyno slug.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to this library.  (You'll
need to use the `build-env` branch of [@mojodna's
fork](https://github.com/mojodna/heroku-buildpack-multi/tree/build-env) for the
build environment (`CPATH`, `LIBRARY_PATH`, etc.) to be set correctly.)

## Using

### Composed

You'll almost certainly want to use this in conjunction with one or more
additional buildpack.

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-cairo.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/mojodna/heroku-buildpack-multi.git#build-env

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-cairo.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

## Building

Cairo et al were built in a [cedar stack
image](https://github.com/heroku/stack-images) using the following steps.

`chroot` preparation:

```bash
mkdir app tmp
sudo /vagrant/bin/install-stack cedar64-2.0.0.img.gz
sudo mount -o bind /dev /mnt/stacks/cedar64-2.0.0/dev/
sudo mount -o bind /home/vagrant/tmp /mnt/stacks/cedar64-2.0.0/tmp/
sudo mount -o bind /home/vagrant/app /mnt/stacks/cedar64-2.0.0/app/
```

Preparation:

```bash
cd tmp/
curl -LO http://cairographics.org/releases/pixman-0.30.2.tar.gz \
     -LO http://cairographics.org/releases/cairo-1.12.16.tar.xz \
     -LO http://download.savannah.gnu.org/releases/freetype/freetype-2.5.0.tar.bz2 \
     -L "http://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgiflib%2F&ts=1384049147&use_mirror=softlayer-dal" -o giflib-4.2.3.tar.bz2
sudo chroot /mnt/stacks/cedar64-2.0.0
```

Pixman build/package:

```bash
cd /tmp
tar zxf pixman-0.30.2.tar.gz
cd pixman-0.30.2/
./configure --prefix=/app/vendor/pixman
make -j4
make install
cd /app/vendor/pixman
tar zcf /tmp/pixman-0.30.2-1.tar.gz .
```

FreeType build/package:

```bash
cd /tmp
tar jxf freetype-2.5.0.tar.bz2
cd freetype-2.50.0/
./configure --prefix=/app/vendor/freetype
make -j4
make install
cd /app/vendor/freetype
tar zcf /tmp/freetype-2.5.0-1.tar.gz .
```

Cairo build/package:

```bash
cd /tmp
tar xf cairo-1.12.16.tar.xz
cd cairo-1.12.16/
PKG_CONFIG_PATH=/app/vendor/pixman/lib/pkgconfig:/app/vendor/freetype/lib/pkgconfig \
  ./configure --prefix=/app/vendor/cairo
make -j4
make install
cd /app/vendor/cairo
tar zcf /tmp/cairo-1.12.16-1.tar.gz .
```

giflib build/package:

```bash
cd /tmp
tar jxf giflib-4.2.3.tar.bz2
cd giflib-4.2.3/
./configure --prefix=/app/vendor/giflib
make -j4
make -j4 install-exec
cd /app/vendor/giflib
tar zcf /tmp/giflib-4.2.3-1.tar.gz .
```
