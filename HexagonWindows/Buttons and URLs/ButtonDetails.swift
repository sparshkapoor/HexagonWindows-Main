//
//  ButtonDetails.swift
//  HexagonWindows
//
//  Created by Sparsh Kapoor on 5/29/24.
//


import Foundation

struct ButtonDetails {
    let url: URL
    let title: String
    let imageName: String
    
}

let page1Buttons = [
    ButtonDetails(url: urlsPage1[0], title: "example", imageName: "image5"),
    ButtonDetails(url: urlsPage1[1], title: "Example 2", imageName: "image6"),
    ButtonDetails(url: urlsPage1[2], title: "Example 3", imageName: "image7"),
    ButtonDetails(url: urlsPage1[3], title: "Example 4", imageName: "image8")
]

let page2Buttons = [
     /// Top Left
     ButtonDetails(url: urlsPage2[0], title: "Members", imageName: "Directory"),
     /// Top Right
    ButtonDetails(url: urlsPage2[1], title: "Communications", imageName: "Equipment"),
     /// Bottom Left
    ButtonDetails(url: urlsPage2[2], title: "Dashboard View", imageName: "Dashboard"),
     /// Bottom Right
    ButtonDetails(url: urlsPage2[3], title: "Unit View", imageName: "Unit")
]

let page3Buttons = [
    ButtonDetails(url: urlsPage3[0], title: "Example 5", imageName: "image9"),
    ButtonDetails(url: urlsPage3[1], title: "Example 6", imageName: "image10"),
    ButtonDetails(url: urlsPage3[2], title: "Example 7", imageName: "image11"),
    ButtonDetails(url: urlsPage3[3], title: "Example 8", imageName: "image12")
]
