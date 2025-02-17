//
//  SplashScreen.swift
//  Tikk
//
//  Created by Theodor Holmen Bjørnstad on 17/02/2025.
//

import Lottie
import SwiftUI

struct SplashScreen: View {

    let oAnimationDidFinish: () -> Void

    var body: some View {
        LottieView(animation: .named(Asset.Animation.splashScreen))
            .playing()
            .animationDidFinish { _ in
                oAnimationDidFinish()
            }
    }
}
