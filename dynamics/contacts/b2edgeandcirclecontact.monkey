Strict
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
Import box2d.collision.shapes
Import box2d.collision
Import box2d.dynamics
Import box2d.common
Import box2d.common.math


#rem
'/**
'* @
'*/
#end
Class EdgeAndCircleContactTypeFactory Extends ContactTypeFactory
    Method Create : b2Contact (allocator: Object)
        
        Return New b2EdgeAndCircleContact()
    End
    
    Method Destroy : void (contact:b2Contact, allocator: Object)
        
        '//
    End
End
Class b2EdgeAndCircleContact Extends b2Contact
    
    
    Method New()
        Super.New()
    End
    
    Method Reset : void (fixtureA:b2Fixture, fixtureB:b2Fixture)
        
        Super.Reset(fixtureA, fixtureB)
        '//b2Settings.B2Assert(m_shape1.m_type = b2Shape.e_circleShape)
        '//b2Settings.B2Assert(m_shape2.m_type = b2Shape.e_circleShape)
    End
    
    '//~b2EdgeAndCircleContact() {}
    Method Evaluate : void ()
        
        Local bA :b2Body = m_fixtureA.GetBody()
        Local bB :b2Body = m_fixtureB.GetBody()
        b2EdgeAndCircleContact.b2CollideEdgeAndCircle(m_manifold,
        b2EdgeShape(m_fixtureA.GetShape()), bA.m_xf,
        b2CircleShape(m_fixtureB.GetShape()), bB.m_xf)
    End

    ' Compute contact points for edge versus circle.
    ' This accounts for edge connectivity.
    Function b2CollideEdgeAndCircle:Void(manifold:b2Manifold,
    							edgeA:b2EdgeShape, xfA:b2Transform,
    							circleB:b2CircleShape, xfB:b2Transform)
    
    	manifold.m_pointCount = 0
    
    	'Compute circle in frame of edge
        Local tmpVec1:b2Vec2 = New b2Vec2()
        b2Math.MulXT(xfB, circleB.m_p,tmpVec1)
    	b2Math.MulXT(xfA, tmpVec1, tmpVec1 )
        Local Q:b2Vec2 = tmpVec1
    	
        Local A:b2Vec2 = edgeA.m_v1
        Local B:b2Vec2 = edgeA.m_v2
    	Local e:b2Vec2 = B.Copy()
        e.Subtract( A )
    
    	'Barycentric coordinates
        tmpVec1 = New b2Vec2()
        b2Math.SubtractVV(B,Q,tmpVec1)
    	Local u:Float = b2Math.Dot(e, tmpVec1)
        
        b2Math.SubtractVV(Q,A,tmpVec1)
    	Local v:Float = b2Math.Dot(e, tmpVec1)
    
    	Local radius:Float = edgeA.m_radius + circleB.m_radius
    
    	Local cf:b2ContactFeature
    	cf.indexB = 0
    	cf.typeB = b2ContactFeature.e_vertex
    
    	'Region A
    	If v <= 0.0
    		Local P:b2Vec2 = A
    		Local d:b2Vec2 = Q - P
    		Local dd:Float = b2Dot(d, d)
    		
            If (dd > radius * radius)
    			Return
    		End
    
    		' Is there an edge connected to A?
    		If edgeA.m_hasVertex0
    		
    			Local A1:b2Vec2 = edgeA.m_vertex0
    			Local B1:b2Vec2 = A
    			Local e1:b2Vec2 = B1 - A1
    			Local u1:Float = b2Dot(e1, B1 - Q)
    
    			' Is the circle in Region AB of the previous edge?
    			If u1 > 0.0
    			    Return
                End
    		End
    
    		cf.indexA = 0
    		cf.typeA = b2ContactFeature.e_vertex
    		manifold.pointCount = 1
    		manifold.type = b2Manifold.e_circles
    		manifold.localNormal.SetZero()
    		manifold.localPoint = P
    		manifold.points[0].id.key = 0
    		manifold.points[0].id.cf = cf
    		manifold.points[0].localPoint = circleB.m_p
    		Return
    	End
    
    	' Region B
    	If u <= 0.0
    		Local P:b2Vec2 P = B
    		Local d:b2Vec2 = Q - P
    		Local dd:b2Vec2 = b2Dot(d, d)
    		If dd > radius * radius
    			Return
    		End
    
    		' Is there an edge connected to B?
    		If edgeA.m_hasVertex3
    	
    			Local B2:b2Vec2 = edgeA.m_vertex3
    			Local A2:b2Vec2 = B
    			Local e2:b2Vec2 = B2 - A2
    			Local v2:Float = b2Dot(e2, Q - A2)
    
    			' Is the circle in Region AB of the next edge?
    			If v2 > 0.0
        			Return
    		    End
            End
    
    		cf.indexA = 1
    		cf.typeA = b2ContactFeature.e_vertex
    		manifold.pointCount = 1
    		manifold.type = b2Manifold.e_circles
    		manifold.localNormal.SetZero()
    		manifold.localPoint = P
    		manifold.points[0].id.key = 0
    		manifold.points[0].id.cf = cf
    		manifold.points[0].localPoint = circleB.m_p
    		Return
    	End
    
    	' Region AB
    	Local den:Float = b2Dot(e, e)
    	b2Assert(den > 0.0)
    	Local P:b2Vec2 = (1.0 / den) * (u * A + v * B)
    	Local d:b2Vec2 = Q - P
    	Local dd:Float = b2Dot(d, d)
    	If (dd > radius * radius)
        	Return
        End
    
    	Local n:b2Vec2 = New b2Vec2(-e.y, e.x)
    	If (b2Dot(n, Q - A) < 0.0)
    	    n.Set(-n.x, -n.y)
    	End
        
    	n.Normalize()
    
    	cf.indexA = 0
    	cf.typeA = b2ContactFeature.e_face
    	manifold.pointCount = 1
    	manifold.type = b2Manifold.e_faceA
    	manifold.localNormal = n
    	manifold.localPoint = A
    	manifold.points[0].id.key = 0
    	manifold.points[0].id.cf = cf
    	manifold.points[0].localPoint = circleB.m_p
    End    
End



