<script>
import {activityList, activitySignup, activityStatus} from "@/api/activity";
import * as echarts from 'echarts';

export default {
    name: "Activity",
    data() {
        return {
            queryInfo: {},
            activity: {},
            ranks: [],
            is_signup: false,
            count_signup: 0
        }
    },
    mounted() {
        this.queryInfo.id = this.$route.query.id
        this.getActDetail();
        this.handleGetStatus();
    },
    methods: {
        getActDetail() {
            activityList(this.queryInfo).then((res) => {
                if (res.data) {
                    this.activity = res.data.activity
                    this.ranks = res.data.ranks || [];
                    if (this.ranks.length > 0) {
                        this.renderRank(this.ranks);
                    }
                }
            }).catch((err) => {
                console.log(err);
            });
        },

        renderRank(ranks) {
            var chartDom = document.getElementById('rank');
            console.log(chartDom)
            var myChart = echarts.init(chartDom);
            var option;

            let unit = this.activity.type === 'TimeBased' ? 'Minutes' : 'Books'

            option = {
                title: {
                    text: this.activity.title,
                    subtext: this.activity.type + ' Rank' + '(unit: ' + unit + ')'
                },
                tooltip: {
                    trigger: 'axis',
                    axisPointer: {
                        type: 'shadow'
                    }
                },
                legend: {},
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                xAxis: {
                    type: 'value',
                    boundaryGap: [0, 0.01]
                },
                yAxis: {
                    type: 'category',
                    data: ranks.map(item => item.user.username)
                },
                series: [
                    {
                        name: this.activity.type === 'TimeBased' ? 'Time' : 'Quantity',
                        type: 'bar',
                        data: ranks.map(item => Math.round(item.value / 60, 2))
                    }
                ]
            };

            option && myChart.setOption(option);

        },

        async handleGetStatus() {
            const res = await activityStatus({
                user_id: this.$store.state.user.id,
                activity_id: this.$route.query.id
            });

            if (res.code === 200) {
                this.is_signup = res.data.status;
                this.count_signup = res.data.count;
            }
        },

        async handleSubmit() {
            const res = await activitySignup({
                activity_id: this.activity.id,
                user_id: this.$store.state.user.id,
                type: this.activity.type,
            });

            if (res.code === 200) {
                this.$message({
                    message: 'Sign up successfully!',
                    type: 'success'
                });
            } else {
                this.$message({
                    message: res.msg,
                    type: 'error'
                });
            }
        }
    }
}
</script>

<template>
    <el-main class="main">
        <el-row style="margin-top:20px;">
            <el-container class="top-box">
                <el-container>
                    <el-main class="right-panel">
                        <el-row>
                            <div class="one-card">
                                <el-row class="product-title">
                                    <h2>{{ activity.title }}</h2>
                                </el-row>
                                <el-row class="top-row" align="middle">
                                    <el-icon>
                                        <Timer/>
                                    </el-icon>
                                    <el-text type="info" size="large" style="margin-left:10px;">
                                        {{ activity.start_date }} - {{ activity.end_date }}
                                    </el-text>
                                </el-row>
                                <el-row class="top-row" align="middle">
                                    <el-icon>
                                        <el-icon>
                                            <Histogram/>
                                        </el-icon>
                                    </el-icon>
                                    <el-text type="info" size="large" style="margin-left:10px;">
                                        {{ activity.type }}
                                    </el-text>
                                </el-row>
                                <el-row class="top-row" align="middle">
                                    <pre v-html="activity.description"></pre>
                                </el-row>
                            </div>
                        </el-row>
                    </el-main>
                </el-container>
            </el-container>
        </el-row>

        <el-row justify="center" align="middle">
            <el-container class="bottom-box">
                <el-main class="bottom-box-main">
                    <el-row justify="center" align="middle">
                        <h1>Sign Up</h1>
                    </el-row>
                    <el-row justify="center" align="middle">
                        <el-text type="info" size="large">
                            Number of applicants：{{ count_signup }}
                        </el-text>
                    </el-row>
                    <el-row justify="center" align="middle" style="margin-top:20px;">
                        <el-button :disabled="is_signup" type="primary" @click="handleSubmit">
                            {{ is_signup ? 'Signed Up' : 'Sign Up' }}
                        </el-button>
                    </el-row>
                </el-main>
            </el-container>
        </el-row>

        <el-row justify="center" align="middle">
            <el-container class="bottom-box">
                <el-main class="bottom-box-main">
                    <el-row justify="center" align="middle">
                        <h1>Rank</h1>
                    </el-row>

                    <el-row v-if="ranks.length === 0" justify="center" align="middle" style="margin-top:20px;">
                        No Data
                    </el-row>

                    <el-row style="width: 100%; height: 600px;">
                        <div id="rank" style="width: 100%; height: 600px;"></div>
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
}

.product-title {
    text-align: left;
    padding: 0;
    margin-bottom: 20px;
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

.rank-list {
    width: 100%;
    margin: 20px auto;
    display: flex;
    flex-direction: column;
    gap: 20px;
}
</style>