class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = SmartLockController.alloc.init

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible

    return true if RUBYMOTION_ENV == 'test'
  end
end
