//
//  Line.swift
//  SingMusic
//
//  Created by Ben Spratling on 4/30/16.
//
//

import Foundation
import CoreGraphics


public struct Line {
	public var point0:CGPoint
	public var point1:CGPoint
	
	public init(point0:CGPoint, point1:CGPoint) {
		self.point0 = point0
		self.point1 = point1
	}
	
	public func pointAtFraction(_ fraction:CGFloat)->CGPoint {
		let diff:CGPoint = point1 - point0
		let scaledDiff:CGPoint = diff * fraction
		return point0 + scaledDiff
	}
	
	public var length:CGFloat {
		let diff:CGPoint = point1 - point0
		return sqrt((diff.x * diff.x) + (diff.y * diff.y))
	}
	
	public func intersectionWithLine(_ otherLine:Line)->CGPoint? {
		//If slopes are equal, but not coincident, there is no intersection
		//since the intended application is looking for generally perpendicular lines, this math case is not considered
		let u:CGPoint = CGPoint(x:point1.x - point0.x, y:point1.y - point0.y)
		let v:CGPoint = CGPoint(x:otherLine.point1.x - otherLine.point0.x, y:otherLine.point1.y - otherLine.point0.y)
		let w:CGPoint = CGPoint(x:point0.x - otherLine.point0.x, y:point0.y - otherLine.point0.y)
		
		let scalar:CGFloat = (((v.y)*(w.x)) - ((v.x)*(w.y))) / (((v.x)*(u.y)) - ((v.y)*(u.x)))
		
		return pointAtFraction(scalar)
	}
}

/// Computes the intersection
public func &&(line0:Line, line1:Line)->CGPoint? {
	return line0.intersectionWithLine(line1)
}

