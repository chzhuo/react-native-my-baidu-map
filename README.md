
从 [react-native-s-baidumap](https://github.com/1035901787/react-native-s-baidumap) fork 而来，感谢原作者的贡献。
修复了部分问题，可以在最新版 react-native 0.74+使用。 已经在 ios 上测试通过
直接通过 npm 安装即可，
ios 需要手动添加百度地图的 key
## IOS 配置
在 AppDelegate.mm  的 application:didFinishLaunchingWithOptions 方法中添加如下代码
```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
  BMKMapManager *mapManager = [[BMKMapManager alloc] init];
  // 如果要关注网络及授权验证事件，请设定generalDelegate参数
  BOOL ret = [mapManager start:@"lTKp2cIoXGnui3TGpxCKTUhnGcaYfm5U"  generalDelegate:nil];
  if (!ret) {
    NSLog(@"baidumap manager start failed!");
  }
  NSLog(@"baidumap manager start ok!");
  RCTLogInfo(@"baidumap manager start ok!");

  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"reactNativeSBaidumap"
                                            initialProperties:nil];
  ...
```