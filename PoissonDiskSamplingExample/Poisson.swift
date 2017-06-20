//
//  Poisson.swift
//  asasdasas
//
//  Created by Peter  Barsby on 6/20/17.
//  Copyright © 2017 Peter Barsby. All rights reserved.
//

import Foundation
import Darwin
import SceneKit

private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    let dx = p1.x - p2.x
    let dy = p1.y - p2.y
    return sqrt(dx * dx + dy * dy)
}

private func generateRandomPointAround(point: CGPoint, minDist: CGFloat) -> CGPoint
{
    
    let rd1 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    let rd2 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    
    //random radius
    let radius = minDist * (rd1 + 1)
    //random angle
    let angle = 2 * CGFloat.pi * rd2
    
    //new point is generated around the point (x, y)
    
    let newX = point.x + radius * cos(angle)
    let newY = point.y + radius * sin(angle)
    return CGPoint(x: newX, y: newY)
    
}


func generatePoisson(wh: CGSize, minDist: CGFloat, newPointsCount: Int? = 30) -> [CGPoint] {
    
    let radius = minDist
    
    //point sample in radius
    let lookUpCount = 30
    var grid = [CGPoint?](), validPoints = [CGPoint](), activePoints = [CGPoint]()
    var cellSize = CGFloat()
    var cols = Int()
    var rows = Int()
    let sizeScren = wh
    
    
    //create cell
    cellSize = (CGFloat(Double(radius) / sqrt(2)))
    cols = Int(floor(sizeScren.height / cellSize))
    rows = Int(floor(sizeScren.width / cellSize))
    
    grid = [CGPoint?](repeating: nil, count: (cols * rows))
    
    let x = sizeScren.height / 2
    let y = sizeScren.width / 2
    let i = floor(x / cellSize)
    let j = floor(y / cellSize)
    
    //first posistion
    
    let pos = CGPoint.zero
    let index = Int(i + j * CGFloat(cols))
    grid[index] = pos
    activePoints.append(pos)
    validPoints.append(pos)
    
    
    while (activePoints.count > 0) {
        let randomIndex = Int(arc4random_uniform(UInt32(activePoints.count)))
        let currentPos = activePoints[randomIndex]
        var found = false
        Mainloop: for _ in 0..<Int(lookUpCount) {
            
            let samplePoint = generateRandomPointAround(point: currentPos, minDist: CGFloat(radius))
            
            let col = floor((samplePoint.x + x) / cellSize)
            let row = floor((samplePoint.y + y) / cellSize)
            
            //check neighbouring cells are empty and valid, if have a point in already
            
            let isIndexValid = grid.indices.contains(Int(col + CGFloat(row) * CGFloat(cols)))
            
            if (isIndexValid && (grid[Int(col + CGFloat(row) * CGFloat(cols))] == nil)) {
                var ok = true
                for index1 in -1...1 {
                    for index2 in -1...1 {
                        
                        //break down complexity for swift compiler
                        
                        let part1 = Int(col + CGFloat(index1))
                        let part2 = Int(row + CGFloat(index2))
                        let part3 = part1 + part2 * cols
                        let sampleIndex = part3
                        
                        let isIndexValid = grid.indices.contains(sampleIndex)
                        
                        if isIndexValid {
                            let neighbor = grid[sampleIndex]
                            
                            if neighbor != nil {
                                let distanceAmount = distance(p1: samplePoint, p2: neighbor!)
                                if distanceAmount < CGFloat(radius) {
                                    ok = false
                                }
                            }
                        }
                    }
                }
                
                if (ok == true) {
                    found = true
                    grid[Int(col + row * CGFloat(cols))] = samplePoint
                    activePoints.append(samplePoint)
                    validPoints.append(samplePoint)
                    //                        break MainLoop
                }
            }
        }
        
        if (!found) {
            activePoints.remove(at: randomIndex)
        }
    }
    return validPoints
}
