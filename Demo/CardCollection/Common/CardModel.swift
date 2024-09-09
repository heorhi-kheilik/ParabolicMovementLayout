//
//  CardModel.swift
//  CardCollection
//
//  Created by Heorhi Heilik on 8.09.24.
//

struct CardModel {
    let number: String
    let name: String
    let gradientType: GradientProvider.GradientType
}

extension CardModel {
    static let cards = [
        CardModel(number: "4220 **** **** 0000", name: "Debit", gradientType: .pink),
        CardModel(number: "4778 **** **** 0001", name: "Savings", gradientType: .green),
        CardModel(number: "5430 **** **** 0002", name: "Credit", gradientType: .orange),
        CardModel(number: "4825 **** **** 0003", name: "Investments", gradientType: .blue),
        CardModel(number: "5375 **** **** 0004", name: "Savings", gradientType: .green),
        CardModel(number: "4878 **** **** 0005", name: "Debit", gradientType: .pink),
        CardModel(number: "4294 **** **** 0006", name: "Credit", gradientType: .orange),
        CardModel(number: "4886 **** **** 0007", name: "Investments", gradientType: .blue),
        CardModel(number: "5319 **** **** 0008", name: "Debit", gradientType: .pink),
        CardModel(number: "5367 **** **** 0009", name: "Savings", gradientType: .green),
        CardModel(number: "4511 **** **** 0010", name: "Credit", gradientType: .orange),
        CardModel(number: "5235 **** **** 0011", name: "Savings", gradientType: .green),
        CardModel(number: "5909 **** **** 0012", name: "Investments", gradientType: .blue),
        CardModel(number: "4006 **** **** 0013", name: "Credit", gradientType: .orange),
        CardModel(number: "5811 **** **** 0014", name: "Investments", gradientType: .blue),
        CardModel(number: "4859 **** **** 0015", name: "Debit", gradientType: .pink),
        CardModel(number: "5991 **** **** 0016", name: "Savings", gradientType: .green),
        CardModel(number: "5234 **** **** 0017", name: "Debit", gradientType: .pink),
        CardModel(number: "4987 **** **** 0018", name: "Savings", gradientType: .green),
        CardModel(number: "4020 **** **** 0019", name: "Credit", gradientType: .orange)
    ]
}
