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


Class TestDominoStack Extends Test

    Const dwidth := 6.0
    Const dheight := 30.0
    Field ddensity:Float
    Const dfriction:Float = 0.6
    Const baseCount:Int = 9
    

    Method MakeDomino:Void( x:Float, y:Float, horizontal:Bool, world:b2World)

    	Local sd:b2PolygonShape = new b2PolygonShape()
        Local fd :b2FixtureDef = New b2FixtureDef()
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
		sd.SetAsBox(0.5*dwidth/m_physScale, 0.5*dheight/m_physScale)
        fd.density = ddensity
        fd.friction = dfriction
        fd.restitution = 0.2
        fd.shape = sd
		bd.position.Set( x/m_physScale, y/m_physScale)
   		If horizontal
			bd.angle = Constants.PI*0.5
		Else
			bd.angle = 0.0
		End
        Local myBody := world.CreateBody(bd)
        myBody.CreateFixture(fd)
        'myBody.SetMassFromShapes()
    End

	Method CreateBoxObject:Void( width:Float, height:Float, xPos:Float, yPos:Float )
	    Local fd :b2FixtureDef = New b2FixtureDef()
        Local sd :b2PolygonShape = New b2PolygonShape()
        Local bd :b2BodyDef = New b2BodyDef()
        bd.type = b2Body.b2_Body
        '//bd.isBullet = True
        Local b :b2Body
        fd.density = 0.5
        fd.friction = 0.5
        fd.restitution = 0.1
        fd.shape = sd
		sd.SetAsBox( width / m_physScale, height / m_physScale)
		bd.position.Set( xPos / m_physScale, yPos / m_physScale)
   		b = m_world.CreateBody(bd)
   		b.CreateFixture(fd)
	
	End
    
	Method New()
        Super.New()
        '// Set Text field
        name = "Domino Pyramid"

		ddensity = 10.0
		
		For Local i := 0 Until baseCount
			Local currX := 320 + i*1.5*dheight - (1.5*dheight*baseCount/2.0)
            MakeDomino(currX, 475-dheight/2.0, false, m_world)
            MakeDomino(currX, 475-(dheight+dwidth/2.0), true, m_world)
        End
        
		'Make 'I's
        For Local j:Int =1 Until baseCount            

			Local currY :Int = 475 - (dheight*0.5 + (dheight+2.0*dwidth)*0.99*j) '//y at center of 'I' structure
            
            For Local i :Int = 0 Until baseCount - j
                Local currX:Int = 320 + i*1.5*dheight - (1.5*dheight*(baseCount-j)/2.0) '// + random(-.05f, .05f);
                ddensity *= 2.5
                If (i=0)
                    MakeDomino(currX - (1.25*dheight) + 0.5*dwidth, currY+dwidth, false, m_world)
                End
                If i=(baseCount-j-1)
                    MakeDomino(currX + (1.25*dheight) - 0.5*dwidth, currY+dwidth, false, m_world)
                End
               	ddensity /= 2.5
                MakeDomino(currX, currY, false, m_world)
                MakeDomino(currX, currY-0.5*(dwidth+dheight), true, m_world)
                MakeDomino(currX, currY+0.5*(dwidth+dheight), true, m_world)
        	End
			If (j > 2) 
				ddensity *= 0.8
            End
		End     
		Local currY := 475 - (dheight*0.5 + (dheight+2.0*dwidth)*0.99*baseCount) '//y at center of 'I' structure
        Local currX := 320 - 0.75 * dheight
        MakeDomino(currX - (0.5*dheight) + 0.5*dwidth, currY+dwidth, false, m_world)
        MakeDomino(currX + (0.5*dheight) - 0.5*dwidth, currY+dwidth, false, m_world)
                           
	End 
End



