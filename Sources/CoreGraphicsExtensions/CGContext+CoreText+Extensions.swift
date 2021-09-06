//
//  CGContext+CoreTextHelpers.swift
//  CoreGraphicsExtensions
//
//  Created by Ben Spratling on 4/22/20.
//  Copyright © 2020 Sing Accord LLC. All rights reserved.
//

import Foundation
import CoreText
import CoreGraphics


extension CGContext {
	///conveniently positions the textPosition, and flips the coordinte system, cleans up after itself with restoreGState() when done
	public func drawCTLine(_ line:CTLine, at coords:CGPoint) {
		saveGState()
		translateBy(x: coords.x, y: coords.y)
		textPosition = .zero
		//this might be wrong, maybe the context doesn't always need to be flipped?
		scaleBy(x: 1.0, y: -1.0)
		CTLineDraw(line, self)
		restoreGState()
	}
	
}



extension CTLine {
	
	public var tightBounds:TextFrame {
		let rect:CGRect = CTLineGetBoundsWithOptions(self, [.useGlyphPathBounds, .excludeTypographicLeading])
		return TextFrame(origin:CGPoint(x: rect.minX, y: 0.0), size: TextSize(width: rect.width, height: TextHeight(ascender: rect.maxY, descender: -rect.minY)))
	}
	
}

public struct TextHeight {
	public var ascender:CGFloat
	public var descender:CGFloat
	
	public init(ascender:CGFloat, descender:CGFloat){
		self.ascender = ascender
		self.descender = descender
	}
	
	public var height:CGFloat {
		return descender + ascender
	}
}


public struct TextSize {
	
	public var width:CGFloat
	public var height:TextHeight
	
	public init(width:CGFloat, height:TextHeight){
		self.width = width
		self.height = height
	}
	
	public var size:CGSize {
		return CGSize(width: width, height: height.height)
	}
	
}


//returns a TextHeight which can handle both ascenders and both descenders
public func maxTextHeight(_ lhs:TextHeight, _ rhs:TextHeight)->TextHeight {
	return TextHeight(ascender: max(lhs.ascender, rhs.ascender), descender: max(lhs.descender, rhs.descender))
}


public struct TextFrame {
	public var origin:CGPoint
	public var size:TextSize
	
	public init(origin:CGPoint, size:TextSize) {
		self.origin = origin
		self.size = size
	}
	
	//in the flipped, i.e. ios, coordinate system
	public var frame:CGRect {
		return CGRect(origin: CGPoint(x: origin.x, y: origin.y - size.height.ascender), size: size.size)
	}
	
}
