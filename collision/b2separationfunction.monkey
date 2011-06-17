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
Import box2d.collision.shapes
Import box2d.common
Import box2d.common.math

Class b2SeparationFunction
    
    '//enum Type
    Const e_points:int = $01
    Const e_faceA:int = $02
    Const e_faceB:int = $04

    Field m_proxyA:b2DistanceProxy        
    Field m_proxyB:b2DistanceProxy
    Field m_sweepA:b2Sweep        
    Field m_sweepB:b2Sweep
    Field m_type:int
    Field m_localPoint:b2Vec2 = New b2Vec2()
    Field m_axis:b2Vec2 = New b2Vec2()

    Method Initialize : void (cache:b2SimplexCache,
        proxyA:b2DistanceProxy, sweepA:b2Sweep,
        proxyB:b2DistanceProxy, sweepB:b2Sweep,
        alpha:Float)
        
        m_proxyA = proxyA
        m_proxyB = proxyB
        Local count :int = cache.count
        b2Settings.B2Assert(0 < count And count < 3)
        
        m_sweepA = sweepA
        m_sweepB = sweepB
        Local xfA := New b2Transform()
        Local xfB := New b2Transform()
        m_sweepA.GetTransform(xfA, alpha)
        m_sweepB.GetTransform(xfB, alpha)

        If (count = 1)
            m_type = e_points
            Local localPointA := m_proxyA.GetVertex(cache.indexA.Get(0))
            Local localPointB := m_proxyB.GetVertex(cache.indexB.Get(0))
            Local pointA := b2Math.MulX(xfA, localPointA)
            Local pointB := b2Math.MulX(xfB, localPointB)
            m_axis = b2Math.SubtractVV(pointB,pointA)
            m_axis.Normalize()
        Else  If (cache.indexA.Get(0).ToInt() = cache.indexA.Get(1).ToInt())
            '// Two points on B and one on A.
            m_type = e_faceB
            Local localPointB1 := proxyB.GetVertex(cache.indexB.Get(0))
            Local localPointB2 := proxyB.GetVertex(cache.indexB.Get(1))

            m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointB2, localPointB1), 1.0)
            m_axis.Normalize()
            Local normal := b2Math.MulMV(xfB.R, m_axis)

            m_localPoint = b2Math.AddVV(localPointB1,localPointB2)
            m_localPoint.Multiply(0.5)
            Local pointB := b2Math.MulX(xfB, m_localPoint)

            Local localPointA := proxyA.GetVertex(cache.indexA.Get(0))
            Local pointA := b2Math.MulX(xfA, localPointA)

            Local s:Float = b2Math.Dot(b2Math.SubtractVV(pointA, pointB), normal)
            If (s < 0.0)
                m_axis.NegativeSelf()
                s = -s
            End
            'return s
        Else
            '// Two points on A and one or two points on B.
            m_type = e_faceA
            Local localPointA1 := m_proxyA.GetVertex(cache.indexA.Get(0))
            Local localPointA2 := m_proxyA.GetVertex(cache.indexA.Get(1))

            m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointA2,localPointA1), 1.0)
            m_axis.Normalize()
            Local normal := b2Math.MulMV(xfA.R, m_axis)

            m_localPoint = b2Math.AddVV(localPointA1,localPointA2)
            m_localPoint.Multiply(0.5)
            Local pointA := b2Math.MulX(xfA, m_localPoint)

            Local localPointB := m_proxyB.GetVertex(cache.indexB.Get(0))
            Local pointB := b2Math.MulX(xfB, localPointB)

            Local s := b2Math.Dot(b2Math.SubtractVV(pointB, pointA), normal)
            If (s < 0.0)
                m_axis.NegativeSelf()
                s = -s
            End
            'Return s
        End
    End
    Method Evaluate : Float (transformA:b2Transform, transformB:b2Transform)
        
        Local axisA :b2Vec2
        Local axisB :b2Vec2
        Local localPointA :b2Vec2
        Local localPointB :b2Vec2
        Local pointA :b2Vec2
        Local pointB :b2Vec2
        Local seperation :Float
        Local normal :b2Vec2
        Select(m_type)
            
            Case e_points
                
                axisA = b2Math.MulTMV(transformA.R, m_axis)
                axisB = b2Math.MulTMV(transformB.R, m_axis.GetNegative())
                localPointA = m_proxyA.GetSupportVertex(axisA)
                localPointB = m_proxyB.GetSupportVertex(axisB)
                pointA = b2Math.MulX(transformA, localPointA)
                pointB = b2Math.MulX(transformB, localPointB)
                '//float32 separation = b2Dot(pointB - pointA, m_axis)
                seperation = (pointB.x - pointA.x) * m_axis.x + (pointB.y - pointA.y) * m_axis.y
                Return seperation
                
            Case e_faceA
                
                normal = b2Math.MulMV(transformA.R, m_axis)
                pointA = b2Math.MulX(transformA, m_localPoint)
                axisB = b2Math.MulTMV(transformB.R, normal.GetNegative())
                localPointB = m_proxyB.GetSupportVertex(axisB)
                pointB = b2Math.MulX(transformB, localPointB)
                '//float32 separation = b2Dot(pointB - pointA, normal)
                seperation = (pointB.x - pointA.x) * normal.x + (pointB.y - pointA.y) * normal.y
                Return seperation
                
            Case e_faceB
                
                normal = b2Math.MulMV(transformB.R, m_axis)
                pointB = b2Math.MulX(transformB, m_localPoint)
                axisA = b2Math.MulTMV(transformA.R, normal.GetNegative())
                localPointA = m_proxyA.GetSupportVertex(axisA)
                pointA = b2Math.MulX(transformA, localPointA)
                '//float32 separation = b2Dot(pointA - pointB, normal)
                seperation = (pointA.x - pointB.x) * normal.x + (pointA.y - pointB.y) * normal.y
                Return seperation
                
                Default
                b2Settings.B2Assert(False)
                Return 0.0
            End
        End
    End
    
