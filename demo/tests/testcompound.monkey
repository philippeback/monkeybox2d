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

Class TestCompound Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Compound Shapes"
        Local bd :b2BodyDef
        Local body :b2Body
        Local i :Int
        Local x :Float
        
        Local cd1 :b2CircleShape = New b2CircleShape()
        cd1.SetRadius(15.0/m_physScale)
        cd1.SetLocalPosition(New b2Vec2( -15.0 / m_physScale, 15.0 / m_physScale))
        Local cd2 :b2CircleShape = New b2CircleShape()
        cd2.SetRadius(15.0/m_physScale)
        cd2.SetLocalPosition(New b2Vec2(15.0 / m_physScale, 15.0 / m_physScale))
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        For Local i:Int = 0 Until 5
            
            x = 320.0 + b2Math.RandomRange(-3.0, 3.0)
            bd.position.Set((x + 150.0)/m_physScale, (31.5 + 75.0 * -i + 300.0)/m_physScale)
            bd.angle = b2Math.RandomRange(-Constants.PI, Constants.PI)
            body = m_world.CreateBody(bd)
            body.CreateFixture2(cd1, 2.0)
            body.CreateFixture2(cd2, 0.0)
        End
        
        Local pd1 :b2PolygonShape = New b2PolygonShape()
        pd1.SetAsBox(7.5/m_physScale, 15.0/m_physScale)
        Local pd2 :b2PolygonShape = New b2PolygonShape()
        pd2.SetAsOrientedBox(7.5/m_physScale, 15.0/m_physScale, New b2Vec2(0.0, -15.0/m_physScale), 0.5 * Constants.PI)
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        For Local i:Int = 0 Until 5
            
            x = 320.0 + b2Math.RandomRange(-3.0, 3.0)
            bd.position.Set((x - 150.0)/m_physScale, (31.5 + 75.0 * -i + 300)/m_physScale)
            bd.angle = b2Math.RandomRange(-Constants.PI, Constants.PI)
            body = m_world.CreateBody(bd)
            body.CreateFixture2(pd1, 2.0)
            body.CreateFixture2(pd2, 2.0)
        End
        
        Local xf1 :b2Transform = New b2Transform()
        xf1.R.Set(0.3524 * Constants.PI)
        b2Math.MulMV(xf1.R, New b2Vec2(1.0, 0.0), xf1.position)
        Local sd1 :b2PolygonShape = New b2PolygonShape()
        Local vArr:b2Vec2[] = [New b2Vec2(),New b2Vec2(),New b2Vec2()]
        b2Math.MulX(xf1, New b2Vec2(-30.0/m_physScale, 0.0),vArr[0])
        b2Math.MulX(xf1, New b2Vec2(30.0/m_physScale, 0.0),vArr[1])
        b2Math.MulX(xf1, New b2Vec2(0.0, 15.0 / m_physScale),vArr[2])
        sd1.SetAsArray(vArr)
        Local xf2 :b2Transform = New b2Transform()
        xf2.R.Set(-0.3524 * Constants.PI)
        b2Math.MulMV(xf2.R, New b2Vec2(-30.0/m_physScale, 0.0),xf2.position)
        Local sd2 :b2PolygonShape = New b2PolygonShape()
        b2Math.MulX(xf2, New b2Vec2(-30.0/m_physScale, 0.0),vArr[0])
        b2Math.MulX(xf2, New b2Vec2(30.0/m_physScale, 0.0),vArr[1])
        b2Math.MulX(xf2, New b2Vec2(0.0, 15.0 / m_physScale),vArr[2])
        sd2.SetAsArray(vArr)
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.fixedRotation = False
        
        For Local i:Int = 0 Until 5
            x = 320.0 + b2Math.RandomRange(-3.0, 3.0)
            bd.position.Set(x/m_physScale, (-61.5 + 55.0 * -i + 300)/m_physScale)
            bd.angle = 0.0
            body = m_world.CreateBody(bd)
            body.CreateFixture2(sd1, 2.0)
            body.CreateFixture2(sd2, 2.0)
        End
        
        Local sd_bottom :b2PolygonShape = New b2PolygonShape()
        sd_bottom.SetAsBox( 45.0/m_physScale, 4.5/m_physScale )
        Local sd_left :b2PolygonShape = New b2PolygonShape()
        sd_left.SetAsOrientedBox(4.5/m_physScale, 81.0/m_physScale, New b2Vec2(-43.5/m_physScale, -70.5/m_physScale), -0.2)
        Local sd_right :b2PolygonShape = New b2PolygonShape()
        sd_right.SetAsOrientedBox(4.5/m_physScale, 81.0/m_physScale, New b2Vec2(43.5/m_physScale, -70.5/m_physScale), 0.2)
        bd = New b2BodyDef()
        bd.type = b2Body.b2_Body
        bd.position.Set( 320.0/m_physScale, 300.0/m_physScale )
        body = m_world.CreateBody(bd)
        body.CreateFixture2(sd_bottom, 4.0)
        body.CreateFixture2(sd_left, 4.0)
        body.CreateFixture2(sd_right, 4.0)
    End
End




