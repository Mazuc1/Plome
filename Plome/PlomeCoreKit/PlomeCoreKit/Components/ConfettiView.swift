//
//  ConfettiView.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 14/11/2022.
//

import QuartzCore
import UIKit

public class ConfettiView: UIView {
    // MARK: - Properties

    private var emitter: CAEmitterLayer!
    public var colors: [UIColor]
    public var intensity: Float
    private var active: Bool

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        intensity = 0.5
        colors = [UIColor(red: 0.95, green: 0.40, blue: 0.27, alpha: 1.0),
                  UIColor(red: 1.00, green: 0.78, blue: 0.36, alpha: 1.0),
                  UIColor(red: 0.48, green: 0.78, blue: 0.64, alpha: 1.0),
                  UIColor(red: 0.30, green: 0.76, blue: 0.85, alpha: 1.0),
                  UIColor(red: 0.58, green: 0.39, blue: 0.55, alpha: 1.0)]
        active = false
        super.init(coder: aDecoder)
    }

    public required init(frame: CGRect, intensity: Float = 0.5, colors: [UIColor]) {
        self.colors = colors
        self.intensity = intensity
        active = false
        super.init(frame: frame)
    }

    // MARK: - Methods

    public func startConfetti() {
        emitter = CAEmitterLayer()

        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        emitter.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }

        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }

    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    private func imageForType() -> UIImage? {
        guard let path = Module.bundle.path(forResource: "confetti", ofType: "png") else { return nil }

        let url = URL(fileURLWithPath: path)

        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }

        return nil
    }

    private func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType()?.cgImage
        return confetti
    }

    public func isActive() -> Bool {
        return active
    }
}
