// StaticFileServer.swift
// A minimal HTTP server for serving files from a directory
// This implementation is suitable for local/demo use only. Not for production!

import Foundation
import Network

class StaticFileServer {
    let port: UInt16
    let rootDirectory: URL
    private var listener: NWListener?
    
    init(port: UInt16 = 8080, directory: URL) {
        self.port = port
        self.rootDirectory = directory
    }
    
    func start() throws {
        let params = NWParameters.tcp
        let listener = try NWListener(using: params, on: NWEndpoint.Port(rawValue: port)!)
        self.listener = listener
        
        listener.newConnectionHandler = { connection in
            connection.start(queue: .main)
            self.handle(connection: connection)
        }
        
        listener.start(queue: .main)
        print("Static file server started at http://localhost:\(port)/ serving: \(rootDirectory.path)")
    }
    
    private func handle(connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) { data, _, isComplete, error in
            guard let data = data, !data.isEmpty,
                  let requestString = String(data: data, encoding: .utf8) else {
                connection.cancel()
                return
            }
            // Parse HTTP request line
            guard let path = requestString.split(separator: " ").dropFirst().first else {
                connection.cancel()
                return
            }
            let safePath = String(path).removingPercentEncoding ?? String(path)
            let fullPath = self.rootDirectory.appendingPathComponent(String(safePath.drop(while: { $0 == "/" })))

            let fileData: Data?
            if FileManager.default.fileExists(atPath: fullPath.path),
                let data = try? Data(contentsOf: fullPath) {
                fileData = data
            } else {
                fileData = nil
            }

            var response = ""
            if let data = fileData {
                response += "HTTP/1.1 200 OK\r\n"
                response += "Content-Length: \(data.count)\r\n"
                response += "Content-Type: \(self.mimeType(for: fullPath))\r\n"
                response += "\r\n"
                connection.send(content: response.data(using: .utf8)! + data, completion: .contentProcessed({ _ in
                    connection.cancel()
                }))
            } else {
                let body = "File not found: \(fullPath.lastPathComponent)"
                response += "HTTP/1.1 404 Not Found\r\nContent-Length: \(body.count)\r\nContent-Type: text/plain\r\n\r\n\(body)"
                connection.send(content: response.data(using: .utf8), completion: .contentProcessed({ _ in
                    connection.cancel()
                }))
            }
        }
    }
    
    private func mimeType(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        switch ext {
            case "html", "htm": return "text/html"
            case "js": return "application/javascript"
            case "css": return "text/css"
            case "json": return "application/json"
            case "png": return "image/png"
            case "jpg", "jpeg": return "image/jpeg"
            case "gif": return "image/gif"
            case "svg": return "image/svg+xml"
            default: return "application/octet-stream"
        }
    }
}
