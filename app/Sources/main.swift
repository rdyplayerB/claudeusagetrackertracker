import AppKit
import SwiftUI

struct Tracker: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let stars: Int
}

struct HistoryEntry {
    let date: String
    let count: Int
    let stars: Int
    let new: Int
}

class AppState: ObservableObject {
    @Published var trackerCount: Int = 0
    @Published var totalStars: Int = 0
    @Published var trackers: [Tracker] = []
    @Published var history: [HistoryEntry] = []
    @Published var lastUpdated: String = ""
    @Published var isLoading: Bool = true

    var weeklyNew: Int {
        history.suffix(7).reduce(0) { $0 + $1.new }
    }

    var weeklyData: [Int] {
        let last7 = Array(history.suffix(7))
        if last7.isEmpty { return Array(repeating: 0, count: 7) }
        // Pad to 7 days if less
        let padded = Array(repeating: HistoryEntry(date: "", count: 0, stars: 0, new: 0), count: max(0, 7 - last7.count)) + last7
        return padded.map { $0.new }
    }

    func fetchData() {
        isLoading = true
        fetchTrackers()
        fetchHistory()
    }

    func fetchTrackers() {
        let urlString = "https://raw.githubusercontent.com/rdyplayerB/claudeusagetrackertracker/master/trackers.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let meta = json["meta"] as? [String: Any],
                  let count = meta["total_count"] as? Int,
                  let trackersArray = json["trackers"] as? [[String: Any]] else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            let stars = meta["total_stars"] as? Int ?? 0
            let updated = meta["last_updated"] as? String ?? ""
            let parsed = trackersArray.compactMap { tracker -> Tracker? in
                guard let name = tracker["name"] as? String,
                      let url = tracker["url"] as? String,
                      let stars = tracker["stars"] as? Int else { return nil }
                return Tracker(name: name, url: url, stars: stars)
            }

            DispatchQueue.main.async {
                self.trackerCount = count
                self.totalStars = stars
                self.lastUpdated = updated
                self.trackers = parsed
                self.isLoading = false
            }
        }.resume()
    }

    func fetchHistory() {
        let urlString = "https://raw.githubusercontent.com/rdyplayerB/claudeusagetrackertracker/master/history.json"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let entries = json["entries"] as? [[String: Any]] else {
                return
            }

            let parsed = entries.compactMap { entry -> HistoryEntry? in
                guard let date = entry["date"] as? String,
                      let count = entry["count"] as? Int,
                      let stars = entry["stars"] as? Int,
                      let new = entry["new"] as? Int else { return nil }
                return HistoryEntry(date: date, count: count, stars: stars, new: new)
            }

            DispatchQueue.main.async {
                self.history = parsed
            }
        }.resume()
    }

    func formatNumber(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}

struct TrackerRow: View {
    let tracker: Tracker
    let index: Int
    let formatNumber: (Int) -> String
    let secondaryText: Color
    let hoverBackground: Color

    @State private var isHovered = false

    var body: some View {
        Button(action: {
            if let url = URL(string: tracker.url) {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack {
                HStack(spacing: 4) {
                    if index == 0 {
                        Text("🏆")
                            .font(.system(size: 12))
                    }
                    Text(tracker.name)
                        .font(.system(size: 12))
                        .lineLimit(1)
                        .foregroundColor(isHovered ? .blue : .primary)
                }
                Spacer()
                HStack(spacing: 2) {
                    Text(formatNumber(tracker.stars))
                        .font(.system(size: 12))
                        .foregroundColor(index == 0 ? .orange : secondaryText)
                    if index == 0 {
                        Text("⭐")
                            .font(.system(size: 10))
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isHovered ? hoverBackground : Color.clear)
            .cornerRadius(6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

struct PopoverView: View {
    @ObservedObject var state: AppState
    @Environment(\.colorScheme) var colorScheme

    var cardBackground: Color {
        colorScheme == .dark ? Color(white: 0.17) : Color(white: 0.94)
    }

    var secondaryText: Color {
        colorScheme == .dark ? Color(white: 0.56) : Color(white: 0.45)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text("Claude Usage Tracker Tracker")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Button(action: { state.fetchData() }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(secondaryText)
                }
                .buttonStyle(.plain)
            }

            // Stats Cards
            HStack(spacing: 12) {
                // Trackers Card
                VStack(spacing: 4) {
                    Text("\(state.trackerCount)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.orange)
                    Text("and counting")
                        .font(.system(size: 12))
                        .foregroundColor(secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(cardBackground)
                .cornerRadius(10)

                // Stars Card
                VStack(spacing: 4) {
                    Text(state.formatNumber(state.totalStars))
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.green)
                    Text("Stars")
                        .font(.system(size: 12))
                        .foregroundColor(secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(cardBackground)
                .cornerRadius(10)
            }

            // Top Trackers
            VStack(alignment: .leading, spacing: 6) {
                Text("TOP TRACKERS")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(secondaryText)

                ForEach(Array(state.trackers.prefix(5).enumerated()), id: \.element.id) { index, tracker in
                    TrackerRow(
                        tracker: tracker,
                        index: index,
                        formatNumber: state.formatNumber,
                        secondaryText: secondaryText,
                        hoverBackground: cardBackground
                    )
                }

                Button(action: {
                    if let url = URL(string: "https://github.com/rdyplayerB/claudeusagetrackertracker") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("View all \(state.trackerCount) on GitHub →")
                            .font(.system(size: 11))
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }

            Divider()

            // This Week Chart
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("This Week")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(secondaryText)
                    Spacer()
                    Text("+\(state.weeklyNew) new")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.green)
                }

                HStack(alignment: .bottom, spacing: 4) {
                    let data = state.weeklyData
                    let maxVal = max(data.max() ?? 1, 1)
                    ForEach(0..<7, id: \.self) { i in
                        let height = CGFloat(data[i]) / CGFloat(maxVal) * 32
                        let barHeight = max(height, data[i] > 0 ? 8 : 4)
                        let isToday = i == 6
                        RoundedRectangle(cornerRadius: 2)
                            .fill(isToday && data[i] > 0 ? Color.green : (colorScheme == .dark ? Color(white: 0.23) : Color(white: 0.8)))
                            .frame(height: barHeight)
                    }
                }
                .frame(height: 32)
            }

            // Footer
            if !state.lastUpdated.isEmpty {
                HStack {
                    Spacer()
                    Text("Synced \(state.lastUpdated)")
                        .font(.system(size: 10))
                        .foregroundColor(secondaryText)
                    Spacer()
                }
            }
        }
        .padding(16)
        .frame(width: 300)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var state = AppState()
    var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // Load menu bar icon from Resources
            if let iconPath = Bundle.main.path(forResource: "menubar-icon", ofType: "png"),
               let icon = NSImage(contentsOfFile: iconPath) {
                icon.size = NSSize(width: 18, height: 18)
                icon.isTemplate = true  // Adapts to light/dark mode
                button.image = icon
                button.imagePosition = .imageLeft
            }
            button.title = " ..."
            button.action = #selector(togglePopover)
            button.target = self
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverView(state: state))

        state.fetchData()

        // Update button title when data loads
        state.$trackerCount.sink { [weak self] count in
            DispatchQueue.main.async {
                if count > 0 {
                    self?.statusItem.button?.title = " \(count)"
                }
            }
        }.store(in: &cancellables)

        // Refresh every hour
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.state.fetchData()
        }

        // Close popover when clicking outside
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }
    }

    var cancellables = Set<AnyCancellable>()

    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}

import Combine

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
