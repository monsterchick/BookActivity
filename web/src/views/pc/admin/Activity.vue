<script setup>
import {onMounted, ref} from 'vue';
import {ElMessage, ElMessageBox} from "element-plus";
import {activityAdd, activityDelete, activityList, activityUpdate} from "@/api/activity.js";
import {upload} from "@/api/upload.js";

const queryInfo = ref({
    pageNo: 1,
    pageSize: 10,
    username: "",
    email: "",
    phone: ""
});

const dataList = ref([]);
const total = ref(0);

const addDialogVisible = ref(false);
const addForm = ref({});

const editDialogVisible = ref(false);
const editForm = ref({});

const getDataList = () => {
    activityList(queryInfo.value).then((res) => {
        if (res.code === 200) {
            dataList.value = res.data.list;
            total.value = res.data.total || 0;
        } else {
            ElMessage.error(res.msg);
        }
    }).catch((err) => {
        console.log(err);
    });
}

const resetDataList = () => {
    queryInfo.value = {
        pageNo: 1,
        pageSize: 10,
        username: "",
        email: "",
        phone: ""
    };
    getDataList();
}

const handleSizeChange = (newSize) => {
    queryInfo.value.pageSize = newSize;
    getDataList();
}

const handleCurrentChange = (newPage) => {
    queryInfo.value.pageNo = newPage;
    getDataList();
}

const showEditBox = (activity) => {
    editForm.value = activity
    editDialogVisible.value = true
}

// delete activity by id
const deleteById = async (id) => {
    const confirmResult = await ElMessageBox.confirm(
        "Confirm deletion?",
        "Tips",
        {
            confirmButtonText: "Confirm",
            cancelButtonText: "Cancel",
            type: "warning",
        }
    ).catch((err) => err);

    if (confirmResult === "confirm") {
        activityDelete(id).then((res) => {
            if (res.code === 200) {
                getDataList();
                ElMessage.success("Delete success");
            } else {
                ElMessage.error("Delete failed");
            }
        }).catch((err) => {
            console.log(err);
            ElMessage.error("Network error");
        });
    }
}

const addUser = () => {
    activityAdd(addForm.value).then((res) => {
        if (res.code === 200) {
            addDialogVisible.value = false
            getDataList();
            ElMessage.success("Add success");
        } else {
            ElMessage.error("Add failed");
        }
    })
}

const editUser = () => {
    activityUpdate(editForm.value).then((res) => {
        if (res.code === 200) {
            editDialogVisible.value = false
            ElMessage.success("Update success");
        } else {
            ElMessage.error("Update failed");
        }
    })
}

const handleUpload = (file, callback) => {
    const formData = new FormData()
    formData.append('file', file.file)

    upload(formData).then((res) => {
        if (res.code === 200) {
            ElMessage.success("Upload success");
            callback && callback(res);
        } else {
            ElMessage.error("Upload failed");
        }
    }).catch((err) => {
        ElMessage.error("Network error");
    });
}

const handleAddBookCover = (file) => {
    handleUpload(file, (res) => {
        addForm.value.cover = res.data
    })
}

const handleAddBookFile = (file) => {
    handleUpload(file, (res) => {
        addForm.value.file = res.data
    })
}

const handleEditBookCover = (file) => {
    handleUpload(file, (res) => {
        editForm.value.cover = res.data
    })
}

const handleEditBookFile = (file) => {
    handleUpload(file, (res) => {
        editForm.value.file = res.data
    })
}

// load data
onMounted(() => {
    getDataList();
})
</script>


<template>
    <el-container class="el-container-fix">
        <el-header>
            <el-row :gutter="20">
                <el-col :span="4">
                    <el-input
                        placeholder="Enter title"
                        v-model="queryInfo.title"
                        clearable
                        @clear="getDataList"
                        @keydown.enter="getDataList"
                    >
                        <template #prepend>Title</template>
                    </el-input>
                </el-col>
                <el-col :span="4">
                    <el-input
                        placeholder="Enter type"
                        v-model="queryInfo.type"
                        clearable
                        @clear="getDataList"
                        @keydown.enter="getDataList"
                    >
                        <template #prepend>Type</template>
                    </el-input>
                </el-col>
                <el-col :span="6">
                    <el-button type="primary" @click="getDataList">
                        Search
                    </el-button>
                    <el-button type="info" @click="resetDataList">
                        Reset
                    </el-button>
                    <el-button type="primary" plain @click="addDialogVisible = true">
                        Add
                    </el-button>
                </el-col>
            </el-row>
        </el-header>

        <el-main>
            <el-table
                :data="dataList"
                height="650"
                ref="filterTable"
                :border="true"
                stripe
            >
                <el-table-column prop="id" label="id" width="80"></el-table-column>
                <el-table-column prop="title" label="Title"></el-table-column>
                <el-table-column prop="description" label="Description"></el-table-column>
                <el-table-column prop="type" label="Type"></el-table-column>
                <el-table-column prop="start_date" label="Start Date"></el-table-column>
                <el-table-column prop="end_date" label="End Date"></el-table-column>
                <el-table-column label="Action" width="300">
                    <template #default="scope">
                        <el-button
                            type="warning"
                            size="small"
                            icon="Edit"
                            @click="showEditBox(scope.row)"
                        >Edit
                        </el-button>
                        <el-button
                            size="small"
                            type="danger"
                            icon="Delete"
                            @click="deleteById(scope.row.id)"
                        >Delete
                        </el-button>
                    </template>
                </el-table-column>
            </el-table>
        </el-main>

        <el-row>
            <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="queryInfo.pageNo"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="queryInfo.pageSize"
                :total="total"
                layout="total,prev, pager, next,jumper"
            >
            </el-pagination>
        </el-row>
    </el-container>

    <el-dialog title="Add activity" v-model="addDialogVisible" width="600px">
        <el-form :model="addForm" label-width="100px">
            <el-form-item prop="title" label="Title">
                <el-input v-model="addForm.title" placeholder="Title" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="type" label="Type">
                <el-select v-model="addForm.type" placeholder="Type">
                    <el-option label="TimeBased" value="TimeBased"></el-option>
                    <el-option label="QuantityBased" value="QuantityBased"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="start_date" label="Start date">
                <el-date-picker
                    v-model="addForm.start_date"
                    type="datetime"
                    unlink-panels
                    range-separator="to"
                    start-placeholder="Start time"
                    end-placeholder="End time"
                    value-format="YYYY-MM-DD HH:mm:ss"
                ></el-date-picker>
            </el-form-item>
            <el-form-item prop="end_date" label="End date">
                <el-date-picker
                    v-model="addForm.end_date"
                    type="datetime"
                    unlink-panels
                    range-separator="to"
                    start-placeholder="Start time"
                    end-placeholder="End time"
                    value-format="YYYY-MM-DD HH:mm:ss"
                ></el-date-picker>
            </el-form-item>
            <el-form-item prop="description" label="Description">
                <el-input type="textarea" rows="8" v-model="addForm.description" placeholder="Summary" size="large"
                          tabIndex="-1"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="addDialogVisible = false">Cancel</el-button>
            <el-button type="primary" @click="addUser">Confirm</el-button>
        </span>
    </el-dialog>

    <el-dialog title="Edit activity" v-model="editDialogVisible" width="30%">
        <el-form :model="editForm" label-width="100px">>
            <el-form-item prop="title" label="Title">
                <el-input v-model="editForm.title" placeholder="Title" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="type" label="Type">
                <el-select v-model="editForm.type" placeholder="Type">
                    <el-option label="TimeBased" value="TimeBased"></el-option>
                    <el-option label="QuantityBased" value="QuantityBased"></el-option>
                </el-select>
            </el-form-item>
            <el-form-item prop="start_date" label="Start date">
                <el-date-picker
                    v-model="editForm.start_date"
                    type="datetime"
                    unlink-panels
                    range-separator="to"
                    start-placeholder="Start time"
                    end-placeholder="End time"
                    value-format="YYYY-MM-DD HH:mm:ss"
                ></el-date-picker>
            </el-form-item>
            <el-form-item prop="end_date" label="End date">
                <el-date-picker
                    v-model="editForm.end_date"
                    type="datetime"
                    unlink-panels
                    range-separator="to"
                    start-placeholder="Start time"
                    end-placeholder="End time"
                    value-format="YYYY-MM-DD HH:mm:ss"
                ></el-date-picker>
            </el-form-item>
            <el-form-item prop="description" label="Description">
                <el-input type="textarea" rows="8" v-model="editForm.description" placeholder="Summary" size="large"
                          tabIndex="-1"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="editDialogVisible = false">Cancel</el-button>
            <el-button type="primary" @click="editUser">Confirm</el-button>
        </span>
    </el-dialog>
</template>

<style scoped>
.el-container-fix {
    width: 98%;
    margin: auto;
    padding: 20px 0;
}

.row-image {
    width: 50%;
    height: 100px;
}
</style>