//
//  PulseAnimation.swift
//  PlomeCoreKit
//
//  Created by Loic Mazuc on 12/11/2022.
//

import QuartzCore
import UIKit

private typealias PulseAccessor = PulseLayer
private typealias PulseInit = PulseLayer
private typealias PulseSetup = PulseLayer
private typealias PulseCAAnimationDelegate = PulseLayer

public class PulseLayer: CAReplicatorLayer {
    open var isAnimating: Bool {
        return self.effect.animationKeys()?.count ?? 0 > 0
    }

    open var radius: CGFloat = 60 {
        didSet {
            let diameter: CGFloat = radius * 2
            self.effect.bounds = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            self.effect.cornerRadius = self.radius
        }
    }

    open var radiusFromValue: CGFloat = 0 {
        didSet {
            if isAnimating {
                start()
            }
        }
    }

    open var alphaFromValue: CGFloat = 0.45 {
        didSet {
            if isAnimating {
                start()
            }
        }
    }

    open var keyTimeForHalfOpacity: NSNumber = 0.2 {
        didSet {
            if isAnimating {
                start()
            }
        }
    }

    open var animationDuration: TimeInterval = 3 {
        didSet {
            self.instanceDelay = (self.animationDuration + self.pulseInterval) / Double(self.count)
        }
    }

    open var pulseInterval: TimeInterval = 0 {
        didSet {
            if pulseInterval == .infinity {
                self.effect.removeAnimation(forKey: "pulse")
            }
        }
    }

    open var useTimingFunction: Bool = true {
        didSet {
            if isAnimating {
                start()
            }
        }
    }

    open var count: NSInteger = 1 {
        didSet {
            self.instanceCount = count
            self.instanceDelay = (self.animationDuration + self.pulseInterval) / Double(count)
        }
    }

    open var startInterval: TimeInterval = 1 {
        didSet {
            self.instanceDelay = startInterval
        }
    }

    open var color: UIColor = .lightGray {
        didSet {
            effect.backgroundColor = color.cgColor
        }
    }

    let effect: CALayer = .init()

    var animationGroup: CAAnimationGroup!

    override init() {
        super.init()

        effect.contentsScale = UIScreen.main.scale
        effect.opacity = 0
        addSublayer(effect)

        setupDefaults()
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init(coder _: NSCoder) {
        super.init()
    }
}

extension PulseInit {
    convenience init(in layer: CALayer) {
        self.init()

        layer.addSublayer(self)
        frame = layer.frame
        position = layer.position
    }
}

public extension PulseAccessor {
    func start() {
        if isAnimating {
            stop()
        }

        setupAnimationGroup()
        effect.add(animationGroup!, forKey: "pulse")
    }

    func stop() {
        effect.removeAllAnimations()
    }

    override var frame: CGRect {
        didSet {
            self.effect.frame = bounds
            radius = min(frame.width, frame.height)
        }
    }

    override var repeatCount: Float {
        didSet {
            animationGroup?.repeatCount = repeatCount
        }
    }
}

public extension PulseSetup {
    func setupDefaults() {
        radiusFromValue = 0.0
        keyTimeForHalfOpacity = 0.2
        animationDuration = 3
        pulseInterval = 0
        useTimingFunction = true

        repeatCount = .infinity
        radius = 60
        count = 1
        startInterval = 1
        color = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: alphaFromValue)
    }

    func setupAnimationGroup() {
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration + pulseInterval
        animationGroup.repeatCount = repeatCount

        if useTimingFunction {
            let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
            animationGroup.timingFunction = defaultCurve
        }

        let animations: [CAAnimation] = [scale(), opacityAnimation()]

        animationGroup.animations = animations

        animationGroup.delegate = self
    }

    private func scale() -> CAAnimation {
        let anim = CABasicAnimation(keyPath: "transform.scale.xy")

        anim.fromValue = radiusFromValue
        anim.toValue = 1.0
        anim.duration = animationDuration

        return anim
    }

    private func opacityAnimation() -> CAAnimation {
        let anim = CAKeyframeAnimation(keyPath: "opacity")
        anim.duration = animationDuration

        let alphaFromValue = color.cgColor.alpha
        anim.values = [alphaFromValue, alphaFromValue * 0.5, 0]
        anim.keyTimes = [0, keyTimeForHalfOpacity, 1.0]

        return anim
    }
}

extension PulseCAAnimationDelegate: CAAnimationDelegate {
    public func animationDidStop(_: CAAnimation, finished _: Bool) {}
}
