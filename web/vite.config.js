import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            '@': path.resolve(__dirname, './src'),
            'components': '@/components',
            'views': '@/views',
        }
    },
    define: {
        'process.env': process.env
    },
    build: {
        target: 'modules',
        outDir: '../dist',
        assetsDir: 'assets',
    },
    server: {
        cors: true,
        open: true,
        port: 8080,
        hmr:true,
        proxy: {
            '^/api': {
                target: 'http://127.0.0.1:5000',
                changeOrigin: true
            },
            '^/uploads': {
                target: 'http://127.0.0.1:5000',
                changeOrigin: true
            }
        }
    }
})
