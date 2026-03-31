# 微信小程序基础模板

这是一个最小化的微信小程序项目模板，适合快速上手和学习。

## 📁 项目结构

```
basic-template/
├── pages/
│   └── index/
│       ├── index.js
│       ├── index.json
│       ├── index.wxml
│       └── index.wxss
├── app.js
├── app.json
├── app.wxss
└── project.config.json
```

## 📝 代码文件

### app.js - 小程序入口

```javascript
App({
  onLaunch() {
    console.log('小程序启动');
  },
  
  globalData: {
    userInfo: null
  }
});
```

### app.json - 全局配置

```json
{
  "pages": [
    "pages/index/index"
  ],
  "window": {
    "navigationBarTitleText": "微信小程序",
    "navigationBarBackgroundColor": "#ffffff",
    "navigationBarTextStyle": "black",
    "backgroundColor": "#f5f5f5"
  }
}
```

### app.wxss - 全局样式

```css
/**app.wxss**/
page {
  height: 100%;
  background-color: #f5f5f5;
}

.container {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx;
  box-sizing: border-box;
}
```

### pages/index/index.wxml - 页面结构

```xml
<view class="container">
  <view class="title">Hello World</view>
  <view class="description">欢迎使用微信小程序</view>
  <button bindtap="handleClick" type="primary">点击我</button>
</view>
```

### pages/index/index.wxss - 页面样式

```css
.container {
  padding: 40rpx;
}

.title {
  font-size: 48rpx;
  font-weight: bold;
  color: #333;
  margin-bottom: 20rpx;
}

.description {
  font-size: 28rpx;
  color: #666;
  margin-bottom: 60rpx;
}

button {
  width: 400rpx;
}
```

### pages/index/index.js - 页面逻辑

```javascript
Page({
  data: {
    message: 'Hello World'
  },

  onLoad() {
    console.log('页面加载');
  },

  handleClick() {
    wx.showToast({
      title: '你点击了按钮',
      icon: 'success'
    });
  }
});
```

### pages/index/index.json - 页面配置

```json
{
  "navigationBarTitleText": "首页"
}
```

### project.config.json - 项目配置

```json
{
  "description": "微信小程序基础模板",
  "appid": "your-appid",
  "compileType": "miniprogram",
  "libVersion": "3.0.0",
  "setting": {
    "useCompilerPlugins": []
  }
}
```

## 🚀 快速开始

### 1. 创建项目

1. 打开微信开发者工具
2. 选择"小程序" → "新建项目"
3. 填写 AppID（测试可选择"测试号"）
4. 选择项目目录
5. 点击"新建"

### 2. 运行项目

1. 在开发者工具中打开项目
2. 点击"编译"按钮
3. 在模拟器中查看效果

### 3. 真机调试

1. 点击工具栏"预览"按钮
2. 使用微信扫描二维码
3. 在手机上查看效果

## 📚 学习资源

### 基础概念

1. **WXML**: 页面结构（类似 HTML）
2. **WXSS**: 页面样式（类似 CSS）
3. **JS**: 页面逻辑
4. **JSON**: 配置文件

### 核心特性

- **数据绑定**: `{{ message }}`
- **条件渲染**: `wx:if`, `wx:elif`, `wx:else`
- **列表渲染**: `wx:for`
- **事件绑定**: `bindtap`, `bindinput`

## 🎯 下一步

从这个基础模板开始，你可以：

1. **添加更多页面**
   ```json
   // app.json
   {
     "pages": [
       "pages/index/index",
       "pages/about/about"
     ]
   }
   ```

2. **使用组件**
   ```xml
   <view>
     <button>按钮</button>
     <input placeholder="输入框" />
     <image src="/images/logo.png" />
   </view>
   ```

3. **网络请求**
   ```javascript
   wx.request({
     url: 'https://api.example.com/data',
     success: (res) => {
       console.log(res.data);
     }
   });
   ```

4. **本地存储**
   ```javascript
   // 存储
   wx.setStorageSync('key', 'value');
   
   // 获取
   const value = wx.getStorageSync('key');
   ```

5. **页面跳转**
   ```javascript
   wx.navigateTo({
     url: '/pages/about/about'
   });
   ```

## 📖 参考文档

- [微信小程序官方文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [小程序开发指南](https://developers.weixin.qq.com/ebook?action=get_post_info&docid=0008aeea9a8978ab0086a685851c0a)
- [小程序组件文档](https://developers.weixin.qq.com/miniprogram/dev/component/)
- [小程序 API 文档](https://developers.weixin.qq.com/miniprogram/dev/api/)

## ⚡ 快速提示

### 常用快捷键

- `Ctrl + S`: 保存并编译
- `Ctrl + Shift + 1`: 模拟器
- `Ctrl + Shift + 2`: 编辑器
- `Ctrl + Shift + 3`: 调试器

### 常见问题

1. **不合法的域名**
   - 解决：开发者工具 → 详情 → 本地设置 → 勾选"不校验合法域名"

2. **代码包过大**
   - 解决：使用分包加载、压缩图片、清理无用代码

3. **setData 卡顿**
   - 解决：减少 setData 频率、只更新变化的数据

## 🔧 调试技巧

### 1. 使用 console

```javascript
console.log('普通日志');
console.warn('警告信息');
console.error('错误信息');
```

### 2. 调试面板

- **Console**: 查看日志
- **Sources**: 设置断点
- **Network**: 查看网络请求
- **Storage**: 查看本地存储
- **AppData**: 查看页面数据

### 3. 真机调试

1. 点击"真机调试"按钮
2. 扫描二维码
3. 在手机上打开 vConsole 面板（右下角绿色按钮）

## 💡 最佳实践

### ✅ 推荐

```javascript
// 1. 使用 const/let 代替 var
const name = 'John';
let age = 20;

// 2. 使用箭头函数
const add = (a, b) => a + b;

// 3. 解构赋值
const { userInfo } = this.data;

// 4. 模板字符串
const message = `Hello, ${name}`;

// 5. async/await 处理异步
async getData() {
  try {
    const res = await wx.request({ url: '...' });
    console.log(res);
  } catch (err) {
    console.error(err);
  }
}
```

### ❌ 避免

```javascript
// 1. 避免直接修改 data
this.data.count++; // ❌

// 2. 避免在 setData 中传递函数
this.setData({
  callback: () => {} // ❌
});

// 3. 避免频繁 setData
for (let i = 0; i < 100; i++) {
  this.setData({ count: i }); // ❌
}
```

## 🎨 UI 示例

### 常用布局

```xml
<!-- 垂直布局 -->
<view class="flex-column">
  <view>项目1</view>
  <view>项目2</view>
</view>

<!-- 水平布局 -->
<view class="flex-row">
  <view>项目1</view>
  <view>项目2</view>
</view>

<!-- 居中布局 -->
<view class="flex-center">
  <view>居中内容</view>
</view>
```

```css
.flex-column {
  display: flex;
  flex-direction: column;
}

.flex-row {
  display: flex;
  flex-direction: row;
}

.flex-center {
  display: flex;
  align-items: center;
  justify-content: center;
}
```

## 🚀 下一步学习

1. **完成官方教程**: [小程序开发教程](https://developers.weixin.qq.com/miniprogram/dev/framework/quickstart/)
2. **查看示例代码**: 开发者工具 → 新建项目 → 选择官方示例
3. **加入开发者社区**: [微信开放社区](https://developers.weixin.qq.com/community/develop)
4. **尝试进阶项目**: 
   - 云开发项目
   - TypeScript 项目
   - 使用 Taro/Uni-app 框架

祝你开发愉快！🎉
