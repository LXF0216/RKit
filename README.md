RKit
====

A free iOS UI framework, providing more useful features, based on UIKit.
一个自由的 iOS UI 框架, 旨在提供更多实用的功能特性, 基于 UIKit.

## Intro

此项目源于写 [42qu](http://42qu.com/) 的应用时萌发的一个念头: 既然经常要用到, 干嘛不把自己写的这些东西整理出来丢到 github 上? 于是现在就这么做了嗯... 显然用数字开头的 class 名是很不科学的, 于是就叫 RKit 好了.

欢迎提供批评和建议. 谢谢!

因为比较懒, 所以此项目不在 "已完成" 中的模块就暂不接受 pull request 好了.

唔... 就介样.

## 进度

### 已完成

#### Segmented Control
* 三种状态下的文字和背景: 默认 / 点击 / 活跃.
* 两种动画: 渐变 / 移动.

#### Slide View
* 与 Segmented Control 配合使用.
* 当动画设为 "移动" 时, UI 实时同步.

#### Pull Refresh Header View
* 使用 QuartzCore.
* 四种状态: 默认 / 下拉 / 释放 / 完成.

#### Update Table View
* 用于显示 update 消息流.
* 使用 Pull Refresh Header View.
* 内建下拉刷新和加载更多两种方法 (以 dispatch 封装为后台执行).

#### HTTP Utils
* URL encode / decode.
* 预置多种 User Agent.

#### Download Manager
* 多队列, 多任务下载 (暂时为单线程).

### 进行中

#### HUD
* 基于 [MBProgressHUD](https://github.com/jdg/MBProgressHUD). (感谢原作者!)

#### Input Table View
* 可进行六种输入: Text Field / Text View / Switch / Image / Picker / Subtable.

### 待完成

#### Status Bar Hint
* 状态栏发送提示.

