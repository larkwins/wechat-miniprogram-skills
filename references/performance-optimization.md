# 微信小程序性能优化详解

深入解析微信小程序性能优化的各个方面，帮助你打造流畅的用户体验。

## 📊 性能指标

### 关键性能指标

| 指标 | 说明 | 目标值 | 优秀值 |
|------|------|--------|--------|
| **首屏渲染时间** | 从打开小程序到首屏内容展示 | < 2s | < 1s |
| **页面切换时间** | 页面跳转的响应时间 | < 300ms | < 150ms |
| **代码包大小** | 主包 + 分包总大小 | < 8MB | < 4MB |
| **setData 耗时** | 单次 setData 调用耗时 | < 30ms | < 15ms |
| **渲染帧率** | 页面滚动、动画的流畅度 | > 50fps | > 58fps |
| **内存占用** | 小程序运行时内存 | < 200MB | < 100MB |

### 性能评分工具

```javascript
// 使用微信开发者工具的"体验评分"功能
// 工具栏 → 工具 → 体验评分

// 或者使用性能面板
const performance = wx.getPerformance();
const observer = performance.createObserver((entryList) => {
  console.log(entryList.getEntries());
});

observer.observe({ 
  entryTypes: ['render', 'script', 'navigation'] 
});
```

## ⚡ setData 优化（核心重点）

### 为什么 setData 是性能瓶颈？

```
逻辑层 (JS)                    渲染层 (WebView)
    |                              |
    |  1. 调用 setData              |
    |----------------------------->|
    |  2. 序列化数据               |
    |  3. 通过 Native 传输         |
    |----------------------------->|
    |                    4. 反序列化数据
    |                    5. diff 数据
    |                    6. 更新 DOM
    |                    7. 重新渲染
```

### 1. 减少 setData 调用频率

#### ❌ 避免：频繁调用

```javascript
// 错误示例：每次循环都调用 setData
for (let i = 0; i < 100; i++) {
  this.setData({
    [`items[${i}]`]: data[i]
  });
}

// 错误示例：短时间内多次调用
this.setData({ a: 1 });
this.setData({ b: 2 });
this.setData({ c: 3 });
```

#### ✅ 推荐：批量更新

```javascript
// 正确示例：一次性更新
const updates = {};
for (let i = 0; i < 100; i++) {
  updates[`items[${i}]`] = data[i];
}
this.setData(updates);

// 正确示例：合并多次更新
this.setData({
  a: 1,
  b: 2,
  c: 3
});
```

### 2. 减少 setData 数据量

#### ❌ 避免：传输大量数据

```javascript
// 错误示例：传输整个数组
this.setData({
  list: newList // 假设有 1000 个元素
});

// 错误示例：传输未使用的数据
this.setData({
  userInfo: {
    id: 1,
    name: 'John',
    age: 20,
    address: '...',
    // ... 100 个字段
  }
});
```

#### ✅ 推荐：只更新变化的部分

```javascript
// 正确示例：只更新变化的元素
this.setData({
  [`list[${index}]`]: newItem
});

// 正确示例：只传递需要的字段
this.setData({
  'userInfo.name': newName,
  'userInfo.age': newAge
});

// 正确示例：使用虚拟列表
// 只渲染可见区域的数据
this.setData({
  visibleItems: list.slice(startIndex, endIndex)
});
```

### 3. 避免设置不在 WXML 中使用的数据

#### ❌ 避免：设置冗余数据

```javascript
// 错误示例：_开头的内部变量也传入 setData
this.setData({
  list: data,
  _rawData: originalData,  // ❌ 页面不使用
  _timestamp: Date.now(),  // ❌ 页面不使用
  _requestId: uuid()       // ❌ 页面不使用
});
```

#### ✅ 推荐：分离渲染数据和逻辑数据

```javascript
// 正确示例：内部数据存储在组件实例上
this._rawData = originalData;
this._timestamp = Date.now();
this._requestId = uuid();

// 只传递渲染需要的数据
this.setData({
  list: data
});
```

### 4. 使用 setData 回调

```javascript
// 在 setData 完成后执行操作
this.setData({
  list: newList
}, () => {
  // 此时页面已经渲染完成
  console.log('渲染完成');
  
  // 可以进行 DOM 查询
  wx.createSelectorQuery()
    .select('.item')
    .boundingClientRect((rect) => {
      console.log(rect);
    })
    .exec();
});
```

### 5. 使用节流和防抖

```javascript
// 节流：限制执行频率
function throttle(fn, delay) {
  let timer = null;
  return function(...args) {
    if (timer) return;
    timer = setTimeout(() => {
      fn.apply(this, args);
      timer = null;
    }, delay);
  };
}

// 防抖：延迟执行
function debounce(fn, delay) {
  let timer = null;
  return function(...args) {
    clearTimeout(timer);
    timer = setTimeout(() => {
      fn.apply(this, args);
    }, delay);
  };
}

// 使用示例
Page({
  // 滚动事件使用节流
  onScroll: throttle(function(e) {
    this.setData({
      scrollTop: e.detail.scrollTop
    });
  }, 100),
  
  // 搜索输入使用防抖
  onSearchInput: debounce(function(e) {
    this.search(e.detail.value);
  }, 300)
});
```

## 🎨 渲染性能优化

### 1. 减少 WXML 节点数量

#### ❌ 避免：过多的嵌套

```xml
<!-- 错误示例：嵌套层级过深 -->
<view class="outer">
  <view class="middle">
    <view class="inner">
      <view class="content">
        <text>内容</text>
      </view>
    </view>
  </view>
</view>
```

#### ✅ 推荐：扁平化结构

```xml
<!-- 正确示例：减少嵌套 -->
<view class="container">
  <text>内容</text>
</view>
```

### 2. 使用 hidden 代替 wx:if

#### 适用场景对比

```xml
<!-- wx:if - 条件为 false 时不渲染节点 -->
<!-- 适合：频繁切换的场景 -->
<view wx:if="{{showModal}}">弹窗内容</view>

<!-- hidden - 始终渲染但控制显示 -->
<!-- 适合：初始化成本高、切换频繁的场景 -->
<view hidden="{{!showContent}}">内容区域</view>
```

```javascript
// 使用建议
Page({
  data: {
    // 很少切换 → 使用 wx:if
    isLogin: false,
    
    // 频繁切换 → 使用 hidden
    showLoading: false
  }
});
```

### 3. 长列表优化

#### 方案一：虚拟列表

```javascript
// 只渲染可见区域的数据
Page({
  data: {
    allItems: [],        // 所有数据
    visibleItems: [],    // 可见数据
    itemHeight: 100,     // 每项高度
    visibleCount: 10     // 可见数量
  },
  
  onScroll(e) {
    const scrollTop = e.detail.scrollTop;
    const startIndex = Math.floor(scrollTop / this.data.itemHeight);
    const endIndex = startIndex + this.data.visibleCount;
    
    this.setData({
      visibleItems: this.data.allItems.slice(startIndex, endIndex),
      scrollOffset: startIndex * this.data.itemHeight
    });
  }
});
```

```xml
<scroll-view 
  scroll-y 
  bindscroll="onScroll"
  style="height: 100vh;">
  <!-- 占位元素 -->
  <view style="height: {{scrollOffset}}px;"></view>
  
  <!-- 可见元素 -->
  <view 
    wx:for="{{visibleItems}}" 
    wx:key="id"
    style="height: {{itemHeight}}px;">
    {{item.name}}
  </view>
  
  <!-- 底部占位 -->
  <view style="height: {{(allItems.length - visibleItems.length) * itemHeight}}px;"></view>
</scroll-view>
```

#### 方案二：分页加载

```javascript
Page({
  data: {
    list: [],
    page: 1,
    pageSize: 20,
    hasMore: true,
    loading: false
  },
  
  async loadMore() {
    if (this.data.loading || !this.data.hasMore) return;
    
    this.setData({ loading: true });
    
    const newData = await api.getList({
      page: this.data.page,
      pageSize: this.data.pageSize
    });
    
    this.setData({
      list: [...this.data.list, ...newData],
      page: this.data.page + 1,
      hasMore: newData.length === this.data.pageSize,
      loading: false
    });
  },
  
  onReachBottom() {
    this.loadMore();
  }
});
```

### 4. 图片优化

#### ❌ 避免

```xml
<!-- 错误示例：使用原图 -->
<image src="https://example.com/image.jpg" />

<!-- 错误示例：没有指定尺寸 -->
<image src="{{imageUrl}}" />
```

#### ✅ 推荐

```xml
<!-- 正确示例：使用缩略图 -->
<image 
  src="{{imageUrl}}?x-oss-process=image/resize,w_750"
  mode="aspectFill"
  style="width: 375rpx; height: 375rpx;"
  lazy-load="{{true}}" />

<!-- 正确示例：WebP 格式 -->
<image 
  src="{{imageUrl}}.webp"
  webp="{{true}}" />
```

```javascript
// 图片压缩
function compressImage(src) {
  return new Promise((resolve) => {
    wx.compressImage({
      src,
      quality: 80,
      success: (res) => resolve(res.tempFilePath)
    });
  });
}
```

### 5. 使用骨架屏

```xml
<!-- 骨架屏组件 -->
<view class="skeleton" wx:if="{{loading}}">
  <view class="skeleton-avatar"></view>
  <view class="skeleton-line"></view>
  <view class="skeleton-line"></view>
</view>

<view wx:else>
  <!-- 实际内容 -->
</view>
```

```css
.skeleton-avatar {
  width: 100rpx;
  height: 100rpx;
  background: linear-gradient(90deg, #f2f2f2 25%, #e6e6e6 50%, #f2f2f2 75%);
  background-size: 400% 100%;
  animation: loading 1.4s ease infinite;
  border-radius: 50%;
}

.skeleton-line {
  height: 30rpx;
  margin: 20rpx 0;
  background: linear-gradient(90deg, #f2f2f2 25%, #e6e6e6 50%, #f2f2f2 75%);
  background-size: 400% 100%;
  animation: loading 1.4s ease infinite;
}

@keyframes loading {
  0% { background-position: 100% 50%; }
  100% { background-position: 0 50%; }
}
```

## 📦 代码包优化

### 1. 分包加载

#### app.json 配置

```json
{
  "pages": [
    "pages/index/index",
    "pages/list/list"
  ],
  "subpackages": [
    {
      "root": "packageA",
      "pages": [
        "pages/detail/detail",
        "pages/profile/profile"
      ]
    },
    {
      "root": "packageB",
      "name": "shop",
      "pages": [
        "pages/shop/shop",
        "pages/cart/cart"
      ]
    }
  ],
  "preloadRule": {
    "pages/list/list": {
      "network": "all",
      "packages": ["packageA"]
    }
  }
}
```

### 2. 独立分包

```json
{
  "subpackages": [
    {
      "root": "packageC",
      "pages": [
        "pages/activity/activity"
      ],
      "independent": true
    }
  ]
}
```

### 3. 代码压缩

```javascript
// 删除 console
if (process.env.NODE_ENV === 'production') {
  console.log = () => {};
  console.warn = () => {};
  console.error = () => {};
}

// 使用 ES6+ 简洁语法
// ❌ 避免
function add(a, b) {
  return a + b;
}

// ✅ 推荐
const add = (a, b) => a + b;
```

### 4. 按需引入

```javascript
// ❌ 避免：引入整个库
import _ from 'lodash';

// ✅ 推荐：按需引入
import throttle from 'lodash/throttle';
import debounce from 'lodash/debounce';
```

## 🚀 启动性能优化

### 1. 首屏数据预加载

```javascript
// app.js
App({
  async onLaunch() {
    // 预加载首屏数据
    this.globalData.indexData = await api.getIndexData();
  }
});

// pages/index/index.js
Page({
  onLoad() {
    const app = getApp();
    if (app.globalData.indexData) {
      // 使用预加载的数据
      this.setData({
        list: app.globalData.indexData
      });
    } else {
      // 加载数据
      this.loadData();
    }
  }
});
```

### 2. 骨架屏

```xml
<!-- 首屏使用骨架屏 -->
<view class="skeleton" wx:if="{{!loaded}}">
  <!-- 骨架屏内容 -->
</view>

<view wx:else>
  <!-- 实际内容 -->
</view>
```

### 3. 避免同步 API

```javascript
// ❌ 避免：同步 API 阻塞渲染
const value = wx.getStorageSync('key');
const systemInfo = wx.getSystemInfoSync();

// ✅ 推荐：异步 API
wx.getStorage({
  key: 'key',
  success: (res) => {
    console.log(res.data);
  }
});

wx.getSystemInfo({
  success: (res) => {
    console.log(res);
  }
});
```

## 🌐 网络优化

### 1. 请求合并

```javascript
// ❌ 避免：多个串行请求
async loadData() {
  const user = await api.getUser();
  const orders = await api.getOrders();
  const products = await api.getProducts();
}

// ✅ 推荐：并行请求
async loadData() {
  const [user, orders, products] = await Promise.all([
    api.getUser(),
    api.getOrders(),
    api.getProducts()
  ]);
}
```

### 2. 请求缓存

```javascript
class RequestCache {
  constructor() {
    this.cache = new Map();
    this.cacheTime = 5 * 60 * 1000; // 5分钟
  }
  
  async request(url, options = {}) {
    const key = url + JSON.stringify(options);
    const cached = this.cache.get(key);
    
    // 检查缓存
    if (cached && Date.now() - cached.timestamp < this.cacheTime) {
      return cached.data;
    }
    
    // 发起请求
    const data = await wx.request({ url, ...options });
    
    // 存储缓存
    this.cache.set(key, {
      data,
      timestamp: Date.now()
    });
    
    return data;
  }
}

const cache = new RequestCache();
```

### 3. 预加载数据

```javascript
// 在页面 A 预加载页面 B 的数据
Page({
  goToDetail(e) {
    const { id } = e.currentTarget.dataset;
    
    // 预加载详情数据
    api.getDetail(id).then((data) => {
      getApp().globalData.detailData = data;
    });
    
    // 跳转页面
    wx.navigateTo({
      url: `/pages/detail/detail?id=${id}`
    });
  }
});
```

## 💾 内存优化

### 1. 及时清理数据

```javascript
Page({
  onUnload() {
    // 页面卸载时清理数据
    this.setData({
      list: [],
      images: []
    });
    
    // 清理定时器
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
    
    // 清理事件监听
    if (this.audioContext) {
      this.audioContext.destroy();
      this.audioContext = null;
    }
  }
});
```

### 2. 使用分页而不是一次性加载

```javascript
// ❌ 避免
async loadAllData() {
  const data = await api.getAll(); // 加载所有数据
  this.setData({ list: data });
}

// ✅ 推荐
async loadPage() {
  const data = await api.getPage(this.page, 20);
  this.setData({
    list: [...this.data.list, ...data]
  });
}
```

## 📈 监控与分析

### 1. 使用性能监控

```javascript
// 监听页面性能
Page({
  onLoad() {
    const performance = wx.getPerformance();
    const observer = performance.createObserver((entryList) => {
      const entries = entryList.getEntries();
      entries.forEach((entry) => {
        console.log('性能指标:', {
          name: entry.name,
          duration: entry.duration,
          startTime: entry.startTime
        });
      });
    });
    
    observer.observe({ 
      entryTypes: ['navigation', 'render', 'script'] 
    });
  }
});
```

### 2. 上报性能数据

```javascript
// 上报到服务器
function reportPerformance(data) {
  wx.request({
    url: 'https://api.example.com/performance',
    method: 'POST',
    data: {
      page: getCurrentPages()[0].route,
      metrics: data,
      timestamp: Date.now()
    }
  });
}
```

## 🎯 性能优化检查清单

### 启动性能
- [ ] 主包大小 < 2MB
- [ ] 首屏数据预加载
- [ ] 使用骨架屏
- [ ] 避免同步 API

### 运行性能
- [ ] setData 调用频率 < 10次/秒
- [ ] 单次 setData 数据量 < 1MB
- [ ] 只更新变化的数据
- [ ] 使用节流/防抖

### 渲染性能
- [ ] WXML 节点数 < 1000
- [ ] 长列表使用虚拟列表
- [ ] 图片使用 lazy-load
- [ ] 图片使用合适的尺寸

### 内存性能
- [ ] 及时清理数据
- [ ] 使用分页加载
- [ ] 清理定时器和监听器

### 网络性能
- [ ] 并行请求
- [ ] 请求缓存
- [ ] 预加载数据
- [ ] 使用 CDN

## 📚 参考资源

- [微信小程序性能优化指南](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/)
- [小程序运行时性能优化](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/tips/runtime.html)
- [小程序启动性能优化](https://developers.weixin.qq.com/miniprogram/dev/framework/performance/tips/start.html)
- [体验评分](https://developers.weixin.qq.com/miniprogram/dev/framework/audits/scoring.html)
