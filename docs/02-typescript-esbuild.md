### esbuild のセットアップ
```
rails  javascript:install:esbuild
rails  turbo:install stimulus:install
rails  css:install:tailwind
```

### typescripteの導入
https://blog.furu07yu.com/entry/rails7-esbuild-typescript

```sh
yarn add -D typescript tsc-watch
```

```json:package.json
"scripts": {
  "build:js": "esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds",
  "build:css": "tailwindcss -i ./app/assets/stylesheets/application.tailwind.css -o ./app/assets/builds/tailwind.css",
  "failure:js": "rm ./app/assets/builds/application.js && rm ./app/assets/builds/application.js.map",
  "dev:js": "tsc-watch --noClear -p tsconfig.json --onSuccess \"yarn build:js\" --onFailure \"yarn failure:js\""
}
```

```:Procfile.dev
web: bin/rails server -b 0.0.0.0 -p 3000
js: yarn dev:js
css: yarn build:css --watch
```
