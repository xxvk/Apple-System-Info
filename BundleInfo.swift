//
//  AppInfo.swift
//  store_killer_ios
//
//  Created by 樊半缠 on 16/7/12.
//  Copyright © 2016年 reformation.tech. All rights reserved.
//

import Foundation

//  MARK: - BundleInfo（Elementary）:包基础信息
public class BundleInfo{
    //  MARK: infoDictionary:私有字典属性
    private class var infoDictionary: [String : AnyObject]! {
        get{
            let foo = NSBundle.mainBundle().infoDictionary!
            
            return foo
        }
    }
    //  MARK: version:这个会设置应用程序版本号，每次部署应用程序的一个新版本时，将会增加这个编号，在app store用的
    class var version: String {
        get{
            let foo = self.infoDictionary["CFBundleShortVersionString"] as! String
            
            return foo
        }
    }
    //  MARK: shortVersion:指定了束的版本号。一般包含该束的主、次版本号。这个字符串的格式通常是“n.n.n”（n表示某个数字）。第一个数字是束的主要版本号，另两个是次要版本号。该关键字的值会被显示在Cocoa应用程序的关于对话框中
    class var shortVersion: String {
        get{
            //Bundle versions string, short
            let foo = self.infoDictionary["CFBundleShortVersionString"] as! String
            
            return foo
        }
    }
    
    //  MARK: infoDictionaryVersion:指定了属性列表结构的当前版本号。该关键字的存在使得可以支持Info.plist格式将来的版本。在您建立一个束时，Project Builder会自动产生该关键字
    class var infoDictionaryVersion: String {
        get{//InfoDictionary version
            let foo = self.infoDictionary["CFBundleInfoDictionaryVrsion"] as! String
            
            return foo
        }
    }
    //  MARK: build:
    //(e.g )
    class var build: String {
        get{
            let foo = self.infoDictionary["CFBundleVersion"] as! String
            
            return foo
        }
    }
    
    //  MARK: name : 简称。简称应该小于16个字符并且适合在菜单和“关于”中显示。通过把它加入到适当的.lproj子文件夹下的InfoPlist.strings文件中，该关键字可以被本地化。如果您本地化了该关键字，那您也应该提供一个CFBundleDisplayName关键字的本地化版本
    class var name: String {
        get{
            //Bundle identifier
            let foo = self.infoDictionary["CFBundleName"] as! String
            
            return foo
        }
    }
    
    enum BundleType :String{
        case Application = "APPL"
        case Framework = "FMWK"
        case Bundle = "BND"
        case other = ""
    }
    //  MARK: type : 关键字指定了束的类型，类似于Mac OS 9的文件类型代码。该关键字的值包含一个四个字母长的代码。应用程序的代码是‘APPL’；框架的代码是‘FMWK’；可装载束的代码是‘BND’。如果您需要，您也可以为可装载束选择其他特殊的类型代码
    class var type: BundleType {
        get{
            //Bundle OS Type code
            let foo = self.infoDictionary["CFBundlePackageType"] as! String
            
            let bar = BundleType(rawValue: foo)
            
            return bar!
        }
    }
    
    //  MARK: Signature : 指定了束的创建者，类似于Mac OS 9中的文件创建者代码。该关键字的值包含四字母长的代码，用来确定每一个束
    class var Signature: String {
        get{
            //Bundle creator OS Type code
            let foo = self.infoDictionary["CFBundleSignature"] as! String
            
            return foo
        }
    }
    
    //  MARK: DisplayName : 这用于设置应用程序的名称，它显示在iphone屏幕的图标下方。应用程序名称限制在10－12个字符，如果超出，iphone将缩写名称
    class var DisplayName: String {
        get{
            //Bundle display name
            let foo = self.infoDictionary["CFBundleDisplayName"] as! String
            
            return foo
        }
    }
    
    //  MARK: Identifier : 身份证书，这个为应用程序在iphone developer program portal web站点上设置的唯一标识符。（就是你安装证书的时候，需要把这里对应修改）。例如com.apple.myapp。该束标识符可以在运行时定位束。预置系统使用这个字符串来唯一地标识每个应用程序
    class var Identifier: String {
        get{
            //Bundle identifier
            let foo = self.infoDictionary["CFBundleIdentifier"] as! String
            
            return foo
        }
    }
    
    //  MARK: DevelopmentRegion:
    class var DevelopmentRegion: String {
        get{//Localization native development region
            let foo = self.infoDictionary["CFBundleDevelopmentRegion"] as! String
            
            return foo
        }
    }
    //  MARK: Localizations:多语言。应用程序本地化的一列表，期间用逗号隔开，例如应用程序支持英语 日语，将会适用 English,Japanese.
    class var Localizations: String {
        get{//Localization native development region
            let foo = self.infoDictionary["CFBundleLocalizations"] as! String
            
            return foo
        }
    }
    //  MARK: AllowMixedLocalizations
    class var AllowMixedLocalizations: Bool {
        get{
            //Localized resources can be mixed
            let foo = self.infoDictionary["CFBundleAllowMixedLocalizations"] as! Bool
            
            return foo
        }
    }
    
    enum ApplicationCategory : String{
        case Business	=	"public.app-category.business"
        case Developer_Tools	=	"public.app-category.developer-tools"
        case Education	=	"public.app-category.education"
        case Entertainment	=	"public.app-category.entertainment"
        case Finance	=	"public.app-category.finance"
        case Games	=	"public.app-category.games"
        case Graphics_and_Design	=	"public.app-category.graphics-design"
        case Healthcare_and_Fitness	=	"public.app-category.healthcare-fitness"
        case Lifestyle	=	"public.app-category.lifestyle"
        case Medical	=	"public.app-category.medical"
        case Music	=	"public.app-category.music"
        case News	=	"public.app-category.news"
        case Photography	=	"public.app-category.photography"
        case Productivity	=	"public.app-category.productivity"
        case Reference	=	"public.app-category.reference"
        case Social_Networking	=	"public.app-category.social-networking"
        case Sports	=	"public.app-category.sports"
        case Travel	=	"public.app-category.travel"
        case Utilities	=	"public.app-category.utilities"
        case Video	=	"public.app-category.video"
        case Weather	=	"public.app-category.weather"
    }
    enum game_specific_Categories : String{
        case	Action	=	"public.app-category.action-games"
        case	Adventure	=	"public.app-category.adventure-games"
        case	Arcade	=	"public.app-category.arcade-games"
        case	Board 	=	"public.app-category.board-games"
        case	Card 	=	"public.app-category.card-games"
        case	Casino 	=	"public.app-category.casino-games"
        case	Dice 	=	"public.app-category.dice-games"
        case	Educational 	=	"public.app-category.educational-games"
        case	Family 	=	"public.app-category.family-games"
        case	Kids 	=	"public.app-category.kids-games"
        case	Music 	=	"public.app-category.music-games"
        case	Puzzle 	=	"public.app-category.puzzle-games"
        case	Racing 	=	"public.app-category.racing-games"
        case	Role_Playing 	=	"public.app-category.role-playing-games"
        case	Simulation 	=	"public.app-category.simulation-games"
        case	Sports 	=	"public.app-category.sports-games"
        case	Strategy 	=	"public.app-category.strategy-games"
        case	Trivia 	=	"public.app-category.trivia-games"
        case	Word 	=	"public.app-category.word-games"
    }
    //  MARK: categoryType:包含UTI相应的应用程序的类型。 App Store中使用该字符串的应用程序，以确定适当的分类
    class var categoryType: ApplicationCategory {
        get{
            let foo = self.infoDictionary["CFBundleVersion"] as! String
            
            var bar = ApplicationCategory.Reference
            
            bar = ApplicationCategory(rawValue: foo)!
            
            if foo == ApplicationCategory.Games.rawValue{
                //                bar =
            }
            return bar
        }
    }
    
    
    //  MARK: externalFontsPath :如果想使用外部字体时，可以指定外问字体的资源文件
    
    class var externalFontsPath: String {
        get{
            //Application fonts resource path
            let foo = self.infoDictionary["ATSApplicationFontsPath"] as! String
            
            return foo
        }
    }
    
    //  MARK: hasLocalizedDisplayName :本地化显示名。设置为YES激活
    class var hasLocalizedDisplayName: Bool {
        get{
            //Application has localized display name
            let foo = self.infoDictionary["LSHasLocalizedDisplayName"] as! Bool
            
            return foo
        }
    }

    //  MARK: Copyright : 包含了一个含有束的版权信息的字符串。您可以在“关于”对话框中显示它。该关键字通常会出现在InfoPlist.strings文件中，因为往往需要本地化该关键字的值
    class var Copyright: String {
        get{
            //Bundle identifier
            let foo = self.infoDictionary["NSHumanReadableCopyright"] as! String
            
            return foo
        }
    }
    enum CoreData_persistent_type : String{
        
        case Sqlite = "Sqlite"//使用SQLITE存储数据
        
        case XML = "XML"//使用XML文档存储数据
        
        case Binary = "Binary"//使用二进制流文件存储数据
        
        case Memoery = "Memoery"//使用内存存储数据。
    }
    
    //  MARK: CoreData_store_type : 核心数据存储的文档类型
    class var CoreData_store_type: CoreData_persistent_type {
        get{
            //Core Data persistent store type
            let foo = self.infoDictionary["NSPersistentStoreTypeKey"] as! String
            
            let bar = CoreData_persistent_type(rawValue: foo)
            
            return bar!
        }
    }
    
/*
    这个Dock可以挂载一个叫NSDockTilePlugIn的 bundle，开发这个类似很多OSGI模型开发bundle一样，继承NSDockTilePlugIn，然后你实现相应的methods，完之后build出来放到指定的目录下，然后在某个特定的“动作”。
    
    1，build后的bundle必须放到你app下的Contents/PlugIns下，且必须在property list文件中申明，其中内容为.docktileplugin结尾的插件名。
    
    2，插件必须扩展NSDockTilePlugI，当插件加载的时候， setDockTile方法就会被执行，并且返回一个NSDockTile，你可以在这里做些其他初始化工作。
    
    3，你的插件和主程序可以同时updateDock title，但主程序的优先级更高。
    
    4，当你的application 从dock去除的时候，会把NSDockTile指向nil，在Object-C中指向nil的对象是自动释放内存并把指针指向NULL。
     
     Dock Plugin 主要做几个工作：
     
     1，其中更改dock上application的图标。
     
     2，更改badge：
     
     3，定义自己的menu：
     
     加徽章（Badge）                                                          -------------图标上的数字。
     
     换图标
     
     隐藏和显示最小化时的图标徽章
     
     增加自定义Dock菜单
     
     苹果官方说明：
     
     The NSDockTilePlugIn protocol defines the methods implemented by plug-ins that allow an application’s Dock tile to be customized while the application is not running.
     
     Customizing an application’s Dock tile when the application itself is not running requires that you write a plug-in. The plug-in’s principal class must implement the NSDockTilePlugIn protocol.
     
     The name of the plugin is indicated by a NSDockTilePlugIn key in the application's Info.plist file.
 */
    //  MARK: NSDockTilePlugIn : 停靠插件路径
    class var NSDockTilePlugIn: String {
        get{
            //Dock Tile plugin path
            let foo = self.infoDictionary["NSDockTilePlugIn"] as! String
            
            return foo
        }
    }


    

    

    
    //  MARK: GetInfoString : CFBundleGetInfoString关键字含有会在束的信息窗口中显示的纯文本字符串（这里的字符串也就是Mac OS 9中的长字符串）。该关键字的格式应该遵照Mac OS 9中的长字符串，例如：“2.2.1, ? Great Software, Inc, 1999”。通过把它加入到合适的.lproj目录中的InfoPlist.strings文件中，您也可以本地化该字符串。如果存在CFBundleGetInfoHTML的话，系统不会选择使用该关键字
    class var GetInfoString: String {
        get{
            //Get Info string
            let foo = self.infoDictionary["CFBundleGetInfoString"] as! String
            
            return foo
        }
    }

    //  MARK: PreferenceSync_ExcludeSyncKeys
    class var PreferenceSync_ExcludeSyncKeys: Array<String>  {
        get{
            //Preferences sync exclusion keys
            let foo = self.infoDictionary["com.apple.PreferenceSync.ExcludeSyncKeys"] as! Array<String>
            
            return foo
        }
    }
    
    //  MARK: NSPrincipalClass :定义了一个束的主类的名称。对于应用程序来说，缺省情况下这个名字就是应用程序的名字
    class var NSPrincipalClass: String {
        get{
            //Main storyboard file base name (iPhone)
            let foo = self.infoDictionary["NSPrincipalClass"] as! String
            
            return foo
        }
    }

    //  MARK: UISupportedExternalAccessoryProtocols : 指定应用程序与外界硬件配件间支持的通迅协议，這個键值是一组设定，可以指定多个通迅协议
    class var UISupportedExternalAccessoryProtocols: Array<String> {
        get{
            //Supported external accessory protocols
            let foo = self.infoDictionary["UISupportedExternalAccessoryProtocols"] as! Array<String>
            
            return foo
        }
    }

    //  MARK: UIUpgradeOtherBundleIdentifier :
    class var UIUpgradeOtherBundleIdentifier: String {
        get{
            //Upgrade other bundle identifier
            let foo = self.infoDictionary["UIUpgradeOtherBundleIdentifier"] as! String
            
            return foo
        }
    }
    
    //  MARK: isFileQuarantineEnabled
    class var isFileQuarantineEnabled: Bool {
        get{
            //File quarantine enabled
            let foo = self.infoDictionary["LSFileQuarantineEnabled"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: UIAppFonts :
    class var UIAppFonts: Array<Any> {
        get{
            //Fonts provided by application
            let foo = self.infoDictionary["UIAppFonts"] as! Array<Any>
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(Advance Graphic Default):“高级图像属性” 扩展
extension BundleInfo  {
    
    //  MARK: UIViewEdgeAntialiasing : 用于指示在描画不和像素边界对齐的层时，Core Animation层是否进行抗锯齿处理。这个特性使开发者可以在仿真器上进行更为复杂的渲染，但是对性能会有显著的影响。如果属性列表上没有这个键，则其缺省值为NO。这个键只在iPhone OS 3.0和更高版本上支持。如果信息属性文件中的属性值是显示在用户界面上的字符串，则应该进行本地化，特别是当Info.plist中的字符串值是与本地化语言子目录下InfoPlist.strings文件中的字符串相关联的键时。更多信息请参见“国际化您的应用程序”部分
    class var UIViewEdgeAntialiasing: Bool {
        get{
            //Renders with edge antialisasing
            let foo = self.infoDictionary["UIViewEdgeAntialiasing"] as! Bool
            
            return foo
        }
    }
    //  MARK: UIViewGroupOpacity : 用于指示Core Animation子层是否继承其超层的不透明特性。这个特性使开发者可以在仿真器上进行更为复杂的渲染，但是对性能会有显著的影响。如果属性列表上没有这个键，则其缺省值为NO。这个键只在iPhone OS 3.0和更高版本上支持
    class var UIViewGroupOpacity: Bool {
        get{
            //Renders with group opacity
            let foo = self.infoDictionary["UIViewGroupOpacity"] as! Bool
            
            return foo
        }
    }
    
    
    //  MARK: UIStatusBarHidden : 设置是否隐藏状态栏。YES时隐藏，FALSE时不隐藏
    class var UIStatusBarHidden: Bool {
        get{
            //Status bar is initially hidden
            let foo = self.infoDictionary["UIStatusBarHidden"] as! Bool
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(Bundle Runtime Default):“运行时” 扩展
extension BundleInfo  {
    //  MARK: supportsSuddenTermination :指定应用程序是否可以被杀死
    class var supportsSuddenTermination: Bool {
        get{
            //Application can be killed immediately after launch
            let foo = self.infoDictionary["NSSupportsSuddenTermination"] as! Bool
            
            return foo
        }
    }
    
    //  MARK:  exitsOnSuspend:是否支持在后台运行，YES时，点击HOME键，则退出应用。NO时点击HOME键切到后台
    
    class var exitsOnSuspend: Bool {
        get{
            // Application does not run in background
            let foo = self.infoDictionary["UIApplicationExitsOnSuspend"] as! Bool
            
            return foo
        }
    }
    //  MARK: isAgent :如果该关键字被设为“1”，启动服务会将该应用程序作为一个用户界面组件来运行。用户界面组件不会出现在Dock或强制退出窗口中。虽然它们通常作为后台应用程序运行，但是如果希望的话，它们也可以在前台显示一个用户界面。点击属于用户界面组件的窗口，应用程序将会处理产生的事件。Dock和登录窗口是两个用户界面组件应用程序
    class var isAgent: Bool {
        get{
            //Application is agent (UIElement)
            let foo = self.infoDictionary["LSUIElement"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isBackgroundOnly :如果该关键字存在并且被设为“1”，启动服务将只会运行在后台。您可以使用该关键字来创建无用户界面的后台应用程序。如果您的应用程序使用了连接到窗口服务器的高级框架，但并不需要显示出来，您也应该使用该关键字。后台应用程序必须被编译成Mach-O可执行文件。该选项不适用于CFM应用程序。您也可以指定该关键字的类型为Boolean或Number。然而，只有Mac OS X 10.2或以上的版本才支持这些类型的值
    class var isBackgroundOnly: Bool {
        get{
            //Application is background only
            let foo = self.infoDictionary["LSBackgroundOnly"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: UIBackgroundModes :后台执行模式。可以参见http://blog.csdn.net/fengsh998/article/details/8312764中的例子。
    class var UIBackgroundModes: Array<String> {
        get{
            //Required background modes
            let foo = self.infoDictionary["UIBackgroundModes"] as! Array<String>
            
            return foo
        }
    }
    
    //  MARK: isVisibleInClassic :指定代理的应用程序或后台唯一的应用程序在Classic环境中的其他应用程序是否是可见的
    class var isVisibleInClassic: Bool {
        get{
            //Application is visible in Classic
            let foo = self.infoDictionary["LSVisibleInClassic"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isPrefersCarbon :如果该关键字被设为“1”，Finder将会在显示简介面板中显示“在Classic环境中打开”控制选项，缺省情况下该控件未被选中。如果需要，用户可以修改这个控制选项来在Classic环境中启动应用程序。您也可以指定该关键字的类型为Boolean或Number。然而，只有Mac OS X 10.2或以上的版本才支持这些类型的值。如果您在您的属性列表中加入了该关键字，那么就不要同时加入LSPrefersClassic, LSRequiresCarbon,或LSRequiresClassic关键字
    class var isPrefersCarbon: Bool {
        get{
            //Application prefers Carbon environment
            let foo = self.infoDictionary["LSPrefersCarbon"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isRequiresCarbon :如果该关键字被设为“1”，启动服务将只在Carbon环境中运行应用程序。如果您的应用程序不应该运行在Classic环境中的话，可以使用该关键字。您也可以指定该关键字的类型为Boolean或Number。然而，只有Mac OS X 10.2或以上的版本才支持这些类型的值。如果您在您的属性列表中加入了该关键字，那么就不要同时加入LSPrefersCarbon, LSPrefersClassic,或LSRequiresClassic关键字
    class var isRequiresCarbon: Bool {
        get{
            //Application requires Carbon environment
            let foo = self.infoDictionary["LSPrefersCarbon"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isPrefersClassic :如果该关键字被设为“1”，Finder将会在显示简介面板中显示“在Classic环境中打开” 控制选项，缺省情况下该控件被选中。如果需要，用户可以修改这个控制选项来在Carbon环境中启动应用程序。您也可以指定该关键字的类型为Boolean或Number。然而，只有Mac OS X 10.2或以上的版本才支持这些类型的值。如果您在您的属性列表中加入了该关键字，那么就不要同时加入LSPrefersCarbon, LSRequiresCarbon,或LSRequiresClassic关键字
    class var isPrefersClassic: Bool {
        get{
            //Application prefers Classic environment
            let foo = self.infoDictionary["LSPrefersClassic"] as! Bool
            
            return foo
        }
    }
    //  MARK: isRequiresClassic :如果该关键字被设为“1”，启动服务将只在Classic环境中运行应用程序。如果您的应用程序不应该运行在Carbon兼容环境中的话，可以使用该关键字。您也可以指定该关键字的类型为Boolean或Number。然而，只有Mac OS X 10.2或以上的版本才支持这些类型的值。如果您在您的属性列表中加入了该关键字，那么就不要同时加入LSPrefersCarbon, LSPrefersClassic,或LSRequiresCarbon关键字
    class var isRequiresClassic: Bool {
        get{
            //Application requires Classic environment
            let foo = self.infoDictionary["LSRequiresClassic"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isUINewsstandApp :是否允许应用程序在Newsstand中显示。如果设为YES。可以通过设置NewsstandIcon来美化图标
    class var isUINewsstandApp: Bool {
        get{
            //Application presents content in Newsstand
            let foo = self.infoDictionary["UINewsstandApp"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isMultipleInstancesProhibited :指定一个或多个用户是否可以同时启动一个应用程序
    class var isMultipleInstancesProhibited: Bool {
        get{
            //Application prohibits multiple instances
            let foo = self.infoDictionary["LSMultipleInstancesProhibited"] as! Bool
            
            return foo
        }
    }
    
    
    //  MARK: isGetAppDiedEvents : 指定是否一个子进程死亡时通知应用程序。如果你的值设置为YES这个关键，系统会发送您的应用程序kAEApplicationDied苹果事件
    class var isGetAppDiedEvents: Bool {
        get{
            //Application should get App Died events
            let foo = self.infoDictionary["LSGetAppDiedEvents"] as! Bool
            
            return foo
        }
    }
    enum PresentationMode : Int {
        
        case Normal = 0//Normal mode. 标准的系统UI元素可见。 默认值。
        
        case Content_suppressed = 1//Content suppressed mode. In this mode, system UI elements in the content area of the screen are hidden. UI elements may show themselves automatically in response to mouse movements or other user activity. For example, the Dock may show itself when the mouse moves into the Dock’s auto-show region.
        
        case Content_hidden = 2//Content hidden mode. In this mode, system UI elements in the content area of the screen are hidden and do not automatically show themselves in response to mouse movements or user activity.
        
        case All_hidden = 3//All hidden mode. In this mode, all UI elements are hidden, including the menu bar. Elements do not automatically show themselves in response to mouse movements or user activity.
        
        case All_suppressed = 4//All suppressed mode. In this mode, all UI elements are hidden, including the menu bar. UI elements may show themselves automatically in response to mouse movements or other user activity. This option is available only in OS X v10.3 and later.
    }
    
    //  MARK: UIPresentationMode : 应用程序启动时设置系统UI元素的可见性。确定了初始的应用程序的用户界面模式。你可以使用这个应用程序，可能需要采取部分包含UI元素，如在Dock和菜单栏的屏幕。大多数模式的影响只出现在内容区域中的画面，就是在屏幕的面积，不包括菜单栏的UI元素。但是，您可以要求所有的UI元素被隐藏
    class var UIPresentationMode: PresentationMode {
        get{
            //Application UI Presentation Mode
            let foo = self.infoDictionary["LSUIPresentationMode"] as! Int
            
            let bar = PresentationMode(rawValue: foo)
            
            return bar!
        }
    }
    
    //  MARK: SMAuthorizedClients : 允行添加或移除工具。具体还真不知道什么效果。没试出来
    class var SMAuthorizedClients: NSArray {
        get{
            //Clients allowed to add and remove tool
            let foo = self.infoDictionary["SMAuthorizedClients"] as! NSArray
            
            return foo
        }
    }
    //  MARK: CSResourcesFileMapped : 是否进行文件映射。指定是否将应用程序的资源映射文件到内存中。否则，他们通常读入内存。对于经常访问的资源数量，使用文件映射可以提高性能。然而，资源被映射到只读存储器，不能被修改
    class var CSResourcesFileMapped: Bool {
        get{
            //Resources should be file-mapped
            let foo = self.infoDictionary["CSResourcesFileMapped"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: NSAppleScriptEnabled : 说明了该应用程序是否支持AppleScript。如果您的应用程序支持，就需要把该字符串的值设为“Yes”
    class var NSAppleScriptEnabled: Bool {
        get{
            //Scriptable
            let foo = self.infoDictionary["NSAppleScriptEnabled"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: OSAScriptingDefinition :  脚本文件名
    class var OSAScriptingDefinition: String {
        get{
            //Scripting definition file name
            let foo = self.infoDictionary["OSAScriptingDefinition"] as! String
            
            return foo
        }
    }
    /*
     NSServices字典的关键字
     
     NSPortName	String	该关键字指定了由您的应用程序监听器为接受外部服务请求所提供的端口名称。
     NSMessage	String	该关键字指定了用来调用该服务的实例方法名。在Objective-C中，实例方法的形式是messageName:userData:error:。在Java中，实例方法的形式是messageName(NSPasteBoard.String)。
     NSSendTypes	Array	该关键字指定了一组可以被该服务读取的数据类型名。NSPasteboard类列出了几个常用的数据类型。您必须包含此关键字，NSReturnTypes，或者两者。
     NSReturnTypes	Array	该关键字指定了一组可以被该服务返回的数据类型名。NSPasteboard类列出了几个常用的数据类型。您必须包含此关键字，NSSendTypes，或者两者。
     NSMenuItem	Dictionary	该关键字包含一个字典，它指定了加入Services菜单中的文本。字典中的唯一一个关键字被称为default并且它的值是菜单项的文本。该值必须是唯一的。您可以使用斜杠“/”来指定一个子菜单。例如，Mail/Send出现在Services菜单中时就是一个带有Send子菜单并且名为Mail的菜单。
     NSKeyEquivalent	Dictionary	该关键字是可选的，并且包含一个含有用来请求服务菜单命令的快捷按键的字典。与NSMenuItem类似，字典中的唯一一个关键字被称为default并且它的值是单个的字符。用户可以通过按下Command，Shift功能键和相应的字符来请求该快捷按键。
     NSUserData	String	该关键字是一个可选字符串，它含有您的选择值。
     NSTimeout	String	该关键字是一个可选的数字字符串，它指定了从应用程序请求服务到收到它的响应所需要等待的毫秒数。
     */
    //  MARK: NSServices : 包含了一组字典，它详细说明了应用程序所提供的服务
    class var NSServices: Array<String> {
        get{
            //Services
            let foo = self.infoDictionary["NSServices"] as! Array<String>
            
            return foo
        }
    }
    
    enum Architecture : String{
        
        case i386 = "i386"//The 32-bit Intel architecture.
        
        case ppc = "ppc"//The 32-bit PowerPC architecture.
        
        case x86_64 = "x86_64"//The 64-bit Intel architecture.
        
        case ppc64 = "ppc64"//The 64-bit PowerPC architecture.
    }
    //  MARK: ArchitecturePriority : 用于标识此应用程序支持的体系结构。此阵列中的字符串的顺序决定优选的执行优先级的架构
    class var ArchitecturePriority: Architecture {
        get{
            //Architecture priority
            let foo = self.infoDictionary["LSArchitecturePriority"] as! String
            
            let bar = Architecture(rawValue: foo)
            
            return bar!
        }
    }
    
    //  MARK: ExecutableArchitectures : 用于标识此应用程序支持的体系结构
    class var ExecutableArchitectures: Array<Architecture> {
        get{
            //AExecutable architectures
            let foo = self.infoDictionary["LSExecutableArchitectures"] as! Array<String>
            
            let bar = foo.map { (rawString) -> Architecture in
                return Architecture(rawValue: rawString)!
            }
            
            return bar
        }
    }
    //  MARK: EnvironmentVars : 用于标识此应用程序支持的体系结构
    class var EnvironmentVars: [String : Any] {
        get{
            //Environment variables
            let foo = self.infoDictionary["LSEnvironment"] as! [String : Any]
            
            return foo
        }
    }
    
    //  MARK: Executable : 应用程序的可执行文件。对于一个可加载束,它是一个可以被束动态加载的二进制文件。对于一个框架，它是一个共享库。Project Builder会自动把该关键字加入到合适项目的Info.plist文件中
    class var Executable: String {
        get{
            //Executable file
            let foo = self.infoDictionary["CFBundleExecutable"] as! String
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(Requirement):“系统需求” 扩展
extension BundleInfo  {
    //  MARK: isRequiresIPhoneOS : 如果应用程序不能在ipod touch上运行，设置此项为true
    class var isRequiresIPhoneOS: Bool {
        get{
            //Application requires iPhone environment
            let foo = self.infoDictionary["LSRequiresIPhoneOS"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: isRequiresNativeExecution : 指定应用程序是否必须在本机运行一个基于Intel的Mac上，而不是根据Rosetta模拟。指定是否要启动该应用程序使用subbinary当前的架构。如果此键被设置为“YES”，启动服务始终运行应用程序使用当前的架构编译的二进制代码。您可以使用此键，以防止一个通用的二进制下运行的Rosetta模拟一个基于Intel的Mac上
    class var isRequiresNativeExecution: Bool {
        get{
            //Application requires native environment
            let foo = self.infoDictionary["LSRequiresNativeExecution"] as! Bool
            
            return foo
        }
    }
    //  MARK: MinimumSystemVersion : 最小系统版本
    class var MinimumSystemVersion: String {
        get{
            //Minimum system version
            let foo = self.infoDictionary["LSMinimumSystemVersion"] as! String
            
            return foo
        }
    }
/*
    除了wifi和telephony项，还有很多项代表各种设备功能，如下：
    
    sms	应用程序需要Messages应用程序或者使用sms://URL
    still-camera	应用程序需要使用照相机模式作为图像选取器的控制器
    auto-focus-camera	应用程序需要使用更多的聚焦功能以进行微距摄影或者拍摄特别清晰的图像以进行图像内数据检测
    video-camera	应用程序需要使用视频模式作为图像选取器的控制器
    accelerometer	应用程序需要特定于加速计的反馈而不知是简单的UIViewController方向事件
    location-services	应用程序需要使用Core Location
    gps	应用程序需要使用Core Location并需要更加精确的gps定位
    magnetometer	应用程序需要使用Core Location并需要与前进方向相关的事件，即行进的方向（通过磁力计获得）
    peer-peer	应用程序需要使用GameKit通过蓝牙（3.1或更高版本）进行对等连接
    opengles-1	应用程序需要OpenGL ES 1.1
    opengles-2	应用程序需要OpenGL ES 2.0
    armv-6	应用程序仅针对armv6指令集（3.1或更高版本）编译
    armv-7	应用程序仅针对armv7指令集（3.1或更高版本）编译
    wifi	当您的应用程序需要设备的网络特性时，包含这个键。
    microphone	如果您的应用程序需要使用内置的麦克风或支持提供麦克风的外设，则包含这个键。
    telephony	如果您的应用程序需要Phone程序，则包含这个键。如果您的应用程序需要打开tel模式的URL，则可能需要这个特性。
 */
    //  MARK: UIRequiredDeviceCapabilities : 当提交程序到app store时，3.0及更高版本的应用程序不再直接说明使用哪种设备，而是使用info.plist文件来确定需要哪些设备功能。iTunes通过这个所需功能的列表来确定一个应用程序能否下载到一个指定的设备并在该设备上正常运行。例如，我在info.plist中设置如下，那么只有居右wifi、电话功能和麦克风（内置的或附件所带的麦克风功能）的ios设备才能运行该程序
    class var UIRequiredDeviceCapabilities: Array<String> {
        get{
            //Required device capabilities
            let foo = self.infoDictionary["UIRequiredDeviceCapabilities"] as! Array<String>
            
            return foo
        }
    }
    
    //  MARK: isRequiresPersistentWiFi : 如果应用程序需要wi-fi才能工作，应该将此属性设置为true。这么做会提示用户，如果没有打开wi-fi的话，打开wi-fi。为了节省电力，iphone会在30分钟后自动关闭应用程序中的任何wi-fi。设置这一个属性可以防止这种情况的发生，并且保持连接处于活动状态
    class var isRequiresPersistentWiFi: Bool {
        get{
            //Application uses Wi-Fi Persistently
            let foo = self.infoDictionary["UIRequiresPersistentWiFi"] as! Bool
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(Installer):“安装时的推荐设置” 扩展
extension BundleInfo  {
    
    //  MARK: SMPrivilegedExecutables :辅助工具，辅助工具必须有一个嵌入式的Info.plist中包含的“SMAuthorizedClients”的字符串数组。每个字符串是一个文本表示的代码签名要求描述一个客户端，它允许添加和删除工具
    class var SMPrivilegedExecutables: [String : AnyObject]! {
        get{//Tools owned after installation
            let foo = self.infoDictionary["SMPrivilegedExecutables"] as! [String : AnyObject]!
            
            return foo
        }
    }
    //  MARK: APInstallerURL :指定了一个指向您希望安装的文件的路径。您必须以file://localhost/path/ 形式来说明这个路径。所有被安装的文件必须位于这个文件夹中。
    class var APInstallerURL: String {
        get{
            //Installation directory base file URL
            let foo = self.infoDictionary["APInstallerURL"] as! String
            return foo
        }
    }
    //  MARK: Installation files :
    class var InstallationFiles: APFiles {
        get{
            let foo = APFiles()
            
            return foo
        }
    }
    public class APFiles: AnyObject {
        private var rawDictionary: [String : AnyObject]! {
            get{
                let foo = BundleInfo.infoDictionary["APFiles"] as! [String : AnyObject]!
                
                return foo
            }
        }
        
        //  MARK: FileDescriptionKey : 用来显示在Finder的信息窗口中的简短描述
        var FileDescriptionKey: String {
            get{
                let foo = self.rawDictionary["APFileDescriptionKey"] as! String
                
                return foo
            }
        }
        //  MARK: DisplayedAsContainer : 如果值为“Yes”，该项目作为一个目录图标显示在信息面板中；否则，它被显示为一个文档图标
        var DisplayedAsContainer: String {
            get{
                let foo = self.rawDictionary["APDisplayedAsContainer"] as! String
                
                return foo
            }
        }
        //  MARK: FileDestinationPath : 一个安装组件的相对路径
        var FileDestinationPath: String {
            get{
                let foo = self.rawDictionary["APFileDestinationPath"] as! String
                
                return foo
            }
        }
        //  MARK: FileName : 文件或目录的名称
        var FileName: String {
            get{
                let foo = self.rawDictionary["APFileName"] as! String
                
                return foo
            }
        }
        //  MARK: FileSourcePath : 指向应用程序包中组件的路径，相对与APInstallerURL路径
        var FileSourcePath: String {
            get{
                let foo = self.rawDictionary["APFileSourcePath"] as! String
                
                return foo
            }
        }
        //  MARK: InstallAction : 操纵组件的动作：“Copy”或者“Open”
        var InstallAction: String {
            get{
                let foo = self.rawDictionary["APInstallAction"] as! String
                
                return foo
            }
        }
    }
}
//  MARK: - BundleInfo(Default Resources):访问默认资源的扩展
extension BundleInfo  {
    //  MARK: UIPrerenderedIcon : 默认情况下，应用程序被设置了玻璃效果，把这个设置为true可以阻止这么做
    class var UIPrerenderedIcon: Bool {
        get{
            //Icon already includes gloss effects
            let foo = self.infoDictionary["UIPrerenderedIcon"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: IconFile :设置应用程序图标的。CFBundleIconFile关键字指定了包含该束图标的文件。您给出的文件名不需要包含“.icns”扩展名。Finder会在该束的“Resource”文件夹内寻找图标文件。如果您的束使用了自定义的图标，那您就必须指定该属性。假如您没有指定，Finder（和其他应用程序）会使用缺省的图标来显示您的束
    class var IconFile: String {
        get{
            //Help file
            let foo = self.infoDictionary["CFBundleIconFile"] as! String
            
            return foo
        }
    }
    
    //  MARK: LaunchImageFile :启动图像。根据不同设备来设置图片的规格大小
    class var LaunchImageFile: String {
        get{
            //Launch image
            let foo = self.infoDictionary["UILaunchImageFile"] as! String
            
            return foo
        }
    }
    //  MARK: LaunchImageFile_ipad :启动图像。根据不同设备来设置图片的规格大小
    class var LaunchImageFile_ipad: String {
        get{
            //Launch image(iPad)
            let foo = self.infoDictionary["UILaunchImageFile~ipad"] as! String
            
            return foo
        }
    }
    //  MARK: LaunchImageFile_iphone :启动图像。根据不同设备来设置图片的规格大小
    class var LaunchImageFile_iphone: String {
        get{
            //Launch image(iPad)
            let foo = self.infoDictionary["UILaunchImageFile~iphone"] as! String
            
            return foo
        }
    }
    
    //  MARK: NSMainNibFile :包含了一个含有应用程序的主nib文件名（不包含.nib文件扩展名）的字符串。一个nib文件作为一个Interface Builder的存档文件，含有对用户界面的详细描述信息以及那些界面中的对象之间的关联信息。当应用程序被启动时，主nib文件会被自动装载。Mac OS X会寻找与应用程序名相匹配的nib文件
    class var NSMainNibFile: String {
        get{
            //Main nib file base name
            let foo = self.infoDictionary["NSMainNibFile"] as! String
            
            return foo
        }
    }
    //  MARK: NSMainNibFile_ipad : (IPAD)
    class var NSMainNibFile_ipad: String {
        get{
            //Main nib file base name (iPad)
            let foo = self.infoDictionary["NSMainNibFile~ipad"] as! String
            
            return foo
        }
    }
    //  MARK: NSMainNibFile_iPhone :(Iphone)
    class var NSMainNibFile_iPhone: String {
        get{
            //Main nib file base name ()
            let foo = self.infoDictionary["NSMainNibFile~iphone"] as! String
            
            return foo
        }
    }
    
    //  MARK: UIMainStoryboardFile :故事板文件名
    class var UIMainStoryboardFile: String {
        get{
            //Main storyboard file base name
            let foo = self.infoDictionary["UIMainStoryboardFile"] as! String
            
            return foo
        }
    }
    //  MARK: UIMainStoryboardFile_ipad :
    class var UIMainStoryboardFile_ipad: String {
        get{
            //Main storyboard file base name (iPad)
            let foo = self.infoDictionary["UIMainStoryboardFile~ipad"] as! String
            
            return foo
        }
    }
    //  MARK: UIMainStoryboardFile_iPhone :启动图像。根据不同设备来设置图片的规格大小。
    class var UIMainStoryboardFile_iPhone: String {
        get{
            //Main storyboard file base name (iPhone)
            let foo = self.infoDictionary["UIMainStoryboardFile~iphone"] as! String
            
            return foo
        }
    }
    
    //  MARK: UISupportedInterfaceOrientations :设定应用程序的显示模式
    class var UISupportedInterfaceOrientations: Array<String> {
        get{
            //Supported interface orientationsSupported interface orientations
            let foo = self.infoDictionary["UISupportedInterfaceOrientations"] as! Array<String>
            
            return foo
        }
    }
    //  MARK: UISupportedInterfaceOrientations_ipad : 设定应用程序的显示模式。
    class var UISupportedInterfaceOrientations_ipad: Array<String> {
        get{
            //Supported interface orientations (iPad)
            let foo = self.infoDictionary["UISupportedInterfaceOrientations~ipad"] as! Array<String>
            
            return foo
        }
    }
    //  MARK: UISupportedInterfaceOrientations_iPhone : 设定应用程序的显示模式。
    class var UISupportedInterfaceOrientations_iPhone: Array<String> {
        get{
            //Supported interface orientations (iPhone)
            let foo = self.infoDictionary["UISupportedInterfaceOrientations~iphone"] as! Array<String>
            
            return foo
        }
    }
    
    //  MARK: NSPrefPaneIconFile
    class var NSPrefPaneIconFile: String {
        get{
            //Preference Pane icon file
            let foo = self.infoDictionary["NSPrefPaneIconFile"] as! String
            
            return foo
        }
    }
    //  MARK: NSPrefPaneIconLabel
    class var NSPrefPaneIconLabel: String {
        get{
            //Preference Pane icon label
            let foo = self.infoDictionary["NSPrefPaneIconLabel"] as! String
            
            return foo
        }
    }
    //  MARK: HelpBookFolder : 帮助目录，CFBundleHelpBookFolder关键字含有该束的帮助文件的文件夹名字。帮助通常被本地化成一种指定的语言，所以该关键字指向的文件夹应该是所选择语言的.lproj目录中的文件夹
    class var HelpBookFolder: String {
        get{
            //Help Book directory name
            let foo = self.infoDictionary["CFBundleHelpBookFolder"] as! String
            
            return foo
        }
    }
    
    //  MARK: HelpBookName :
    class var HelpBookName: String {
        get{
            //Help Book identifier
            let foo = self.infoDictionary["CFBundleHelpBookName"] as! String
            
            return foo
        }
    }
    
    //  MARK: HelpAnchor :定义了束的初始HTML帮助文件名，不需要包括.html或.htm扩展名。这个文件位于束的本地化资源目录中，或者如果没有本地化资源目录的话，则直接被放在Resources目录中
    class var HelpAnchor: String {
        get{
            //Help file
            let foo = self.infoDictionary["CFAppleHelpAnchor"] as! String
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(UTI & document):文件 & UTI扩展
extension BundleInfo  {
    //  MARK: FileSharingEnabled : 应用程序支持共享到iTunes   值为 boolean 值   YES 共享；  NO 不共享
    class var FileSharingEnabled: Bool {
        get{
            //Application supports iTunes file sharing
            let foo = self.infoDictionary["UIFileSharingEnabled"] as! Bool
            
            return foo
        }
    }
    /*
     CFBundleTypeRole	String	该关键字定义了那些与URL类型有关的应用程序的角色（即该应用程序与某种文档类型的关系）。它的值可以是Editer，Viewer，Printer，Shell或None。有关这些值的详细描述可以参见“ 文档的配置”。该关键字是必须的。
     CFBundleURLIconFile	String	该关键字包含了被用于这种URL类型的图标文件名（不包括扩展名）字符串。
     CFBundleURLName	String	该关键字包含了这种URL类型的抽象名称字符串。为了确保唯一性，建议您使用Java包方式的命名法则。这个名字作为一个关键字也会在InfoPlist.strings文件中出现，用来提供该类型名的可读性版本。
     CFBundleURLSchemes	Array	该关键字包含了一组可被这种类型处理的URL协议。例如：http,ftp等。
     */
    //  MARK: URLTypes : 包含了一组描述了应用程序所支持的URL协议的字典。它的用途类似于CFBundleDocumentTypes的作用，但它描述了URL协议而不是文档类型。每一个字典条目对应一个单独的URL协议
    class var URLTypes: Array<[String : AnyObject]> {
        get{
            //Supported external accessory protocols
            let foo = self.infoDictionary["CFBundleURLTypes"] as! Array<[String : AnyObject]>
            
            return foo
        }
    }
    /*
     表 A-2 CFBundleDocumentTypes字典的关键字
     
     关键字	类型	描述
     CFBundleTypeExtensions	Array	该关键字包含了一组映射到这个类型的文件扩展名。为了打开具有任何扩展名的文档，可以用单个星号“*”。该关键字是必须的。
     CFBundleTypeIconFile	String	该关键字指定了系统显示该类文档时使用的图标文件名，该图标文件名的扩展名是可选的。如果没有扩展名，系统会根据平台指定一个（例如，Mac OS 9中的.icons）。
     CFBundleTypeName	String	该关键字包含了这种文档类型的抽象名称。通过在适当的InforPlist.strings文件中包含该关键字，可以实现对它的本地化。
     CFBundleTypeOSTypes	Array	该关键字包含了一组映射到这个类型的四字母长的类型代码。为了打开所有类型的文档，可以把它设为“****”。该关键字是必须的。
     CFBundleTypeRole	String	该关键字定义了那些与文档类型有关的应用程序的角色。它的值可以是Editer，Viewer，Printer，Shell或None。有关这些值的详细描述可以参见“ 文档的配置” 。该关键字是必须的。
     NSDocumentClass	String	该关键字描述了被用来实例化文档的NSDocument子类。仅供Cocoa应用程序使用。
     NSExportableAs	Array	该关键字描述了一组可以输出的文档类型。仅供Cocoa应用程序使用。
     */
    //  MARK: DocumentTypes : 保存了一组字典，它包含了该应用程序所支持的文档类型。每一个字典都被称做类型定义字典，并且包含了用于定义文档类型的关键字。表A-2列出了类型定义字典中支持的关键字
    class var DocumentTypes: Array<[String : AnyObject]> {
        get{
            let foo = self.infoDictionary["CFBundleDocumentTypes"] as! Array<[String : AnyObject]>
            
            return foo
        }
    }
    //  MARK: UTExportedTypeDeclarations : 导出UTI（Unique Type Identifier）类型
    class var UTExportedTypeDeclarations: Array<Any> {
        get{
            //Exported Type UTIs
            let foo = self.infoDictionary["UTExportedTypeDeclarations"] as! Array<Any>
            
            return foo
        }
    }
    //  MARK: UTExportedTypeDeclarations : 导出UTI（Unique Type Identifier）类型
    class var UTImportedTypeDeclarations: Array<Any> {
        get{
            //Imported Type UTIs
            let foo = self.infoDictionary["UTImportedTypeDeclarations"] as! Array<Any>
            
            return foo
        }
    }

}
//  MARK: - BundleInfo(Java):Java扩展
extension BundleInfo  {
    //  MARK: isJavaNeeded : 用来确定在执行该束的代码之前Java虚拟机是否需要被载入并运行
    class var isJavaNeeded: Bool {
        get{
            //Cocoa Java application
            let foo = self.infoDictionary["NSJavaNeeded"] as! Bool
            
            return foo
        }
    }
    
    //  MARK: NSJavaPath : 包含了一组路径。每一个路径指向一个Java类。该路径相对于由NSJavaRoot关键字定义的位置来说，可能是一个绝对路径也可能是一个相对路径。开发环境会自动把这些值保存在数组中
    class var JavaPath: String {
        get{
            //Java classpaths
            let foo = self.infoDictionary["NSJavaPath"] as! String
            
            return foo
        }
    }
    
    //  MARK: NSJavaRoot : 一个指向一个目录的字符串。该目录是应用程序的Java类文件的根目录
    class var JavaRoot: String {
        get{
            //Java root directory
            let foo = self.infoDictionary["NSJavaRoot"] as! String
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(PlugIn):插件扩展
extension BundleInfo  {
    //  MARK: PlugInDynamicRegisterFunction :
    class var PlugInDynamicRegisterFunction: String {
        get{
            //Plug-in dynamic registration function name
            let foo = self.infoDictionary["CFPlugInDynamicRegisterFunction"] as! String
            
            return foo
        }
    }
    
    //  MARK: PlugInFactories : 插件工厂接口
    class var PlugInFactories: String {
        get{
            //Plug-in factory interfaces
            let foo = self.infoDictionary["CFPlugInFactories"] as! String
            
            return foo
        }
    }

    //  MARK: PlugInDynamicRegistration : 是否动态注册插件
    class var PlugInDynamicRegistration: Bool {
        get{
            //Plug-in should be registered dynamically
            let foo = self.infoDictionary["CFPlugInDynamicRegistration"] as! Bool
            
            return foo
        }
    }

    //  MARK: PlugInTypes : 插件类型
    class var PlugInTypes: [String : AnyObject] {
        get{
            //Plug-in types
            let foo = self.infoDictionary["CFPlugInTypes"] as! [String : AnyObject]!
            
            return foo
        }
    }
    
    //  MARK: PlugInUnloadFunction : 插件卸载函数名
    class var PlugInUnloadFunction: String {
        get{
            //Plug-in unload function name
            let foo = self.infoDictionary["CFPlugInUnloadFunction"] as! String
            
            return foo
        }
    }
}
//  MARK: - BundleInfo(Quick Look):快速查看扩展
extension BundleInfo  {

    //  MARK: QLNeedsToBeRunInMainThread
    class var QLNeedsToBeRunInMainThread: Bool {
        get{
            //Quick Look needs to be run in main thread
            let foo = self.infoDictionary["QLNeedsToBeRunInMainThread"] as! Bool
            
            return foo
        }
    }

    //  MARK: QLPreviewHeight
    class var QLPreviewHeight: Float {
        get{
            //Quick Look preview height
            let foo = self.infoDictionary["QLPreviewHeight"] as! Float
            
            return foo
        }
    }
    //  MARK: QLPreviewWidth
    class var QLPreviewWidth: Float {
        get{
            //Quick Look preview width
            let foo = self.infoDictionary["QLPreviewWidth"] as! Float
            
            return foo
        }
    }
    //  MARK: QLSupportsConcurrentRequests
    class var QLSupportsConcurrentRequests: Bool {
        get{
            //Quick Look supports concurrent requests
            let foo = self.infoDictionary["QLSupportsConcurrentRequests"] as! Bool
            
            return foo
        }
    }

    //  MARK: QLThumbnailMinimumSize
    class var QLThumbnailMinimumSize: CGSize {
        get{
            //Quick Look thumbnail minimum size
            let foo = self.infoDictionary["QLThumbnailMinimumSize"] as! CGSize
            
            return foo
        }
    }
}