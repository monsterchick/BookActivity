import request from '@/utils/request'

// 向服务器添加书籍信息的异步请求函数
export function bookAdd(data) {
    return request({
        url: '/book',
        method: 'post',
        data
    })
}

export function bookDelete(id) {
    return request({
        url: '/book',
        method: 'delete',
        params: {
            id: id
        }
    })
}

export function bookUpdate(data) {
    return request({
        url: '/book',
        method: 'put',
        data
    })
}

export function bookList(params) {
    return request({
        url: '/book',
        method: 'get',
        params
    })
}

export function bookSearch(params) {
    return request({
        url: '/book/search',
        method: 'get',
        params
    })
}


export function bookRead(params) {
    return request({
        url: '/chapter',
        method: 'get',
        params
    })
}