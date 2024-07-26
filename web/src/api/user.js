import request from '@/utils/request'

/* 发起登录请求的方法 */
export function userLogin(data) {
    return request({
        url: '/login',
        method: 'post',
        data,
    })
}

export function userRegister(data) {
    return request({
        url: '/register',
        method: 'post',
        data,
    })
}

export function userDelete(ids) {
    return request({
        url: '/user',
        method: 'delete',
        params: {
            id: ids
        }
    })
}

export function userAdd(data) {
    return request({
        url: '/user',
        method: 'post',
        data
    })
}

export function userUpdate(data) {
    return request({
        url: '/user',
        method: 'put',
        data
    })
}

export function userList(params) {
    return request({
        url: '/user',
        method: 'get',
        params
    })
}