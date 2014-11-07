# heroku-buildpack-cairo

I am a Heroku buildpack that installs [Cairo](http://cairographics.org/) and
its dependencies ([Pixman](http://pixman.org/) and
[FreeType](http://www.freetype.org/)) into a dyno slug.

When used with
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi),
I enable subsequent buildpacks / steps to link to this library.

## Using

### Composed

You'll almost certainly want to use this in conjunction with one or more
additional buildpack.

When creating a new Heroku app:

```bash
heroku apps:create -b https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-cairo.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

When modifying an existing Heroku app:

```bash
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

cat << EOF > .buildpacks
https://github.com/mojodna/heroku-buildpack-cairo.git
https://github.com/heroku/heroku-buildpack-nodejs.git
EOF

git push heroku master
```

## Building

This uses Docker to build against Heroku
[stack-image](https://github.com/heroku/stack-images)-like images.

```bash
make
```

Artifacts will be dropped in `dist/`.  See `Dockerfile`s for build options.
