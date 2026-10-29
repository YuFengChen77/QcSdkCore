# QcSdkCore

QC 海外 iOS SDK 的核心模块，以预编译静态 XCFramework 通过 Swift Package Manager（SPM）分发，不提供业务实现源码。Core 本身没有第三方 SDK 依赖；Google、Facebook、Kakao、分享、统计等能力通过各自独立的 SPM 包按需接入。

## 环境要求

- iOS 17.0 或以上。
- 支持 Swift 6.2 的完整 Xcode；当前已验证环境为 Apple Silicon、Xcode 26.6。
- 当前制品包含 iOS 真机 arm64 和 iOS 模拟器 arm64，不包含 Intel 模拟器 x86_64。

## 在 Xcode 中集成

1. 打开 App 工程，选择 **File → Add Package Dependencies…**。
2. 输入仓库地址：

   ```text
   https://github.com/YuFengChen77/QcSdkCore.git
   ```

3. 将 Dependency Rule 设置为 **Exact Version**，选择所需的已发布版本。可在本仓库的 **Releases** 中查看可用版本。
4. 点击 Add Package，选择 **QcSdkCore** 产品，将 Add to Target 设置为实际使用 SDK 的 App Target。
5. 在该 Target 的 **Build Settings → Other Linker Flags** 中保留原有配置，并加入：

   ```text
   $(inherited) -ObjC
   ```

6. 确认最低部署版本为 iOS 17.0 或以上，选择 iPhone 模拟器编译运行。

SPM 会读取本仓库的 `Package.swift`，从对应 Release 下载 XCFramework ZIP、校验 checksum 并完成链接。无需手工下载、拖入或重复嵌入 Framework。

## 接入验证

在 Swift 文件中导入模块并调用公开 API：

```swift
import QcSdkCore

print("SDK 版本：\(BuildInfo.sdkVersion)")
print("当前语言：\(QcSdkApi.shared.getLanguage())")
```

能完成编译并执行上述调用，说明二进制 SDK 已接入。业务初始化、登录、支付仍需配置项目参数、生命周期转发及对应回调；这段示例不代表业务联调完成。

Objective-C 和 Unity 继续使用 SDK 已有的公开接口和桥接协议。Unity 应将包产品和 `-ObjC` 配置到实际链接 SDK 的 Target，通常为 `UnityFramework`，并由最终 App 管理依赖动态库的嵌入与签名。

## 资源与目录

分发仓库采用以下结构：

```text
Package.swift
QcSdkCore/
├── Sources/
│   └── Dependencies.swift
└── Resources/
    ├── Font/
    ├── Images/
    ├── Strings/
    └── PrivacyInfo.xcprivacy
```

`Sources/Dependencies.swift` 仅为依赖 / 资源包装，不包含业务实现。实际实现位于 Release 的 XCFramework ZIP 中。

SPM 在宿主构建时将图片、字体、语言文件和隐私清单处理为 `QcSdkCore_QcSdkCoreSupport.bundle`。接入方无需另行复制资源或在 `UIAppFonts` 中手动登记 SDK 字体；SDK 初始化时会注册自身字体。请勿删除、改名或另外复制该资源 bundle，避免资源缺失和重复。

Xcode 左侧导航中未显示 XCFramework 节点不代表缺少依赖。下载文件通常位于该工程 DerivedData 的 `SourcePackages/artifacts`，可结合 Target 的 **General → Frameworks, Libraries, and Embedded Content**、构建结果和运行验证确认接入情况。

## 更新版本

1. 进入 **PROJECT → 工程名 → Package Dependencies**。
2. 选择 `QcSdkCore`，把 Exact Version 改为新的已发布版本。
3. 等待下载解析完成；必要时执行 **File → Packages → Resolve Package Versions**。
4. 重新编译运行，验证资源和业务功能。

无需删除并重新添加依赖，不需要修改 `import QcSdkCore`。多个插件接入同一工程时，应使用兼容的 Core 版本；自有插件目前通过 exact 版本声明其 Core 依赖，升级 Core 时需同时检查插件声明，避免版本冲突。

## 注意事项与常见问题

- **静态链接**：自己的 SDK 实现采用静态链接，不要再把同一份手动 Framework 与 SPM 产品重复集成，也不要手动将自有静态 Framework 设置为 Embed & Sign。
- **反射插件**：实际链接 SDK 的 Target 必须保留 `-ObjC`，否则只通过类名反射使用的插件可能被裁掉。
- **第三方能力**：只接入 Core 不会自动带上 Google、Facebook、Kakao、Adjust、ThinkingData 等 SDK。添加相应功能包后，其声明的第三方依赖由 SPM 自动拉取。
- **资源或字体缺失**：确认使用包含完整资源的新版本，检查构建产物中的资源 bundle；不要通过手动复制字体掩盖发布内容不完整的问题。
- **版本不可覆盖**：发布过的版本不能删除后重新指向另一份提交或 ZIP。若出现 `does not match previously recorded value`，请联系 SDK 维护者发布新版本，不应关闭 SPM 校验。
- **工具链路径**：若命令行提示 `xcodebuild requires Xcode`，确认已安装完整 Xcode，并检查 `xcode-select -p` 是否指向它的 Developer 目录。
- **源码与接口**：XCFramework 中的 `.swiftinterface` 和 Objective-C 头文件用于提供公开接口，不是业务实现源码；资源文件和公开接口声明可以被查看。
- **业务验收**：第三方登录、支付、URL 回跳、隐私授权和 Unity 导出宿主需按实际接入场景联调。业务密钥、签名凭据不应提交到公开分发仓库。

本文件由开发仓库的 `QcSdkCore/README.md` 维护，生成分发包时自动复制，避免下次打包覆盖接入说明。
