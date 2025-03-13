import Foundation
import Foundation

class ReportDownloader {
    
    /// Menghasilkan file CSV sederhana dari laporan pengemudi.
    /// - Parameter reports: Array objek `DriverReport`.
    /// - Returns: URL file CSV yang dihasilkan, atau `nil` jika gagal.
    static func generateCSV(for reports: [DriverReport]) -> URL? {
        let fileName = "DriverReports.csv"
        
        // Path folder Downloads
        guard let downloadsURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
            print("❌ Gagal menemukan folder Downloads.")
            return nil
        }
        let fileURL = downloadsURL.appendingPathComponent(fileName)
        
        var csvText = "Nama Pengemudi,Kebersihan,Komitmen Keselamatan,Kesehatan,Jam Kerja\n"
        
        for report in reports {
            let row = "\(report.driverName),\(report.cleanliness),\(report.safetyCommitment),\(report.healthCondition),\(report.workingHours)\n"
            csvText += row
        }
        
        do {
            try csvText.write(to: fileURL, atomically: true, encoding: .utf8)
            print("✅ CSV berhasil disimpan di \(fileURL.path)")
            return fileURL
        } catch {
            print("❌ Gagal menyimpan CSV: \(error)")
            return nil
        }
    }
}
