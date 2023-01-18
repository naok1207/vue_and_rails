#!/bin/bash
cat << EOL > vite.config.ts
import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import FullReload from "vite-plugin-full-reload";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 100 }),
  ],
});
EOL
bundle install
bundle exec vite install
rails  turbo:install stimulus:install
yarn add -D typescript vite-plugin-full-reload
cat >> app/frontend/entrypoints/application.js << EOL
import "@hotwired/turbo-rails"
import "../../javascript/controllers"
EOL
cat << EOL > bin/dev
#!/usr/bin/env sh

if ! gem list foreman -i --silent; then
  echo "Installing foreman..."
  gem install foreman
fi

exec foreman start -f Procfile.dev "\$@"
EOL
chmod +x bin/dev
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
    "allowSyntheticDefaultImports": true,
    "typeRoots": ["./app/javascript/@types"]
  },
  "include": ["**/*.ts", "**/*.d.ts", "**/*.tsx"],
  "exclude": [
    "node_modules"
  ]
}
EOL
find app/frontend app/javascript -name "*.js" -exec sh -c 'mv "$1" "${1%.js}.ts"' _ {} \;
sed -i 's/vite_javascript_tag/vite_typescript_tag/g' app/views/layouts/application.html.erb
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
