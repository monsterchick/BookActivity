<!-- 模板 图书搜索功能-->
<script>
import {bookSearch} from "@/api/book.js";

export default {
    data() {
        return {
            queryInfo: {
                keyword: "",
                pageNo: 1,
                pageSize: 12
            },
            dataList: [],
            total: 0
        }
    },
    mounted() {
        this.getSearchList();
    },
    methods: {
        getSearchList() {
            bookSearch(this.queryInfo).then((res) => {
                this.dataList = res.data.book || [];
            }).catch((err) => {
                console.log(err);
            });
        },
        jumpPage(name, id) {
            this.$router.push({name: name, query: {"id": id}});
        }
    }
}
</script>

<template>
    <div class="background-image">
        <el-row class="el-row-fix">
            <el-input
                size="large"
                placeholder="Search"
                v-model="queryInfo.keyword"
                border
                @keyup.enter.native="getSearchList">
            </el-input>
            <el-button size="large" class="search-btn" icon="Search" type="primary"
                       @click="getSearchList"></el-button>
        </el-row>
    </div>

    <div class="app-none" v-if="dataList.length===0">
        <el-empty description="No Results"/>
    </div>

    <div class="app-list" v-if="dataList.length>0">
        <div class="app-list">
            <div class="app-item" @click="jumpPage('Detail',item.id)" v-for="item in dataList"
                 :key="item">
                <div class="app-image">
                    <img :src="item.cover" alt="game cover">
                </div>
                <div class="app-name">
                    <el-tooltip :content="item.title" placement="top">
                        {{ item.title }}
                    </el-tooltip>
                </div>
                <div class="app-author">
                    {{ item.author }}
                </div>
                <div class="app-author">
                    <el-button type="primary" @click="jumpPage('Detail',item.id)">Read</el-button>
                </div>
            </div>
        </div>

        <template v-if="dataList.length>0">
            <div class="app-item" style="opacity: 0;cursor: default" v-for="i in dataList.length % 4" :key="i"></div>
        </template>
    </div>

</template>

<style scoped>
.background-image {
    height: 100px;
    background: linear-gradient(45deg, blue, #ff00c8);
    color: white;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 32px;
}

.app-list {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    flex-wrap: wrap;
    width: 90%;
    margin: 30px auto;
    gap: 30px;
}

.app-item {
    width: 260px;
    height: 380px;
    background-color: #ffffff;
    cursor: pointer;
    box-shadow: 0 5px 10px 0 rgba(17, 58, 93, 0.1);
}

.app-image {
    width: 260px;
    height: 260px;
    overflow: hidden;
}

.app-image > img {
    width: 260px;
    height: 100%;
    object-fit: cover;
}

.app-image > img:hover {
    transform: scale(1.2);
    transition: 0.5s;

}

.app-name {
    margin: 10px 10px;
    text-align: left;
    display: -webkit-box; /* Safari/Chrome */
    -webkit-line-clamp: 1; /* Safari/Chrome */
    -webkit-box-orient: vertical; /* Safari/Chrome */
    overflow: hidden;
}

:deep(.el-input__wrapper) {
    border-radius: 50px;
    width: 300px;
}

.el-row-fix {
    flex-wrap: nowrap;
    align-items: center;
}

.app-author {
    margin: 10px 10px;
    text-align: left;
    color: #ff8000;
}

.search-btn {
    margin-left: -20px;
    width: 100px;
    z-index: 99;
    border-radius: 0 50px 50px 0;
}

</style>