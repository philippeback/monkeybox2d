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

Class TestOneSidedPlatform Extends Test
    
    Method New()
        '// Set Text field
        name = "One Sided Platform\n"
        Local bd :b2BodyDef
        Local body :b2Body
        '// Platform
        
        bd = New b2BodyDef()
        bd.position.Set(10.0, 10.0)
        body = m_world.CreateBody(bd)
        Local polygon :b2PolygonShape = b2PolygonShape.AsBox(3.0, 0.5)
        m_platform = body.CreateFixture2(polygon)
        m_bottom = bd.position.y + 0.5
        m_top = bd.position.y - 0.5
        'End
        '// Actor
        
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(10.0, 12.0)
        body = m_world.CreateBody(bd)
        m_radius = 0.5
        Local circle :b2CircleShape = New b2CircleShape(m_radius)
        m_character = body.CreateFixture2(circle, 1.0)
        m_state = e_unknown
        'End
        m_world.SetContactListener(New ContactListener(Self))
    End
    '//===========
    '// Member Data
    '//===========
    Global e_unknown:int = 0
    Global e_above:int = 1
    Global e_below:int = 2
    Field m_radius :Float
    Field m_top :Float
    Field m_bottom :Float
    Field m_state :int
    Field m_platform :b2Fixture
    Field m_character :b2Fixture
End

Class ContactListener Extends b2ContactListener
    
    Field test:TestOneSidedPlatform
    
    Method New(test:TestOneSidedPlatform)
        Super.New()
        Self.test = test
    End
    
    Method PreSolve : void (contact:b2Contact, oldManifold:b2Manifold)
        Local fixtureA :b2Fixture = contact.GetFixtureA()
        Local fixtureB :b2Fixture = contact.GetFixtureB()
        
        If (fixtureA <> test.m_platform  And  fixtureA <> test.m_character)
            Return
        End
        
        If (fixtureB <> test.m_platform  And  fixtureB <> test.m_character)
            Return
        End
        
        Local position :b2Vec2 = test.m_character.GetBody().GetPosition()
        
        If (position.y > test.m_top)
            contact.SetEnabled(False)
        End
    End
End





