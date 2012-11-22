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


Class TestStack Extends Test
    Method New()
        Super.New()
        '// Set Text field
        name = "Stacked Boxes"
        '// Add bodies
        Local fd :b2FixtureDef = New b2FixtureDef()
        Local sd :b2PolygonShape = New b2PolygonShape()
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        '//bd.isBullet = True
        Local b :b2Body
        fd.density = 1.0
        fd.friction = 0.5
        fd.restitution = 0.1
        fd.shape = sd
        Local i :int
        '// Create 3 stacks
        For Local i:Int = 0 Until 10
            
            sd.SetAsBox((10) / m_physScale, (10) / m_physScale)
            '//bd.position.Set((640/2+100+Rnd()*0.02 - 0.01) / m_physScale, (360-5-i*25) / m_physScale)
            bd.position.Set((640/2+100) / m_physScale, (360-5-i*25) / m_physScale)
            b = m_world.CreateBody(bd)
            b.CreateFixture(fd)
        End
        
        For Local i:Int = 0 Until 10
            
            sd.SetAsBox((10) / m_physScale, (10) / m_physScale)
            bd.position.Set((640/2-0+Rnd()*0.02 - 0.01) / m_physScale, (360-5-i*25) / m_physScale)
            b = m_world.CreateBody(bd)
            b.CreateFixture(fd)
        End
        
        For Local i:Int = 0 Until 10
            
            sd.SetAsBox((10) / m_physScale, (10) / m_physScale)
            bd.position.Set((640/2+200+Rnd()*0.02 - 0.01) / m_physScale, (360-5-i*25) / m_physScale)
            b = m_world.CreateBody(bd)
            b.CreateFixture(fd)
        End
        
        '// Create ramp
        Local vxs := [New b2Vec2(0, 0),
        New b2Vec2(0, -100 / m_physScale),
        New b2Vec2(200 / m_physScale, 0)]
        sd.SetAsArray(vxs, vxs.Length)
        fd.density = 0
        bd.type = b2Body.b2_staticBody
        bd.userData = New StringObject("ramp")
        bd.position.Set(5 / m_physScale, (height-5) / m_physScale)
        b = m_world.CreateBody(bd)
        b.CreateFixture(fd)
        '// Create ball
        Local cd :b2CircleShape = New b2CircleShape()
        cd.m_radius = 40/m_physScale
        fd.density = 2
        fd.restitution = 0.2
        fd.friction = 0.5
        fd.shape = cd
        bd.type = b2Body.b2_Body
        bd.userData = New StringObject("ball")
        bd.position.Set(50/m_physScale, 100 / m_physScale)
        b = m_world.CreateBody(bd)
        b.CreateFixture(fd)
    End
    '//===========
    '// Member Data
    '//===========
End



