//
//  CGSize+Extensions.swift
//  SingMusic
//
//  Created by Ben Spratling on 4/30/16.
//
//

import Foundation
import CoreGraphics


extension CGSize {
	public init(square:CGFloat) {
		self.init(width:square, height:square)
	}
	
	/// returns the origin of a rect of the reciever's size and the given center
	public func originForCenter(_ center:CGPoint)->CGPoint {
		return CGPoint(x: center.x - (width/2.0), y: center.y - (height/2.0))
	}
	
	/// returns a size with the same aspect ratio as the reciever which fits in the given size, also returns the scale factor
	public func size(fitting superSize:CGSize)->(size:CGSize, scale:CGFloat) {
		let superAspectRatio:CGFloat = superSize.height / superSize.width
		let smallApectRatio:CGFloat = height/width
		let scale:CGFloat
		if superAspectRatio > smallApectRatio {
			scale = superSize.width / width
		} else {
			scale = superSize.height / height
		}
		return (size:self * scale, scale:scale)
	}
	
	
	/// returns a size with the same aspect ratio as the reciever which fills in the given size, also returns the scale factor
	public func sizeFillingSize(_ superSize:CGSize)->(size:CGSize, scale:CGFloat) {
		let superAspectRatio:CGFloat = superSize.height / superSize.width
		let smallApectRatio:CGFloat = height/width
		let scale:CGFloat
		if superAspectRatio < smallApectRatio {
			scale = superSize.width / width
		} else {
			scale = superSize.height / height
		}
		return (size:self * scale, scale:scale)
	}
	
	public static func /(lhs:CGSize, rhs:CGFloat)->CGSize {
		return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
	}
}

public func +(lhs:CGSize, rhs:CGSize)->CGSize {
	return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
}

public func -(lhs:CGSize, rhs:CGSize)->CGSize {
	return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
}

public func -=(lhs:inout CGSize, rhs:CGSize) {
	lhs.width -= rhs.width
	lhs.height -= rhs.height
}

public func *(lhs:CGSize, rhs:CGFloat)->CGSize {
	return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
}

public func *(lhs:CGSize, rhs:CGSize)->CGSize {
	return CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
}


public func /(lhs:CGSize, rhs:CGSize)->CGSize {
	return CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
}

public func *(lhs:CGSize, rhs:CGPoint)->CGPoint {
	return CGPoint(x: lhs.width * rhs.x, y: lhs.height * rhs.y)
}

