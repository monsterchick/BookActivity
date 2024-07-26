<script setup>
import {onMounted, ref} from 'vue';
import {ElMessage, ElMessageBox} from "element-plus";
import {bookAdd, bookDelete, bookList, bookUpdate} from "@/api/book.js";
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
    bookList(queryInfo.value).then((res) => {
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

const showEditBox = (book) => {
    editForm.value = book
    editDialogVisible.value = true
}

// delete book by id
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
        bookDelete(id).then((res) => {
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
    bookAdd(addForm.value).then((res) => {
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
    bookUpdate(editForm.value).then((res) => {
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
                        placeholder="Enter author"
                        v-model="queryInfo.author"
                        clearable
                        @clear="getDataList"
                        @keydown.enter="getDataList"
                    >
                        <template #prepend>Author</template>
                    </el-input>
                </el-col>
                <el-col :span="4">
                    <el-input
                        placeholder="Enter category"
                        v-model="queryInfo.category"
                        clearable
                        @clear="getDataList"
                        @keydown.enter="getDataList"
                    >
                        <template #prepend>Category</template>
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
                <el-table-column prop="cover" label="Cover" width="150">
                    <template #default="scope">
                        <el-avatar
                            shape="square"
                            :size="50"
                            :src="scope.row.cover"
                        />
                    </template>
                </el-table-column>
                <el-table-column prop="author" label="Author"></el-table-column>
                <el-table-column prop="category" label="Category"></el-table-column>
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

    <el-dialog title="Add book" v-model="addDialogVisible" width="600px">
        <el-form :model="addForm">
            <el-form-item prop="title" label="Title">
                <el-input v-model="addForm.title" placeholder="Title" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="cover" label="Cover">
                <el-upload
                    class="upload-demo"
                    drag
                    style="margin-top:10px;"
                    :http-request="handleAddBookCover"
                >
                    <el-icon v-if="!addForm.cover" class="el-icon--upload">
                        <upload-filled/>
                    </el-icon>

                    <el-image v-if="addForm.cover" style="width: 20%; height: auto" :src="addForm.cover"
                              fit="contain"/>
                    <div class="el-upload__text">
                        Drag and drop the file here <em> or click Upload </em>
                    </div>
                </el-upload>
            </el-form-item>
            <el-form-item prop="file" label="File">
                <el-upload
                    class="upload-demo"
                    drag
                    style="margin-top:10px;"
                    :http-request="handleAddBookFile"
                >
                    <el-icon v-if="!addForm.file" class="el-icon--upload">
                        <upload-filled/>
                    </el-icon>

                    <div class="el-upload__text">
                        Drag and drop the file here <em> or click Upload </em>
                    </div>
                </el-upload>
            </el-form-item>
            <el-form-item prop="author" label="Author">
                <el-input v-model="addForm.author" placeholder="Author" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="category" label="Category">
                <el-input v-model="addForm.category" placeholder="Category" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="summary" label="Summary">
                <el-input type="textarea" rows="8" v-model="addForm.summary" placeholder="Summary" size="large"
                          tabIndex="-1"></el-input>
            </el-form-item>
        </el-form>
        <span slot="footer" class="dialog-footer">
            <el-button @click="addDialogVisible = false">Cancel</el-button>
            <el-button type="primary" @click="addUser">Confirm</el-button>
        </span>
    </el-dialog>

    <el-dialog title="Edit book" v-model="editDialogVisible" width="30%">
        <el-form :model="editForm">
            <el-form-item prop="title" label="Title">
                <el-input v-model="editForm.title" placeholder="Title" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="cover" label="Cover">
                <el-upload
                    class="upload-demo"
                    drag
                    style="margin-top:10px;"
                    :http-request="handleEditBookCover"
                >
                    <el-icon v-if="!editForm.cover" class="el-icon--upload">
                        <upload-filled/>
                    </el-icon>

                    <el-image v-if="editForm.cover" style="width: 20%; height: auto" :src="editForm.cover"
                              fit="contain"/>
                    <div class="el-upload__text">
                        Drag and drop the file here <em> or click Upload </em>
                    </div>
                </el-upload>
            </el-form-item>
            <el-form-item prop="file" label="File">
                <el-upload
                    class="upload-demo"
                    drag
                    style="margin-top:10px;"
                    :http-request="handleEditBookFile"
                >
                    <el-icon v-if="!editForm.file" class="el-icon--upload">
                        <upload-filled/>
                    </el-icon>

                    <div class="el-upload__text">
                        Drag and drop the file here <em> or click Upload </em>
                    </div>
                </el-upload>
            </el-form-item>
            <el-form-item prop="author" label="Author">
                <el-input v-model="editForm.author" placeholder="Author" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="category" label="Category">
                <el-input v-model="editForm.category" placeholder="Category" size="large" tabIndex="-1"></el-input>
            </el-form-item>
            <el-form-item prop="summary" label="Summary">
                <el-input type="textarea" rows="8" v-model="editForm.summary" placeholder="Summary" size="large"
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