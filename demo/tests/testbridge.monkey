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
Class TestBridge Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Bridge"
        Local ground :b2Body = m_world.GetGroundBody()
        Local i :int
        Local anchor :b2Vec2 = New b2Vec2()
        Local body :b2Body
        '// Bridge
        
        Local sd :b2PolygonShape = New b2PolygonShape()
        Local fixtureDef :b2FixtureDef = New b2FixtureDef()
        sd.SetAsBox(24 / m_physScale, 5 / m_physScale)
        fixtureDef.shape = sd
        fixtureDef.density = 20.0
        fixtureDef.friction = 0.2
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        Local jd :b2RevoluteJointDef = New b2RevoluteJointDef()
        const numPlanks:int = 10
        jd.lowerAngle = -15 / (180/Constants.PI)
        jd.upperAngle = 15 / (180/Constants.PI)
        jd.enableLimit = True
        Local prevBody :b2Body = ground
        For Local i:Int = 0 Until numPlanks
            
            bd.position.Set((100 + 22 + 44 * i) / m_physScale, 250 / m_physScale)
            body = m_world.CreateBody(bd)
            body.CreateFixture(fixtureDef)
            anchor.Set((100 + 44 * i) / m_physScale, 250 / m_physScale)
            jd.Initialize(prevBody, body, anchor)
            m_world.CreateJoint(jd)
            prevBody = body
        End
        anchor.Set((100 + 44 * numPlanks) / m_physScale, 250 / m_physScale)
        jd.Initialize(prevBody, ground, anchor)
        m_world.CreateJoint(jd)
        'End
        '// Spawn in a bunch of crap
        For Local i:Int = 0 Until 5
            
            Local bodyDef :b2BodyDef = New b2BodyDef()
            bodyDef.type = b2Body.b2_Body
            Local boxShape :b2PolygonShape = New b2PolygonShape()
            fixtureDef.shape = boxShape
            fixtureDef.density = 1.0
            '// Override the default friction.
            fixtureDef.friction = 0.3
            fixtureDef.restitution = 0.1
            boxShape.SetAsBox((Rnd() * 5 + 10) / m_physScale, (Rnd() * 5 + 10) / m_physScale)
            bodyDef.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDef.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDef)
            body.CreateFixture(fixtureDef)
        End
        
        For Local i:Int = 0 Until 5
            
            Local bodyDefC :b2BodyDef = New b2BodyDef()
            bodyDefC.type = b2Body.b2_Body
            Local circShape :b2CircleShape = New b2CircleShape((Rnd() * 5 + 10) / m_physScale)
            fixtureDef.shape = circShape
            fixtureDef.density = 1.0
            '// Override the default friction.
            fixtureDef.friction = 0.3
            fixtureDef.restitution = 0.1
            bodyDefC.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDefC.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDefC)
            body.CreateFixture(fixtureDef)
        End
        
        Local j :int
        For Local i:Int = 0 Until 15
            
            Local bodyDefP :b2BodyDef = New b2BodyDef()
            bodyDefP.type = b2Body.b2_Body
            Local polyShape :b2PolygonShape = New b2PolygonShape()
            Local vertices :FlashArray<b2Vec2> = New FlashArray<b2Vec2>()
            Local vertexCount :int
            If (Rnd() > 0.66)
                
                vertexCount = 4
                For Local j:Int = 0 Until vertexCount
                    
                    vertices.Set( j,  New b2Vec2() )
                End
                
                vertices.Get(0).Set((-10 -Rnd()*10) / m_physScale, ( 10 +Rnd()*10) / m_physScale)
                vertices.Get(1).Set(( -5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices.Get(2).Set((  5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices.Get(3).Set(( 10 +Rnd()*10) / m_physScale, ( 10 +Rnd()*10) / m_physScale)
            Else  If (Rnd() > 0.5)
                
                
                vertexCount = 5
                For Local j:Int = 0 Until vertexCount
                    
                    vertices.Set( j,  New b2Vec2() )
                End
                
                vertices.Get(0).Set(0, (10 +Rnd()*10) / m_physScale)
                vertices.Get(2).Set((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices.Get(3).Set(( 5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices.Get(1).Set((vertices.Get(0).x + vertices.Get(2).x), (vertices.Get(0).y + vertices.Get(2).y))
                vertices.Get(1).Multiply(Rnd()/2+0.8)
                vertices.Get(4).Set((vertices.Get(3).x + vertices.Get(0).x), (vertices.Get(3).y + vertices.Get(0).y))
                vertices.Get(4).Multiply(Rnd()/2+0.8)
            Else
                
                
                vertexCount = 3
                For Local j:Int = 0 Until vertexCount
                    
                    vertices.Set( j,  New b2Vec2() )
                End
                
                vertices.Get(0).Set(0, (10 +Rnd()*10) / m_physScale)
                vertices.Get(1).Set((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices.Get(2).Set(( 5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
            End
            
            polyShape.SetAsArray( vertices, vertexCount )
            fixtureDef.shape = polyShape
            fixtureDef.density = 1.0
            fixtureDef.friction = 0.3
            fixtureDef.restitution = 0.1
            bodyDefP.position.Set((Rnd() * 400 + 120) / m_physScale, (Rnd() * 150 + 50) / m_physScale)
            bodyDefP.angle = Rnd() * Constants.PI
            body = m_world.CreateBody(bodyDefP)
            body.CreateFixture(fixtureDef)
        End
    End
    '//===========
    '// Member Data
    '//===========
End




