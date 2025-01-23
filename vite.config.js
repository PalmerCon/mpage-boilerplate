import { resolve } from 'path'

export default {
  root: resolve(__dirname, 'src'),
  base: './',
  build: {
    outDir: '../dist'
  },
  server: {
    port: 8080,
    open: '/?pId=12345',
  }
}