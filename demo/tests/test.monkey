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
Import box2d.demo.maindemo
Import box2d.dynamics
Import box2d.collision
Import box2d.collision.shapes
Import box2d.dynamics.joints
Import box2d.dynamics.contacts
Import box2d.common
Import box2d.common.math


Class TestQueryAABBCallback Extends QueryFixtureCallback
    
    Field includeStatic: Bool
    Field mousePVec:b2Vec2
    Field body:b2Body = null
    
    Method New( includeStatic:Bool, mousePVec:b2Vec2 )
        Self.includeStatic = includeStatic
        Self.mousePVec = mousePVec
    End
    
    '// Query the world for overlapping shapes.
    Method Callback : Bool (fixture:b2Fixture)
        Local shape :b2Shape = fixture.GetShape()
        
        If (fixture.GetBody().GetType() <> b2Body.b2_staticBody  Or  includeStatic)
            Local inside :Bool = shape.TestPoint(fixture.GetBody().GetTransform(), mousePVec)
            If (inside)
                body = fixture.GetBody()
                Return False
            End
        End
        
        Return True
    End
    
End

'Class TestRenderer Extends FlashDisplayObject
'    Field m_world:b2World
'    
'    Method New(world:b2World)
'        m_world = world
'    End
'    
'    Method OnRender:Int()
'        '// Render
'        m_world.DrawDebugData()
'    End
'End

Class Test
    Field width:Int = 640
    Field height:Int = 480
    Field name:String = "Base"
    
    Field m_world:b2World
    Field m_bomb:b2Body
    Field m_mouseJoint:b2MouseJoint
    Field m_velocityIterations:int = 10
    Field m_positionIterations:int = 10
    Field m_timeStep:Float = 1.0/MainDemo.physicsRate
    Field m_physScale:Float = 30
    
    '// world mouse position
    Global mouseXWorldPhys:Float
    Global mouseYWorldPhys:Float
    Global mouseXWorld:Float
    Global mouseYWorld:Float
    '// Sprite to draw in to
    Field m_sprite:FlashSprite
    
    
    Method New()
        m_sprite = MainDemo.m_display
        Local worldAABB :b2AABB = New b2AABB()
        worldAABB.lowerBound.Set(-1000.0, -1000.0)
        worldAABB.upperBound.Set(1000.0, 1000.0)
        '// Define the gravity vector
        Local gravity :b2Vec2 = New b2Vec2(0.0, 10.0)
        '// Allow bodies to sleep
        Local doSleep :Bool = True
        '// Construct a world object
        m_world = New b2World(gravity, doSleep)
        m_world.SetWarmStarting(True)
        '// set debug draw
        Local dbgDraw :b2DebugDraw = New b2DebugDraw()
        
        dbgDraw.SetSprite(m_sprite)
        dbgDraw.SetDrawScale(30.0)
        dbgDraw.SetFillAlpha(0.3)
        dbgDraw.SetLineThickness(1.0)
        dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit)'| b2DebugDraw.e_pairBit)
        m_world.SetDebugDraw(dbgDraw)
        
        '// Create border of boxes
        Local wall :b2PolygonShape= New b2PolygonShape()
        Local wallBd :b2BodyDef = New b2BodyDef()
        Local wallB :b2Body
        
        '// Left
        wallBd.position.Set( -95 / m_physScale, height / m_physScale / 2)
        wall.SetAsBox(100/m_physScale, height+100/m_physScale/2)
        wallB = m_world.CreateBody(wallBd)
        wallB.CreateFixture2(wall)
        '// Right
        wallBd.position.Set((width+95) / m_physScale, height / m_physScale / 2)
        wallB = m_world.CreateBody(wallBd)
        wallB.CreateFixture2(wall)
        '// Top
        wallBd.position.Set(width / m_physScale / 2, -95 / m_physScale)
        wall.SetAsBox(width+100/m_physScale/2, 100/m_physScale)
        wallB = m_world.CreateBody(wallBd)
        wallB.CreateFixture2(wall)
        '// Bottom
        wall.SetAsBox(width+100/m_physScale/2, 100/m_physScale)
        wallBd.position.Set(width / m_physScale / 2, (height + 95) / m_physScale)
        wallB = m_world.CreateBody(wallBd)
        wallB.CreateFixture2(wall)
    End
    
    Method OnRender:Int()
        '// Render
        m_world.DrawDebugData()
    End
    
    Method Update : void ()
        
        '// Update mouse joint
        UpdateMouseWorld()
        MouseDestroy()
        MouseDrag()
        '// Update physics
        MainDemo.m_fpsCounter.StartPhysics()
        m_world.TimeStep(m_timeStep, m_velocityIterations, m_positionIterations)
        m_world.ClearForces()
        MainDemo.m_fpsCounter.EndPhysics()
    End
    
    '//===========
    '// Update mouseWorld
    '//===========
    Method UpdateMouseWorld : void ()
        
        mouseXWorldPhys = (MouseX())/m_physScale
        mouseYWorldPhys = (MouseY())/m_physScale
        mouseXWorld = (MouseX())
        mouseYWorld = (MouseY())
    End
    '//===========
    '// Mouse Drag
    '//===========
    Method MouseDrag : void ()
        
        '// mouse press
        If (MouseDown()  And  Not(m_mouseJoint))
            Local body :b2Body = GetBodyAtMouse()
            If (body)
                
                Local md :b2MouseJointDef = New b2MouseJointDef()
                md.bodyA = m_world.GetGroundBody()
                md.bodyB = body
                md.target.Set(mouseXWorldPhys, mouseYWorldPhys)
                md.collideConnected = True
                md.maxForce = 300.0 * body.GetMass()
                m_mouseJoint = b2MouseJoint(m_world.CreateJoint(md))
                body.SetAwake(True)
            End
        End
        '// mouse release
        If (Not(MouseDown()))
            
            If (m_mouseJoint)
                
                m_world.DestroyJoint(m_mouseJoint)
                m_mouseJoint = null
            End
        End
        '// mouse move
        If (m_mouseJoint)
            
            Local p2 :b2Vec2 = New b2Vec2(mouseXWorldPhys, mouseYWorldPhys)
            m_mouseJoint.SetTarget(p2)
        End
    End
    '//===========
    '// Mouse Destroy
    '//===========
    Method MouseDestroy : void ()
        
        '// mouse press
        If (Not(MouseDown()) And KeyHit(68) > 0)
            Local body :b2Body = GetBodyAtMouse(True)
            If (body)
                
                m_world.DestroyBody(body)
                Return
            End
        End
    End
    '//===========
    '// GetBodyAtMouse
    '//===========
    Field mousePVec:b2Vec2 = New b2Vec2()
    
    Method GetBodyAtMouse : b2Body (includeStatic:Bool = False)
        
        '// Make a small box.
        mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys)
        Local aabb:b2AABB = New b2AABB()
        
        aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001)
        aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001)
        
        Local callback:TestQueryAABBCallback = New TestQueryAABBCallback(includeStatic,mousePVec)
        Local fixture:b2Fixture
        
        m_world.QueryAABB(callback, aabb)
        Return callback.body
    End
    
End









