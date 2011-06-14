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

Class TestRagdoll Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Ragdolls"
        Local circ :b2CircleShape
        Local box :b2PolygonShape
        Local bd :b2BodyDef = New b2BodyDef()
        Local jd :b2RevoluteJointDef = New b2RevoluteJointDef()
        Local fixtureDef :b2FixtureDef = New b2FixtureDef()
        Local head :b2Body
        '// Add 5 ragdolls along the top
        For Local i:Int = 0 Until 2
            
            Local startX :Float = 70 + Rnd() * 20 + width * i
            Local startY :Float = 20 + Rnd() * 50
            '// BODIES
            '// Set these to  bodies
            bd.type = b2Body.b2_Body
            '// Head
            circ = New b2CircleShape( 12.5 / m_physScale )
            fixtureDef.shape = circ
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.3
            bd.position.Set(startX / m_physScale, startY / m_physScale)
            head = m_world.CreateBody(bd)
            head.CreateFixture(fixtureDef)
            '//if (i = 0){
            head.ApplyImpulse(New b2Vec2(Rnd() * 100 - 50, Rnd() * 100 - 50), head.GetWorldCenter())
            '//}
            '// Torso1
            box = New b2PolygonShape()
            box.SetAsBox(15 / m_physScale, 10 / m_physScale)
            fixtureDef.shape = box
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.1
            bd.position.Set(startX / m_physScale, (startY + 28) / m_physScale)
            Local torso1 :b2Body = m_world.CreateBody(bd)
            torso1.CreateFixture(fixtureDef)
            '// Torso2
            box = New b2PolygonShape()
            box.SetAsBox(15 / m_physScale, 10 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set(startX / m_physScale, (startY + 43) / m_physScale)
            Local torso2 :b2Body = m_world.CreateBody(bd)
            torso2.CreateFixture(fixtureDef)
            '// Torso3
            box.SetAsBox(15 / m_physScale, 10 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set(startX / m_physScale, (startY + 58) / m_physScale)
            Local torso3 :b2Body = m_world.CreateBody(bd)
            torso3.CreateFixture(fixtureDef)
            '// UpperArm
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.1
            '// L
            box = New b2PolygonShape()
            box.SetAsBox(18 / m_physScale, 6.5 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX - 30) / m_physScale, (startY + 20) / m_physScale)
            Local upperArmL :b2Body = m_world.CreateBody(bd)
            upperArmL.CreateFixture(fixtureDef)
            '// R
            box = New b2PolygonShape()
            box.SetAsBox(18 / m_physScale, 6.5 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX + 30) / m_physScale, (startY + 20) / m_physScale)
            Local upperArmR :b2Body = m_world.CreateBody(bd)
            upperArmR.CreateFixture(fixtureDef)
            '// LowerArm
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.1
            '// L
            box = New b2PolygonShape()
            box.SetAsBox(17 / m_physScale, 6 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX - 57) / m_physScale, (startY + 20) / m_physScale)
            Local lowerArmL :b2Body = m_world.CreateBody(bd)
            lowerArmL.CreateFixture(fixtureDef)
            '// R
            box = New b2PolygonShape()
            box.SetAsBox(17 / m_physScale, 6 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX + 57) / m_physScale, (startY + 20) / m_physScale)
            Local lowerArmR :b2Body = m_world.CreateBody(bd)
            lowerArmR.CreateFixture(fixtureDef)
            '// UpperLeg
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.1
            '// L
            box = New b2PolygonShape()
            box.SetAsBox(7.5 / m_physScale, 22 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX - 8) / m_physScale, (startY + 85) / m_physScale)
            Local upperLegL :b2Body = m_world.CreateBody(bd)
            upperLegL.CreateFixture(fixtureDef)
            '// R
            box = New b2PolygonShape()
            box.SetAsBox(7.5 / m_physScale, 22 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX + 8) / m_physScale, (startY + 85) / m_physScale)
            Local upperLegR :b2Body = m_world.CreateBody(bd)
            upperLegR.CreateFixture(fixtureDef)
            '// LowerLeg
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.4
            fixtureDef.restitution = 0.1
            '// L
            box = New b2PolygonShape()
            box.SetAsBox(6 / m_physScale, 20 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX - 8) / m_physScale, (startY + 120) / m_physScale)
            Local lowerLegL :b2Body = m_world.CreateBody(bd)
            lowerLegL.CreateFixture(fixtureDef)
            '// R
            box = New b2PolygonShape()
            box.SetAsBox(6 / m_physScale, 20 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((startX + 8) / m_physScale, (startY + 120) / m_physScale)
            Local lowerLegR :b2Body = m_world.CreateBody(bd)
            lowerLegR.CreateFixture(fixtureDef)
            '// JOINTS
            jd.enableLimit = True
            '// Head to shoulders
            jd.lowerAngle = -40 / (180/Constants.PI)
            jd.upperAngle = 40 / (180/Constants.PI)
            jd.Initialize(torso1, head, New b2Vec2(startX / m_physScale, (startY + 15) / m_physScale))
            m_world.CreateJoint(jd)
            '// Upper arm to shoulders
            '// L
            jd.lowerAngle = -85 / (180/Constants.PI)
            jd.upperAngle = 130 / (180/Constants.PI)
            jd.Initialize(torso1, upperArmL, New b2Vec2((startX - 18) / m_physScale, (startY + 20) / m_physScale))
            m_world.CreateJoint(jd)
            '// R
            jd.lowerAngle = -130 / (180/Constants.PI)
            jd.upperAngle = 85 / (180/Constants.PI)
            jd.Initialize(torso1, upperArmR, New b2Vec2((startX + 18) / m_physScale, (startY + 20) / m_physScale))
            m_world.CreateJoint(jd)
            '// Lower arm to upper arm
            '// L
            jd.lowerAngle = -130 / (180/Constants.PI)
            jd.upperAngle = 10 / (180/Constants.PI)
            jd.Initialize(upperArmL, lowerArmL, New b2Vec2((startX - 45) / m_physScale, (startY + 20) / m_physScale))
            m_world.CreateJoint(jd)
            '// R
            jd.lowerAngle = -10 / (180/Constants.PI)
            jd.upperAngle = 130 / (180/Constants.PI)
            jd.Initialize(upperArmR, lowerArmR, New b2Vec2((startX + 45) / m_physScale, (startY + 20) / m_physScale))
            m_world.CreateJoint(jd)
            '// Shoulders/stomach
            jd.lowerAngle = -15 / (180/Constants.PI)
            jd.upperAngle = 15 / (180/Constants.PI)
            jd.Initialize(torso1, torso2, New b2Vec2(startX / m_physScale, (startY + 35) / m_physScale))
            m_world.CreateJoint(jd)
            '// Stomach/hips
            jd.Initialize(torso2, torso3, New b2Vec2(startX / m_physScale, (startY + 50) / m_physScale))
            m_world.CreateJoint(jd)
            '// Torso to upper leg
            '// L
            jd.lowerAngle = -25 / (180/Constants.PI)
            jd.upperAngle = 45 / (180/Constants.PI)
            jd.Initialize(torso3, upperLegL, New b2Vec2((startX - 8) / m_physScale, (startY + 72) / m_physScale))
            m_world.CreateJoint(jd)
            '// R
            jd.lowerAngle = -45 / (180/Constants.PI)
            jd.upperAngle = 25 / (180/Constants.PI)
            jd.Initialize(torso3, upperLegR, New b2Vec2((startX + 8) / m_physScale, (startY + 72) / m_physScale))
            m_world.CreateJoint(jd)
            '// Upper leg to lower leg
            '// L
            jd.lowerAngle = -25 / (180/Constants.PI)
            jd.upperAngle = 115 / (180/Constants.PI)
            jd.Initialize(upperLegL, lowerLegL, New b2Vec2((startX - 8) / m_physScale, (startY + 105) / m_physScale))
            m_world.CreateJoint(jd)
            '// R
            jd.lowerAngle = -115 / (180/Constants.PI)
            jd.upperAngle = 25 / (180/Constants.PI)
            jd.Initialize(upperLegR, lowerLegR, New b2Vec2((startX + 8) / m_physScale, (startY + 105) / m_physScale))
            m_world.CreateJoint(jd)
        End
        '// Add stairs on the left, these are static bodies so set the type accordingly
        bd.type = b2Body.b2_staticBody
        fixtureDef.density = 0.0
        fixtureDef.friction = 0.4
        fixtureDef.restitution = 0.3
        For Local j:Int = 1 Until 10
            
            box = New b2PolygonShape()
            box.SetAsBox((10*j) / m_physScale, 10 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((10*j) / m_physScale, (height-5-200 + 20*j) / m_physScale)
            head = m_world.CreateBody(bd)
            head.CreateFixture(fixtureDef)
        End
        '// Add stairs on the right
        For Local k:Int = 1 Until 10
            
            box = New b2PolygonShape()
            box.SetAsBox((10 * k) / m_physScale, 10 / m_physScale)
            fixtureDef.shape = box
            bd.position.Set((640-10*k) / m_physScale, (height-5-200 + 20*k) / m_physScale)
            head = m_world.CreateBody(bd)
            head.CreateFixture(fixtureDef)
        End
        box = New b2PolygonShape()
        box.SetAsBox(30 / m_physScale, 40 / m_physScale)
        fixtureDef.shape = box
        bd.position.Set((width*0.5) / m_physScale, (height-40) / m_physScale)
        head = m_world.CreateBody(bd)
        head.CreateFixture(fixtureDef)
    End
    '//===========
    '// Member Data
    '//===========
End




