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
Import box2d.dynamics.controllers
Import box2d.common
Import box2d.common.math

Class TestBuoyancy Extends Test
    Field m_bodies:FlashArray<b2Body> = New FlashArray<b2Body>()
    Field m_controller:b2Controller
    Method New()
        Super.New()
        
        Local bc :b2BuoyancyController = New b2BuoyancyController()
        m_controller = bc
        bc.normal.Set(0,-1)
        bc.offset = -height*0.5 / m_physScale
        bc.density = 2.0
        bc.linearDrag = 5
        bc.angularDrag = 2
        Local ground :b2Body = m_world.GetGroundBody()
        Local i :Int
        Local anchor :b2Vec2 = New b2Vec2()
        Local body :b2Body
        Local fd :b2FixtureDef
        Local bodyDef :b2BodyDef
        Local boxDef :b2PolygonShape
        Local circDef :b2CircleShape
        
        '// Spawn in a bunch of crap
        For Local i:Int = 0 Until 5
            
            bodyDef = New b2BodyDef()
            bodyDef.type = b2Body.b2_Body
            '//bodyDef.isBullet = True
            boxDef = New b2PolygonShape()
            fd = New b2FixtureDef()
            fd.shape = boxDef
            fd.density = 1.0
            '// Override the default friction.
            fd.friction = 0.3
            fd.restitution = 0.1
            boxDef.SetAsBox((Rnd() * 5 + 10) / m_physScale, (Rnd() * 5 + 10) / m_physScale)
            bodyDef.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDef.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDef)
            body.CreateFixture(fd)
            m_bodies.Push(body)
        End
        
        For Local i:Int = 0 Until 5
            
            Local bodyDefC :b2BodyDef = New b2BodyDef()
            bodyDefC.type = b2Body.b2_Body
            '//bodyDefC.isBullet = True
            circDef = New b2CircleShape((Rnd() * 5 + 10) / m_physScale)
            fd = New b2FixtureDef()
            fd.shape = circDef
            fd.density = 1.0
            '// Override the default friction.
            fd.friction = 0.3
            fd.restitution = 0.1
            bodyDefC.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDefC.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDefC)
            body.CreateFixture(fd)
            m_bodies.Push(body)
        End
        
        For Local i:Int = 0 Until 15
            
            Local bodyDefP :b2BodyDef = New b2BodyDef()
            bodyDefP.type = b2Body.b2_Body
            '//bodyDefP.isBullet = True
            Local polyDef :b2PolygonShape = New b2PolygonShape()
            If (Rnd() > 0.66)
                
                polyDef.SetAsArray([New b2Vec2((-10 -Rnd()*10) / m_physScale, ( 10 +Rnd()*10) / m_physScale),
                New b2Vec2(( -5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale),
                New b2Vec2((  5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale),
                New b2Vec2(( 10 +Rnd() * 10) / m_physScale, ( 10 +Rnd() * 10) / m_physScale)])
            Else  If (Rnd() > 0.5)
                
                
                Local vecarray:b2Vec2[] = New b2Vec2[5]
                vecarray[0] = New b2Vec2(0, (10 +Rnd()*10) / m_physScale)
                vecarray[2] = New b2Vec2((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vecarray[3] = New b2Vec2(( 5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vecarray[1] = New b2Vec2((vecarray[0].x + vecarray[2].x), (vecarray[0].y + vecarray[2].y))
                vecarray[1].Multiply(Rnd()/2+0.8)
                vecarray[4] = New b2Vec2((vecarray[3].x + vecarray[0].x), (vecarray[3].y + vecarray[0].y))
                vecarray[4].Multiply(Rnd() / 2 + 0.8)
                polyDef.SetAsArray(vecarray)
            Else
                
                
                polyDef.SetAsArray([New b2Vec2(0, (10 +Rnd()*10) / m_physScale),
                New b2Vec2((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale),
                New b2Vec2(( 5 +Rnd() * 10) / m_physScale, ( -10 -Rnd() * 10) / m_physScale)])
            End
            
            fd = New b2FixtureDef()
            fd.shape = polyDef
            fd.density = 1.0
            fd.friction = 0.3
            fd.restitution = 0.1
            bodyDefP.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDefP.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDefP)
            body.CreateFixture(fd)
            m_bodies.Push(body)
        End
        '//Add some exciting bath toys
        boxDef.SetAsBox(40 / m_physScale, 10 / m_physScale)
        fd = New b2FixtureDef()
        fd.shape = boxDef
        fd.density = 3.0
        bodyDef.position.Set(50 / m_physScale, 300 / m_physScale)
        bodyDef.angle = 0
        body = m_world.CreateBody(bodyDef)
        body.CreateFixture(fd)
        m_bodies.Push(body)
        bodyDef.position.Set(300/ m_physScale, 300 / m_physScale)
        body = m_world.CreateBody(bodyDef)
        circDef = New b2CircleShape(7 / m_physScale)
        fd = New b2FixtureDef()
        fd.shape = circDef
        fd.density =2
        circDef.m_p.Set(30 / m_physScale, 0 / m_physScale)
        body.CreateFixture(fd)
        circDef.m_p.Set(-30 / m_physScale, 0 / m_physScale)
        body.CreateFixture(fd)
        circDef.m_p.Set(0 / m_physScale, 30 / m_physScale)
        body.CreateFixture(fd)
        circDef.m_p.Set(0 / m_physScale, -30 / m_physScale)
        body.CreateFixture(fd)
        fd = New b2FixtureDef()
        fd.shape = boxDef
        fd.density = 2.0
        boxDef.SetAsBox(30 / m_physScale, 2 / m_physScale)
        body.CreateFixture(fd)
        fd.density = 2.0
        boxDef.SetAsBox(2 / m_physScale, 30 / m_physScale)
        body.CreateFixture(fd)
        m_bodies.Push(body)
        For Local loopBody:b2Body = EachIn m_bodies
            m_controller.AddBody(loopBody)
        End
        m_world.AddController(m_controller)
        '// Set Text field
        name = "Buoyancy"
    End
    '//===========
    '// Member Data
    '//===========
    Method OnRender:Void()
        Super.OnRender()
        '//Draw water line
        SetColor(0,0,255)
        DrawLine(5,height*0.5,width-5,height*0.5)
        '//Its not water without transparency...
        SetAlpha(0.2)
        DrawRect(5,height*0.5,width-10,height*0.5-5)
        SetAlpha(1.0)
    End
End






