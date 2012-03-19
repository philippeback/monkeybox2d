#rem
'/*
'* Copyright (c) 2011, Damian Sinclair
'*
'* This is a port of Box2D by Erin Catto (box2d.org).
'* It is translated from the Flash port: Box2DFlash, by BorisTheBrave (http://www.box2dflash.org/).
'* Box2DFlash also credits Matt Bush and John Nesky as contributors.
'*
'* All rights reserved.
'* Redistribution and use in source and binary forms, with or without
'* modification, are permitted provided that the following conditions are met:
'*
'*   - Redistributions of source code must retain the above copyright
'*     notice, this list of conditions and the following disclaimer.
'*   - Redistributions in binary form must reproduce the above copyright
'*     notice, this list of conditions and the following disclaimer in the
'*     documentation and/or other materials provided with the distribution.
'*
'* THIS SOFTWARE IS PROVIDED BY THE MONKEYBOX2D PROJECT CONTRIBUTORS "AS IS" AND
'* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
'* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
'* DISCLAIMED. IN NO EVENT SHALL THE MONKEYBOX2D PROJECT CONTRIBUTORS BE LIABLE
'* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
'* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
'* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
'* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
'* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
'* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
'* DAMAGE.
'*/
#end
Import box2d.flash.flashtypes
Import box2d.collision
Import box2d.collision.shapes.b2shape
Import box2d.common
Import box2d.common.math


#rem
'.
'*/
#end
Class b2AABB
    #rem
    '/**
    '* Verify that the bounds are sorted.
    '*/
    #end
    Method IsValid : Bool ()
        
        '//b2Vec2 d = upperBound - lowerBound;
        Local dX :Float = upperBound.x - lowerBound.x
        Local dY :Float = upperBound.y - lowerBound.y
        Local valid :Bool = dX >= 0.0 And dY >= 0.0
        valid = valid And lowerBound.IsValid() And upperBound.IsValid()
        Return valid
    End
    '* Get the center of the AABB.
    Method GetCenter : b2Vec2 ()
        
        Return New b2Vec2( (lowerBound.x + upperBound.x) / 2,
        (lowerBound.y + upperBound.y) / 2)
    End
    '* Get the extents of the AABB (half-widths).
    Method GetExtents : b2Vec2 ()
        
        Return New b2Vec2( (upperBound.x - lowerBound.x) / 2,
        (upperBound.y - lowerBound.y) / 2)
    End
    #rem
    '/**
    '* Is an AABB contained within this one.
    '*/
    #end
    Method Contains : Bool (aabb:b2AABB)
        
        Local result :Bool = True
        result = result And lowerBound.x <= aabb.lowerBound.x
        result = result And lowerBound.y <= aabb.lowerBound.y
        result = result And aabb.upperBound.x <= upperBound.x
        result = result And aabb.upperBound.y <= upperBound.y
        Return result
    End
    '// From Real-time Collision Detection, p179.0
    #rem
    '/**
    '* Perform a precise raycast against the AABB.
    '*/
    #end
    Method RayCast : Bool (output:b2RayCastOutput, input:b2RayCastInput)
        
        Local tmin :Float = -Constants.FMAX
        Local tmax :Float = Constants.FMAX
        Local pX :Float = input.p1.x
        Local pY :Float = input.p1.y
        Local dX :Float = input.p2.x - input.p1.x
        Local dY :Float = input.p2.y - input.p1.y
        Local absDX :Float = Abs(dX)
        Local absDY :Float = Abs(dY)
        Local normal :b2Vec2 = output.normal
        Local inv_d :Float
        Local t1 :Float
        Local t2 :Float
        Local t3 :Float
        Local s :Float
        '//x
        
        If (absDX < Constants.EPSILON)
            
            '// Parallel.
            If (pX < lowerBound.x Or upperBound.x < pX)
                Return False
            End
        Else
            
            
            inv_d = 1.0 / dX
            t1 = (lowerBound.x - pX) * inv_d
            t2 = (upperBound.x - pX) * inv_d
            '// Sign of the normal vector
            s = -1.0
            If (t1 > t2)
                
                t3 = t1
                t1 = t2
                t2 = t3
                s = 1.0
            End
            '// Push the min up
            If (t1 > tmin)
                
                normal.x = s
                normal.y = 0
                tmin = t1
            End
            '// Pull the max down
            tmax = Math.Min(tmax, t2)
            If (tmin > tmax)
                Return False
            End
        End
        'End
        
        '//y
        
        If (absDY < Constants.FMAX)
            
            '// Parallel.
            If (pY < lowerBound.y Or upperBound.y < pY)
                Return False
            End
        Else
            
            
            inv_d = 1.0 / dY
            t1 = (lowerBound.y - pY) * inv_d
            t2 = (upperBound.y - pY) * inv_d
            '// Sign of the normal vector
            s = -1.0
            If (t1 > t2)
                
                t3 = t1
                t1 = t2
                t2 = t3
                s = 1.0
            End
            '// Push the min up
            If (t1 > tmin)
                
                normal.y = s
                normal.x = 0
                tmin = t1
            End
            '// Pull the max down
            tmax = Math.Min(tmax, t2)
            If (tmin > tmax)
                Return False
            End
        End
        'End
        output.fraction = tmin
        Return True
    End
    #rem
    '/**
    '* Tests if another AABB overlaps this one.
    '*/
    #end
    Method TestOverlap : Bool (other:b2AABB)
        
        Local d1X :Float = other.lowerBound.x - upperBound.x
        Local d1Y :Float = other.lowerBound.y - upperBound.y
        Local d2X :Float = lowerBound.x - other.upperBound.x
        Local d2Y :Float = lowerBound.y - other.upperBound.y
        If (d1X > 0.0 Or d1Y > 0.0)
            Return False
        End
        If (d2X > 0.0 Or d2Y > 0.0)
            Return False
        End
        Return True
    End
    
    '* Combine two AABBs into one.
    Function StaticCombine : b2AABB (aabb1:b2AABB, aabb2:b2AABB)
        Local aabb :b2AABB = New b2AABB()
        aabb.Combine(aabb1, aabb2)
        Return aabb
    End
    
    '* Combine two AABBs into one.
    Method Combine : void (aabb1:b2AABB, aabb2:b2AABB)
        
        lowerBound.x = Math.Min(aabb1.lowerBound.x, aabb2.lowerBound.x)
        lowerBound.y = Math.Min(aabb1.lowerBound.y, aabb2.lowerBound.y)
        upperBound.x = Math.Max(aabb1.upperBound.x, aabb2.upperBound.x)
        upperBound.y = Math.Max(aabb1.upperBound.y, aabb2.upperBound.y)
    End
    
    '* The lower vertex
    Field lowerBound:b2Vec2 = New b2Vec2()
    
    
    '* The upper vertex
    Field upperBound:b2Vec2 = New b2Vec2()
    
    
End




