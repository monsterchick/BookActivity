import {createRouter, createWebHashHistory} from 'vue-router'

const routes = [
    {
        path: '',
        name: 'DefaultLogin',
        component: () => import('@/views/pc/Login.vue')
    },
    {
        path: '/',
        name: 'Default',
        component: () => import('@/views/pc/Login.vue')
    },
    {
        path: '/:catchAll(.*)',
        redirect: '/dashboard'
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import('@/views/pc/Login.vue')
    },
    {
        path: '/register',
        name: 'Register',
        component: () => import('@/views/pc/Register.vue')
    },
    {
        path: '/dashboard',
        name: 'DashBoard',
        component: () => import('@/views/pc/user/DashBoard.vue'),
        children: [
            // user start
            {
                path: '',
                name: 'Home',
                component: () => import('@/views/pc/user/Home.vue')
            },
            {
                path: '/index',
                name: 'Index',
                component: () => import('@/views/pc/user/Home.vue'),
            },
            {
                path: '/search',
                name: 'Search',
                component: () => import('@/views/pc/user/Search.vue'),
            },
            {
                path: '/all',
                name: 'All',
                component: () => import('@/views/pc/user/All.vue'),
            },
            {
                path: '/detail',
                name: 'Detail',
                component: () => import('@/views/pc/user/Detail.vue'),
            },
            {
                path: '/profile',
                name: 'Profile',
                component: () => import('@/views/pc/user/Profile.vue'),
            },
            {
                path: '/activity',
                name: 'Activity',
                component: () => import('@/views/pc/user/Activity.vue'),
            },
            {
                path: '/activitys',
                name: 'Activitys',
                component: () => import('@/views/pc/user/Activitys.vue'),
            },
            // user end
        ]
    },
    {
        path: '/console',
        name: 'Console',
        component: () => import('@/views/pc/admin/Console.vue'),
        children: [
            // admin start
            {
                path: '/userlist',
                name: 'UserList',
                component: () => import('@/views/pc/admin/User.vue')
            },
            {
                path: '/booklist',
                name: 'BookList',
                component: () => import('@/views/pc/admin/Book.vue')
            },
            {
                path: '/activitylist',
                name: 'ActivityList',
                component: () => import('@/views/pc/admin/Activity.vue')
            }
            // admin end
        ]
    }
]

const router = createRouter({
    history: createWebHashHistory(process.env.BASE_URL),
    routes: routes
})

export default router
