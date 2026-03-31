# TypeScript 项目示例

## 项目说明

这是一个使用 TypeScript 开发的微信小程序示例，展示如何配置 TypeScript 环境和最佳实践。

## 项目结构

```
typescript-template/
├── miniprogram/
│   ├── pages/
│   │   └── index/
│   │       ├── index.ts          # TypeScript 文件
│   │       ├── index.json
│   │       ├── index.wxml
│   │       └── index.wxss
│   ├── components/
│   │   └── custom-button/
│   │       ├── custom-button.ts
│   │       ├── custom-button.json
│   │       ├── custom-button.wxml
│   │       └── custom-button.wxss
│   ├── utils/
│   │   ├── request.ts           # 请求封装
│   │   ├── storage.ts           # 存储封装
│   │   └── util.ts
│   ├── types/                    # 类型定义
│   │   ├── api.d.ts             # API 接口类型
│   │   ├── common.d.ts          # 通用类型
│   │   └── index.d.ts           # 入口文件
│   ├── services/                 # API 服务层
│   │   ├── user.ts
│   │   └── product.ts
│   ├── app.ts
│   ├── app.json
│   └── app.wxss
├── typings/                      # 微信 API 类型定义
│   └── index.d.ts
├── tsconfig.json                 # TypeScript 配置
├── project.config.json
└── package.json
```

## 1. TypeScript 配置

### tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "lib": ["ES2020"],
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "moduleResolution": "node",
    "baseUrl": ".",
    "paths": {
      "@/*": ["miniprogram/*"]
    },
    "typeRoots": ["./typings", "./node_modules/@types"],
    "types": ["miniprogram-api-typings"]
  },
  "include": ["miniprogram/**/*"],
  "exclude": ["node_modules"]
}
```

### project.config.json
```json
{
  "miniprogramRoot": "miniprogram/",
  "compileType": "miniprogram",
  "setting": {
    "useCompilerPlugins": ["typescript"]
  },
  "compileOptions": {
    "typescript": {
      "configPath": "tsconfig.json"
    }
  }
}
```

### package.json
```json
{
  "name": "wechat-miniprogram-typescript",
  "version": "1.0.0",
  "scripts": {
    "tsc": "tsc",
    "watch": "tsc -w"
  },
  "dependencies": {},
  "devDependencies": {
    "@types/wechat-miniprogram": "^3.4.0",
    "miniprogram-api-typings": "^3.12.0",
    "typescript": "^5.0.0"
  }
}
```

## 2. 类型定义

### types/common.d.ts
```typescript
/**
 * 通用类型定义
 */

// 分页参数
export interface PaginationParams {
  page: number;
  pageSize: number;
}

// 分页响应
export interface PaginationResponse<T> {
  list: T[];
  total: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

// API 响应
export interface ApiResponse<T = any> {
  code: number;
  message: string;
  data: T;
}

// 用户信息
export interface UserInfo {
  id: string;
  nickName: string;
  avatarUrl: string;
  gender: 0 | 1 | 2; // 0: 未知, 1: 男, 2: 女
  province: string;
  city: string;
}

// 商品信息
export interface Product {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  images: string[];
  description: string;
  stock: number;
  category: string;
}
```

### types/api.d.ts
```typescript
/**
 * API 接口类型定义
 */
import { PaginationParams, PaginationResponse, UserInfo, Product } from './common';

// 登录参数
export interface LoginParams {
  code: string;
}

// 登录响应
export interface LoginResponse {
  token: string;
  userInfo: UserInfo;
}

// 获取商品列表参数
export interface GetProductListParams extends PaginationParams {
  category?: string;
  keyword?: string;
}

// 获取商品列表响应
export type GetProductListResponse = PaginationResponse<Product>;

// 获取商品详情参数
export interface GetProductDetailParams {
  id: string;
}

// 获取商品详情响应
export type GetProductDetailResponse = Product;
```

## 3. 工具函数

### utils/request.ts
```typescript
/**
 * 网络请求封装
 */
import { ApiResponse } from '../types/common';

interface RequestOptions {
  url: string;
  method?: 'GET' | 'POST' | 'PUT' | 'DELETE';
  data?: Record<string, any>;
  header?: Record<string, string>;
  showLoading?: boolean;
}

class Request {
  private baseURL = 'https://api.example.com';
  private timeout = 10000;

  /**
   * 发起请求
   */
  async request<T = any>(options: RequestOptions): Promise<T> {
    const { url, method = 'GET', data, header, showLoading = true } = options;

    if (showLoading) {
      wx.showLoading({ title: '加载中...' });
    }

    try {
      const res = await wx.request({
        url: this.baseURL + url,
        method,
        data,
        header: {
          'Content-Type': 'application/json',
          'Authorization': this.getToken(),
          ...header
        },
        timeout: this.timeout
      });

      if (showLoading) {
        wx.hideLoading();
      }

      const response = res.data as ApiResponse<T>;

      if (response.code === 0) {
        return response.data;
      } else {
        throw new Error(response.message);
      }
    } catch (err: any) {
      if (showLoading) {
        wx.hideLoading();
      }

      wx.showToast({
        title: err.message || '网络错误',
        icon: 'none'
      });

      throw err;
    }
  }

  /**
   * GET 请求
   */
  get<T = any>(url: string, data?: Record<string, any>): Promise<T> {
    return this.request<T>({ url, method: 'GET', data });
  }

  /**
   * POST 请求
   */
  post<T = any>(url: string, data?: Record<string, any>): Promise<T> {
    return this.request<T>({ url, method: 'POST', data });
  }

  /**
   * 获取 token
   */
  private getToken(): string {
    return wx.getStorageSync('token') || '';
  }
}

export default new Request();
```

### utils/storage.ts
```typescript
/**
 * 本地存储封装
 */

class Storage {
  /**
   * 设置数据
   */
  set<T>(key: string, value: T): void {
    try {
      wx.setStorageSync(key, value);
    } catch (err) {
      console.error('存储数据失败:', err);
    }
  }

  /**
   * 获取数据
   */
  get<T>(key: string): T | null;
  get<T>(key: string, defaultValue: T): T;
  get<T>(key: string, defaultValue?: T): T | null {
    try {
      const value = wx.getStorageSync(key);
      return value !== '' ? value : (defaultValue ?? null);
    } catch (err) {
      console.error('获取数据失败:', err);
      return defaultValue ?? null;
    }
  }

  /**
   * 删除数据
   */
  remove(key: string): void {
    try {
      wx.removeStorageSync(key);
    } catch (err) {
      console.error('删除数据失败:', err);
    }
  }

  /**
   * 清空数据
   */
  clear(): void {
    try {
      wx.clearStorageSync();
    } catch (err) {
      console.error('清空数据失败:', err);
    }
  }
}

export default new Storage();
```

## 4. API 服务层

### services/user.ts
```typescript
/**
 * 用户相关 API
 */
import request from '../utils/request';
import { LoginParams, LoginResponse } from '../types/api';
import { UserInfo } from '../types/common';

export const userService = {
  /**
   * 用户登录
   */
  async login(params: LoginParams): Promise<LoginResponse> {
    return request.post<LoginResponse>('/user/login', params);
  },

  /**
   * 获取用户信息
   */
  async getUserInfo(): Promise<UserInfo> {
    return request.get<UserInfo>('/user/info');
  },

  /**
   * 更新用户信息
   */
  async updateUserInfo(data: Partial<UserInfo>): Promise<void> {
    return request.post<void>('/user/update', data);
  }
};
```

### services/product.ts
```typescript
/**
 * 商品相关 API
 */
import request from '../utils/request';
import {
  GetProductListParams,
  GetProductListResponse,
  GetProductDetailParams,
  GetProductDetailResponse
} from '../types/api';

export const productService = {
  /**
   * 获取商品列表
   */
  async getList(params: GetProductListParams): Promise<GetProductListResponse> {
    return request.get<GetProductListResponse>('/product/list', params);
  },

  /**
   * 获取商品详情
   */
  async getDetail(params: GetProductDetailParams): Promise<GetProductDetailResponse> {
    return request.get<GetProductDetailResponse>('/product/detail', params);
  }
};
```

## 5. 页面开发

### pages/index/index.ts
```typescript
import { productService } from '../../services/product';
import { Product } from '../../types/common';

// 页面数据类型
interface PageData {
  list: Product[];
  page: number;
  pageSize: number;
  hasMore: boolean;
  loading: boolean;
}

Page<PageData>({
  data: {
    list: [],
    page: 1,
    pageSize: 10,
    hasMore: true,
    loading: false
  },

  async onLoad() {
    await this.loadList();
  },

  /**
   * 加载列表
   */
  async loadList() {
    if (this.data.loading || !this.data.hasMore) return;

    this.setData({ loading: true });

    try {
      const res = await productService.getList({
        page: this.data.page,
        pageSize: this.data.pageSize
      });

      this.setData({
        list: [...this.data.list, ...res.list],
        hasMore: res.hasMore,
        loading: false
      });
    } catch (err) {
      console.error('加载列表失败:', err);
      this.setData({ loading: false });
    }
  },

  /**
   * 上拉加载更多
   */
  async onReachBottom() {
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
   * 跳转详情页
   */
  goToDetail(e: WechatMiniprogram.TouchEvent) {
    const { id } = e.currentTarget.dataset;
    wx.navigateTo({
      url: `/pages/detail/detail?id=${id}`
    });
  }
});
```

## 6. 组件开发

### components/custom-button/custom-button.ts
```typescript
/**
 * 自定义按钮组件
 */

interface ComponentData {
  loading: boolean;
}

interface ComponentProperties {
  type: StringConstructor;
  size: StringConstructor;
  disabled: BooleanConstructor;
}

interface ComponentMethods {
  handleTap(e: WechatMiniprogram.TouchEvent): void;
}

Component<ComponentData, ComponentProperties, ComponentMethods>({
  properties: {
    type: {
      type: String,
      value: 'primary'
    },
    size: {
      type: String,
      value: 'default'
    },
    disabled: {
      type: Boolean,
      value: false
    }
  },

  data: {
    loading: false
  },

  methods: {
    handleTap(e: WechatMiniprogram.TouchEvent) {
      if (this.data.disabled || this.data.loading) return;

      this.triggerEvent('tap', e.detail);
    }
  }
});
```

## 7. 最佳实践

### ✅ 推荐做法

1. **严格的类型定义**
   ```typescript
   // 为所有数据定义类型
   interface User {
     id: string;
     name: string;
   }
   ```

2. **使用泛型**
   ```typescript
   function getData<T>(key: string): T {
     return wx.getStorageSync(key);
   }
   ```

3. **使用枚举**
   ```typescript
   enum OrderStatus {
     Pending = 1,
     Paid = 2,
     Shipped = 3,
     Completed = 4
   }
   ```

4. **使用类型守卫**
   ```typescript
   function isProduct(obj: any): obj is Product {
     return obj && typeof obj.id === 'string';
   }
   ```

### ❌ 避免做法

1. **避免使用 any**
   ```typescript
   // ❌ 不推荐
   const data: any = getData();

   // ✅ 推荐
   const data: User = getData<User>();
   ```

2. **避免类型断言滥用**
   ```typescript
   // ❌ 不推荐
   const user = data as User;

   // ✅ 推荐
   if (isUser(data)) {
     const user = data;
   }
   ```

## 8. 编译和开发

```bash
# 安装依赖
npm install

# 类型检查
npm run tsc

# 监听模式
npm run watch
```

## 参考资源

- [TypeScript 官方文档](https://www.typescriptlang.org/)
- [小程序 TypeScript 支持](https://developers.weixin.qq.com/miniprogram/dev/devtools/codecompile.html#typescript-%E6%94%AF%E6%8C%81)
- [miniprogram-api-typings](https://github.com/wechat-miniprogram/api-typings)
