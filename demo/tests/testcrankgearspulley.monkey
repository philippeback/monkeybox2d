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

Class TestCrankGearsPulley Extends Test
    
    Method New()
        Super.New()
        '// Set Text field
        name = "Joints"
        Local ground :b2Body = m_world.GetGroundBody()
        Local body :b2Body
        Local circleBody :b2Body
        Local sd :b2PolygonShape
        Local bd :b2BodyDef
        Local fixtureDef :b2FixtureDef = New b2FixtureDef()
        '//
        '// CRANK
        '//
        
        '// Define crank.
        sd = New b2PolygonShape()
        sd.SetAsBox(7.5 / m_physScale, 30.0 / m_physScale)
        fixtureDef.shape = sd
        fixtureDef.density = 1.0
        Local rjd :b2RevoluteJointDef = New b2RevoluteJointDef()
        Local prevBody :b2Body = ground
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(100.0/m_physScale, (360.0-105.0)/m_physScale)
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        rjd.Initialize(prevBody, body, New b2Vec2(100.0/m_physScale, (360.0-75.0)/m_physScale))
        rjd.motorSpeed = 1.0 * -Constants.PI
        rjd.maxMotorTorque = 5000.0
        rjd.enableMotor = True
        m_joint1 = b2RevoluteJoint(m_world.CreateJoint(rjd))
        prevBody = body
        '// Define follower.
        sd = New b2PolygonShape
        sd.SetAsBox(7.5 / m_physScale, 60.0 / m_physScale)
        fixtureDef.shape = sd
        bd.position.Set(100.0/m_physScale, (360.0-195.0)/m_physScale)
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        rjd.Initialize(prevBody, body, New b2Vec2(100.0/m_physScale, (360.0-135.0)/m_physScale))
        rjd.enableMotor = False
        m_world.CreateJoint(rjd)
        prevBody = body
        '// Define piston
        sd = New b2PolygonShape()
        sd.SetAsBox(22.5 / m_physScale, 22.5 / m_physScale)
        fixtureDef.shape = sd
        bd.position.Set(100.0/m_physScale, (360.0-255.0)/m_physScale)
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        rjd.Initialize(prevBody, body, New b2Vec2(100.0/m_physScale, (360.0-255.0)/m_physScale))
        m_world.CreateJoint(rjd)
        Local pjd :b2PrismaticJointDef = New b2PrismaticJointDef()
        pjd.Initialize(ground, body, New b2Vec2(100.0/m_physScale, (360.0-255.0)/m_physScale), New b2Vec2(0.0, 1.0))
        pjd.maxMotorForce = 500.0
        pjd.enableMotor = True
        m_joint2 = b2PrismaticJoint(m_world.CreateJoint(pjd))
        '// Create a payload
        sd = New b2PolygonShape()
        sd.SetAsBox(22.5 / m_physScale, 22.5 / m_physScale)
        fixtureDef.shape = sd
        fixtureDef.density = 2.0
        bd.position.Set(100.0/m_physScale, (360.0-345.0)/m_physScale)
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        
        '//
        '// GEARS
        '//
        '//{
        Local circle1 :b2CircleShape = New b2CircleShape(25 / m_physScale)
        fixtureDef.shape = circle1
        fixtureDef.density = 5.0
        Local bd1 :b2BodyDef = New b2BodyDef()
        bd1.type = b2Body.b2_Body
        bd1.position.Set(200 / m_physScale, 360/2 / m_physScale)
        Local body1 :b2Body = m_world.CreateBody(bd1)
        body1.CreateFixture(fixtureDef)
        Local jd1 :b2RevoluteJointDef = New b2RevoluteJointDef()
        jd1.Initialize(ground, body1, bd1.position)
        m_gJoint1 = b2RevoluteJoint(m_world.CreateJoint(jd1))
        Local circle2 :b2CircleShape = New b2CircleShape(50 / m_physScale)
        fixtureDef.shape = circle2
        fixtureDef.density = 5.0
        Local bd2 :b2BodyDef = New b2BodyDef()
        bd2.type = b2Body.b2_Body
        bd2.position.Set(275 / m_physScale, 360/2 / m_physScale)
        Local body2 :b2Body = m_world.CreateBody(bd2)
        body2.CreateFixture(fixtureDef)
        Local jd2 :b2RevoluteJointDef = New b2RevoluteJointDef()
        jd2.Initialize(ground, body2, bd2.position)
        m_gJoint2 = b2RevoluteJoint(m_world.CreateJoint(jd2))
        Local box :b2PolygonShape = New b2PolygonShape()
        box.SetAsBox(10 / m_physScale, 100 / m_physScale)
        fixtureDef.shape = box
        fixtureDef.density = 5.0
        Local bd3 :b2BodyDef = New b2BodyDef()
        bd3.type = b2Body.b2_Body
        bd3.position.Set(335 / m_physScale, 360/2 / m_physScale)
        Local body3 :b2Body = m_world.CreateBody(bd3)
        body3.CreateFixture(fixtureDef)
        Local jd3 :b2PrismaticJointDef = New b2PrismaticJointDef()
        jd3.Initialize(ground, body3, bd3.position, New b2Vec2(0,1))
        jd3.lowerTranslation = -25.0 / m_physScale
        jd3.upperTranslation = 100.0 / m_physScale
        jd3.enableLimit = True
        m_gJoint3 = b2PrismaticJoint(m_world.CreateJoint(jd3))
        Local jd4 :b2GearJointDef = New b2GearJointDef()
        jd4.bodyA = body1
        jd4.bodyB = body2
        jd4.joint1 = m_gJoint1
        jd4.joint2 = m_gJoint2
        jd4.ratio = circle2.GetRadius() / circle1.GetRadius()
        m_gJoint4 = b2GearJoint(m_world.CreateJoint(jd4))
        Local jd5 :b2GearJointDef = New b2GearJointDef()
        jd5.bodyA = body2
        jd5.bodyB = body3
        jd5.joint1 = m_gJoint2
        jd5.joint2 = m_gJoint3
        jd5.ratio = -1.0 / circle2.GetRadius()
        m_gJoint5 = b2GearJoint(m_world.CreateJoint(jd5))
        '//}
        '//
        '// PULLEY
        '//
        '//{
        sd = New b2PolygonShape()
        sd.SetAsBox(50 / m_physScale, 20 / m_physScale)
        fixtureDef.shape = sd
        fixtureDef.density = 5.0
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(480 / m_physScale, 200 / m_physScale)
        body2 = m_world.CreateBody(bd)
        body2.CreateFixture(fixtureDef)
        Local pulleyDef :b2PulleyJointDef = New b2PulleyJointDef()
        Local anchor1 :b2Vec2 = New b2Vec2(335 / m_physScale, 180 / m_physScale)
        Local anchor2 :b2Vec2 = New b2Vec2(480 / m_physScale, 180 / m_physScale)
        Local groundAnchor1 :b2Vec2 = New b2Vec2(335 / m_physScale, 50 / m_physScale)
        Local groundAnchor2 :b2Vec2 = New b2Vec2(480 / m_physScale, 50 / m_physScale)
        pulleyDef.Initialize(body3, body2, groundAnchor1, groundAnchor2, anchor1, anchor2, 2.0)
        pulleyDef.maxLengthA = 200 / m_physScale
        pulleyDef.maxLengthB = 150 / m_physScale
        m_world.CreateJoint(pulleyDef)
        '// Add a circle to weigh down the pulley
        Local circ :b2CircleShape = New b2CircleShape(40 / m_physScale)
        fixtureDef.shape = circ
        fixtureDef.friction = 0.3
        fixtureDef.restitution = 0.3
        fixtureDef.density = 5.0
        bd.position.Set(485 / m_physScale, 100 / m_physScale)
        body1 = m_world.CreateBody(bd)
        circleBody = body1
        body1.CreateFixture(fixtureDef)
        
        '//}
        '//
        '// LINE JOINT
        '//
        
        sd = New b2PolygonShape()
        sd.SetAsBox(7.5 / m_physScale, 30.0 / m_physScale)
        fixtureDef.shape = sd
        fixtureDef.density = 1.0
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set(500 / m_physScale, 500/2 / m_physScale)
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        Local ljd :b2LineJointDef = New b2LineJointDef()
        ljd.Initialize(ground, body, body.GetPosition(), New b2Vec2(0.4, 0.6))
        ljd.lowerTranslation = -1
        ljd.upperTranslation = 1
        ljd.enableLimit = True
        ljd.maxMotorForce = 1
        ljd.motorSpeed = 0
        ljd.enableMotor = True
        m_world.CreateJoint(ljd)
        
        '//
        '// FRICTION JOINT
        '//
        
        Local fjd :b2FrictionJointDef = New b2FrictionJointDef()
        fjd.Initialize(circleBody, m_world.GetGroundBody(), circleBody.GetPosition())
        fjd.collideConnected = True
        fjd.maxForce = 200
        m_world.CreateJoint(fjd)
        
        '//
        '// WELD JOINT
        '//
        '// Not Weld(enabled) joints are not encouraged compared with merging two bodies
        If(False)
            Local wjd :b2WeldJointDef = New b2WeldJointDef()
            wjd.Initialize(circleBody, body, circleBody.GetPosition())
            m_world.CreateJoint(wjd)
        End
    End
    '//===========
    '// Member Data
    '//===========
    Field m_joint1:b2RevoluteJoint
    
    
    Field m_joint2:b2PrismaticJoint
    
    Field m_gJoint1:b2RevoluteJoint
    
    
    Field m_gJoint2:b2RevoluteJoint
    
    
    Field m_gJoint3:b2PrismaticJoint
    
    
    Field m_gJoint4:b2GearJoint
    
    
    Field m_gJoint5:b2GearJoint
    
End





