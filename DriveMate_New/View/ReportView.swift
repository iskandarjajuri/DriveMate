import SwiftUI

struct ReportsView: View {
    let reports: [DriverReport] // ✅ Tambahkan parameter ini agar tidak error

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Laporan Driver").font(.headline)) {
                    ForEach(reports) { report in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(report.driverName)
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            HStack {
                                Label("Kebersihan:", systemImage: "sparkles")
                                Spacer()
                                Text(report.cleanliness)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Label("Komitmen Safety:", systemImage: "shield.lefthalf.filled")
                                Spacer()
                                Text(report.safetyCommitment)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Label("Kondisi Kesehatan:", systemImage: "heart.fill")
                                Spacer()
                                Text(report.healthCondition)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Label("Jam Kerja:", systemImage: "clock.fill")
                                Spacer()
                                Text(report.workingHours)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Reports")
        }
    }
}

// **Model untuk laporan driver**
struct DriverReport: Identifiable {
    let id = UUID()
    let driverName: String
    let cleanliness: String
    let safetyCommitment: String
    let healthCondition: String
    let workingHours: String
}

// **Preview**
struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ReportsView(reports: [
            DriverReport(driverName: "Driver 1", cleanliness: "Baik", safetyCommitment: "Ya", healthCondition: "Sehat", workingHours: "08:00 - 17:00")
        ])
    }
}
