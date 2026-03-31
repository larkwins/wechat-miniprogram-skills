# 云开发项目示例

## 项目说明

这是一个使用微信小程序云开发的完整示例，展示如何使用云函数、云数据库和云存储。

## 项目结构

```
cloud-development/
├── miniprogram/                # 小程序端代码
│   ├── pages/
│   │   ├── index/             # 首页
│   │   │   ├── index.js
│   │   │   ├── index.json
│   │   │   ├── index.wxml
│   │   │   └── index.wxss
│   │   ├── list/              # 列表页
│   │   └── detail/            # 详情页
│   ├── components/            # 自定义组件
│   ├── utils/                 # 工具函数
│   │   ├── cloud.js          # 云开发封装
│   │   └── util.js
│   ├── app.js
│   ├── app.json
│   └── app.wxss
├── cloudfunctions/            # 云函数
│   ├── login/                 # 登录云函数
│   ├── getList/              # 获取列表
│   ├── getDetail/            # 获取详情
│   └── updateItem/           # 更新数据
└── project.config.json
```

## 1. 云开发初始化

### app.js
```javascript
App({
  onLaunch() {
    // 初始化云开发
    if (!wx.cloud) {
      console.error('请使用 2.2.3 或以上的基础库以使用云能力');
    } else {
      wx.cloud.init({
        env: 'your-env-id', // 云开发环境 ID
        traceUser: true,
      });
    }
  },
  
  globalData: {
    userInfo: null
  }
});
```

## 2. 云函数示例

### cloudfunctions/login/index.js
```javascript
// 云函数：用户登录
const cloud = require('wx-server-sdk');
cloud.init({ env: cloud.DYNAMIC_CURRENT_ENV });
const db = cloud.database();

exports.main = async (event, context) => {
  const wxContext = cloud.getWXContext();
  
  try {
    // 查询用户是否存在
    const { data: users } = await db.collection('users').where({
      openid: wxContext.OPENID
    }).get();
    
    if (users.length === 0) {
      // 新用户，创建记录
      await db.collection('users').add({
        data: {
          openid: wxContext.OPENID,
          createTime: db.serverDate(),
          lastLoginTime: db.serverDate()
        }
      });
    } else {
      // 老用户，更新最后登录时间
      await db.collection('users').where({
        openid: wxContext.OPENID
      }).update({
        data: {
          lastLoginTime: db.serverDate()
        }
      });
    }
    
    return {
      success: true,
      openid: wxContext.OPENID,
      appid: wxContext.APPID,
      unionid: wxContext.UNIONID
    };
  } catch (err) {
    console.error(err);
    return {
      success: false,
      error: err
    };
  }
};
```

### cloudfunctions/getList/index.js
```javascript
// 云函数：获取列表（支持分页）
const cloud = require('wx-server-sdk');
cloud.init({ env: cloud.DYNAMIC_CURRENT_ENV });
const db = cloud.database();

exports.main = async (event, context) => {
  const { page = 1, pageSize = 10, category } = event;
  
  try {
    const skip = (page - 1) * pageSize;
    
    // 构建查询条件
    let query = db.collection('items');
    if (category) {
      query = query.where({ category });
    }
    
    // 获取总数
    const { total } = await query.count();
    
    // 获取数据
    const { data } = await query
      .skip(skip)
      .limit(pageSize)
      .orderBy('createTime', 'desc')
      .get();
    
    return {
      success: true,
      data,
      total,
      page,
      pageSize,
      totalPages: Math.ceil(total / pageSize)
    };
  } catch (err) {
    console.error(err);
    return {
      success: false,
      error: err
    };
  }
};
```

### cloudfunctions/updateItem/index.js
```javascript
// 云函数：更新数据
const cloud = require('wx-server-sdk');
cloud.init({ env: cloud.DYNAMIC_CURRENT_ENV });
const db = cloud.database();

exports.main = async (event, context) => {
  const { id, data } = event;
  const wxContext = cloud.getWXContext();
  
  try {
    // 检查权限：只能更新自己创建的数据
    const { data: items } = await db.collection('items').where({
      _id: id,
      _openid: wxContext.OPENID
    }).get();
    
    if (items.length === 0) {
      return {
        success: false,
        message: '无权限或数据不存在'
      };
    }
    
    // 更新数据
    await db.collection('items').doc(id).update({
      data: {
        ...data,
        updateTime: db.serverDate()
      }
    });
    
    return {
      success: true,
      message: '更新成功'
    };
  } catch (err) {
    console.error(err);
    return {
      success: false,
      error: err
    };
  }
};
```

## 3. 小程序端调用

### utils/cloud.js
```javascript
/**
 * 云函数调用封装
 */
class CloudAPI {
  /**
   * 调用云函数
   */
  static async call(name, data = {}) {
    try {
      wx.showLoading({ title: '加载中...' });
      
      const res = await wx.cloud.callFunction({
        name,
        data
      });
      
      wx.hideLoading();
      
      if (res.result.success) {
        return res.result;
      } else {
        throw new Error(res.result.message || '请求失败');
      }
    } catch (err) {
      wx.hideLoading();
      wx.showToast({
        title: err.message || '网络错误',
        icon: 'none'
      });
      throw err;
    }
  }
  
  /**
   * 用户登录
   */
  static async login() {
    return await this.call('login');
  }
  
  /**
   * 获取列表
   */
  static async getList({ page = 1, pageSize = 10, category } = {}) {
    return await this.call('getList', { page, pageSize, category });
  }
  
  /**
   * 获取详情
   */
  static async getDetail(id) {
    return await this.call('getDetail', { id });
  }
  
  /**
   * 更新数据
   */
  static async updateItem(id, data) {
    return await this.call('updateItem', { id, data });
  }
  
  /**
   * 上传文件
   */
  static async uploadFile(filePath, cloudPath) {
    try {
      wx.showLoading({ title: '上传中...' });
      
      const res = await wx.cloud.uploadFile({
        cloudPath,
        filePath
      });
      
      wx.hideLoading();
      
      return {
        success: true,
        fileID: res.fileID
      };
    } catch (err) {
      wx.hideLoading();
      wx.showToast({
        title: '上传失败',
        icon: 'none'
      });
      throw err;
    }
  }
  
  /**
   * 删除文件
   */
  static async deleteFile(fileID) {
    try {
      await wx.cloud.deleteFile({
        fileList: [fileID]
      });
      return { success: true };
    } catch (err) {
      wx.showToast({
        title: '删除失败',
        icon: 'none'
      });
      throw err;
    }
  }
}

module.exports = CloudAPI;
```

### pages/index/index.js
```javascript
const CloudAPI = require('../../utils/cloud');

Page({
  data: {
    list: [],
    page: 1,
    pageSize: 10,
    hasMore: true
  },
  
  async onLoad() {
    // 用户登录
    await CloudAPI.login();
    
    // 加载数据
    await this.loadList();
  },
  
  /**
   * 加载列表
   */
  async loadList() {
    try {
      const res = await CloudAPI.getList({
        page: this.data.page,
        pageSize: this.data.pageSize
      });
      
      this.setData({
        list: [...this.data.list, ...res.data],
        hasMore: this.data.page < res.totalPages
      });
    } catch (err) {
      console.error('加载列表失败:', err);
    }
  },
  
  /**
   * 上拉加载更多
   */
  async onReachBottom() {
    if (!this.data.hasMore) return;
    
    this.setData({
      page: this.data.page + 1
    });
    
    await this.loadList();
  },
  
  /**
   * 下拉刷新
   */
  async onPullDownRefresh() {
    this.setData({
      list: [],
      page: 1,
      hasMore: true
    });
    
    await this.loadList();
    wx.stopPullDownRefresh();
  },
  
  /**
   * 选择并上传图片
   */
  async uploadImage() {
    try {
      // 选择图片
      const { tempFilePaths } = await wx.chooseImage({
        count: 1,
        sizeType: ['compressed'],
        sourceType: ['album', 'camera']
      });
      
      // 上传到云存储
      const cloudPath = `images/${Date.now()}-${Math.random().toString(36).slice(2)}.jpg`;
      const res = await CloudAPI.uploadFile(tempFilePaths[0], cloudPath);
      
      wx.showToast({
        title: '上传成功',
        icon: 'success'
      });
      
      return res.fileID;
    } catch (err) {
      console.error('上传图片失败:', err);
    }
  }
});
```

## 4. 数据库设计

### 用户集合 (users)
```json
{
  "_id": "自动生成",
  "_openid": "用户 openid（自动）",
  "nickName": "用户昵称",
  "avatarUrl": "头像 URL",
  "createTime": "创建时间",
  "lastLoginTime": "最后登录时间"
}
```

### 数据集合 (items)
```json
{
  "_id": "自动生成",
  "_openid": "创建者 openid（自动）",
  "title": "标题",
  "content": "内容",
  "category": "分类",
  "images": ["图片 fileID 数组"],
  "createTime": "创建时间",
  "updateTime": "更新时间"
}
```

## 5. 云数据库安全规则

```json
{
  "read": "auth.openid == doc._openid",
  "write": "auth.openid == doc._openid"
}
```

## 6. 部署步骤

1. **创建云开发环境**
   - 在微信开发者工具中点击"云开发"按钮
   - 创建新环境并记录环境 ID

2. **部署云函数**
   ```bash
   # 右键 cloudfunctions 目录下的每个云函数文件夹
   # 选择"上传并部署：云端安装依赖"
   ```

3. **创建数据库集合**
   - 在云开发控制台创建 `users` 和 `items` 集合
   - 配置权限规则

4. **配置环境 ID**
   - 在 `app.js` 中填写正确的环境 ID

## 7. 最佳实践

### ✅ 推荐做法

1. **云函数职责单一**
   - 每个云函数只负责一个功能
   - 便于维护和调试

2. **统一封装**
   - 使用 `CloudAPI` 统一管理云函数调用
   - 统一错误处理和 loading 状态

3. **权限控制**
   - 在云函数中验证用户权限
   - 使用 `_openid` 自动权限控制

4. **数据校验**
   - 在云函数中进行数据校验
   - 防止恶意数据提交

### ❌ 避免做法

1. **避免在小程序端直接操作数据库**
   - 所有数据操作通过云函数
   - 保证数据安全和业务逻辑集中

2. **避免上传大文件**
   - 限制文件大小（建议 < 10MB）
   - 压缩图片后再上传

3. **避免频繁调用云函数**
   - 使用防抖/节流
   - 合理使用缓存

## 8. 性能优化

1. **云函数冷启动优化**
   - 定期调用云函数保持热启动
   - 减少云函数依赖包大小

2. **数据库查询优化**
   - 创建索引（在云开发控制台）
   - 限制单次查询数量

3. **文件存储优化**
   - 使用 CDN 加速（自动）
   - 图片使用临时链接

## 参考资源

- [云开发官方文档](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/getting-started.html)
- [云函数开发指南](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/guide/functions.html)
- [云数据库开发指南](https://developers.weixin.qq.com/miniprogram/dev/wxcloud/guide/database.html)
