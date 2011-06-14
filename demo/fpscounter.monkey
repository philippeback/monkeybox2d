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
Import mojo

Class FpsCounter Extends FlashSprite
    
    Field textBox :TextField
    Field textBox2 :TextField

    Field mfpsCount :int = 0
    Field mfpsCount2 :int = 0
    Field avgCount :int = 30
    Field avgCount2 :int = 30
    Field oldT :Int

    Method New()
        '// create text field
        textBox = New TextField()
        textBox.text = "..."
        
        textBox2 = New TextField()
        textBox2.text = "..."
        textBox2.width = 150
        textBox2.y = 15
        
        '// set initial lastTime
        oldT = Millisecs()
        AddChild(textBox)
        AddChild(textBox2)
    End

    Method Update : void ()
        
        Local newT :Int = Millisecs()
        Local f1 :Int = newT-oldT
        mfpsCount += f1
        If (avgCount < 1)
            
            textBox.text = String(Math.Round(1000.0/(Float(mfpsCount)/30.0))+" fps average")
            avgCount = 30
            mfpsCount = 0
        End
        
        avgCount -= 1
        oldT = Millisecs()
    End

    Method UpdatePhys : void (oldT2:Int)
        
        Local newT :Int = Millisecs()
        Local f1 :Int = newT-oldT2
        mfpsCount2 += f1
        If (avgCount2 < 1)
            
            textBox2.text = String("Physics timeStep: "+Math.Round(Float(mfpsCount2)/30.0)+" ms (" +Math.Round(1000.0/(Float(mfpsCount2)/30.0))+" fps)")
            avgCount2 = 30
            mfpsCount2 = 0
        End
        
        avgCount2 -= 1
        
    End
End



