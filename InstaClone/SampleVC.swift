//
//  SampleVC.swift
//  InstaClone
//
//  Created Phat Pham on 19/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by phthphat
//

import UIKit

class SampleVC: UIViewController {

	override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .yellow
    }

}


#if DEBUG
import SwiftUI
struct PresentableSampleVC: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SampleVC {
		let vc = SampleVC()
		return vc 
    }
    func updateUIViewController(_ uiViewController: SampleVC, context: Context) { }
}
struct SampleVCPreview: PreviewProvider {
    static var previews: some View {
        return PresentableSampleVC()
    }
}
#endif
