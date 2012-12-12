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

Class SensorContactListener Extends b2ContactListener
    Field sensor:b2Body
    Field ball:b2Body

    Method New(sensor:b2Body)
        Self.sensor = sensor
    End
    
    Method BeginContact:void (contact:b2Contact)
        If contact.GetFixtureA().GetBody() = sensor Or contact.GetFixtureB().GetBody() = sensor
            TestSensor.sensorColliding = True
        End
    End
    
    Method EndContact : void (contact:b2Contact)
        If contact.GetFixtureA().GetBody() = sensor Or contact.GetFixtureB().GetBody() = sensor
            TestSensor.sensorColliding = False
        End
    End
    
End

Class TestSensor Extends Test
    Global sensorColliding:Bool = False
    Field sensor:b2Body
    
    Method New()
        Super.New()
        
        '// Set Text field
        name = "Sensor"
        m_world.SetGravity(New b2Vec2(0, 0))
        Local ground :b2Body = m_world.GetGroundBody()
        Local box:b2PolygonShape = New b2PolygonShape()
        box.SetAsBox(100 / m_physScale, 100 / m_physScale)
        Local fd :b2FixtureDef = New b2FixtureDef()
        fd.shape = box
        fd.density = 4
        fd.friction = 0.4
        fd.restitution = 0.3
        fd.userData = New StringObject("sensor")
        fd.isSensor = True
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(320 / m_physScale, 150 / m_physScale)
        'bd.position.Set(40 / m_physScale, 150 / m_physScale)
        sensor = m_world.CreateBody(bd)
        sensor.CreateFixture(fd)
        m_world.SetContactListener(New SensorContactListener(sensor))
        
        Local circle:b2CircleShape = New b2CircleShape(30 / m_physScale)
        fd.shape = circle
        fd.density = 4
        fd.friction = 0.4
        fd.restitution = 0.3
        fd.userData = New StringObject("circle")
        bd.position.Set(100 / m_physScale, 100 / m_physScale)
        Local body :b2Body = m_world.CreateBody(bd)
        body.CreateFixture(fd)
    End
    
    Method Update:Void ()
        Super.Update()
    End
    
    Method OnRender:Void()
        Super.OnRender()
        If sensorColliding
            m_world.DrawBody(sensor, New b2Color(0, 1.0, 1.0))
        End
    End
End



