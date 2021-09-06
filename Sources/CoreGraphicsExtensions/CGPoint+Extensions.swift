//
//  CGPointExtensions.swift
//  SingMusic
//
//  Created by Ben Spratling on 4/30/16.
//
//

import Foundation
import CoreGraphics


public func +(lhs:CGPoint, rhs:CGPoint)->CGPoint {
	return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func +=(lhs:inout CGPoint, rhs:CGPoint) {
	lhs = lhs + rhs
}

public func -(lhs:CGPoint, rhs:CGPoint)->CGPoint {
	return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -=(lhs:inout CGPoint, rhs:CGPoint) {
	lhs = lhs - rhs
}

public prefix func -(lhs:CGPoint)->CGPoint {
	return CGPoint(x: -lhs.x, y: -lhs.y)
}

public func +(lhs:CGPoint, rhs:CGSize)->CGPoint {
	return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
}

public func -(lhs:CGPoint, rhs:CGSize)->CGPoint {
	return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
}

public func *(lhs:CGPoint, rhs:CGFloat)->CGPoint {
	return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func *(lhs:CGPoint, rhs:CGSize)->CGPoint {
	return CGPoint(x: lhs.x * rhs.width, y: lhs.y * rhs.height)
}

public func /(lhs:CGPoint, rhs:CGSize)->CGPoint {
	return CGPoint(x: lhs.x / rhs.width, y: lhs.y / rhs.height)
}

public func /(lhs:CGPoint, rhs:CGFloat)->CGPoint {
	return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}


extension CGPoint {
	public init(_ size:CGSize) {
		self.init(x: size.width, y: size.height)
	}
}
