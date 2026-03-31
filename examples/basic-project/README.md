# 基础小程序项目模板

这是一个完整的微信小程序基础项目模板，包含标准的目录结构、配置文件和常用功能模块。

## 📁 项目结构

```
basic-project/
├── pages/                      # 页面目录
│   ├── index/                 # 首页
│   │   ├── index.js
│   │   ├── index.json
│   │   ├── index.wxml
│   │   └── index.wxss
│   ├── list/                  # 列表页
│   │   ├── list.js
│   │   ├── list.json
│   │   ├── list.wxml
│   │   └── list.wxss
│   └── detail/                # 详情页
│       ├── detail.js
│       ├── detail.json
│       ├── detail.wxml
│       └── detail.wxss
│
├── components/                 # 自定义组件
│   ├── loading/               # 加载组件
│   │   ├── loading.js
│   │   ├── loading.json
│   │   ├── loading.wxml
│   │   └── loading.wxss
│   └── empty/                 # 空状态组件
│       ├── empty.js
│       ├── empty.json
│       ├── empty.wxml
│       └── empty.wxss
│
├── utils/                      # 工具函数
│   ├── request.js             # 网络请求封装
│   ├── storage.js             # 本地存储封装
│   ├── permission.js          # 权限管理
│   └── util.js                # 通用工具函数
│
├── services/                   # API 服务层
│   ├── api.js                 # API 接口定义
│   └── config.js              # 配置文件
│
├── styles/                     # 全局样式
│   ├── variables.wxss         # 变量定义
│   └── common.wxss            # 通用样式
│
├── images/                     # 图片资源
│   └── tabbar/                # TabBar 图标
│
├── app.js                      # 小程序逻辑
├── app.json                    # 小程序配置
├── app.wxss                    # 全局样式
├── sitemap.json               # 搜索配置
└── project.config.json        # 项目配置
```

## 🚀 快速开始

### 1. 安装依赖

如果项目使用了 npm 包：

```bash
npm install
```

### 2. 配置 API 地址

修改 `services/config.js`：

```javascript
module.exports = {
  baseURL: 'https://your-api-domain.com',
  timeout: 10000
};
```

### 3. 开发调试

1. 使用微信开发者工具打开项目
2. 填写 AppID（测试号或正式 AppID）
3. 点击"编译"开始调试

## 📝 核心文件说明

### app.js - 小程序入口

```javascript
App({
  onLaunch(options) {
    // 小程序启动时触发
    console.log('小程序启动', options);
    
    // 获取系统信息
    const systemInfo = wx.getSystemInfoSync();
    this.globalData.systemInfo = systemInfo;
    
    // 检查更新
    this.checkUpdate();
  },

  onShow(options) {
    // 小程序显示时触发
    console.log('小程序显示', options);
  },

  onHide() {
    // 小程序隐藏时触发
    console.log('小程序隐藏');
  },

  onError(error) {
    // 错误监听
    console.error('小程序错误:', error);
  },

  /**
   * 检查小程序更新
   */
  checkUpdate() {
    if (wx.canIUse('getUpdateManager')) {
      const updateManager = wx.getUpdateManager();
      
      updateManager.onCheckForUpdate((res) => {
        if (res.hasUpdate) {
          updateManager.onUpdateReady(() => {
            wx.showModal({
              title: '更新提示',
              content: '新版本已准备好，是否重启应用？',
              success: (res) => {
                if (res.confirm) {
                  updateManager.applyUpdate();
                }
              }
            });
          });
          
          updateManager.onUpdateFailed(() => {
            wx.showModal({
              title: '更新失败',
              content: '新版本下载失败，请删除小程序后重新打开',
              showCancel: false
            });
          });
        }
      });
    }
  },

  globalData: {
    userInfo: null,
    systemInfo: null,
    token: ''
  }
});
```

### app.json - 小程序配置

```json
{
  "pages": [
    "pages/index/index",
    "pages/list/list",
    "pages/detail/detail"
  ],
  "window": {
    "backgroundTextStyle": "light",
    "navigationBarBackgroundColor": "#fff",
    "navigationBarTitleText": "微信小程序",
    "navigationBarTextStyle": "black",
    "enablePullDownRefresh": false,
    "backgroundColor": "#f5f5f5"
  },
  "tabBar": {
    "color": "#666666",
    "selectedColor": "#1890ff",
    "backgroundColor": "#ffffff",
    "borderStyle": "black",
    "list": [
      {
        "pagePath": "pages/index/index",
        "text": "首页",
        "iconPath": "images/tabbar/home.png",
        "selectedIconPath": "images/tabbar/home-active.png"
      },
      {
        "pagePath": "pages/list/list",
        "text": "列表",
        "iconPath": "images/tabbar/list.png",
        "selectedIconPath": "images/tabbar/list-active.png"
      }
    ]
  },
  "networkTimeout": {
    "request": 10000,
    "downloadFile": 10000
  },
  "permission": {
    "scope.userLocation": {
      "desc": "你的位置信息将用于显示附近的服务"
    }
  }
}
```

### utils/request.js - 网络请求封装

```javascript
const config = require('../services/config');

/**
 * 网络请求封装
 */
function request(options) {
  return new Promise((resolve, reject) => {
    wx.showLoading({ title: '加载中...' });

    wx.request({
      url: config.baseURL + options.url,
      method: options.method || 'GET',
      data: options.data || {},
      header: {
        'Content-Type': 'application/json',
        'Authorization': wx.getStorageSync('token') || '',
        ...options.header
      },
      timeout: config.timeout,
      success: (res) => {
        wx.hideLoading();
        
        if (res.statusCode === 200) {
          if (res.data.code === 0) {
            resolve(res.data.data);
          } else {
            wx.showToast({
              title: res.data.message || '请求失败',
              icon: 'none'
            });
            reject(res.data);
          }
        } else {
          wx.showToast({
            title: '网络错误',
            icon: 'none'
          });
          reject(res);
        }
      },
      fail: (err) => {
        wx.hideLoading();
        wx.showToast({
          title: '网络连接失败',
          icon: 'none'
        });
        reject(err);
      }
    });
  });
}

module.exports = {
  get: (url, data) => request({ url, method: 'GET', data }),
  post: (url, data) => request({ url, method: 'POST', data }),
  put: (url, data) => request({ url, method: 'PUT', data }),
  delete: (url, data) => request({ url, method: 'DELETE', data })
};
```

### utils/storage.js - 本地存储封装

```javascript
/**
 * 设置缓存
 */
function setStorage(key, value) {
  try {
    wx.setStorageSync(key, value);
    return true;
  } catch (err) {
    console.error('设置缓存失败:', err);
    return false;
  }
}

/**
 * 获取缓存
 */
function getStorage(key, defaultValue = null) {
  try {
    const value = wx.getStorageSync(key);
    return value !== '' ? value : defaultValue;
  } catch (err) {
    console.error('获取缓存失败:', err);
    return defaultValue;
  }
}

/**
 * 删除缓存
 */
function removeStorage(key) {
  try {
    wx.removeStorageSync(key);
    return true;
  } catch (err) {
    console.error('删除缓存失败:', err);
    return false;
  }
}

/**
 * 清空缓存
 */
function clearStorage() {
  try {
    wx.clearStorageSync();
    return true;
  } catch (err) {
    console.error('清空缓存失败:', err);
    return false;
  }
}

module.exports = {
  setStorage,
  getStorage,
  removeStorage,
  clearStorage
};
```

### utils/permission.js - 权限管理

```javascript
/**
 * 检查并请求权限
 */
function checkPermission(scope) {
  return new Promise((resolve, reject) => {
    wx.getSetting({
      success: (res) => {
        if (res.authSetting[scope]) {
          // 已授权
          resolve(true);
        } else {
          // 未授权，发起授权请求
          wx.authorize({
            scope,
            success: () => resolve(true),
            fail: () => {
              // 授权失败，引导用户去设置页面
              wx.showModal({
                title: '授权提示',
                content: '需要您授权才能使用此功能',
                confirmText: '去设置',
                success: (res) => {
                  if (res.confirm) {
                    wx.openSetting({
                      success: (res) => {
                        if (res.authSetting[scope]) {
                          resolve(true);
                        } else {
                          reject(false);
                        }
                      }
                    });
                  } else {
                    reject(false);
                  }
                }
              });
            }
          });
        }
      },
      fail: () => reject(false)
    });
  });
}

/**
 * 获取用户信息
 */
async function getUserProfile() {
  try {
    const res = await wx.getUserProfile({
      desc: '用于完善用户资料'
    });
    return res.userInfo;
  } catch (err) {
    console.error('获取用户信息失败:', err);
    return null;
  }
}

/**
 * 获取用户位置
 */
async function getLocation() {
  try {
    await checkPermission('scope.userLocation');
    const res = await wx.getLocation({
      type: 'gcj02'
    });
    return {
      latitude: res.latitude,
      longitude: res.longitude
    };
  } catch (err) {
    console.error('获取位置失败:', err);
    return null;
  }
}

module.exports = {
  checkPermission,
  getUserProfile,
  getLocation
};
```

### services/api.js - API 接口定义

```javascript
const request = require('../utils/request');

/**
 * API 接口
 */
const api = {
  // 用户相关
  user: {
    login: (data) => request.post('/user/login', data),
    getUserInfo: () => request.get('/user/info'),
    updateUserInfo: (data) => request.post('/user/update', data)
  },

  // 商品相关
  product: {
    getList: (data) => request.get('/product/list', data),
    getDetail: (id) => request.get(`/product/detail?id=${id}`)
  },

  // 订单相关
  order: {
    create: (data) => request.post('/order/create', data),
    getList: (data) => request.get('/order/list', data),
    getDetail: (id) => request.get(`/order/detail?id=${id}`)
  }
};

module.exports = api;
```

## 🎨 页面示例

### pages/index/index.js - 首页

```javascript
const api = require('../../services/api');

Page({
  data: {
    banners: [],
    products: [],
    loading: true
  },

  async onLoad() {
    await this.loadData();
  },

  /**
   * 加载数据
   */
  async loadData() {
    try {
      const [banners, products] = await Promise.all([
        api.product.getList({ type: 'banner' }),
        api.product.getList({ page: 1, pageSize: 10 })
      ]);

      this.setData({
        banners,
        products,
        loading: false
      });
    } catch (err) {
      console.error('加载数据失败:', err);
      this.setData({ loading: false });
    }
  },

  /**
   * 下拉刷新
   */
  async onPullDownRefresh() {
    await this.loadData();
    wx.stopPullDownRefresh();
  },

  /**
   * 跳转详情
   */
  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/detail/detail?id=${id}`
    });
  }
});
```

## 🧩 组件示例

### components/loading/loading.wxml

```xml
<view class="loading" wx:if="{{show}}">
  <view class="loading-spinner"></view>
  <text class="loading-text">{{text}}</text>
</view>
```

### components/loading/loading.js

```javascript
Component({
  properties: {
    show: {
      type: Boolean,
      value: false
    },
    text: {
      type: String,
      value: '加载中...'
    }
  }
});
```

## 📱 运行效果

1. **首页**: 展示轮播图和商品列表
2. **列表页**: 支持下拉刷新、上拉加载
3. **详情页**: 展示商品详细信息

## 🔧 常用命令

```bash
# 安装依赖
npm install

# 构建 npm
# 在开发者工具中：工具 -> 构建 npm

# 清理缓存
# 在开发者工具中：工具 -> 清除缓存
```

## 📚 参考资源

- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [小程序开发指南](https://developers.weixin.qq.com/ebook?action=get_post_info&docid=0008aeea9a8978ab0086a685851c0a)
