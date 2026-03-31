# 微信小程序 API 速查手册

快速查找和使用微信小程序常用 API。

## 📱 基础 API

### 系统信息

```javascript
// 获取系统信息（同步）
const systemInfo = wx.getSystemInfoSync();
console.log(systemInfo);
// {
//   brand: "Apple",
//   model: "iPhone 12",
//   platform: "ios",
//   system: "iOS 14.0",
//   version: "8.0.5",
//   screenWidth: 375,
//   screenHeight: 812,
//   windowWidth: 375,
//   windowHeight: 724,
//   statusBarHeight: 44,
//   safeArea: {...}
// }

// 获取系统信息（异步）
wx.getSystemInfo({
  success: (res) => {
    console.log(res);
  }
});
```

### 网络状态

```javascript
// 获取网络类型
wx.getNetworkType({
  success: (res) => {
    console.log(res.networkType); // wifi, 2g, 3g, 4g, 5g, none, unknown
  }
});

// 监听网络状态变化
wx.onNetworkStatusChange((res) => {
  console.log(res.isConnected); // 是否有网络连接
  console.log(res.networkType);  // 网络类型
});
```

### 账号信息

```javascript
// 获取账号信息
const accountInfo = wx.getAccountInfoSync();
console.log(accountInfo);
// {
//   miniProgram: {
//     appId: "wxe5f52902cf4de896",
//     envVersion: "develop" // develop(开发版), trial(体验版), release(正式版)
//   }
// }
```

## 🔐 用户相关

### 登录

```javascript
// 用户登录
wx.login({
  success: (res) => {
    if (res.code) {
      // 发送 res.code 到后台换取 openId, sessionKey, unionId
      wx.request({
        url: 'https://api.example.com/login',
        data: { code: res.code }
      });
    }
  }
});
```

### 用户信息

```javascript
// 获取用户信息（需用户授权）
wx.getUserProfile({
  desc: '用于完善用户资料',
  success: (res) => {
    console.log(res.userInfo);
    // {
    //   nickName: "微信用户",
    //   avatarUrl: "https://...",
    //   gender: 1, // 0: 未知, 1: 男, 2: 女
    //   country: "China",
    //   province: "Guangdong",
    //   city: "Shenzhen"
    // }
  }
});
```

### 授权设置

```javascript
// 获取用户当前设置
wx.getSetting({
  success: (res) => {
    console.log(res.authSetting);
    // {
    //   "scope.userInfo": true,
    //   "scope.userLocation": false
    // }
  }
});

// 提前向用户发起授权请求
wx.authorize({
  scope: 'scope.userLocation',
  success: () => {
    // 用户已经同意授权
    wx.getLocation({...});
  },
  fail: () => {
    // 用户拒绝授权
  }
});

// 打开设置页面
wx.openSetting({
  success: (res) => {
    console.log(res.authSetting);
  }
});
```

## 🌐 网络请求

### HTTP 请求

```javascript
// 发起 HTTPS 网络请求
wx.request({
  url: 'https://api.example.com/data',
  method: 'POST',
  data: {
    key: 'value'
  },
  header: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer token'
  },
  timeout: 10000,
  success: (res) => {
    console.log(res.data);
  },
  fail: (err) => {
    console.error(err);
  }
});

// 封装后的请求
const request = (url, options = {}) => {
  return new Promise((resolve, reject) => {
    wx.request({
      url: 'https://api.example.com' + url,
      method: options.method || 'GET',
      data: options.data || {},
      header: options.header || {},
      success: (res) => {
        if (res.statusCode === 200) {
          resolve(res.data);
        } else {
          reject(res);
        }
      },
      fail: reject
    });
  });
};
```

### 文件上传

```javascript
// 上传文件
wx.chooseImage({
  count: 1,
  success: (res) => {
    const tempFilePath = res.tempFilePaths[0];
    
    wx.uploadFile({
      url: 'https://api.example.com/upload',
      filePath: tempFilePath,
      name: 'file',
      formData: {
        'user': 'test'
      },
      success: (res) => {
        console.log(res.data);
      }
    });
  }
});
```

### 文件下载

```javascript
// 下载文件
wx.downloadFile({
  url: 'https://example.com/file.pdf',
  success: (res) => {
    if (res.statusCode === 200) {
      // 下载成功
      const tempFilePath = res.tempFilePath;
      
      // 保存到本地
      wx.saveFile({
        tempFilePath,
        success: (res) => {
          const savedFilePath = res.savedFilePath;
        }
      });
    }
  }
});
```

### WebSocket

```javascript
// 创建 WebSocket 连接
const socketTask = wx.connectSocket({
  url: 'wss://example.com/socket'
});

// 监听连接打开
socketTask.onOpen(() => {
  console.log('WebSocket 连接已打开');
  
  // 发送消息
  socketTask.send({
    data: 'Hello WebSocket'
  });
});

// 监听接收消息
socketTask.onMessage((res) => {
  console.log('收到消息:', res.data);
});

// 监听连接关闭
socketTask.onClose(() => {
  console.log('WebSocket 连接已关闭');
});

// 监听错误
socketTask.onError((err) => {
  console.error('WebSocket 错误:', err);
});

// 关闭连接
socketTask.close();
```

## 💾 数据存储

### 本地存储

```javascript
// 同步存储
wx.setStorageSync('key', 'value');
const value = wx.getStorageSync('key');
wx.removeStorageSync('key');
wx.clearStorageSync();

// 异步存储
wx.setStorage({
  key: 'key',
  data: 'value',
  success: () => {
    console.log('存储成功');
  }
});

wx.getStorage({
  key: 'key',
  success: (res) => {
    console.log(res.data);
  }
});

wx.removeStorage({
  key: 'key',
  success: () => {
    console.log('删除成功');
  }
});

wx.clearStorage({
  success: () => {
    console.log('清空成功');
  }
});

// 获取存储信息
wx.getStorageInfo({
  success: (res) => {
    console.log(res.keys);           // 当前所有 key
    console.log(res.currentSize);    // 当前占用空间（KB）
    console.log(res.limitSize);      // 限制空间大小（KB）
  }
});
```

## 📍 位置相关

### 获取位置

```javascript
// 获取当前位置
wx.getLocation({
  type: 'gcj02', // wgs84, gcj02
  success: (res) => {
    console.log(res.latitude);   // 纬度
    console.log(res.longitude);  // 经度
    console.log(res.speed);      // 速度（m/s）
    console.log(res.accuracy);   // 位置精度
  }
});

// 选择位置
wx.chooseLocation({
  success: (res) => {
    console.log(res.name);       // 位置名称
    console.log(res.address);    // 详细地址
    console.log(res.latitude);   // 纬度
    console.log(res.longitude);  // 经度
  }
});

// 打开地图
wx.openLocation({
  latitude: 39.9,
  longitude: 116.4,
  scale: 18,
  name: '天安门',
  address: '北京市东城区'
});
```

## 📷 媒体相关

### 图片

```javascript
// 选择图片
wx.chooseImage({
  count: 9,
  sizeType: ['original', 'compressed'],
  sourceType: ['album', 'camera'],
  success: (res) => {
    const tempFilePaths = res.tempFilePaths;
    
    // 预览图片
    wx.previewImage({
      current: tempFilePaths[0],
      urls: tempFilePaths
    });
  }
});

// 保存图片到相册
wx.saveImageToPhotosAlbum({
  filePath: 'tempFilePath',
  success: () => {
    wx.showToast({
      title: '保存成功'
    });
  }
});

// 获取图片信息
wx.getImageInfo({
  src: 'tempFilePath',
  success: (res) => {
    console.log(res.width);   // 图片宽度
    console.log(res.height);  // 图片高度
    console.log(res.path);    // 图片路径
    console.log(res.type);    // 图片格式
  }
});

// 压缩图片
wx.compressImage({
  src: 'tempFilePath',
  quality: 80,
  success: (res) => {
    console.log(res.tempFilePath);
  }
});
```

### 视频

```javascript
// 选择视频
wx.chooseVideo({
  sourceType: ['album', 'camera'],
  maxDuration: 60,
  camera: 'back',
  success: (res) => {
    console.log(res.tempFilePath);  // 视频文件路径
    console.log(res.duration);      // 视频时长（s）
    console.log(res.size);          // 视频大小（字节）
  }
});

// 保存视频到相册
wx.saveVideoToPhotosAlbum({
  filePath: 'tempFilePath',
  success: () => {
    wx.showToast({
      title: '保存成功'
    });
  }
});
```

### 录音

```javascript
// 开始录音
const recorderManager = wx.getRecorderManager();

recorderManager.onStart(() => {
  console.log('开始录音');
});

recorderManager.onStop((res) => {
  console.log(res.tempFilePath); // 临时文件路径
  console.log(res.duration);     // 录音时长（ms）
  console.log(res.fileSize);     // 文件大小（字节）
});

recorderManager.start({
  duration: 60000,      // 最长录音时间（ms）
  sampleRate: 44100,    // 采样率
  numberOfChannels: 1,  // 录音通道数
  encodeBitRate: 192000,// 编码码率
  format: 'mp3'         // 音频格式
});

// 停止录音
recorderManager.stop();
```

### 音频播放

```javascript
// 创建音频上下文
const innerAudioContext = wx.createInnerAudioContext();

innerAudioContext.src = 'https://example.com/audio.mp3';
innerAudioContext.autoplay = false;
innerAudioContext.loop = false;

// 播放
innerAudioContext.play();

// 暂停
innerAudioContext.pause();

// 停止
innerAudioContext.stop();

// 监听播放事件
innerAudioContext.onPlay(() => {
  console.log('开始播放');
});

innerAudioContext.onEnded(() => {
  console.log('播放结束');
});

innerAudioContext.onError((err) => {
  console.error('播放错误:', err);
});

// 销毁
innerAudioContext.destroy();
```

## 📋 剪贴板

```javascript
// 设置剪贴板内容
wx.setClipboardData({
  data: 'hello world',
  success: () => {
    wx.showToast({
      title: '复制成功'
    });
  }
});

// 获取剪贴板内容
wx.getClipboardData({
  success: (res) => {
    console.log(res.data);
  }
});
```

## 📞 电话

```javascript
// 拨打电话
wx.makePhoneCall({
  phoneNumber: '10086'
});
```

## 🧭 扫码

```javascript
// 扫描二维码/条形码
wx.scanCode({
  onlyFromCamera: false,  // 是否只能从相机扫码
  scanType: ['qrCode', 'barCode'],
  success: (res) => {
    console.log(res.result);    // 扫码内容
    console.log(res.scanType);  // 扫码类型
  }
});
```

## 📳 振动

```javascript
// 短振动（15ms）
wx.vibrateShort({
  type: 'heavy' // heavy, medium, light
});

// 长振动（400ms）
wx.vibrateLong();
```

## 🔔 交互反馈

### Toast 提示

```javascript
// 显示提示框
wx.showToast({
  title: '成功',
  icon: 'success',  // success, error, loading, none
  duration: 2000,
  mask: true
});

// 隐藏提示框
wx.hideToast();

// 显示 loading
wx.showLoading({
  title: '加载中',
  mask: true
});

// 隐藏 loading
wx.hideLoading();
```

### Modal 对话框

```javascript
// 显示模态对话框
wx.showModal({
  title: '提示',
  content: '这是一个模态弹窗',
  showCancel: true,
  cancelText: '取消',
  cancelColor: '#000000',
  confirmText: '确定',
  confirmColor: '#3CC51F',
  success: (res) => {
    if (res.confirm) {
      console.log('用户点击确定');
    } else if (res.cancel) {
      console.log('用户点击取消');
    }
  }
});
```

### ActionSheet 操作菜单

```javascript
// 显示操作菜单
wx.showActionSheet({
  itemList: ['选项1', '选项2', '选项3'],
  itemColor: '#000000',
  success: (res) => {
    console.log('用户点击了第' + (res.tapIndex + 1) + '个选项');
  },
  fail: (res) => {
    console.log('用户点击了取消');
  }
});
```

## 🧭 导航

### 页面跳转

```javascript
// 保留当前页面，跳转到应用内的某个页面
wx.navigateTo({
  url: '/pages/detail/detail?id=123',
  success: () => {
    console.log('跳转成功');
  }
});

// 关闭当前页面，跳转到应用内的某个页面
wx.redirectTo({
  url: '/pages/index/index'
});

// 跳转到 tabBar 页面，并关闭其他所有非 tabBar 页面
wx.switchTab({
  url: '/pages/index/index'
});

// 关闭所有页面，打开到应用内的某个页面
wx.reLaunch({
  url: '/pages/index/index'
});

// 返回上一页面或多级页面
wx.navigateBack({
  delta: 1  // 返回的页面数
});
```

### 导航栏

```javascript
// 设置导航栏标题
wx.setNavigationBarTitle({
  title: '新标题'
});

// 设置导航栏颜色
wx.setNavigationBarColor({
  frontColor: '#ffffff',      // 前景颜色（文字、状态栏）
  backgroundColor: '#000000', // 背景色
  animation: {
    duration: 400,
    timingFunc: 'easeIn'
  }
});

// 显示导航栏 loading
wx.showNavigationBarLoading();

// 隐藏导航栏 loading
wx.hideNavigationBarLoading();
```

### TabBar

```javascript
// 显示 tabBar 某一项的右上角的红点
wx.showTabBarRedDot({
  index: 1
});

// 隐藏 tabBar 某一项的右上角的红点
wx.hideTabBarRedDot({
  index: 1
});

// 为 tabBar 某一项的右上角添加文本
wx.setTabBarBadge({
  index: 1,
  text: '8'
});

// 移除 tabBar 某一项右上角的文本
wx.removeTabBarBadge({
  index: 1
});

// 显示 tabBar
wx.showTabBar();

// 隐藏 tabBar
wx.hideTabBar();

// 动态设置 tabBar 某一项的内容
wx.setTabBarItem({
  index: 0,
  text: '首页',
  iconPath: '/images/home.png',
  selectedIconPath: '/images/home-active.png'
});

// 动态设置 tabBar 的整体样式
wx.setTabBarStyle({
  color: '#666666',
  selectedColor: '#1890ff',
  backgroundColor: '#ffffff',
  borderStyle: 'black'
});
```

## 🎨 界面

### 下拉刷新

```javascript
// 页面配置中开启
// page.json
{
  "enablePullDownRefresh": true,
  "backgroundColor": "#f5f5f5",
  "backgroundTextStyle": "dark"
}

// 页面中监听
Page({
  onPullDownRefresh() {
    // 处理下拉刷新
    setTimeout(() => {
      wx.stopPullDownRefresh();
    }, 1000);
  }
});

// 手动触发下拉刷新
wx.startPullDownRefresh();

// 停止下拉刷新
wx.stopPullDownRefresh();
```

### 滚动

```javascript
// 将页面滚动到目标位置
wx.pageScrollTo({
  scrollTop: 0,
  duration: 300
});
```

### 动画

```javascript
// 创建动画实例
const animation = wx.createAnimation({
  duration: 1000,
  timingFunction: 'ease',
  delay: 0
});

// 设置动画
animation.scale(2).rotate(45).step();
animation.translate(100, 100).step();

// 应用动画
this.setData({
  animationData: animation.export()
});
```

## 🔌 设备相关

### 屏幕亮度

```javascript
// 设置屏幕亮度
wx.setScreenBrightness({
  value: 0.5  // 0-1
});

// 获取屏幕亮度
wx.getScreenBrightness({
  success: (res) => {
    console.log(res.value);
  }
});

// 设置是否保持常亮状态
wx.setKeepScreenOn({
  keepScreenOn: true
});
```

### 手机联系人

```javascript
// 添加手机联系人
wx.addPhoneContact({
  firstName: '张',
  lastName: '三',
  mobilePhoneNumber: '13800138000',
  email: 'zhangsan@example.com',
  organization: '公司名称',
  success: () => {
    wx.showToast({
      title: '添加成功'
    });
  }
});
```

## 📊 转发分享

```javascript
// 页面中定义
Page({
  // 用户点击右上角分享
  onShareAppMessage() {
    return {
      title: '分享标题',
      path: '/pages/index/index?id=123',
      imageUrl: '/images/share.jpg'
    };
  },

  // 用户点击右上角分享到朋友圈
  onShareTimeline() {
    return {
      title: '分享标题',
      query: 'id=123',
      imageUrl: '/images/share.jpg'
    };
  },

  // 触发分享
  shareToFriend() {
    wx.showShareMenu({
      withShareTicket: true,
      menus: ['shareAppMessage', 'shareTimeline']
    });
  }
});
```

## 🎯 性能监控

```javascript
// 获取性能数据
const performance = wx.getPerformance();

// 监听性能数据
const observer = performance.createObserver((entryList) => {
  console.log(entryList.getEntries());
});

observer.observe({ entryTypes: ['render', 'script', 'navigation'] });

// 停止监听
observer.disconnect();
```

## 🔧 更新管理

```javascript
// 获取全局唯一的版本更新管理器
const updateManager = wx.getUpdateManager();

// 检查更新
updateManager.onCheckForUpdate((res) => {
  console.log('是否有新版本:', res.hasUpdate);
});

// 新版本下载成功
updateManager.onUpdateReady(() => {
  wx.showModal({
    title: '更新提示',
    content: '新版本已准备好，是否重启应用？',
    success: (res) => {
      if (res.confirm) {
        // 新版本已下载，调用 applyUpdate 应用新版本并重启
        updateManager.applyUpdate();
      }
    }
  });
});

// 新版本下载失败
updateManager.onUpdateFailed(() => {
  wx.showModal({
    title: '更新失败',
    content: '请删除当前小程序，重新搜索打开'
  });
});
```

## 📚 参考资源

- [微信小程序官方 API 文档](https://developers.weixin.qq.com/miniprogram/dev/api/)
- [小程序开发指南](https://developers.weixin.qq.com/ebook?action=get_post_info&docid=0008aeea9a8978ab0086a685851c0a)
