# vite を typscriptで導入する

## vite を導入
```Gemfile
gem 'vite_rails'
```

```
bundle install
bundle exec vite install
rails  turbo:install stimulus:install
yarn add -D vite-plugin-full-reload
```

`vite.config.ts`を修正する
```ts:vite.config.ts
// vite.config.ts
import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
// これを追加
import FullReload from "vite-plugin-full-reload";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    // これを追加
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 100 }),
  ],
});
```

```sh
cat >> app/frontend/entrypoints/application.js << EOL
import "@hotwired/turbo-rails"
import "../../javascript/controllers"
EOL
```

bin/devが作成されないので手動で作成する
```sh
cat << EOL > bin/dev
#!/usr/bin/env sh

if ! gem list foreman -i --silent; then
  echo "Installing foreman..."
  gem install foreman
fi

exec foreman start -f Procfile.dev "\$@"
EOL
```

作成したスクリプトファイルに実行権限を付与
```
chmod +x bin/dev
```

起動確認
```
bin/dev
```

## typescript を導入

```sh
yarn add -D typescript
```

```sh
cat << EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "useDefineForClassFields": true,
    "module": "ESNext",
    "moduleResolution": "Node",
    "strict": true,
    "jsx": "preserve",
    "sourceMap": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "esModuleInterop": true,
    "lib": ["ESNext", "DOM"],
    "skipLibCheck": true,
    "allowSyntheticDefaultImports": true
  },
  "include": ["**/*.ts", "**/*.d.ts", "**/*.tsx"],
  "exclude": [
    "node_modules"
  ]
}
EOL
```

`.js`を一括で`.ts`に書き換える
```
find app/frontend app/javascript -name "*.js" -exec sh -c 'mv "$1" "${1%.js}.ts"' _ {} \;
```

`application.html.erb` を修正する
```diff erb:application.html.erb
+ <%= vite_typescript_tag 'application' %>
- <%= vite_javascript_tag 'application' %>
```

追加する
```:Procfile.dev
vite: bin/vite dev
```

## stimulus を利用する場合
`app/javascript/controllers/application.ts`で以下のエラーが発生するので対処
> プロパティ 'Stimulus' は型 'Window & typeof globalThis' に存在しません。

```sh
mkdir app/javascript/@types
cat << EOL > app/javascript/@types/index.d.ts
import { Application } from '@hotwired/stimulus';

export {};

declare global {
  interface Window {
    Stimulus: Application;
  }
}
EOL
```

`tsconfig.json`を編集する
```json:tsconfig.json
{
  "compilerOptions": {
    "typeRoots": ["./app/javascript/@types"]
  }
}
```

## 参考
https://zenn.dev/shu_illy/articles/a0ad61ef62e0d4
https://qiita.com/h-kawamoto/items/48eb32ed88219cbe744f


## スクリプトを利用
先に `gem 'vite_rails'` を Gemfile に追加しておく

```
sh setup-vite.sh
```
