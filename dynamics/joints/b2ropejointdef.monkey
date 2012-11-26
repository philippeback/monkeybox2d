Strict
#rem
/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/
#end
Import box2d.flash.flashtypes
Import box2d.common
Import box2d.common.math
Import box2d.dynamics

#rem
/// Rope joint definition. This requires two body anchor points and
/// a maximum lengths.
/// Note: by default the connected objects will not collide.
/// see collideConnected in b2JointDef.
#end
class b2RopeJointDef Extends b2JointDef
    Method New()
        Super.New()
		type = b2Joint.e_ropeJoint
		localAnchorA.Set(-1.0, 0.0)
		localAnchorB.Set(1.0, 0.0)
		maxLength = 0
	End
	
	Method Initialize:Void(bA:b2Body, bB:b2Body, anchorA:b2Vec2, anchorB:b2Vec2, maxLength:Float)
		bodyA = bA;
		bodyB = bB;
		localAnchorA.SetV(bodyA.GetLocalPoint(anchorA))
		localAnchorB.SetV(bodyB.GetLocalPoint(anchorB))
		Local dX:Float = anchorB.x - anchorA.x
		Local dY:Float = anchorB.y - anchorA.y
		length = Math.sqrt(dX * dX + dY * dY)
		this.maxLength = maxLength
	End

	Field localAnchorA:b2Vec2 = New b2Vec2()
	Field localAnchorB:b2Vec2 = New b2Vec2()
	Field maxLength:Float
	Field length:Float
End