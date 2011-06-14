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
    Method Initialize : void (cache:b2SimplexCache,
        proxyA:b2DistanceProxy, transformA:b2Transform,
        proxyB:b2DistanceProxy, transformB:b2Transform)
        
        m_proxyA = proxyA
        m_proxyB = proxyB
        Local count :int = cache.count
        b2Settings.B2Assert(0 < count And count < 3)
        Local localPointA :b2Vec2
        Local localPointA1 :b2Vec2
        Local localPointA2 :b2Vec2
        Local localPointB :b2Vec2
        Local localPointB1 :b2Vec2
        Local localPointB2 :b2Vec2
        Local pointAX :Float
        Local pointAY :Float
        Local pointBX :Float
        Local pointBY :Float
        Local normalX :Float
        Local normalY :Float
        Local tMat :b2Mat22
        Local tVec :b2Vec2
        Local s :Float
        Local sgn :Float
        If (count = 1)
            
            m_type = e_points
            localPointA = m_proxyA.GetVertex(cache.indexA.Get(0))
            localPointB = m_proxyB.GetVertex(cache.indexB.Get(0))
            '//pointA = b2Math.b2MulX(transformA, localPointA)
            tVec = localPointA
            tMat = transformA.R
            pointAX = transformA.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointAY = transformA.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//pointB = b2Math.b2MulX(transformB, localPointB)
            tVec = localPointB
            tMat = transformB.R
            pointBX = transformB.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointBY = transformB.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//m_axis = b2Math.SubtractVV(pointB, pointA)
            m_axis.x = pointBX - pointAX
            m_axis.y = pointBY - pointAY
            m_axis.Normalize()
        Else  If (cache.indexB.Get(0) = cache.indexB.Get(1))
            
            
            '// Two points on A and one on B
            m_type = e_faceA
            localPointA1 = m_proxyA.GetVertex(cache.indexA.Get(0))
            localPointA2 = m_proxyA.GetVertex(cache.indexA.Get(1))
            localPointB = m_proxyB.GetVertex(cache.indexB.Get(0))
            m_localPoint.x = 0.5 * (localPointA1.x + localPointA2.x)
            m_localPoint.y = 0.5 * (localPointA1.y + localPointA2.y)
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointA2, localPointA1), 1.0)
            m_axis.Normalize()
            '//normal = b2Math.b2MulMV(transformA.R, m_axis)
            tVec = m_axis
            tMat = transformA.R
            normalX = tMat.col1.x * tVec.x + tMat.col2.x * tVec.y
            normalY = tMat.col1.y * tVec.x + tMat.col2.y * tVec.y
            '//pointA = b2Math.b2MulX(transformA, m_localPoint)
            tVec = m_localPoint
            tMat = transformA.R
            pointAX = transformA.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointAY = transformA.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//pointB = b2Math.b2MulX(transformB, localPointB)
            tVec = localPointB
            tMat = transformB.R
            pointBX = transformB.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointBY = transformB.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//float32 s = b2Dot(pointB - pointA, normal)
            s = (pointBX - pointAX) * normalX + (pointBY - pointAY) * normalY
            If (s < 0.0)
                
                m_axis.NegativeSelf()
            End
            
        Else  If (cache.indexA.Get(0) = cache.indexA.Get(0))
            
            
            '// Two points on B and one on A
            m_type = e_faceB
            localPointB1 = m_proxyB.GetVertex(cache.indexB.Get(0))
            localPointB2 = m_proxyB.GetVertex(cache.indexB.Get(1))
            localPointA = m_proxyA.GetVertex(cache.indexA.Get(0))
            m_localPoint.x = 0.5 * (localPointB1.x + localPointB2.x)
            m_localPoint.y = 0.5 * (localPointB1.y + localPointB2.y)
            m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointB2, localPointB1), 1.0)
            m_axis.Normalize()
            '//normal = b2Math.b2MulMV(transformB.R, m_axis)
            tVec = m_axis
            tMat = transformB.R
            normalX = tMat.col1.x * tVec.x + tMat.col2.x * tVec.y
            normalY = tMat.col1.y * tVec.x + tMat.col2.y * tVec.y
            '//pointB = b2Math.b2MulX(transformB, m_localPoint)
            tVec = m_localPoint
            tMat = transformB.R
            pointBX = transformB.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointBY = transformB.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//pointA = b2Math.b2MulX(transformA, localPointA)
            tVec = localPointA
            tMat = transformA.R
            pointAX = transformA.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
            pointAY = transformA.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
            '//float32 s = b2Dot(pointA - pointB, normal)
            s = (pointAX - pointBX) * normalX + (pointAY - pointBY) * normalY
            If (s < 0.0)
                
                m_axis.NegativeSelf()
            End
            
        Else
            
            
            '// Two points on B and two points on A.
            '// The faces are parallel.
            localPointA1 = m_proxyA.GetVertex(cache.indexA.Get(0))
            localPointA2 = m_proxyA.GetVertex(cache.indexA.Get(1))
            localPointB1 = m_proxyB.GetVertex(cache.indexB.Get(0))
            localPointB2 = m_proxyB.GetVertex(cache.indexB.Get(1))
            Local pA :b2Vec2 = b2Math.MulX(transformA, localPointA)
            Local dA :b2Vec2 = b2Math.MulMV(transformA.R, b2Math.SubtractVV(localPointA2, localPointA1))
            Local pB :b2Vec2 = b2Math.MulX(transformB, localPointB)
            Local dB :b2Vec2 = b2Math.MulMV(transformB.R, b2Math.SubtractVV(localPointB2, localPointB1))
            Local a :Float = dA.x * dA.x + dA.y * dA.y
            Local e :Float = dB.x * dB.x + dB.y * dB.y
            Local r :b2Vec2 = b2Math.SubtractVV(dB, dA)
            Local c :Float = dA.x * r.x + dA.y * r.y
            Local f :Float = dB.x * r.x + dB.y * r.y
            Local b :Float = dA.x * dB.x + dA.y * dB.y
            Local denom :Float = a * e-b * b
            s = 0.0
            If (denom <> 0.0)
                
                s = b2Math.Clamp((b * f - c * e) / denom, 0.0, 1.0)
            End
            Local t :Float = (b * s + f) / e
            If (t < 0.0)
                
                t = 0.0
                s = b2Math.Clamp((b - c) / a, 0.0, 1.0)
            End
            '//b2Vec2 localPointA = localPointA1 + s * (localPointA2 - localPointA1)
            localPointA = New b2Vec2()
            localPointA.x = localPointA1.x + s * (localPointA2.x - localPointA1.x)
            localPointA.y = localPointA1.y + s * (localPointA2.y - localPointA1.y)
            '//b2Vec2 localPointB = localPointB1 + s * (localPointB2 - localPointB1)
            localPointB = New b2Vec2()
            localPointB.x = localPointB1.x + s * (localPointB2.x - localPointB1.x)
            localPointB.y = localPointB1.y + s * (localPointB2.y - localPointB1.y)
            If (s = 0.0 Or s = 1.0)
                
                m_type = e_faceB
                m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointB2, localPointB1), 1.0)
                m_axis.Normalize()
                m_localPoint = localPointB
                '//normal = b2Math.b2MulMV(transformB.R, m_axis)
                tVec = m_axis
                tMat = transformB.R
                normalX = tMat.col1.x * tVec.x + tMat.col2.x * tVec.y
                normalY = tMat.col1.y * tVec.x + tMat.col2.y * tVec.y
                '//pointB = b2Math.b2MulX(transformB, m_localPoint)
                tVec = m_localPoint
                tMat = transformB.R
                pointBX = transformB.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
                pointBY = transformB.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
                '//pointA = b2Math.b2MulX(transformA, localPointA)
                tVec = localPointA
                tMat = transformA.R
                pointAX = transformA.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
                pointAY = transformA.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
                '//float32 sgn = b2Dot(pointA - pointB, normal)
                sgn = (pointAX - pointBX) * normalX + (pointAY - pointBY) * normalY
                If (s < 0.0)
                    
                    m_axis.NegativeSelf()
                End
                
            Else
                
                
                m_type = e_faceA
                m_axis = b2Math.CrossVF(b2Math.SubtractVV(localPointA2, localPointA1), 1.0)
                m_localPoint = localPointA
                '//normal = b2Math.b2MulMV(transformA.R, m_axis)
                tVec = m_axis
                tMat = transformA.R
                normalX = tMat.col1.x * tVec.x + tMat.col2.x * tVec.y
                normalY = tMat.col1.y * tVec.x + tMat.col2.y * tVec.y
                '//pointA = b2Math.b2MulX(transformA, m_localPoint)
                tVec = m_localPoint
                tMat = transformA.R
                pointAX = transformA.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
                pointAY = transformA.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
                '//pointB = b2Math.b2MulX(transformB, localPointB)
                tVec = localPointB
                tMat = transformB.R
                pointBX = transformB.position.x + (tMat.col1.x * tVec.x + tMat.col2.x * tVec.y)
                pointBY = transformB.position.y + (tMat.col1.y * tVec.x + tMat.col2.y * tVec.y)
                '//float32 sgn = b2Dot(pointB - pointA, normal)
                sgn = (pointBX - pointAX) * normalX + (pointBY - pointAY) * normalY
                If (s < 0.0)
                    
                    m_axis.NegativeSelf()
                End
            End
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
        Field m_proxyA:b2DistanceProxy
        
        
        Field m_proxyB:b2DistanceProxy
        
        
        Field m_type:int
        
        
        Field m_localPoint:b2Vec2 = New b2Vec2()
        
        
        Field m_axis:b2Vec2 = New b2Vec2()
        
        
    End
    
