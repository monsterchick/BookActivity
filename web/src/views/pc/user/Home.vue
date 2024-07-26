<script setup>
 template
// 引入Vue的Composition API中的ref和onMounted函数
import {ref, onMounted} from 'vue';
// 引入Vue Router的useRouter功能，用于导航和访问路由信息
import {useRouter} from 'vue-router';
// 从book API模块导入bookList函数，用于获取图书列表数据
import {bookList} from '@/api/book';
// 从activity API模块导入activityList函数，用于获取活动列表数据
import {activityList} from '@/api/activity';

const dataList = ref([]);//定义了一个空数组的ref实例，可以用来存储数据列表
const activityData = ref([]);
const queryInfo = ref({});
const category = ref({});

const router = useRouter();

const handleSearch = () => {
    if (queryInfo.value.keyword) {
        router.push({name: 'Search', query: {q: queryInfo.value.keyword}});
    }
};

const jumpPage = (name, id) => {
    router.push({name: name, query: {id: id}});
};

//用于获取书籍列表数据并更新数据列表
const getDataList = async () => {
    try {
        const res = await bookList();
        dataList.value = res.data.list;
    } catch (err) {
        console.error(err);
    }
};

//用于获取书籍列表数据并更新数据列表
const getActivityList = async () => {
    try {
        const res = await activityList(
            {
                page: 1,
                limit: 3
            },
        );
        activityData.value = res.data.list;
    } catch (err) {
        console.error(err);
    }
};

onMounted(() => {
    getDataList();
    getActivityList();
});
</script>

<template>
    <el-container class="layout">
        <el-row class="banner-bg">
            <el-row>
                <p class="web-name">BOOKACTIVITY</p>
            </el-row>
            <el-row class="web-description">
                Connect, Explore, Achieve with BookVoyage!
            </el-row>
            <el-row class="el-row-fix">
                <el-input
                    size="large"
                    placeholder="Search"
                    v-model="queryInfo.keyword"
                    border
                    @keyup.enter.native="handleSearch">
                </el-input>
                <el-button size="large" class="search-btn" icon="Search" type="primary"
                           @click="handleSearch"></el-button>
            </el-row>
        </el-row>

        <el-main class="main-container">
            <div class="banner-title">
                <div class="banner-name">ACTIVITY</div>
                <div class="banner-more" @click="jumpPage('Activitys',1)">
                    More
                </div>
            </div>
            <div class="activity-list">
                <el-card class="activity-item" @click="jumpPage('Activity',item.id)" v-for="item in activityData">
                    <template #header>
                        <div class="card-header">
                            <h3>{{ item.title }}</h3>
                        </div>
                    </template>
                    <p>{{ item.description }}</p>
                    <template #footer>
                        <div class="card-footer">
                            <el-icon>
                                <Timer/>
                            </el-icon>
                            <el-text type="info">
                                {{ item.start_date }} - {{ item.end_date }}
                            </el-text>
                        </div>
                    </template>
                </el-card>
            </div>
        </el-main>

        <el-main class="main-container">
            <div class="banner-title">
                <div class="banner-name">Recommend for you</div>
                <div class="banner-more" @click="jumpPage('All',1)">
                    All
                </div>
            </div>
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
        </el-main>
    </el-container>
</template>


<style scoped>
body {
    background-color: #ede8e866;
}

.main-container {
    background-color: rgba(204, 204, 204, 0.34);
}

.banner-title {
    display: flex;
    justify-content: space-between;
    width: 70%;
    margin: auto;
    height: 50px;
    padding: 20px 0;
    align-items: center;
}

.banner-name {
    font-size: 30px;
    font-weight: bolder;
    cursor: pointer;
}

.banner-more {
    font-size: 16px;
    cursor: pointer;
}

.card-footer {
    display: flex;
    justify-content: flex-start;
    align-items: center;
    gap: 5px;
}

.banner-more:hover {
    color: #56a3f3;
}


.logo > .logo-img > img {
    width: auto;
    height: 60px;
}

.web-name {
    font-size: 42px;
}

.web-description {
    font-size: 20px;
}

.banner-bg {
    background-image: url(/bg/bg.png);
    width: 100%;
    height: 400px;
    display: flex;
    color: white;
    gap: 10px;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

:deep(.el-input__wrapper) {
    border-radius: 50px;
    width: 300px;
}

.el-row-fix {
    flex-wrap: nowrap;
    align-items: center;
}

.search-btn {
    margin-left: -20px;
    width: 100px;
    z-index: 99;
    border-radius: 0 50px 50px 0;
}

.activity-list {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    width: 70%;
    margin: 10px auto;
    gap: 20px;
}

.activity-item {
    width: 100%;
    background-color: #ffffff;
    cursor: pointer;
    box-shadow: 0 5px 10px 0 rgba(17, 58, 93, 0.1);
}

.app-list {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    width: 70%;
    margin: 10px auto;
    gap: 20px;
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

.app-author {
    margin: 10px 10px;
    text-align: left;
    color: #ff8000;
}
</style>