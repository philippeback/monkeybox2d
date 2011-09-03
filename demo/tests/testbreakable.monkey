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
Import box2d.demo.tests.test
Import box2d.dynamics
Import box2d.collision
Import box2d.collision.shapes
Import box2d.dynamics.joints
Import box2d.dynamics.contacts
Import box2d.common
Import box2d.common.math

Class TestBreakableTester Extends BreakableTester
    Field m_piece1:b2Fixture
    
    Method New(m_piece1:b2Fixture)
        Self.m_piece1 = m_piece1
    End
    
    Method IsBreakable:Bool(f:b2Fixture)
        Return f <> m_piece1
    End
End

Class TestBreakable Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Breakable"
        m_world.SetContactListener(New ContactListener(Self))
        Local ground :b2Body = m_world.GetGroundBody()
        '// Breakable Dynamic Body
        
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(5.0, 5.0)
        bd.angle = 0.25 * Constants.PI
        m_body1 = m_world.CreateBody(bd)
        m_shape1.SetAsOrientedBox(0.5, 0.5, New b2Vec2( -0.5, 0.0))
        m_piece1 = m_body1.CreateFixture2(m_shape1, 1.0)
        m_shape2.SetAsOrientedBox(0.5, 0.5, New b2Vec2( 0.5, 0.0))
        m_piece2 = m_body1.CreateFixture2(m_shape2, 1.0)
        'End
        m_break = False
        m_broke = False
    End
    
    
    Method Break : void ()
        
        '// Apply cached velocity for more realistic  Exit
        m_body1.SetLinearVelocity(m_velocity)
        m_body1.SetAngularVelocity(m_angularVelocity)
        '// Split body into two pieces
        m_body1.Split(New TestBreakableTester(m_piece1) )
        
    End
    Method Update : void ()
        
        Super.Update()
        If (m_break)
            
            Break()
            m_broke = True
            m_break = False
        End
        '// Cache velocities to improve movement on  Exitage
        If (m_broke = False)
            
            m_velocity = m_body1.GetLinearVelocity()
            m_angularVelocity = m_body1.GetAngularVelocity()
        End
    End
    '//===========
    '// Member Data
    '//===========
    Field m_body1 :b2Body
    Field m_velocity :b2Vec2 = New b2Vec2()
    Field m_angularVelocity :Float
    Field m_shape1 :b2PolygonShape = New b2PolygonShape()
    Field m_shape2 :b2PolygonShape = New b2PolygonShape()
    Field m_piece1 :b2Fixture
    Field m_piece2 :b2Fixture
    Field m_broke :Bool
    Field m_break :Bool
End


Class ContactListener Extends b2ContactListener
    
    Field test:TestBreakable
    
    
    Method New(test:TestBreakable)
        Super.New()
        Self.test = test
    End
    
    Method PostSolve : void (contact:b2Contact, impulse:b2ContactImpulse)
        
        If (test.m_broke)
            
            '// The body already broke
            Return
        End
        '// Should the body  Exit?
        Local count :int = contact.GetManifold().m_pointCount
        Local maxImpulse :Float = 0.0
        
        For Local i:Int = 0 Until count
            maxImpulse = b2Math.Max(maxImpulse, impulse.normalImpulses[i])
        End
        
        If (maxImpulse > 50)
            test.m_break = True
        End
    End
    
End




