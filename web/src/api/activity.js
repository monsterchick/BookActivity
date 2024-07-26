import request from '@/utils/request'

export function activityAdd(data) {
    return request({
        url: '/activity',
        method: 'post',
        data
    })
}


export function activityDelete(id) {
    return request({
        url: '/activity',
        method: 'delete',
        params: {
            id: id
        }
    })
}

export function activityUpdate(data) {
    return request({
        url: '/activity',
        method: 'put',
        data
    })
}

export function activityList(params) {
    return request({
        url: '/activity',
        method: 'get',
        params
    })
}

export function activityStatus(params) {
    return request({
        url: '/activity/status',
        method: 'get',
        params
    })
}

export function activitySignup(data) {
    return request({
        url: '/activity/signup',
        method: 'post',
        data
    })
}