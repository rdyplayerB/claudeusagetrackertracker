import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var trackerCount: Int = 0
    var totalStars: Int = 0
    var lastUpdated: String = ""
    var trackers: [(name: String, url: String, stars: Int)] = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.title = "..."
        }

        fetchTrackerCount()

        // Refresh every hour
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            self.fetchTrackerCount()
        }
    }

    func fetchTrackerCount() {
        let urlString = "https://raw.githubusercontent.com/rdyplayerB/claudeusagetrackertracker/master/trackers.json"
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

            let stars = meta["total_stars"] as? Int ?? 0
            let updated = meta["last_updated"] as? String ?? ""

            let parsed = trackersArray.compactMap { tracker -> (String, String, Int)? in
                guard let name = tracker["name"] as? String,
                      let url = tracker["url"] as? String,
                      let stars = tracker["stars"] as? Int else { return nil }
                return (name, url, stars)
            }

            DispatchQueue.main.async {
                self.trackerCount = count
                self.totalStars = stars
                self.lastUpdated = updated
                self.trackers = parsed
                self.statusItem.button?.title = "📊 \(count)"
                self.buildMenu()
            }
        }.resume()
    }

    func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }

    func buildMenu() {
        let menu = NSMenu()

        // Header
        let header = NSMenuItem(title: "claudeusagetrackertracker", action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)

        menu.addItem(NSMenuItem.separator())

        // Stats
        let statsItem = NSMenuItem(title: "\(trackerCount) Trackers  ·  \(formatNumber(totalStars)) ⭐", action: nil, keyEquivalent: "")
        statsItem.isEnabled = false
        menu.addItem(statsItem)

        menu.addItem(NSMenuItem.separator())

        // Top 5 Trackers
        let topLabel = NSMenuItem(title: "TOP TRACKERS", action: nil, keyEquivalent: "")
        topLabel.isEnabled = false
        menu.addItem(topLabel)

        for (index, tracker) in trackers.prefix(5).enumerated() {
            let starText = formatNumber(tracker.stars)
            let item = NSMenuItem(
                title: "\(index + 1). \(tracker.name)  ·  \(starText)",
                action: #selector(openTracker(_:)),
                keyEquivalent: ""
            )
            item.target = self
            item.representedObject = tracker.url
            menu.addItem(item)
        }

        menu.addItem(NSMenuItem.separator())

        // Last updated
        if !lastUpdated.isEmpty {
            let updatedItem = NSMenuItem(title: "Updated: \(lastUpdated)", action: nil, keyEquivalent: "")
            updatedItem.isEnabled = false
            menu.addItem(updatedItem)
        }

        // View All
        let viewAll = NSMenuItem(title: "View All on GitHub", action: #selector(openRepo), keyEquivalent: "")
        viewAll.target = self
        menu.addItem(viewAll)

        menu.addItem(NSMenuItem.separator())

        // Quit
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
        if let url = URL(string: "https://github.com/rdyplayerB/claudeusagetrackertracker") {
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
