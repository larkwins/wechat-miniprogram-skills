# 微信小程序开发 Skills 大纲

## 设计理念

本 Skill 采用**分层渐进式架构**，结合三个参考示例的优点：
- 📋 **场景定义清晰**（借鉴 TencentCloudBase）
- ⚡ **性能优化深入**（借鉴 gourdbaby）
- 📚 **知识覆盖全面**（借鉴 joneqian）
- 🚀 **创新补充实战内容**（错误处理、测试、安全、UX）

---

## 文档结构

```
wechat-miniprogram-skill/
├── SKILL.md              # 核心技能定义文件
├── README.md             # 项目说明和使用指南
├── references/           # 参考资料目录
│   ├── framework.md      # 框架核心概念
│   ├── components.md     # 组件使用指南
│   ├── api.md            # API 快速参考
│   ├── performance.md    # 性能优化指南
│   ├── pitfalls.md       # 常见问题防坑指南
│   ├── cloud.md          # 云开发集成
│   ├── testing.md        # 测试策略
│   └── security.md       # 安全规范
└── examples/             # 代码示例
    ├── basic/            # 基础示例
    ├── advanced/         # 高级示例
    └── templates/        # 项目模板
```

---

## SKILL.md 详细大纲

### 第一部分：基础信息

#### 1. Skill 元数据
```yaml
name: wechat-miniprogram-expert
version: 1.0.0
description: 微信小程序开发专家，提供全面的开发指导、性能优化和最佳实践
language: zh-CN
author: [Your Name]
tags: [wechat, miniprogram, javascript, performance, cloud]
```

#### 2. 角色定义
- 你是一位资深的微信小程序开发专家
- 精通微信小程序框架、API、组件和云开发
- 注重代码质量、性能优化和用户体验
- 熟悉常见坑点和解决方案

---

### 第二部分：核心原则

#### 1. 开发原则（5 大核心）
- **性能优先**: 优化渲染、减少 setData、按需加载
- **原生兼容**: 确保 iOS/Android 双端一致性
- **代码质量**: 模块化、可维护、可测试
- **用户体验**: 快速响应、友好反馈、流畅交互
- **安全规范**: 数据加密、权限控制、敏感信息保护

#### 2. 技术栈支持
- ✅ **原生开发**: JavaScript (ES6+) / TypeScript
- ✅ **跨平台框架**: Taro / Uni-app（提供最佳实践）
- ✅ **云开发**: 支持多云（微信云开发、腾讯云 CloudBase、其他 BaaS）
- ✅ **构建工具**: 微信开发者工具 / miniprogram-ci

---

### 第三部分：场景定义与触发条件

#### 1. 何时使用此 Skill ✅

**明确场景**:
- 创建、修改或优化微信小程序项目
- 实现小程序页面、组件或功能模块
- 集成微信 API（支付、登录、分享等）
- 配置小程序项目（app.json, project.config.json）
- 调试、测试、预览或发布小程序
- 性能优化和问题排查
- 云开发集成（云函数、云数据库、云存储）

**关键词触发**:
- 微信小程序、WeChat Mini Program
- WXML、WXSS、WXS
- wx.xxx API（如 wx.request, wx.login）
- 小程序组件、页面、云函数
- AppID、project.config.json
- 开发者工具、真机预览、上传发布

#### 2. 何时不使用此 Skill ❌

**排除场景**:
- 纯 Web 前端开发（Vue/React Web 应用）
- 微信公众号 H5 开发
- 微信开放平台第三方应用
- 纯后端服务开发（Node.js/Python 后端）
- 原生 iOS/Android 应用开发
- 桌面应用或其他平台开发

#### 3. 与其他 Skill 的协作
- Web 开发 Skill: 共享 CSS/JavaScript 基础知识
- 云开发 Skill: 后端服务和数据库集成
- UI/UX 设计 Skill: 界面设计和用户体验优化

---

### 第四部分：项目结构与配置

#### 1. 标准项目结构
```
miniprogram/
├── app.js                 # 小程序入口逻辑
├── app.json              # 全局配置
├── app.wxss              # 全局样式
├── sitemap.json          # 索引配置
├── project.config.json   # 项目配置
├── project.private.config.json  # 私有配置（gitignore）
├── pages/                # 页面目录
│   ├── index/
│   │   ├── index.js      # 页面逻辑
│   │   ├── index.json    # 页面配置
│   │   ├── index.wxml    # 页面结构
│   │   └── index.wxss    # 页面样式
│   └── ...
├── components/           # 自定义组件
│   └── custom-component/
│       ├── index.js
│       ├── index.json
│       ├── index.wxml
│       └── index.wxss
├── utils/                # 工具函数
│   ├── request.js        # 网络请求封装
│   ├── storage.js        # 本地存储封装
│   └── util.js           # 通用工具
├── api/                  # API 接口定义
├── assets/               # 静态资源
│   ├── images/
│   ├── icons/
│   └── fonts/
├── cloud/                # 云函数（云开发项目）
│   └── functions/
└── miniprogram_npm/      # npm 依赖（构建后）
```

#### 2. 关键配置文件

**app.json 核心配置**:
- pages: 页面路径列表
- window: 全局窗口配置
- tabBar: 底部导航配置
- networkTimeout: 网络超时设置
- permission: 权限配置
- usingComponents: 全局自定义组件

**project.config.json 重点**:
- appid: 小程序 AppID
- miniprogramRoot: 小程序根目录
- cloudfunctionRoot: 云函数根目录
- setting: 编译设置
- compileType: 编译类型

---

### 第五部分：开发规范

#### 1. 代码规范

**命名规范**:
- 文件命名: 小写 kebab-case（如 user-info.js）
- 变量/函数: 驼峰 camelCase（如 getUserInfo）
- 组件: 短横线连接（如 custom-button）
- 常量: 大写下划线（如 API_BASE_URL）
- 样式类名: BEM 规范（如 .user-info__avatar--large）

**JavaScript/TypeScript**:
```javascript
// ✅ 使用箭头函数处理 this 绑定
const handleTap = () => {
  this.setData({ count: this.data.count + 1 })
}

// ✅ 使用 async/await 处理异步
async getUserInfo() {
  try {
    const res = await wx.cloud.callFunction({ name: 'getUser' })
    this.setData({ userInfo: res.result })
  } catch (err) {
    console.error('获取用户信息失败', err)
  }
}

// ✅ 使用解构赋值
const { nickName, avatarUrl } = this.data.userInfo

// ❌ 避免使用 var
// ❌ 避免回调地狱
```

**WXML 模板**:
```xml
<!-- ✅ wx:for 必须包含 wx:key -->
<view wx:for="{{list}}" wx:key="id">
  {{item.name}}
</view>

<!-- ✅ 使用数据绑定 -->
<image src="{{avatarUrl}}" mode="aspectFill" />

<!-- ✅ 条件渲染优先使用 hidden（频繁切换） -->
<view hidden="{{!showTip}}">提示信息</view>

<!-- ✅ 条件渲染使用 wx:if（不频繁切换） -->
<view wx:if="{{userType === 'vip'}}">VIP 内容</view>
```

**WXSS 样式**:
```css
/* ✅ 使用 rpx 响应式单位 */
.container {
  width: 750rpx;
  padding: 20rpx;
}

/* ✅ BEM 命名规范 */
.user-card {
  /* Block */
}
.user-card__avatar {
  /* Element */
}
.user-card--highlighted {
  /* Modifier */
}

/* ❌ 避免使用 px（除非特定场景） */
/* ❌ 避免深层嵌套（不超过 3 层） */
```

#### 2. 组件化规范

**优先使用 Component 构造器**:
```javascript
// ✅ 推荐：使用 Component
Component({
  options: {
    styleIsolation: 'isolated',
    multipleSlots: true
  },
  properties: {
    title: {
      type: String,
      value: ''
    }
  },
  data: {
    count: 0
  },
  lifetimes: {
    attached() {
      // 组件实例进入页面节点树
    },
    detached() {
      // 组件实例被移除
    }
  },
  methods: {
    handleTap() {
      this.setData({ count: this.data.count + 1 })
      this.triggerEvent('tap', { count: this.data.count })
    }
  }
})
```

**组件通信**:
- 父 → 子: properties
- 子 → 父: triggerEvent
- 跨组件: 事件总线或全局状态管理

---

### 第六部分：性能优化（核心）

#### 1. setData 优化

**使用数据路径进行局部更新**:
```javascript
// ✅ 推荐：局部更新
this.setData({
  'userInfo.nickName': 'New Name',
  'list[0].status': 'completed'
})

// ❌ 避免：全量更新
this.setData({
  userInfo: { ...this.data.userInfo, nickName: 'New Name' }
})

// ✅ 合并多次 setData
const updates = {}
updates[`list[${index}].checked`] = true
updates[`count`] = this.data.count + 1
this.setData(updates)

// ❌ 避免频繁调用 setData
for (let i = 0; i < 100; i++) {
  this.setData({ count: i }) // 性能极差！
}
```

**setData 性能原则**:
- 单次传输数据不超过 1024KB
- 避免在 onPageScroll 中使用 setData
- 减少 setData 调用频率（合并更新）
- 只更新需要变化的数据（不传递不变的数据）

#### 2. 渲染优化

**长列表优化**:
- 使用虚拟列表（如 recycle-view）
- 分页加载数据
- 使用 hidden 而非 wx:if（频繁切换）

**图片优化**:
- 压缩图片体积
- 使用 webp 格式
- 懒加载（lazy-load）
- 合理设置 mode 属性

**分包加载**:
```json
{
  "pages": ["pages/index/index"],
  "subPackages": [
    {
      "root": "packageA",
      "pages": ["pages/cat/cat"],
      "independent": true
    }
  ],
  "preloadRule": {
    "pages/index/index": {
      "network": "all",
      "packages": ["packageA"]
    }
  }
}
```

#### 3. 代码体积优化
- 清理无用代码和依赖
- 使用按需引入（tree-shaking）
- 分包加载（单包不超过 2MB）
- 压缩图片和资源文件

---

### 第七部分：常见问题防坑指南

#### 1. 平台兼容性

**iOS 日期格式问题**:
```javascript
// ❌ iOS 不支持
new Date('2024-03-31 12:00:00')

// ✅ 兼容写法
new Date('2024/03/31 12:00:00')
// 或
const dateStr = '2024-03-31 12:00:00'.replace(/-/g, '/')
new Date(dateStr)
```

**iOS 键盘遮挡问题**:
```javascript
// 监听键盘高度变化
wx.onKeyboardHeightChange(res => {
  this.setData({
    keyboardHeight: res.height
  })
})
```

**Android 返回键处理**:
```javascript
// 拦截返回键
wx.onBackPress(() => {
  // 自定义返回逻辑
  return true // 返回 true 阻止默认返回
})
```

#### 2. 页面栈管理

**页面栈限制（最大 10 层）**:
```javascript
// ✅ 检查页面栈
const pages = getCurrentPages()
if (pages.length >= 10) {
  // 使用 redirectTo 或 reLaunch
  wx.redirectTo({ url: '/pages/target/target' })
} else {
  wx.navigateTo({ url: '/pages/target/target' })
}

// ✅ Tab 页面切换
wx.switchTab({ url: '/pages/home/home' })

// ✅ 关闭所有页面并跳转
wx.reLaunch({ url: '/pages/index/index' })
```

#### 3. 原生组件层级

**使用 cover-view 覆盖原生组件**:
```xml
<!-- 原生组件：video, map, canvas, camera, live-player 等 -->
<video src="{{videoUrl}}">
  <cover-view class="controls">
    <cover-image src="/images/play.png" />
  </cover-view>
</video>
```

#### 4. 异步陷阱

**避免竞态条件**:
```javascript
// ❌ 可能导致竞态
async loadData() {
  const data = await fetchData()
  this.setData({ data }) // 如果快速切换页面，可能更新已销毁的页面
}

// ✅ 检查页面是否存在
async loadData() {
  const data = await fetchData()
  if (this.data) { // 检查组件是否已销毁
    this.setData({ data })
  }
}
```

#### 5. 缓存与存储

**存储限制（单个 key 不超过 1MB，总大小不超过 10MB）**:
```javascript
// ✅ 使用同步 API（简单场景）
try {
  wx.setStorageSync('key', value)
  const data = wx.getStorageSync('key')
} catch (err) {
  console.error('存储失败', err)
}

// ✅ 使用异步 API（大数据场景）
wx.setStorage({
  key: 'largeData',
  data: value,
  success: () => console.log('存储成功'),
  fail: (err) => console.error('存储失败', err)
})
```

---

### 第八部分：API 使用规范

#### 1. 网络请求

**封装统一请求方法**:
```javascript
// utils/request.js
const BASE_URL = 'https://api.example.com'

const request = (url, options = {}) => {
  return new Promise((resolve, reject) => {
    wx.request({
      url: BASE_URL + url,
      method: options.method || 'GET',
      data: options.data || {},
      header: {
        'content-type': 'application/json',
        'Authorization': wx.getStorageSync('token') || '',
        ...options.header
      },
      timeout: 10000,
      success: (res) => {
        if (res.statusCode === 200) {
          resolve(res.data)
        } else {
          reject(new Error(`请求失败: ${res.statusCode}`))
        }
      },
      fail: (err) => {
        reject(err)
      }
    })
  })
}

// 使用示例
try {
  const data = await request('/api/user/info', {
    method: 'POST',
    data: { userId: 123 }
  })
  console.log(data)
} catch (err) {
  wx.showToast({ title: '网络请求失败', icon: 'none' })
}
```

#### 2. 用户授权

**优雅处理授权流程**:
```javascript
// 检查并请求授权
async checkPermission(scope) {
  try {
    const { authSetting } = await wx.getSetting()
    
    if (authSetting[scope]) {
      return true // 已授权
    }
    
    // 请求授权
    await wx.authorize({ scope })
    return true
  } catch (err) {
    // 用户拒绝授权，引导打开设置
    const res = await wx.showModal({
      title: '需要授权',
      content: '请在设置中开启相关权限',
      confirmText: '去设置'
    })
    
    if (res.confirm) {
      wx.openSetting()
    }
    return false
  }
}

// 使用示例
const hasPermission = await this.checkPermission('scope.userLocation')
if (hasPermission) {
  wx.getLocation({ ... })
}
```

#### 3. 登录与用户信息

**微信登录流程**:
```javascript
// 登录
async login() {
  try {
    // 1. 获取 code
    const { code } = await wx.login()
    
    // 2. 发送 code 到后端换取 token
    const { token, userInfo } = await request('/api/login', {
      method: 'POST',
      data: { code }
    })
    
    // 3. 保存 token
    wx.setStorageSync('token', token)
    wx.setStorageSync('userInfo', userInfo)
    
    return userInfo
  } catch (err) {
    console.error('登录失败', err)
    throw err
  }
}

// 获取用户信息（使用新版 API）
async getUserProfile() {
  try {
    const { userInfo } = await wx.getUserProfile({
      desc: '用于完善用户资料'
    })
    this.setData({ userInfo })
    return userInfo
  } catch (err) {
    console.log('用户取消授权')
  }
}
```

---

### 第九部分：云开发集成

#### 1. 云开发初始化

**微信云开发**:
```javascript
// app.js
App({
  onLaunch() {
    if (!wx.cloud) {
      console.error('请使用 2.2.3 或以上的基础库以使用云能力')
    } else {
      wx.cloud.init({
        env: 'your-env-id',
        traceUser: true
      })
    }
  }
})
```

#### 2. 云函数调用

```javascript
// 调用云函数
async callCloudFunction(name, data) {
  try {
    const res = await wx.cloud.callFunction({
      name: name,
      data: data
    })
    return res.result
  } catch (err) {
    console.error('云函数调用失败', err)
    throw err
  }
}

// 使用示例
const result = await this.callCloudFunction('getUser', { userId: 123 })
```

#### 3. 云数据库操作

```javascript
// 获取数据库引用
const db = wx.cloud.database()
const _ = db.command

// 查询
async getList() {
  try {
    const { data } = await db.collection('todos')
      .where({ status: _.neq('deleted') })
      .orderBy('createTime', 'desc')
      .limit(20)
      .get()
    return data
  } catch (err) {
    console.error('查询失败', err)
  }
}

// 添加
async addItem(item) {
  try {
    const { _id } = await db.collection('todos').add({
      data: {
        ...item,
        createTime: db.serverDate()
      }
    })
    return _id
  } catch (err) {
    console.error('添加失败', err)
  }
}

// 更新
async updateItem(id, updates) {
  try {
    await db.collection('todos').doc(id).update({
      data: updates
    })
  } catch (err) {
    console.error('更新失败', err)
  }
}
```

#### 4. 云存储

```javascript
// 上传文件
async uploadFile(filePath) {
  try {
    const cloudPath = `images/${Date.now()}-${Math.random()}.png`
    const { fileID } = await wx.cloud.uploadFile({
      cloudPath: cloudPath,
      filePath: filePath
    })
    return fileID
  } catch (err) {
    console.error('上传失败', err)
  }
}

// 下载文件
async downloadFile(fileID) {
  try {
    const { tempFilePath } = await wx.cloud.downloadFile({
      fileID: fileID
    })
    return tempFilePath
  } catch (err) {
    console.error('下载失败', err)
  }
}
```

---

### 第十部分：测试策略

#### 1. 单元测试

**使用小程序官方测试框架**:
```javascript
// 安装 miniprogram-simulate
// npm install --save-dev miniprogram-simulate

const simulate = require('miniprogram-simulate')

test('custom-component', () => {
  const id = simulate.load('/components/custom-component/index')
  const comp = simulate.render(id)
  
  // 测试初始状态
  expect(comp.data.count).toBe(0)
  
  // 触发事件
  comp.querySelector('.button').dispatchEvent('tap')
  
  // 验证状态变化
  expect(comp.data.count).toBe(1)
})
```

#### 2. 端到端测试

**使用自动化测试工具**:
```javascript
// miniprogram-automator
const automator = require('miniprogram-automator')

describe('index page', () => {
  let miniProgram
  let page

  beforeAll(async () => {
    miniProgram = await automator.launch({
      projectPath: 'path/to/project'
    })
    page = await miniProgram.reLaunch('/pages/index/index')
    await page.waitFor(500)
  })

  it('should display title', async () => {
    const title = await page.$('.title')
    expect(await title.text()).toBe('Welcome')
  })

  afterAll(async () => {
    await miniProgram.close()
  })
})
```

#### 3. 真机调试与预览

**使用 miniprogram-ci**:
```javascript
// scripts/preview.js
const ci = require('miniprogram-ci')

const project = new ci.Project({
  appid: 'your-appid',
  type: 'miniProgram',
  projectPath: 'path/to/project',
  privateKeyPath: 'path/to/private.key'
})

;(async () => {
  const previewResult = await ci.preview({
    project,
    desc: '预览描述',
    qrcodeFormat: 'image',
    qrcodeOutputDest: './preview.jpg'
  })
  console.log(previewResult)
})()
```

---

### 第十一部分：安全规范

#### 1. 数据加密

```javascript
// 敏感数据加密
const crypto = require('crypto-js')

// 加密
function encrypt(data, key) {
  return crypto.AES.encrypt(JSON.stringify(data), key).toString()
}

// 解密
function decrypt(ciphertext, key) {
  const bytes = crypto.AES.decrypt(ciphertext, key)
  return JSON.parse(bytes.toString(crypto.enc.Utf8))
}
```

#### 2. 防止 XSS 攻击

```javascript
// 转义用户输入
function escapeHtml(text) {
  const map = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  }
  return text.replace(/[&<>"']/g, m => map[m])
}
```

#### 3. 敏感信息处理

```javascript
// ❌ 不要在代码中硬编码敏感信息
const API_KEY = 'sk-xxxxxxxxxxxxxxxx' // 错误！

// ✅ 使用环境变量或云函数
// 在云函数中调用第三方 API
// 小程序端只调用自己的云函数
```

---

### 第十二部分：用户体验优化

#### 1. 加载优化

**骨架屏**:
```xml
<view class="skeleton" wx:if="{{loading}}">
  <view class="skeleton-avatar"></view>
  <view class="skeleton-text"></view>
</view>
<view wx:else>
  <!-- 实际内容 -->
</view>
```

**下拉刷新**:
```javascript
onPullDownRefresh() {
  this.loadData().then(() => {
    wx.stopPullDownRefresh()
  })
}
```

**触底加载**:
```javascript
onReachBottom() {
  if (this.data.hasMore && !this.data.loading) {
    this.loadMore()
  }
}
```

#### 2. 交互反馈

**加载提示**:
```javascript
wx.showLoading({ title: '加载中...' })
try {
  await fetchData()
} finally {
  wx.hideLoading()
}
```

**操作反馈**:
```javascript
// 成功提示
wx.showToast({ title: '操作成功', icon: 'success' })

// 失败提示
wx.showToast({ title: '操作失败', icon: 'none' })

// 确认对话框
const res = await wx.showModal({
  title: '提示',
  content: '确定要删除吗？'
})
if (res.confirm) {
  // 执行删除
}
```

#### 3. 错误处理

**全局错误处理**:
```javascript
// app.js
App({
  onError(err) {
    console.error('全局错误', err)
    // 上报错误日志
    this.reportError(err)
  },
  
  onPageNotFound(res) {
    wx.redirectTo({
      url: '/pages/404/404'
    })
  }
})
```

---

### 第十三部分：调试与发布

#### 1. 开发调试

**调试技巧**:
- 使用 console 分组和样式
- 利用 vConsole 查看日志
- 使用开发者工具的调试面板
- 真机调试查看性能和兼容性

**性能监控**:
```javascript
// 使用 Performance API
const observer = wx.createIntersectionObserver()
observer.relativeTo('.container').observe('.item', (res) => {
  console.log('元素可见性', res.intersectionRatio)
})
```

#### 2. 版本管理

**app.json 版本配置**:
```json
{
  "version": "1.0.0",
  "versionDescription": "首次发布"
}
```

**兼容性处理**:
```javascript
// 检查 API 是否可用
if (wx.canIUse('getPrivacySetting')) {
  wx.getPrivacySetting({
    success: res => {
      console.log(res.needAuthorization)
    }
  })
}

// 检查基础库版本
const systemInfo = wx.getSystemInfoSync()
if (compareVersion(systemInfo.SDKVersion, '2.10.0') >= 0) {
  // 使用新 API
}
```

#### 3. 发布流程

**发布前检查清单**:
- [ ] 代码审查和测试通过
- [ ] 真机预览验证功能
- [ ] 检查分包大小（单包 < 2MB，总包 < 20MB）
- [ ] 隐私协议和权限说明完善
- [ ] 配置正确的服务器域名
- [ ] 清理无用代码和资源
- [ ] 更新版本号和版本描述

**使用 CI 工具上传**:
```javascript
const ci = require('miniprogram-ci')

;(async () => {
  const project = new ci.Project({
    appid: 'your-appid',
    type: 'miniProgram',
    projectPath: 'path/to/project',
    privateKeyPath: 'path/to/private.key'
  })

  await ci.upload({
    project,
    version: '1.0.0',
    desc: '版本描述',
    setting: {
      es6: true,
      minify: true
    }
  })
})()
```

---

### 第十四部分：进阶内容

#### 1. 自定义 TabBar

```javascript
// custom-tab-bar/index.js
Component({
  data: {
    selected: 0,
    list: [
      { pagePath: '/pages/home/home', text: '首页', iconPath: '/images/home.png' },
      { pagePath: '/pages/mine/mine', text: '我的', iconPath: '/images/mine.png' }
    ]
  },
  methods: {
    switchTab(e) {
      const index = e.currentTarget.dataset.index
      const pagePath = this.data.list[index].pagePath
      wx.switchTab({ url: pagePath })
      this.setData({ selected: index })
    }
  }
})
```

#### 2. 分享功能

```javascript
// 自定义分享
onShareAppMessage() {
  return {
    title: '分享标题',
    path: '/pages/index/index?id=123',
    imageUrl: '/images/share.png'
  }
}

// 分享到朋友圈
onShareTimeline() {
  return {
    title: '分享标题',
    query: 'id=123',
    imageUrl: '/images/share.png'
  }
}
```

#### 3. 订阅消息

```javascript
// 请求订阅消息
async requestSubscribeMessage(tmplIds) {
  try {
    const res = await wx.requestSubscribeMessage({
      tmplIds: tmplIds
    })
    console.log('订阅结果', res)
    return res
  } catch (err) {
    console.log('用户拒绝订阅')
  }
}
```

#### 4. 小程序跳转

```javascript
// 跳转到其他小程序
wx.navigateToMiniProgram({
  appId: 'target-appid',
  path: 'pages/index/index',
  extraData: { foo: 'bar' },
  success: () => console.log('跳转成功')
})
```

---

### 第十五部分：工作流程与最佳实践

#### 1. 开发工作流

```
需求分析 → 技术方案 → UI 设计 → 开发实现 → 单元测试 → 集成测试 → 真机预览 → 代码审查 → 上传体验版 → 提交审核 → 发布上线 → 监控反馈
```

#### 2. Git 工作流

```bash
# 功能分支开发
git checkout -b feature/user-login
git add .
git commit -m "feat: 实现用户登录功能"
git push origin feature/user-login

# 合并到主分支
git checkout main
git merge feature/user-login
```

#### 3. 代码审查要点

- 代码规范性（命名、格式、注释）
- 功能完整性（是否满足需求）
- 性能优化（setData、渲染、包体积）
- 安全性（数据加密、权限控制）
- 可维护性（模块化、可读性）
- 兼容性（iOS/Android、不同版本）

---

### 第十六部分：附录

#### 1. 常用 API 速查

**界面**:
- wx.showToast: 提示框
- wx.showModal: 对话框
- wx.showLoading: 加载提示
- wx.showActionSheet: 操作菜单

**路由**:
- wx.navigateTo: 保留当前页面，跳转
- wx.redirectTo: 关闭当前页面，跳转
- wx.switchTab: 跳转到 tabBar 页面
- wx.navigateBack: 返回上一页
- wx.reLaunch: 关闭所有页面，跳转

**网络**:
- wx.request: HTTP 请求
- wx.uploadFile: 上传文件
- wx.downloadFile: 下载文件
- wx.connectSocket: WebSocket 连接

**数据缓存**:
- wx.setStorage: 异步存储
- wx.getStorage: 异步获取
- wx.removeStorage: 异步删除
- wx.clearStorage: 清空缓存

**媒体**:
- wx.chooseImage: 选择图片
- wx.previewImage: 预览图片
- wx.chooseVideo: 选择视频
- wx.createVideoContext: 视频控制

#### 2. 常用组件速查

**视图容器**:
- view: 视图容器
- scroll-view: 滚动视图
- swiper: 轮播容器
- movable-view: 可移动视图

**基础内容**:
- text: 文本
- icon: 图标
- progress: 进度条
- rich-text: 富文本

**表单组件**:
- button: 按钮
- input: 输入框
- textarea: 多行输入
- picker: 选择器
- switch: 开关

**导航**:
- navigator: 页面链接

**媒体组件**:
- image: 图片
- video: 视频
- camera: 相机
- live-player: 直播播放

#### 3. 关键性能指标

- 首屏渲染时间 < 2s
- setData 单次数据 < 1024KB
- 代码包总大小 < 20MB
- 单个分包 < 2MB
- 页面栈深度 < 10 层
- 列表渲染 < 100 项（使用虚拟列表）

#### 4. 参考资源链接

- 微信官方文档: https://developers.weixin.qq.com/miniprogram/dev/framework/
- 小程序社区: https://developers.weixin.qq.com/community/
- 云开发文档: https://developers.weixin.qq.com/miniprogram/dev/wxcloud/basis/getting-started.html
- 性能优化指南: https://developers.weixin.qq.com/miniprogram/dev/framework/performance/

---

## 总结

本大纲涵盖了微信小程序开发的全方位内容，采用分层渐进式架构，从基础概念到高级技巧，从开发规范到性能优化，从常见问题到最佳实践，为 AI 助手提供全面的指导。

**核心优势**:
- ✅ 场景定义清晰（明确触发条件）
- ✅ 代码规范详细（提供具体示例）
- ✅ 性能优化深入（setData、渲染、包体积）
- ✅ 防坑指南实用（iOS/Android 兼容性）
- ✅ 知识覆盖全面（框架、API、云开发）
- ✅ 创新补充完善（测试、安全、UX）

下一步：基于此大纲编写完整的 SKILL.md 文件。
