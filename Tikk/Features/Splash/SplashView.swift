//
//  SplashView.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import Lottie
import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    var body: some View {
        LottieView(animation: .named(Asset.Animation.splashScreen))
            .playing()
            .animationDidFinish { _ in
                onFinished()
            }
    }
}
