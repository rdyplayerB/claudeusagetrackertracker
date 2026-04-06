import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var trackerCount: Int = 0
    var trackers: [(name: String, url: String, stars: Int)] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.title = "..."
        }

        fetchTrackerCount()

        // Refresh every 30 minutes
        Timer.scheduledTimer(withTimeInterval: 1800, repeats: true) { _ in
            self.fetchTrackerCount()
        }
    }

    func fetchTrackerCount() {
        let urlString = "https://raw.githubusercontent.com/rdyplayerB/claudetrackertracker/master/trackers.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let meta = json["meta"] as? [String: Any],
                  let count = meta["total_count"] as? Int,
                  let trackersArray = json["trackers"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    self.statusItem.button?.title = "??"
                }
                return
            }

            let parsed = trackersArray.compactMap { tracker -> (String, String, Int)? in
                guard let name = tracker["name"] as? String,
                      let url = tracker["url"] as? String,
                      let stars = tracker["stars"] as? Int else { return nil }
                return (name, url, stars)
            }

            DispatchQueue.main.async {
                self.trackerCount = count
                self.trackers = parsed
                self.statusItem.button?.title = "📊 \(count)"
                self.buildMenu()
            }
        }.resume()
    }

    func buildMenu() {
        let menu = NSMenu()

        let header = NSMenuItem(title: "Claude Tracker Tracker", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)

        let countItem = NSMenuItem(title: "\(trackerCount) trackers tracked", action: nil, keyEquivalent: "")
        countItem.isEnabled = false
        menu.addItem(countItem)

        menu.addItem(NSMenuItem.separator())

        let topLabel = NSMenuItem(title: "Top Trackers:", action: nil, keyEquivalent: "")
        topLabel.isEnabled = false
        menu.addItem(topLabel)

        for tracker in trackers.prefix(10) {
            let item = NSMenuItem(
                title: "  \(tracker.name) (\(tracker.stars)⭐)",
                action: #selector(openTracker(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = tracker.url
            menu.addItem(item)
        }

        menu.addItem(NSMenuItem.separator())

        let viewAll = NSMenuItem(title: "View All on GitHub", action: #selector(openRepo), keyEquivalent: "")
        viewAll.target = self
        menu.addItem(viewAll)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc func openTracker(_ sender: NSMenuItem) {
        if let urlString = sender.representedObject as? String,
           let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func openRepo() {
        if let url = URL(string: "https://github.com/rdyplayerB/claudetrackertracker") {
            NSWorkspace.shared.open(url)
        }
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
