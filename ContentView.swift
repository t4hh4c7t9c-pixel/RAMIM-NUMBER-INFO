import SwiftUI

struct NumberResult: Identifiable, Codable {
    var id = UUID()
    let number: String
    let country: String
    let callingCode: String
    let checkedAt: Date
}

struct ContentView: View {
    @State private var phoneNumber = ""
    @State private var result: NumberResult?
    @State private var message = ""
    @State private var history: [NumberResult] = []
    private let green = Color(red: 0.0, green: 1.0, blue: 0.34)

    private let countries: [(name: String, code: String)] = [
        ("Bangladesh", "+880"), ("India", "+91"), ("United States / Canada", "+1"),
        ("United Kingdom", "+44"), ("Australia", "+61"), ("Pakistan", "+92"),
        ("Saudi Arabia", "+966"), ("United Arab Emirates", "+971"),
        ("Malaysia", "+60"), ("Singapore", "+65"), ("Nepal", "+977"),
        ("Sri Lanka", "+94"), ("Indonesia", "+62"), ("Turkey", "+90"),
        ("Germany", "+49"), ("France", "+33"), ("Japan", "+81")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 18) {
                    header

                    VStack(alignment: .leading, spacing: 14) {
                        Label("PHONE NUMBER", systemImage: "phone.fill")
                            .font(.caption.bold())
                            .foregroundStyle(green)

                        TextField("+8801XXXXXXXXX", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textInputAutocapitalization(.never)
                            .padding(16)
                            .background(Color.white.opacity(0.06))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(green.opacity(0.45)))
                            .foregroundStyle(.white)

                        Button(action: checkNumber) {
                            Label("CHECK NUMBER", systemImage: "magnifyingglass")
                                .font(.headline.bold())
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .background(green)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(18)
                    .background(Color(red: 0.025, green: 0.07, blue: 0.06))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(green.opacity(0.25)))

                    if !message.isEmpty {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(message.hasPrefix("Please") ? .orange : green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if let result {
                        resultCard(result)
                    }

                    if !history.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("RECENT SEARCHES")
                                .font(.headline.bold())
                                .foregroundStyle(green)
                            ForEach(history.prefix(5)) { item in
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundStyle(green)
                                    VStack(alignment: .leading) {
                                        Text(item.number).foregroundStyle(.white)
                                        Text("\(item.country) • \(item.callingCode)")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }

                    VStack(spacing: 6) {
                        Text("Country calling-code lookup")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        Text("Credit : RAMIM X CHEAT")
                            .font(.footnote.bold())
                            .foregroundStyle(green)
                    }
                    .padding(.top, 8)
                }
                .padding(18)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 34))
                .foregroundStyle(green)
                .shadow(color: green.opacity(0.8), radius: 12)
            Text("RAMIM")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)
            Text("NUMBER INFO")
                .font(.system(size: 20, weight: .heavy, design: .rounded))
                .foregroundStyle(green)
            Text("WORLDWIDE NUMBER DETAILS")
                .font(.caption2.weight(.semibold))
                .tracking(2)
                .foregroundStyle(.gray)
        }
        .padding(.vertical, 10)
    }

    private func resultCard(_ item: NumberResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("NUMBER INFO", systemImage: "checkmark.seal.fill")
                .font(.headline.bold())
                .foregroundStyle(green)
            infoRow("Phone number", item.number)
            infoRow("Country", item.country)
            infoRow("Calling code", item.callingCode)
            Divider().overlay(green.opacity(0.3))
            Text("Operator details are not reliably available from a phone number alone. Add a legitimate carrier-lookup API if you need this feature.")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.025, green: 0.07, blue: 0.06))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(green.opacity(0.35)))
    }

    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(.gray)
            Spacer()
            Text(value).foregroundStyle(.white).multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func checkNumber() {
        let cleaned = phoneNumber.filter { $0.isNumber || $0 == "+" }
        guard cleaned.count >= 7 else {
            result = nil
            message = "Please enter a valid-looking phone number."
            return
        }

        let match = countries
            .filter { cleaned.hasPrefix($0.code) }
            .max { $0.code.count < $1.code.count }

        let country = match?.name ?? "Unknown country"
        let code = match?.code ?? "Not identified"
        let item = NumberResult(number: cleaned, country: country, callingCode: code, checkedAt: Date())
        result = item
        message = ""
        history.removeAll { $0.number == cleaned }
        history.insert(item, at: 0)
    }
}

#Preview {
    ContentView()
}
