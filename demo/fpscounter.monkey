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
    
    Field physicsRateTextBox :TextField
    Field renderRateTextBox :TextField

    Const AverageSample:Int = 120

    Method New()
        
        physicsRateTextBox = New TextField()
        physicsRateTextBox.text = "..."
        physicsRateTextBox.width = 150
        physicsRateTextBox.x = 0'230
        physicsRateTextBox.y = 0
        
        renderRateTextBox = New TextField()
        renderRateTextBox.text = "..."
        renderRateTextBox.width = 150
        renderRateTextBox.x = 0
        renderRateTextBox.y = 15

        AddChild(physicsRateTextBox)
        AddChild(renderRateTextBox)
    End

    Method StartPhysics:Void()
        StartTimer(PhysicsID)
    End
    
    Method EndPhysics:Void()
        EndTimer(PhysicsID)
        Local avgFrameMS:Float = GetAverageDuration(PhysicsID)
        Local maxFPS:Int = Math.Round(1000.0/avgFrameMS)
        If avgFrameMS < 1
            physicsRateTextBox.text = String("Actual physics updates/sec: " + Math.Round(GetActualRate(PhysicsID)) + ", Avg: < 1 ms (max. > 1000 updates/sec)")
        Else
            physicsRateTextBox.text = String("Actual physics updates/sec: " + Math.Round(GetActualRate(PhysicsID)) + ", Avg update: " + Math.Round(avgFrameMS)+" ms (max. " + maxFPS +" updates/sec)")
        End
    End
    
    Method StartRender:Void()
        StartTimer(RenderID)
    End
    
    Method EndRender:Void()
        EndTimer(RenderID)
        Local avgFrameMS:Float = GetAverageDuration(RenderID)
        Local maxFPS:Int = Math.Round(1000.0/avgFrameMS)
        If avgFrameMS < 1
            renderRateTextBox.text = String("Actual drawn FPS: " + Math.Round(GetActualRate(RenderID)) + ", Avg. Render time: < 1 ms (max. > 1000 frames/sec)")
        Else
            renderRateTextBox.text = String("Actual drawn FPS: " + Math.Round(GetActualRate(RenderID)) + ", Avg. Render time: " + Math.Round(avgFrameMS)+" ms (max. " + maxFPS +" frames/sec)")
        End
    End
    
    Const PhysicsID = 0
    Const RenderID = 1
    Const MaxTimings = 2
    
    Field startTimes:Int[][] = [New Int[AverageSample],New Int[AverageSample]]
    Field durations:Int[] = [0,0]
    Field times:Int[][] = [New Int[AverageSample],New Int[AverageSample]]
    Field counts:Int[] = [0,0]
    Field lastFrameIndex:Int[] = [0,0]
    
    Method GetActualRate : Float( id:Int )
        If( startTimes[id][AverageSample-1] > 0 )
            return Float(AverageSample-1) / (startTimes[id][lastFrameIndex[id]] - startTimes[id][(lastFrameIndex[id]+1) Mod AverageSample]) * 1000
        Else
            return Float(counts[id]-1)/(startTimes[id][lastFrameIndex[id]] - startTimes[id][0])*1000
        End            
    End
    
    Method GetAverageDuration : Float( id:Int )
        If startTimes[id][AverageSample-1] = 0
            return Float(durations[id])/counts[id]
        Else
            return Float(durations[id])/AverageSample
        End
    End
    
    Method StartTimer : Void ( id:Int )
        startTimes[id][counts[id]] = Millisecs()
    End
    
    Method EndTimer : Void ( id:Int )
        Local newT :Int = Millisecs()
        Local f1 :Int = newT-startTimes[id][counts[id]]
        Local nextFrame = (counts[id] + 1) Mod AverageSample
        
        durations[id] -= times[id][nextFrame]
        durations[id] += f1
        times[id][counts[id]] = f1
        lastFrameIndex[id] = counts[id]
        counts[id] = nextFrame
    End
End



