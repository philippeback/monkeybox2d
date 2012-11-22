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
Import box2d.demo.tests.test
Import box2d.dynamics
Import box2d.collision
Import box2d.collision.shapes
Import box2d.dynamics.joints
Import box2d.dynamics.contacts
Import box2d.common
Import box2d.common.math
Class TestRaycast Extends Test
    Field laser:b2Body
    Method New()
        Super.New()
        
        '// Set Text field
        name = "Raycast"
        m_world.SetGravity(New b2Vec2(0,0))
        Local ground :b2Body = m_world.GetGroundBody()
        Local box :b2PolygonShape = New b2PolygonShape()
        box.SetAsBox(30 / m_physScale, 4 / m_physScale)
        Local fd :b2FixtureDef = New b2FixtureDef()
        fd.shape = box
        fd.density = 4
        fd.friction = 0.4
        fd.restitution = 0.3
        fd.userData = New StringObject("laser")
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(320 / m_physScale, 150 / m_physScale)
        bd.position.Set(40 / m_physScale, 150 / m_physScale)
        laser = m_world.CreateBody(bd)
        laser.CreateFixture(fd)
        laser.SetAngle(0.5)
        laser.SetAngle(Constants.PI)
        Local circle :b2CircleShape = New b2CircleShape(30 / m_physScale)
        fd.shape = circle
        fd.density = 4
        fd.friction = 0.4
        fd.restitution = 0.3
        fd.userData = New StringObject("circle")
        bd.position.Set(100 / m_physScale, 100 / m_physScale)
        Local body :b2Body = m_world.CreateBody(bd)
        body.CreateFixture(fd)
    End
    '//===========
    '// Member Data
    '//===========
    Field p1:b2Vec2 = New b2Vec2()
    Field p2:b2Vec2 = New b2Vec2()
    Field f :b2Fixture
    Field lambda :Float = 1.0
    
    Method Update:Void ()
        
        Super.Update()
        laser.GetWorldPoint(New b2Vec2(30.1 / m_physScale, 0), p1)
        laser.GetWorldPoint(New b2Vec2(130.1 / m_physScale, 0), p2)
        f = m_world.RayCastOne(p1, p2)
        lambda = 1.0
        
        If (f)
            Local input :b2RayCastInput = New b2RayCastInput(p1, p2)
            Local output :b2RayCastOutput = New b2RayCastOutput()
            f.RayCast(output, input)
            lambda = output.fraction
        End
    End
    
    Method OnRender:Void()
        Super.OnRender()
        
        SetColor(255,0,0)
        DrawLine(p1.x * m_physScale, p1.y * m_physScale,
        (p2.x * lambda + (1 - lambda) * p1.x) * m_physScale,
        (p2.y * lambda + (1 - lambda) * p1.y) * m_physScale)
    End
End



