# CoreGraphicsExtensions
 
The stuff they should have built in to CoreGraphics for Swift.

Theoretically, this stuff should work for all apple platforms, but I've only tested on ios & macos.  If you need it on others, make a pr and we can do some testing to make sure the images are turning out right.


## Math operators for CGPoint, CGSize

CGPoint + CGPoint, +=, -, -=

CGPoint + CGSize, +=, -, -=

CGPoint * CGFloat, /

CGPoint  * CGSize, /

CGPoint(CGSize)

CGSize + CGSize, -, -=, 

CGSize * CGFloat, /
CGSize * CGSize, /


## Fit / Fill algorithms for CGRect

///where should I put the origin if I want the center at ___ ?
`func originForCenter()`

/// Returns the rect (and scale factor for the change) of fitting the rect in the size 
`func rectFittingSize()`

///fits the self rect in the super rect
`func rectFittingRect(...)`

///returns the rect and scale factor for filling the provided rect with a rect with the size ratio of self
`func rect(filling`

Unlike regular fit & fill algorithms,which always center the original content in the superrect, this algorithm also attempts to fill the superrect with the rest of the original self rect while fitting the interest area in the eruprect.

`public func rect(fitting superRect:CGRect, interestArea:CGRect)->(rect:CGRect, scaledInterest:CGRect, scale:CGFloat)`

Imagine a 4x wide image with a mountain in the left 25% and a valley in the rest of the image.  As you move to narrower and narrower screen aspect ratios, if you fit the image to make the mountain always visible, you end up with a tooon of dead space above and below the image.  A regular fill algorithm would zoom in on the valley and perhaps cut the mountain completely out.

But with this, you define the mountain as the interest area (the left 25% of the self rect), so the image always fills veritically, and the mountain stays left aligned, filling the available right width of the screen with valley.  It produces a significantly better artistic effect than other fitting / scaling algorithms.


## Line scaling / intersection algorithms

a `Line` struct is provided, defined by 2 points, which can clculate a point as a fraction of the way from point0 to point1.  Or can calculate the intersection of the lines (assuming lines are not papprallel.)  


## CGImage creation methods like UIGraphicsRenderer 

Before `UIGraphicsImageRenderer`, there was benspratling4/CoreGraphicsExtensions /CGImage.make()

It sets up a CGContext for you appropriately depending on the OS, lets you control the final render scale, and you put your CGContext drawing commands in a closure.  Out pops a CGImage.  You can also control the flipping with a flag.

```swift
let image:CGImage = CGImage.make(size:CGSize(width:320.0, height:480.0), scale:2.0) { cgContext in
	cgContext.setFillColor(...CGColor...)
	cgContext.fill(rect)	//and all that jazz
}
```
