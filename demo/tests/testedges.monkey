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

Class TestEdges Extends Test
    
    Method New()
        Super.New()
        '// Set Text field
        name = "Edge Chains"
        
        
        Local ground :b2Body = m_world.GetGroundBody()
        Local i :int
        Local body :b2Body
        '// edge
        
        Local sv:b2Vec2 = New b2Vec2(100/m_physScale,250/m_physScale)
        Local ev:b2Vec2 = New b2Vec2(500/m_physScale,250/m_physScale)
        
        'Local sd :b2EdgeShape = New b2EdgeShape(sv,ev)
        Local sd :b2PolygonShape = New b2PolygonShape()
        sd.SetAsEdge(sv,ev)
        Local fixtureDef :b2FixtureDef = New b2FixtureDef()
       
        fixtureDef.shape = sd
        fixtureDef.density = 20.0
        fixtureDef.friction = 0.2
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_staticBody
        body = m_world.CreateBody(bd)
        body.CreateFixture(fixtureDef)
        
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
            Local vertices : b2Vec2[]
            Local vertexCount :int
            If (Rnd() > 0.66)
                
                vertexCount = 4
                vertices = New b2Vec2[vertexCount]
                For Local j:Int = 0 Until vertexCount
                    vertices[j] = New b2Vec2()
                End
                
                vertices[0].Set((-10 -Rnd()*10) / m_physScale, ( 10 +Rnd()*10) / m_physScale)
                vertices[1].Set(( -5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices[2].Set((  5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices[3].Set(( 10 +Rnd()*10) / m_physScale, ( 10 +Rnd()*10) / m_physScale)
            Else  If (Rnd() > 0.5)
                
                vertexCount = 5
                vertices = New b2Vec2[vertexCount]
                For Local j:Int = 0 Until vertexCount
                    vertices[j] = New b2Vec2()
                End
                
                vertices[0].Set(0, (10 +Rnd()*10) / m_physScale)
                vertices[2].Set((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices[3].Set(( 5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices[1].Set((vertices[0].x + vertices[2].x), (vertices[0].y + vertices[2].y))
                vertices[1].Multiply(Rnd()/2+0.8)
                vertices[4].Set((vertices[3].x + vertices[0].x), (vertices[3].y + vertices[0].y))
                vertices[4].Multiply(Rnd()/2+0.8)
            Else
                
                vertexCount = 3
                vertices = New b2Vec2[vertexCount]
                For Local j:Int = 0 Until vertexCount
                    vertices[j] = New b2Vec2()
                End
                
                vertices[0].Set(0, (10 +Rnd()*10) / m_physScale)
                vertices[1].Set((-5 -Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
                vertices[2].Set(( 5 +Rnd()*10) / m_physScale, (-10 -Rnd()*10) / m_physScale)
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
End



