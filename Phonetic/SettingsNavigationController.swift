//
//  SettingsNavigationController.swift
//  Phonetic
//
//  Created by Augus on 2/15/16.
//  Copyright © 2016 iAugus. All rights reserved.
//

import UIKit
import Device
import SnapKit


let kNavigationBarBackgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)

class SettingsNavigationController: UINavigationController {

    let _font      = UIFont.systemFont(ofSize: 17.0)
    let _textColor = UIColor.white

    var customBarButton: UIButton!
    fileprivate(set) var customTitleLabel: UILabel!
    fileprivate var customNavBar: UIView!
    
    fileprivate var shouldHideCustomBarButton: Bool {
        // iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        
        // 6(s) Plus or larger iPhones in the future (maybe).
        if Device.isLargerThanScreenSize(Size.screen4_7Inch) {
            return UIDevice.current.orientation.isLandscape
        }
        
        return false
    }
    
    fileprivate var hideCustomBarButton = false {
        didSet {
            customBarButton?.isHidden = hideCustomBarButton
        }
    }

    override func loadView() {
        super.loadView()
        completelyTransparentBar()
        navigationBar.backgroundColor = kNavigationBarBackgroundColor
        navigationBar.tintColor = GLOBAL_CUSTOM_COLOR.darkerColor(0.9)
        
        configureCustomNavBar()
        configureCustomBarButtonIfNeeded()
        configureCustomTitleLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCustomBarButtonIfNeeded() {
        
        guard customBarButton == nil else { return }
        
        customBarButton = UIButton(type: .custom)
        customBarButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
        customBarButton.tintColor   = UIColor.white
        customBarButton.contentMode = .center
        customBarButton.addTarget(self, action: #selector(customBarButtonDidTap), for: .touchUpInside)
        
        view.addSubview(customBarButton)
        customBarButton.snp.remakeConstraints { (make) in
            make.width.height.equalTo(25)
            make.centerY.equalTo(navigationBar)
            make.left.equalTo(8)
        }
        
        hideCustomBarButton = shouldHideCustomBarButton
    }
    
    @objc fileprivate func customBarButtonDidTap() {
        if let vc = viewControllers.first as? BaseTableViewController {
            vc.dismissViewController(completion: nil)
        }
    }
    
    fileprivate func configureCustomNavBar() {
        
        guard !UIDevice.isPad else { return }
        
        customNavBar = UIView()
        customNavBar.backgroundColor = kNavigationBarBackgroundColor
        customNavBar.isUserInteractionEnabled = false
        navigationBar.addSubview(customNavBar)
        customNavBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(navigationBar)
            make.top.equalTo(view)
        }
    }
    
    fileprivate func configureCustomTitleLabel() {
        
        customTitleLabel               = UILabel()
        customTitleLabel.textAlignment = .center
        customTitleLabel.textColor     = _textColor
        customTitleLabel.font          = _font
        customTitleLabel.sizeToFit()
        navigationBar.addSubview(customTitleLabel)
        customTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }

}

extension SettingsNavigationController {
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        // Optimized for 6(s) Plus
        if Device.isEqualToScreenSize(Size.screen5_5Inch) {
            hideCustomBarButton = toInterfaceOrientation.isLandscape
        }
    }
}
