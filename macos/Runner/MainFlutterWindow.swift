import Cocoa
import FlutterMacOS
import window_manager

class MainFlutterWindow: NSPanel {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Remove the default black square border and background color.
    self.isOpaque = false
    self.backgroundColor = NSColor.clear
    flutterViewController.backgroundColor = NSColor.clear

    self.styleMask = [
      .borderless, .fullSizeContentView, .resizable, .miniaturizable, .closable, .titled,
    ]
    
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true

    // Ensure this app is always on top when it is visible
    self.level = .floating

    // So this app can be hidden when clicking outside of the window
    self.hidesOnDeactivate = true

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }

  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    super.order(place, relativeTo: otherWin)
    hiddenWindowAtLaunch()
  }
}


