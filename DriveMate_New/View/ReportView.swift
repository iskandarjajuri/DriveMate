import SwiftUI
import Foundation

struct ReportsView: View {
    let reports: [DriverReport]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(reports) { report in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                Text(report.driverName)
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(.primary)
                                Spacer()
                            }

                            Divider()

                            ReportRow(icon: "sparkles", label: "Kebersihan", value: report.cleanliness, color: .orange)
                            ReportRow(icon: "shield.lefthalf.filled", label: "Komitmen Safety", value: report.safetyCommitment, color: .green)
                            ReportRow(icon: "heart.fill", label: "Kondisi Kesehatan", value: report.healthCondition, color: .red)
                            ReportRow(icon: "clock.fill", label: "Jam Kerja", value: report.workingHours, color: .purple)
                        }
                        .padding()
                        .background(
                            Color.white.opacity(0.9)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Reports")
        }
    }
}

struct ReportRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Label {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(color)
            }
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
        }
    }
}
// MARK: - Preview
struct ReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReportsView(reports: sampleReports)
                .preferredColorScheme(.light) // atau .dark untuk melihat versi gelap
        }
    }
}

