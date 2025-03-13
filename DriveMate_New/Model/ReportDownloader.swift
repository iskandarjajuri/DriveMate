import Foundation
import SwiftUI

class ReportDownloader {
    
    /// Menghasilkan file CSV sederhana dari laporan pengemudi.
    /// - Parameters:
    ///   - reports: Array objek `DriverReport`.
    ///   - completion: Closure untuk mengirimkan URL jika sukses, atau error jika gagal.
    static func generateCSV(for reports: [DriverReport], completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let fileName = "DriverReports.csv"
            
            #if os(macOS)
            let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
            #else
            let downloadsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            #endif
            
            guard let saveURL = downloadsURL else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Folder tidak ditemukan.", code: 1)))
                }
                return
            }
            
            let fileURL = saveURL.appendingPathComponent(fileName)
            
            var csvText = "Nama Pengemudi,Kebersihan,Komitmen Keselamatan,Kesehatan,Jam Kerja\n"
            
            for report in reports {
                let row = "\(report.driverName),\(report.cleanliness),\(report.safetyCommitment),\(report.healthCondition),\(report.workingHours)\n"
                csvText += row
            }
            
            do {
                try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    completion(.success(fileURL))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
