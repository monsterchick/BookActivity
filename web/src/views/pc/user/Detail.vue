<script>
import {bookList, bookSearch, bookRead} from "@/api/book";//导入三个函数
import {Delete} from "@element-plus/icons-vue";//导入的Delete图标组件
import {commentAdd, commentDelete} from "@/api/comment.js";//導入相關兩個函數
import {ElMessage, ElMessageBox} from "element-plus";//導入elementui的兩個組件

export default {
    name: "Detail",
    components: {Delete},
    data() {
        return {
            queryInfo: {},
            book: {},
            user: {},
            more: [],
            page: 1,
            size: 1500,
            content: "",
            progress: '0%',
            comment: "",
            comments: []
        }
    },
    mounted() {
        this.queryInfo.keyword = this.$route.query.id
        this.getBookDetail()
    },
    watch: {},
    methods: {
        getBookDetail() {
            bookSearch(this.queryInfo).then((res) => {
                if (res.data) {
                    this.book = res.data.book[0]
                    this.comments = res.data.comments || [];
                }
                this.getChapter();
                this.getBookList();
            }).catch((err) => {
                console.log(err);
            });
        },

        getChapter() {
            bookRead({
                book_id: this.book.id,
                file: this.book.file,
                page: this.page,
                size: this.size
            }).then((res) => {
                this.content = res.data.content || 'No content';
                this.progress = res.data.progress || '0%';
            }).catch((err) => {
                console.log(err);
            });
        },

        getBookList() {
            bookList({page: 1, limit: 12}).then((res) => {
                this.more = res.data.list || [];
            }).catch((err) => {
                console.log(err);
            });
        },

        handleClickItem(item) {
            this.queryInfo.keyword = item.id;
            this.page = 1;
            this.getBookDetail();
            this.getChapter();
            window.scrollTo(0, 0);
        },

        handlePageChange(page = 1) {
            if (page <= 0) {
                return
            }
            this.page = page;
            this.getChapter();
            window.scrollTo(0, 500);
        },

        async handleComment() {
            const res = await commentAdd({
                book_id: this.book.id,
                user_id: this.$store.state.user.id,
                comment: this.comment
            });

            if (res.code === 200) {
                this.comment = "";
                this.getBookDetail();
                this.$message.success(res.msg);
            } else {
                this.$message.error(res.msg);
            }
        },

        async handleDeleteComment(id) {
            const ok = await ElMessageBox.confirm('Are you sure to delete this comment?', 'Warning', {
                confirmButtonText: 'Confirm',
                cancelButtonText: 'Cancel',
                type: 'warning'
            })

            if (ok !== 'confirm') {
                return
            }

            const res = await commentDelete(id);
            if (res.code === 200) {
                this.getBookDetail();
                this.$message.success(res.msg);
            } else {
                this.$message.error(res.msg);
            }
        }
    }
}
</script>

<template>
    <el-main class="main">
        <el-row style="margin-top:20px;">
            <el-container class="top-box">
                <el-header class="product-title">
                    <h2>{{ book.title }}</h2>
                </el-header>
                <el-container>
                    <el-aside width="25%">
                        <el-image class="cover" fit="contain" :src="book.cover"></el-image>
                    </el-aside>
                    <el-main class="right-panel">
                        <el-row>
                            <div class="one-card">
                                <el-row class="top-row" align="middle">
                                    <el-icon>
                                        <User/>
                                    </el-icon>

                                    <el-text type="info" size="large" style="margin-left:10px;">
                                        {{ book.author }}
                                    </el-text>
                                </el-row>
                                <el-row class="top-row" align="middle">
                                    <el-icon>
                                        <Reading/>
                                    </el-icon>
                                    <el-text type="info" size="large" style="margin-left:10px;">
                                        {{ book.category }}
                                    </el-text>
                                </el-row>
                                <el-row class="top-row" align="middle">
                                    <el-text type="info" size="large">{{ book.summary }}</el-text>
                                </el-row>
                            </div>
                        </el-row>
                    </el-main>
                </el-container>
            </el-container>
        </el-row>

        <el-row>
            <el-container class="bottom-box">
                <el-main class="bottom-box-main">
                    <el-row class="content">
                        <pre v-html="content || '<b>No More Content</b>'"></pre>
                    </el-row>

                    <el-row style="margin-top:30px;" justify="space-around" align="middle">
                        <el-row class="bottom-box-row">
                            <el-button type="primary" @click="handlePageChange(--page)">Prev</el-button>
                        </el-row>
                        <el-row class="bottom-box-row">
                            <el-text type="info" size="large">{{ progress }}</el-text>
                        </el-row>
                        <el-row class="bottom-box-row">
                            <el-button type="primary" @click="handlePageChange(++page)">Next</el-button>
                        </el-row>
                    </el-row>
                </el-main>
                <el-aside class="bottom-box-aside" width="300px">
                    <el-row class="nav-title">
                        More Book
                    </el-row>

                    <el-row v-for="item in more">
                        <el-container class="item-list" @click="handleClickItem(item)">
                            <el-aside class="item-image" width="50%">
                                <div class="el-image-box">
                                    <el-image :src="item.cover" fit="cover"></el-image>
                                </div>
                            </el-aside>
                            <el-main class="item-desc">
                                <el-row class="item-name">
                                    <el-tooltip placement="top" :content="item.title">{{ item.title }}</el-tooltip>
                                </el-row>
                                <el-row class="item-author">
                                    {{ item.author }}
                                </el-row>
                            </el-main>
                        </el-container>
                    </el-row>
                </el-aside>
            </el-container>
        </el-row>

        <el-row justify="center" align="middle">
            <el-container class="bottom-box">
                <el-main class="bottom-box-main">
                    <el-row justify="center" align="middle">
                        <h1>Post Comments</h1>
                    </el-row>

                    <el-row style="margin:10px auto;">
                        <el-input v-model="comment" rows="5" type="textarea" placeholder="Please input"
                                  style="width: 100%;"></el-input>
                    </el-row>

                    <el-row>
                        <el-button type="primary" @click="handleComment">Comment</el-button>
                    </el-row>
                </el-main>
            </el-container>
        </el-row>

        <el-row justify="center" align="middle">
            <el-container class="bottom-box">
                <el-main class="bottom-box-main">
                    <el-row justify="center" align="middle">
                        <h1>Comments List</h1>
                    </el-row>

                    <el-row v-if="comments.length === 0" justify="center" align="middle" style="margin-top:20px;">
                        Not Comment
                    </el-row>

                    <el-row class="comment-list">
                        <el-card class="activity-item" v-for="item in comments">
                            <template #header>
                                <el-row justify="start" align="middle">
                                    <el-avatar :src="item.user.avatar" size="30" fit="cover" style="margin-right:10px;">
                                        >
                                    </el-avatar>
                                    {{ item.user.username }}
                                </el-row>
                            </template>
                            <p>{{ item.comment }}</p>
                            <template #footer>
                                <el-row justify="space-between" align="middle">
                                    <el-row justify="start" align="middle">
                                        <el-icon>
                                            <Timer/>
                                        </el-icon>
                                        <el-text type="info" style="margin-left:5px;">
                                            {{ item.created_at }}
                                        </el-text>
                                    </el-row>
                                    <el-row justify="end" align="middle">
                                        <el-icon v-if="this.$store.state.user.id === item.user.id"
                                                 @click="handleDeleteComment(item.id)">
                                            <Delete/>
                                        </el-icon>
                                    </el-row>
                                </el-row>
                            </template>
                        </el-card>
                    </el-row>
                </el-main>
            </el-container>
        </el-row>
    </el-main>
</template>

<style scoped>
.main {
    width: 70%;
    max-width: 1200px;
    margin: auto;
}

.row {
    margin: 15px 0;
}

.top-box {
    background-color: white;
    padding: 40px;
}

.product-title {
    text-align: left;
    padding: 0;
    margin-bottom: 20px;
}

.tips-panel {
    background-color: #efefef;
    padding: 20px;
    text-align: left;
}

.one-card {
    padding: 20px 10px;
    display: flex;
    width: 100%;
    flex-direction: column;
    gap: 10px;
    justify-content: space-between;
    align-items: flex-start;
    background: url(data:image/jpg;base64,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);
}

pre {
    font-size: 18px;
    white-space: pre-wrap;
    white-space: -moz-pre-wrap;
    word-wrap: break-word;
}

.bottom-row {
    display: flex;
    justify-content: flex-start;
    align-items: center;
}

.pay-member {
    margin-left: 10px;
}

.cover {
    width: 100%;
    height: 300px;
}

.right-panel {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.bottom-box {
    width: 100%;
    margin: 30px auto;
    background-color: whitesmoke;
}

.bottom-box-main {
    background-color: white;
    width: 100%;
}

:deep(main.bottom-box-main img) {
    width: 100%;
}

.nav-title {
    font-size: 18px;
    margin: 10px;
}

.bottom-box-aside {
    max-height: 1300px;
    margin-left: 30px;
    padding: 20px;
    background-color: white;
}

.item-image {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-left: 10px;
    height: 80px;
}

.el-image-box {
    height: 70px;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
}

.item-desc {
    display: flex;
    justify-content: center;
    align-items: flex-start;
    flex-direction: column;
    gap: 20px;
    padding: 10px;
    font-size: 13px;
    text-align: left;
}

.item-name {
    display: -webkit-box; /* Safari/Chrome */
    -webkit-line-clamp: 2; /* Safari/Chrome */
    -webkit-box-orient: vertical; /* Safari/Chrome */
    overflow: hidden;
}

.item-author {
    color: red;
}

.item-list {
    margin: 5px auto;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
}

.item-list:hover {
    background-color: rgba(44, 62, 80, 0.13);
}

.el-row-fix {
    margin: 20px auto;
}

.comment-list {
    width: 100%;
    margin: 20px auto;
    display: flex;
    flex-direction: column;
    gap: 20px;
}
</style>