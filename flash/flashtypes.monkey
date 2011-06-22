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



#rem
'This file contains a number of classes than serve to imitate the behaviour of
'Flash/haXe classes or simply to ease translation of naming conventions. Some code is
'copied from the standard monkey modules.
'
'Eventually they will be reduced to only those classes that are needed for
'functional reasons.
#end

Class Math
    
    Function Round:Int( f : Float )
        If( Ceil(f) - f > f - Floor(f))
            Return Floor(f)
        Else
            Return Ceil(f)
        End
    End
    
    Const RadsPerDegree : Float = TWOPI/360.0
    Const DegreesPerRad : Float = 360.0/TWOPI
    
    Function Sin: Float( rads: Float)
        Return monkey.math.Sin( rads * DegreesPerRad )
    End
    
    Function Cos: Float( rads: Float)
        Return monkey.math.Cos( rads * DegreesPerRad )
    End
    
    Function ASin: Float( x: Float)
        Return monkey.math.ASin( x ) * RadsPerDegree
    End
    
    Function ACos: Float( x: Float)
        Return monkey.math.ACos( x ) * RadsPerDegree
    End
    
    Function Tan: Float( rads: Float)
        Return monkey.math.Tan( rads * DegreesPerRad )
    End
    
    Function ATan: Float( x: Float)
        Return monkey.math.ATan( x ) * RadsPerDegree
    End
    
    Function ATan2: Float( x: Float, y: Float)
        Return monkey.math.ATan2( x, y ) * RadsPerDegree
    End
End

Class FlashDisplayObject Abstract
    Field x:Int
    Field y:Int
    Field width:Int
    Field height:Int
    
    Method OnRender(x:Int, y:Int) Abstract
End

Class TextField Extends FlashDisplayObject
    Field text:String
    
    Method OnRender(x:Int,y:Int)
        Local color:=GetColor()
        SetColor(255,255,255)
        DrawText(text,Self.x+x,Self.y+y)
        SetColor(color[0],color[1],color[2])
    End
    
End

Class FlashSprite Extends FlashDisplayObject
    Field displayList:HaxeFastList<FlashDisplayObject> = New HaxeFastList<FlashDisplayObject>()
    
    Method AddChild:FlashDisplayObject( child:FlashDisplayObject )
        displayList.AddLast(child)
        Return child
    End
    
    Method AddChildAt:FlashDisplayObject( child:FlashDisplayObject, position:Int )
        displayList.AddAt(child,position)
        Return child
    End
    
    Method OnRender(x:Int,y:Int)
        For Local displayObject:FlashDisplayObject = Eachin displayList
            displayObject.OnRender(Self.x+x,Self.y+y)
        Next
    End
End

Class FlashArray<T>
    
    Private
    Const LengthInc : Int = 100
    Field arr : T[] = New T[LengthInc]
    Field EmptyArr: T[] = New T[0]
    
    Public
    Field length : Int = 0
    
	Method Length:Int() Property
        Return length
    End
    
    Method Length(value:Int) Property
        length = value
        If length > arr.Length
            arr = arr.Resize(length)
        End
    End
    
    Method New( length:Int )
        Length = length
    End
    
    Method New( vals:T[] )
        arr = vals
        length = arr.Length
    End
    
    Method Get:T( index:Int)
        If( index >=0 And length > index )
            Return arr[index]
        Else
            Return Null
        End
    End
    
    Method Set( index:Int, item:T )
        If( index >= arr.Length )
            arr = arr.Resize(index+LengthInc)
        End
        arr[index] = item
        If( index >= length )
            length = index+1
        End
    End
    
    Method Push( item:T )
        If( length = arr.Length() )
            arr = arr.Resize(length+LengthInc)
        End
        
        arr[length] = item
        length += 1
    End
    
    Method Pop:T()
        If( length >= 0 )
            length -= 1
            Return arr[length]
        Else
            Return Null
        End
    End
    
    Method IndexOf:Int( element:T )
        For Local index := 0 Until Length
            Local check:T = arr[index]
            If check = element
                Return index
            End
        Next
        Return -1
    End
    
    Method Splice( index:Int, deletes:Int = -1)
        Splice(index,deletes,EmptyArr)
    End

    Method Splice( index:Int, deletes:Int = -1, insert:T[] )
        If deletes = -1
            deletes = Length - index
        End
        
        Local newLength = Length - deletes
        If newLength < 0
            newLength = 0
        End
        
        newLength += insert.Length
        
        Local newArr:T[]
        If index > 0
            newArr = arr[..index-1]
            newArr = newArr.Resize(newLength)
        Else
            index = 0
            newArr = New T[newLength]
        End 

        Local copyInd = index
        
        If insert
            For Local val:= Eachin insert
                newArr[copyInd] = val
                copyInd += 1
            End
        End
        
        For Local i := index+deletes Until Length
            newArr[copyInd] = arr[i]
            copyInd += 1
        Next
        
        arr = newArr
        length = newLength
    End
    
    Method ObjectEnumerator:FAEnumerator<T>()
        Return New FAEnumerator<T>( Self )
    End
    
End
Class FAEnumerator<T>
    
    Method New( arr:FlashArray<T> )
        _arr=arr
        index = 0
    End Method
    
    Method HasNext:Bool()
        Return index<_arr.Length
    End
    
    Method NextObject:T()
        Local data:T=_arr.Get(index)
        index += 1
        Return data
    End
    
    Private
    
    Field _arr:FlashArray<T>
    Field index:Int
    
End


Class HaxeFastList<T>
    
    Field _head:HaxeFastCell<T> = null
    Field _tail:HaxeFastCell<T> = null
    
    Method Add( item:T )
        AddFirst(item)
    End
    
    Method Pop:T()
        Return RemoveFirst()
    End
    
    Method Equals( lhs:Object,rhs:Object )
        Return lhs=rhs
    End
    
    Method Clear()
        _head=null
        _tail=null
    End
    
    Method Count()
        Local n,node:=_head
        While node<>null
            node=node.nextItem
            n+=1
        Wend
        Return n
    End
    
    Method IsEmpty?()
        Return _head = null
    End
    
    Method FirstNode:HaxeFastCell<T>()
        Return _head
    End
    
    Method First:T()
        If( _head <> null )
            Return _head.elt
        End
        Return null
    End
    
    Method Last:T()
        If( _tail <> null )
            Return _tail.elt
        End
        Return null
    End
    
    Method AddFirst:HaxeFastCell<T>( data:T )
        Local added := New HaxeFastCell<T>( _head,null,data )
        _head = added
        If( _tail = null )
            _tail = added
        End
        Return added
    End
    
    Method AddAt:HaxeFastCell<T>( data:T, index:int )
        If( index = 0 )
            Return AddFirst( data )
        Else If( index = Count() )
            Return AddLast( data )
        End
        
        Local node := _head
        Local i:Int = 0
        
        While node<>null And index > i
            node=node.nextItem
            i += 1
        Wend
        
        If( node <> null )
            Local added := New HaxeFastCell<T>( node, null, data )
            Return added
        Else
            Return AddLast(data)
        End
    End
    
    Method AddLast:HaxeFastCell<T>( data:T )
        Local added := New HaxeFastCell<T>( null,_tail,data )
        _tail = added
        If( _head = null )
            _head = added
        End
        Return added
    End
    
    'I think this should GO!
    Method Remove : Bool ( value:T )
        Return RemoveFirst(value)
    End
    
    Method RemoveFirst : Bool( value:T )
        Local node:=_head
        While node<>null
            If Equals( node.elt,value )
                Remove(node)
                Return True
            End
            node=node.nextItem
        Wend
        Return False
    End
    
    Method RemoveEach( value:T )
        Local node:=_head
        While node<>null
            Local nextnode:=node.nextItem
            If Equals( node.elt,value )
                Remove(node)
            End
            node = nextNode
        Wend
    End
    
    Method RemoveFirst:T()
        If( IsEmpty() )
            Return null
        End
        Local data:T=_head.elt
        Remove(_head)
        Return data
    End
    
    Method RemoveLast:T()
        If( IsEmpty() )
            Return null
        End
        Local data:T=_tail.elt
        Remove(_tail)
        Return data
    End
    
    
    Method Remove(cell:HaxeFastCell<T>)
        If( cell = _tail )
            _tail = cell._pred
        End
        If( cell = _head )
            _head = cell.nextItem
        End
        If( cell.nextItem <> null )
            cell.nextItem._pred=cell._pred
        End
        If( cell._pred <> null )
            cell._pred.nextItem=cell.nextItem
        End
    End
    
    Method ObjectEnumerator:Enumerator<T>()
        Return New Enumerator<T>( Self )
    End
    
    
End

Class HaxeFastCell<T>
    
    'create a _head node
    Method New()
        nextItem=null
        _pred=null
    End
    
    Method New( data:T, succ:HaxeFastCell<T>)
        nextItem=succ
        _pred=succ._pred
        If( nextItem <> null )
            nextItem._pred=Self
        End
        If( _pred <> null )
            _pred.nextItem=Self
        End
        elt=data
    End
    
    'create a link node
    Method New( succ:HaxeFastCell<T>,pred:HaxeFastCell<T>,data:T )
        nextItem=succ
        _pred=pred
        If( nextItem <> null )
            nextItem._pred=Self
        End
        If( _pred <> null )
            _pred.nextItem=Self
        End
        elt=data
    End
    
    Method Value:T()
        Return elt
    End
    
    Field elt:T
    Field nextItem:HaxeFastCell<T>
    
    Private
    
    Field _pred:HaxeFastCell<T>
    
End


Class Enumerator<T>
    
    Method New( list:HaxeFastList<T> )
        _list=list
        _curr=list._head
    End Method
    
    Method HasNext:Bool()
        Return _curr<>null
    End
    
    Method NextObject:T()
        Local data:T=_curr.elt
        _curr=_curr.nextItem
        Return data
    End
    
    Private
    
    Field _list:HaxeFastList<T>
    Field _curr:HaxeFastCell<T>
    
End









