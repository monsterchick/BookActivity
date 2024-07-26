<script>
import {activityList} from "@/api/activity.js";

export default {
    data() {
        return {
            queryInfo: {
                keyword: "",
                pageNo: 1,
                pageSize: 12
            },
            activityData: [],
            total: 0
        }
    },
    mounted() {
        this.getActivityList();
    },
    methods: {
        jumpPage(name, id) {
            this.$router.push({name: name, query: {"id": id}});
        },
        async getActivityList() {
            try {
                const res = await activityList({
                    all: "true",
                    title: this.queryInfo.keyword
                });
                this.activityData = res.data;
            } catch (err) {
                console.error(err);
            }
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
                @keyup.enter.native="getActivityList">
            </el-input>
            <el-button size="large" class="search-btn" icon="Search" type="primary"
                       @click="getActivityList"></el-button>
        </el-row>
    </div>

    <div class="app-none" v-if="activityData.length===0">
        <el-empty description="No Results"/>
    </div>

    <el-main class="main-container">
        <div class="banner-title">
            <h2>ACTIVITY</h2>
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

.banner-title {
    display: flex;
    justify-content: center;
    width: 70%;
    margin: auto;
    height: 50px;
    padding: 20px 0;
    text-align: center;
    align-items: center;
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


.app-image > img {
    width: 260px;
    height: 100%;
    object-fit: cover;
}

.app-image > img:hover {
    transform: scale(1.2);
    transition: 0.5s;

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