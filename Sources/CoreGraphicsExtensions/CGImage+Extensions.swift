//
//  CGImage+Extensions.swift
//  SingMusic
//
//  Created by Ben Spratling on 8/25/16.
//
//

import Foundation
import CoreGraphics
/**
	context -> image <- Data <- URL
*/

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
	import UIKit
#elseif os(macOS)
	import Cocoa
#endif

enum ImageFileType : String {
	case png
	case jpg, jpeg
}

extension CGImage {
	
	public static func create(withJPEGData jpegData:Data)->CGImage? {
		guard let provider = CGDataProvider(data: jpegData as CFData) else { return nil }
		return CGImage(jpegDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
	}
	
	public static func create(withPNGData pngData:Data)->CGImage? {
		guard let provider = CGDataProvider(data: pngData as CFData) else { return nil }
		return CGImage(pngDataProviderSource: provider, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
	}
	
	/// Can open .png, .jpg, or .jpeg determined by the file extension
	public static func create(url:URL)->CGImage? {
		guard let fileFormat:ImageFileType = ImageFileType(rawValue: url.pathExtension)
			, let data:Data = try? Data(contentsOf: url, options: [])
			else { return nil }
		switch fileFormat {
		case .png:
			return create(withPNGData:data)
		case .jpg, .jpeg:
			return create(withJPEGData:data)
		}
	}
	
	public var size:CGSize {
		return CGSize(width: self.width, height: self.height)
	}
	
}


public enum ImageDrawingFlipping {
	case uiKit, macOS, always, never
}


extension CGImage {
	/**
	A convenience to create images from drawing instructions in a context
	*/
	public class func make(size:CGSize, scale:CGFloat, flip:ImageDrawingFlipping = .uiKit, drawing:(CGContext)->())->CGImage {
		#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
			UIGraphicsBeginImageContextWithOptions(size, false, scale)
			let bitmapContext:CGContext = UIGraphicsGetCurrentContext()!
			if flip == .never || flip == .macOS {
				//on ios, UIGraphicsBeginImageContextWithOptions creates a flipped coordinate system, so you only need to un-flip it if it shouldn't be flipped
				bitmapContext.translateBy(x: 0.0, y: size.height)
				bitmapContext.scaleBy(x: 1.0, y: -1.0)
			}
		#elseif os(macOS)
			
			//let imageRep:NSBitmapImageRep = view.bitmapImageRepForCachingDisplayInRect(CGRect(x:0, y:0, width:size.width, height:size.height))
			//let context:NSGraphicsContext = NSGraphicsContext.graphicsContextWithBitmapImageRep(imageRep)
			let pixelsWide:Int = Int((size.width * scale).rounded())
			let pixelsHigh:Int = max(Int((size.height * scale).rounded()), 1)
			let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()//CGColorSpace.genericRGBColorSpace
			let bitmapInfo:UInt32 = /*CGBitmapInfo.floatComponents.rawValue |*/ CGImageAlphaInfo.premultipliedLast.rawValue
			let bitmapContext:CGContext = CGContext(data: nil, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: pixelsWide * 4, space: colorSpace, bitmapInfo: bitmapInfo)!
			bitmapContext.scaleBy(x: scale, y: scale)
			//TODO: apply scale transformation
			if flip == .always || flip == .macOS {
				bitmapContext.translateBy(x: 0.0, y: size.height)
				bitmapContext.scaleBy(x: 1.0, y: -1.0)
			}
		#endif
		
		drawing(bitmapContext)
		
		let image:CGImage = bitmapContext.makeImage()!
		//clean up
		#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
			//TODO: double check that this is correct
			UIGraphicsEndImageContext()
		#endif
		return image
	}
	
	/// quality = 0 is empty data, quality = 1 is no compression
	public func jpegData(quality:CGFloat)->Data? {
		#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
			return UIImage(cgImage:self).jpegData(compressionQuality: quality)
		#elseif os(macOS)
			let rep = NSBitmapImageRep(cgImage: self)
			return rep.representation(using: .jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor:quality])
		#endif
	}
	
}
