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

Class TestTheoJansen Extends Test
    
    Field tScale:Float
    Field m_offset:b2Vec2 = New b2Vec2()
    Field m_chassis:b2Body
    Field m_wheel:b2Body
    Field m_motorJoint:b2RevoluteJoint
    Field m_motorOn:Bool = True
    Field m_motorSpeed:Float
    
    Method New()
        Super.New()
        '// Set Text field
        name = "Theo Jansen Walker"
        '// scale walker by variable to easily change size
        tScale = m_physScale * 2
        '// Set position in world space
        m_offset.Set(120.0/m_physScale, 250/m_physScale)
        m_motorSpeed = -2.0
        m_motorOn = True
        Local pivot :b2Vec2 = New b2Vec2(0.0, -24.0/tScale)
        Local pd :b2PolygonShape
        Local cd :b2CircleShape
        Local fd :b2FixtureDef
        Local bd :b2BodyDef
        Local body :b2Body
        For Local i:Int = 0 Until 40
            
            cd = New b2CircleShape(7.5/tScale)
            bd = New b2BodyDef()
            bd.type = b2Body.b2_Body
            '// Position in world space
            bd.position.Set((Rnd() * 620 + 10)/m_physScale, 350/m_physScale)
            body = m_world.CreateBody(bd)
            body.CreateFixture2(cd, 1.0)
        End
        
        pd = New b2PolygonShape()
        pd.SetAsBox(75 / tScale, 30 / tScale)
        fd = New b2FixtureDef()
        fd.shape = pd
        fd.density = 1.0
        fd.filter.groupIndex = -1
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        '//bd.position = pivot + m_offset
        b2Math.AddVV(pivot, m_offset, bd.position)
        m_chassis = m_world.CreateBody(bd)
        m_chassis.CreateFixture(fd)
        'End
        
        cd = New b2CircleShape(48 / tScale)
        fd = New b2FixtureDef()
        fd.shape = cd
        fd.density = 1.0
        fd.filter.groupIndex = -1
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        '//bd.position = pivot + m_offset
        b2Math.AddVV(pivot, m_offset, bd.position)
        m_wheel = m_world.CreateBody(bd)
        m_wheel.CreateFixture(fd)
        
        
        Local jd :b2RevoluteJointDef = New b2RevoluteJointDef()
        Local po :b2Vec2 = pivot.Copy()
        po.Add(m_offset)
        jd.Initialize(m_wheel, m_chassis, po)
        jd.collideConnected = False
        jd.motorSpeed = m_motorSpeed
        jd.maxMotorTorque = 400.0
        jd.enableMotor = m_motorOn
        m_motorJoint = b2RevoluteJoint(m_world.CreateJoint(jd))
        
        Local wheelAnchor :b2Vec2
        '//wheelAnchor = pivot + b2Vec2(0.0f, -0.8)
        wheelAnchor = New b2Vec2(0.0, 24.0/tScale)
        wheelAnchor.Add(pivot)
        CreateLeg(-1.0, wheelAnchor)
        CreateLeg(1.0, wheelAnchor)
        m_wheel.SetPositionAndAngle(m_wheel.GetPosition(), 120.0 * Constants.PI / 180.0)
        CreateLeg(-1.0, wheelAnchor)
        CreateLeg(1.0, wheelAnchor)
        m_wheel.SetPositionAndAngle(m_wheel.GetPosition(), -120.0 * Constants.PI / 180.0)
        CreateLeg(-1.0, wheelAnchor)
        CreateLeg(1.0, wheelAnchor)
    End
    
    Method CreateLeg : void (s:Float, wheelAnchor:b2Vec2)
        Local p1 :b2Vec2 = New b2Vec2(162 * s/tScale, 183/tScale)
        Local p2 :b2Vec2 = New b2Vec2(216 * s/tScale, 36 /tScale)
        Local p3 :b2Vec2 = New b2Vec2(129 * s/tScale, 57 /tScale)
        Local p4 :b2Vec2 = New b2Vec2( 93 * s/tScale, -24  /tScale)
        Local p5 :b2Vec2 = New b2Vec2(180 * s/tScale, -45  /tScale)
        Local p6 :b2Vec2 = New b2Vec2( 75 * s/tScale, -111 /tScale)
        Local tmp1 :b2Vec2 = New b2Vec2()
        Local tmp2 :b2Vec2 = New b2Vec2()
        Local tmp3 :b2Vec2 = New b2Vec2()
        '//b2PolygonDef sd1, sd2
        Local sd1 :b2PolygonShape = New b2PolygonShape()
        Local sd2 :b2PolygonShape = New b2PolygonShape()
        Local fd1 :b2FixtureDef = New b2FixtureDef()
        Local fd2 :b2FixtureDef = New b2FixtureDef()
        fd1.shape = sd1
        fd2.shape = sd2
        fd1.filter.groupIndex = -1
        fd2.filter.groupIndex = -1
        fd1.density = 1.0
        fd2.density = 1.0
        If (s > 0.0)
            sd1.SetAsArray([p3, p2, p1])
            b2Math.SubtractVV(p6, p4, tmp1)
            b2Math.SubtractVV(p5, p4, tmp2) 
            sd2.SetAsArray([tmp1, tmp2, New b2Vec2()])
        Else
            sd1.SetAsArray([p2, p3, p1])
            b2Math.SubtractVV(p5, p4, tmp1)
            b2Math.SubtractVV(p6, p4, tmp2)
            sd2.SetAsArray([tmp1, tmp2, New b2Vec2()])
        End
        '//b2BodyDef bd1, bd2
        Local bd1 :b2BodyDef = New b2BodyDef()
        bd1.type = b2Body.b2_Body
        Local bd2 :b2BodyDef = New b2BodyDef()
        bd2.type = b2Body.b2_Body
        bd1.position.SetV(m_offset)
        b2Math.AddVV(p4, m_offset, bd2.position)
        bd1.angularDamping = 10.0
        bd2.angularDamping = 10.0
        Local body1 :b2Body = m_world.CreateBody(bd1)
        Local body2 :b2Body = m_world.CreateBody(bd2)
        body1.CreateFixture(fd1)
        body2.CreateFixture(fd2)
        Local djd :b2DistanceJointDef = New b2DistanceJointDef()
        '// Using a soft distance constraint can reduce some jitter.
        '// It also makes the structure seem a bit more fluid by
        '// acting like a suspension system.
        djd.dampingRatio = 0.5
        djd.frequencyHz = 10.0
        b2Math.AddVV(p2, m_offset, tmp1)
        b2Math.AddVV(p5, m_offset, tmp2)
        djd.Initialize(body1, body2, tmp1, tmp2 )
        m_world.CreateJoint(djd)
        b2Math.AddVV(p3, m_offset, tmp1)
        b2Math.AddVV(p4, m_offset, tmp2)
        djd.Initialize(body1, body2, tmp1, tmp2)
        m_world.CreateJoint(djd)
        b2Math.AddVV(p3, m_offset, tmp1)
        b2Math.AddVV(wheelAnchor, m_offset, tmp2)
        djd.Initialize(body1, m_wheel, tmp1, tmp2 )
        m_world.CreateJoint(djd)
        b2Math.AddVV(p6, m_offset, tmp1)
        b2Math.AddVV(wheelAnchor, m_offset, tmp2)
        djd.Initialize(body2, m_wheel, tmp1, tmp2)
        m_world.CreateJoint(djd)
        Local rjd :b2RevoluteJointDef = New b2RevoluteJointDef()
        b2Math.AddVV(p4, m_offset, tmp1)
        rjd.Initialize(body2, m_chassis, tmp1)
        m_world.CreateJoint(rjd)
    End
    
    Method Update : void ()
        '//case a:
        If (KeyHit(65))
            '// A
            
            
            m_chassis.SetAwake(True)
            m_motorJoint.SetMotorSpeed(-m_motorSpeed)
        End
        
        '//case s:
        If (KeyHit(83))
            '// S
            
            
            m_chassis.SetAwake(True)
            m_motorJoint.SetMotorSpeed(0.0)
        End
        
        '//case d:
        If (KeyHit(68))
            '// D
            
            
            m_chassis.SetAwake(True)
            m_motorJoint.SetMotorSpeed(m_motorSpeed)
        End
        
        '//case m:
        If (KeyHit(77))
            '// M
            
            
            m_chassis.SetAwake(True)
            m_motorJoint.EnableMotor(Not(m_motorJoint.IsMotorEnabled()))
        End
        '// Finally update super class
        Super.Update()
    End
    
End




