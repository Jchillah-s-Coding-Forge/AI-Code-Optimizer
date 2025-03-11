import SwiftUI
import UniformTypeIdentifiers

#if os(macOS)
import AppKit
#endif

@MainActor
class CodeEditorViewModel: ObservableObject {
    @Published var code: String = ""
    @Published var optimizedCode: String = ""
    @Published var previousVersions: [String] = []
    @Published var isOptimizing = false
    @Published var selectedFileURL: URL?

    private let optimizerService = GeminiCodeOptimizerService.shared

    func optimizeCode() {
        guard !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        previousVersions.append(code)
        isOptimizing = true

        Task {
            let result = await optimizerService.optimize(code: code, language: "swift")
            self.optimizedCode = result
            self.isOptimizing = false
        }
    }

    func undoLastChange() {
        if let lastVersion = previousVersions.popLast() {
            code = lastVersion
        }
    }

    func saveToFile() {
        #if os(iOS)
        saveOniOS()
        #elseif os(macOS)
        saveOnMac()
        #endif
    }

    func openFile() {
        #if os(iOS)
        openOniOS()
        #elseif os(macOS)
        openOnMac()
        #endif
    }

    // MARK: - macOS Datei-Handling
    #if os(macOS)
    private func saveOnMac() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.swiftSource, UTType.plainText, UTType.json, UTType.pythonScript]
        savePanel.nameFieldStringValue = "CodeSnippet.swift"
        savePanel.title = "Speicherort auswählen"
        savePanel.prompt = "Speichern"

        if savePanel.runModal() == .OK, let url = savePanel.url {
            do {
                try code.write(to: url, atomically: true, encoding: .utf8)
                print("Datei gespeichert: \(url.path)")
            } catch {
                print("Fehler beim Speichern: \(error.localizedDescription)")
            }
        }
    }

    private func openOnMac() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.swiftSource, UTType.plainText, UTType.json, UTType.pythonScript]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.title = "Datei auswählen"

        if openPanel.runModal() == .OK, let url = openPanel.url {
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                code = content
                print("Datei geladen: \(url.path)")
            } catch {
                print("Fehler beim Öffnen: \(error.localizedDescription)")
            }
        }
    }
    #endif

    // MARK: - iOS Datei-Handling
    private func saveOniOS() {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("CodeSnippet.swift")
        do {
            try code.write(to: tempURL, atomically: true, encoding: .utf8)
            selectedFileURL = tempURL
        } catch {
            print("Fehler beim Speichern: \(error.localizedDescription)")
        }
    }

    private func openOniOS() {
        print("Dateiauswahl unter iOS muss mit UIDocumentPickerViewController implementiert werden.")
    }
}
