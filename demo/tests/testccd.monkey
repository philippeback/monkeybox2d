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
Class TestCCD Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Continuous Collision Detection"
        Local bd :b2BodyDef
        Local body :b2Body
        Local fixtureDef :b2FixtureDef = New b2FixtureDef()
        '// These values are used for all the parts of the basket
        fixtureDef.density = 4.0
        fixtureDef.restitution = 1.4
        '// Create basket
        
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.bullet = True
        bd.position.Set( 150.0/m_physScale, 100.0/m_physScale )
        body = m_world.CreateBody(bd)
        Local sd_bottom :b2PolygonShape = New b2PolygonShape()
        sd_bottom.SetAsBox( 45.0 / m_physScale, 4.5 / m_physScale )
        fixtureDef.shape = sd_bottom
        body.CreateFixture( fixtureDef )
        Local sd_left :b2PolygonShape = New b2PolygonShape()
        sd_left.SetAsOrientedBox(4.5/m_physScale, 81.0/m_physScale, New b2Vec2(-43.5/m_physScale, -70.5/m_physScale), -0.2)
        fixtureDef.shape = sd_left
        body.CreateFixture( fixtureDef )
        Local sd_right :b2PolygonShape = New b2PolygonShape()
        sd_right.SetAsOrientedBox(4.5/m_physScale, 81.0/m_physScale, New b2Vec2(43.5/m_physScale, -70.5/m_physScale), 0.2)
        fixtureDef.shape = sd_right
        body.CreateFixture( fixtureDef )
        'End
        '// add some small circles for effect
        For Local i:Int = 0 Until 5
            
            Local cd :b2CircleShape = New b2CircleShape((Rnd() * 10 + 5) / m_physScale)
            fixtureDef.shape = cd
            fixtureDef.friction = 0.3
            fixtureDef.density = 1.0
            fixtureDef.restitution = 1.1
            bd = New b2BodyDef()
            bd.type = b2Body.b2_Body
            bd.bullet = True
            bd.position.Set( (Rnd()*300 + 250)/m_physScale, (Rnd()*320 + 20)/m_physScale )
            body = m_world.CreateBody(bd)
            body.CreateFixture(fixtureDef)
        End
    End
    '//===========
    '// Member Data
    '//===========
End



