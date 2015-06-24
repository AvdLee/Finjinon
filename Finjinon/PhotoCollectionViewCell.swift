//
//  PhotoCollectionViewCell.swift
//  Finjinon
//
//  Created by Sørensen, Johan on 22.06.15.
//  Copyright (c) 2015 FINN.no AS. All rights reserved.
//

import UIKit

internal protocol PhotoCollectionViewCellDelegate: NSObjectProtocol {
    func collectionViewCellDidTapDelete(cell: PhotoCollectionViewCell)
}


internal class PhotoCollectionViewCell: UICollectionViewCell {
    weak var delegate: PhotoCollectionViewCellDelegate?
    let imageView = UIImageView(frame: CGRect.zeroRect)
    let closeButton = CloseButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    var asset: Asset?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let offset = self.closeButton.bounds.height/3
        imageView.frame = CGRect(x: offset, y: offset, width: contentView.bounds.width - (offset*2), height: contentView.bounds.height - (offset*2))
        imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        imageView.layer.shouldRasterize = true // to avoid jaggies while we wiggle
        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        contentView.addSubview(imageView)

        closeButton.addTarget(self, action: Selector("closeButtonTapped:"), forControlEvents: .TouchUpInside)
        contentView.addSubview(closeButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func prepareForReuse() {
        super.prepareForReuse()

        delegate = nil
        asset = nil
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let delta = (44 - closeButton.bounds.width) / 2
        let expandedRect = closeButton.frame.rectByInsetting(dx: -delta, dy: -delta)
        let viewIsVisible = !closeButton.hidden && closeButton.alpha > 0.01
        if viewIsVisible && delta > 0 && expandedRect.contains(point) {
            return closeButton
        }

        return super.hitTest(point, withEvent: event)
    }

    func closeButtonTapped(sender: UIButton) {
        delegate?.collectionViewCellDidTapDelete(self)
    }
}