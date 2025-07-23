import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  plugins: [RubyPlugin()],
  esbuild: {
    loader: 'jsx',
    include: /app\/frontend\/.*\.jsx?$/,
    jsx: 'transform',
    jsxFactory: 'React.createElement',
    jsxFragment: 'React.Fragment'
  }
})