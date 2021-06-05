//
//  CGRect+Extensions.swift
//  SingMusic
//
//  Created by Ben Spratling on 4/30/16.
//
//

import Foundation
import CoreGraphics

extension CGRect {
	
	public var center:CGPoint {
		return CGPoint(x: origin.x + (size.width/2.0)
			, y: origin.y + (size.height/2.0))
	}
	
	//returns the origin of another rect with the same size as this one, with a different center
	public func originForCenter(_ center:CGPoint)->CGPoint {
		return size.originForCenter(center)
	}
	
	public init(size:CGSize, center:CGPoint) {
		self.init(origin:size.originForCenter(center), size:size)
	}
	
	/// rescales a rect to fit a given size at its current center
	public func rectFittingSize(_ superSize:CGSize)->(rect:CGRect, scale:CGFloat) {
		let (fittingSize, fittingScale) = size.size(fitting:superSize)
		return (rect:CGRect(size: fittingSize, center: center)
		, scale:fittingScale)
	}
	
	
	/// rescales a rect to fill a given size at its current center
	public func rectFillingSize(_ superSize:CGSize)->(rect:CGRect, scale:CGFloat) {
		let (fillingSize, fillingScale) = size.sizeFillingSize(superSize)
		return (rect:CGRect(size: fillingSize, center: center)
			, scale:fillingScale)
	}
	
	
	public func rectFittingRect(_ superRect:CGRect)->(rect:CGRect, scale:CGFloat) {
		let (fittingSize, fittingScale) = size.size(fitting:superRect.size)
		return (rect:CGRect(size: fittingSize, center: superRect.center)
			, scale:fittingScale)
	}
	
	
	public func rect(filling superRect:CGRect)->(rect:CGRect, scale:CGFloat) {
		let (fillingSize, fillingScale) = size.sizeFillingSize(superRect.size)
		return (rect:CGRect(size: fillingSize, center: superRect.center)
			, scale:fillingScale)
	}
	
	
	
	/// Returns a scaled version of self, which has been scaled such that the `interestArea` fits inside `fitting`
	/// `interestArea` is provided relative to self's origin, however, `scaledInterest` is relative to same frame as `fitting`, instead of to the returned `rect`.
	///The algorithm will attempt to center the interest area within the available space, but will translate the interest area within the fitting in an effort to fill the fitting with the larger rect.
	//TODO: for high professionalism, re-do with support for margins
	public func rect(fitting superRect:CGRect, interestArea:CGRect)->(rect:CGRect, scaledInterest:CGRect, scale:CGFloat) {
		//find the new scale we need for interest area
		let (scaledInterestSize, scale):(CGSize, CGFloat) = interestArea.size.size(fitting: superRect.size)
		
		let scaledInterestOffset:CGPoint = interestArea.origin * scale
		
		//now determine if the receiver covers the superRect in this mode, so that we can center the interest area in the superRect
		let scaledSize:CGSize = size * scale
		
		//this anonymous function returns the offset of the full rect relative to the viewport rect
		// viewport = the width or height of the superRect,
		// full = the width or height of the receiver as scaled
		// interest = the width or hight of the scaled interest area
		// interest offset = the offset of the interest area within the full rect
		let aligner = { (_ viewport:CGFloat, _ full:CGFloat, _ interest:CGFloat, _ interestOffset:CGFloat)->(CGFloat) in
			if full <= viewport {
				return (viewport - full)/2.0
			}
			let halfOfNeededSpace:CGFloat = (viewport - interest)/2.0
			if interestOffset < halfOfNeededSpace {
				//align the left edge of full with the viewport
				return 0.0
			} else if full - interest - interestOffset < halfOfNeededSpace {
				//align the right edge of the full with the viewpot
				return viewport - full
			} else {
				//plenty of space, center the intrest area
				return (viewport - interest)/2.0 - interestOffset
			}
		}
		
		let fullX: CGFloat = aligner(superRect.size.width, scaledSize.width, scaledInterestSize.width, scaledInterestOffset.x)
		let fullY:CGFloat = aligner(superRect.size.height, scaledSize.height, scaledInterestSize.height, scaledInterestOffset.y)
		
		let receiverFinal:CGRect = CGRect(origin:/* superRect.origin +*/
			CGPoint(x:fullX, y:fullY)
			,size: scaledSize)
		
		return (rect:receiverFinal, scaledInterest:CGRect(origin:scaledInterestOffset + receiverFinal.origin + superRect.origin, size:scaledInterestSize), scale:scale)
	}
	
	
	public static func -(lhs:CGRect, rhs:CGPoint)->CGRect {
		return CGRect(origin: lhs.origin - rhs, size: lhs.size)
	}
	
	
}



///union of 2 rects
public func ||(lhs:CGRect, rhs:CGRect)->CGRect {
	let origin:CGPoint = CGPoint(x: min(lhs.minX, rhs.minX), y: min(lhs.minY, rhs.minY))
	let width:CGFloat = max(lhs.maxX, rhs.maxX) - origin.x
	let height:CGFloat = max(lhs.maxY, rhs.maxY) - origin.y
	return CGRect(x:origin.x, y:origin.y, width: width, height: height)
}



/// returns lhs as normalized within rhs
public func /(lhs:CGRect, rhs:CGRect)->CGRect {
	let scale:CGSize = lhs.size / rhs.size
	return CGRect(origin: (lhs.origin-rhs.origin)/scale, size:scale)
}


public func *(lhs:CGSize, rhs:CGRect)->CGRect {
	return CGRect(origin:lhs * rhs.origin, size:lhs * rhs.size)
}


extension CGRect {
	
	public enum Rounding {
		case nearest, outside, inside
	}
	
	public func rounded(rounding:Rounding = .nearest)->CGRect {
		switch rounding {
		case .nearest:
			let newMinX = origin.x.rounded(.toNearestOrEven)
			let newMaxX = maxX.rounded(.toNearestOrEven)
			let newMinY = origin.y.rounded(.toNearestOrEven)
			let newMaxY = maxY.rounded(.toNearestOrEven)
			return CGRect(origin: CGPoint(x:newMinX, y:newMinY), size: CGSize(width:newMaxX-newMinX, height:newMaxY-newMinY))
		case .outside:
			let newMinX = origin.x.rounded(.down)
			let newMaxX = maxX.rounded(.up)
			let newMinY = origin.y.rounded(.down)
			let newMaxY = maxY.rounded(.up)
			return CGRect(origin: CGPoint(x:newMinX, y:newMinY), size: CGSize(width:newMaxX-newMinX, height:newMaxY-newMinY))
		case .inside:
			let newMinX = origin.x.rounded(.up)
			let newMaxX = maxX.rounded(.down)
			let newMinY = origin.y.rounded(.up)
			let newMaxY = maxY.rounded(.down)
			return CGRect(origin: CGPoint(x:newMinX, y:newMinY), size: CGSize(width:newMaxX-newMinX, height:newMaxY-newMinY))
		}
	}
}

