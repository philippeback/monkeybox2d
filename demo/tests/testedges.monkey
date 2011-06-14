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
    
    Field laser:b2Body
    
    Method New()
        Super.New()
        '// Set Text field
        name = "Edge Chains"
        Local box :b2PolygonDef = New b2PolygonDef()
        box.SetAsBox(30 / m_physScale, 4 / m_physScale)
        box.density = 4
        box.friction = 0.4
        box.restitution = 0.3
        Local bd :b2BodyDef = New b2BodyDef()
        bd.position.Set(320 / m_physScale, 150 / m_physScale)
        laser = m_world.CreateBody(bd)
        laser.CreateShape(box)
        laser.SetMassFromShapes()
        '// Add bodies
        Local sd :b2PolygonDef = New b2PolygonDef()
        '//bd.isBullet = True
        Local b :b2Body
        sd.density = 1.0
        sd.friction = 0.5
        sd.restitution = 0.1
        Local i :int
        For Local i:Int = 0 Until 10
            
            sd.SetAsBox((10) / m_physScale, (10) / m_physScale)
            bd.position.Set((640/2+200+Rnd()*0.02 - 0.01) / m_physScale, (360-5-i*25) / m_physScale)
            b = m_world.CreateBody(bd)
            b.CreateShape(sd)
            b.SetMassFromShapes()
        End
        '// Create ball
        Local cd :b2CircleDef = New b2CircleDef()
        cd.radius = 20/m_physScale
        cd.density = 2
        cd.restitution = 0.2
        cd.friction = 0.5
        bd.position.Set(50/m_physScale, 100 / m_physScale)
        b = m_world.CreateBody(bd)
        b.CreateShape(cd)
        b.SetMassFromShapes()
        b2SVG.ParseSVG(m_svg, m_world, 1, 15)
    End
    
    Method Update : void ()
        Super.Update()
        Local segment :b2Segment = New b2Segment()
        segment.p1.SetV(laser.GetWorldPoint(New b2Vec2(30.1/m_physScale,0)))
        segment.p2.SetV(laser.GetWorldVector(New b2Vec2(100/m_physScale,0)))
        segment.p2.Add(segment.p1)
        Local lambdaRef :Array=[1]
        Local normal :b2Vec2=New b2Vec2()
        Local shape :b2Shape = m_world.RaycastOne(segment,lambdaRef,normal,True,null)
        Local lambda :Float = lambdaRef.Get(0)
        m_sprite.graphics.lineStyle(1,$ff0000,1)
        m_sprite.graphics.moveTo(segment.p1.x * m_physScale, segment.p1.y * m_physScale)
        m_sprite.graphics.lineTo( 	(segment.p2.x * lambda + (1-lambda) * segment.p1.x) * m_physScale,
        (segment.p2.y * lambda + (1-lambda) * segment.p1.y) * m_physScale)
    End
    '//===========
    '// Member Data
    '//===========
    #rem
    'Field m_svg: XML =
    '
    '<svg
    'xmlns:dc="http://purl.org/dc/elements/1.1/"
    'xmlns:cc="http://web.resource.org/cc/"
    'xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    'xmlns:svg="http://www.w3.org/2000/svg"
    'xmlns="http://www.w3.org/2000/svg"
    'xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
    'xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
    'width="744.09448819"
    'height="1052.3622047"
    'id="svg2"
    'sodipodi:version="0.32"
    'inkscape:version="0.45.1"
    'sodipodi:docbase="/Users/johnnesky/Box2DAS3_staticEdges"
    'sodipodi:docname="drawing.svg"
    'inkscape:output_extension="org.inkscape.output.svg.inkscape">
    '<defs
    'id="defs4" />
    '<sodipodi:namedview
    'id="base"
    'pagecolor="#ffffff"
    'bordercolor="#666666"
    'borderopacity="1.0"
    'gridtolerance="10000"
    'guidetolerance="10"
    'objecttolerance="10"
    'inkscape:pageopacity="0.0"
    'inkscape:pageshadow="2"
    'inkscape:zoom="15.839192"
    'inkscape:cx="15.021172"
    'inkscape:cy="1046.0077"
    'inkscape:document-units="px"
    'inkscape:current-layer="layer1"
    'inkscape:window-width="883"
    'inkscape:window-height="731"
    'inkscape:window-x="0"
    'inkscape:window-y="22" />
    '<metadata
    'id="metadata7">
    '<rdf:RDF>
    '<cc:Work
    'rdf:about="">
    '<dc:format>image/svg+xml</dc:format>
    '<dc:type
    'rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
    '</cc:Work>
    '</rdf:RDF>
    '</metadata>
    '<g
    'inkscape:label="Layer 1"
    'inkscape:groupmode="layer"
    'id="layer1">
    '<path
    'style="fill:none
    'fill-rule:evenodd
    'stroke:#000000
    'stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
    'd="M 0.063134534,8.3695248 L 0.94701801,9.3165428 L 0,9.0640047 L -0.12626907,10.326695 L 1.4520943,11.77879 L 2.2728432,10.137292 L 2.3991123,11.147444 L 3.5986685,10.958041 L 3.9143411,7.3593722 L 4.1668793,9.4428119 L 5.4295699,9.3165428 L 6.2503189,8.3063903 L 6.6922606,10.137292 L 4.9876282,9.8216191 L 4.7350901,10.958041 L 7.2604714,11.652521 L 10.732871,11.147444 L 10.480333,10.642368 L 10.732871,9.8216191 L 11.55362,9.4428119 L 12.374369,9.3796773 L 13.005714,9.8216191 L 13.195118,10.38983 L 13.005714,10.768637 L 12.626907,10.894906 L 12.753176,11.526252 L 13.573925,11.715655 L 14.836616,11.399982 L 16.351844,10.768637 L 17.867073,11.399982 L 17.803939,10.263561 L 17.361997,8.3063903 L 17.803939,8.1801212 L 18.056477,9.5059464 L 18.182746,11.336848 L 18.561553,11.210579 L 18.561553,9.6322155 L 18.561553,7.7381795 L 18.687822,5.5284708 L 19.382302,5.6547398 L 19.066629,8.1801212 L 19.003495,10.263561 L 19.066629,11.463117 L 19.887378,11.841924 L 20.708127,11.273713 L 21.0238,10.011023 L 20.708127,7.2962377 L 21.086934,6.2860852 L 21.150069,3.7607038 L 20.392455,2.5611476 L 18.624688,2.5611476 L 20.771262,2.1192059 L 20.771262,0.22516988 L 18.624688,-0.2799064 L 13.826463,0.16203534 L 14.015867,1.7403987 L 13.195118,2.1823404 L 12.626907,1.5509951 L 12.879445,0.85651522 L 12.626907,0.35143895 L 10.543467,1.298457 L 11.490485,3.9501074 L 13.889598,3.6344347 L 13.889598,2.9399549 L 14.584077,3.8869729 L 11.932427,5.2127981 L 9.7227183,4.0132419 L 10.796005,3.5081657 L 9.7858528,3.2556275 L 10.796005,2.4980131 L 7.9549513,1.7403987 L 9.6595837,1.424726 L 9.217642,0.66711162 L 8.270624,-0.090502792 L 7.0079333,0.85651522 L 6.1240498,-0.15363733 L 6.1240498,3.192493 L 5.6821081,2.4348786 L 4.9876282,2.1192059 L 4.1037447,1.8666678 L 3.0304576,1.8666678 L 2.0834396,2.245475 L 1.6414979,2.6242822 L 1.3258252,3.5081657 L 1.2626907,0.47770802 L 0.63134534,0.035766276 L 0.063134534,0.98278429 L 0.063134534,8.3695248 z "
    'id="path2162" />
    '<path
    'style="fill:none
    'fill-rule:evenodd
    'stroke:#000000
    'stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
    'd="M 8.270624,6.1598161 L 8.270624,5.3390672 L 8.7757003,5.086529 L 9.4701801,5.5284708 L 9.217642,6.033547 L 8.7757003,6.4123542 L 8.270624,6.1598161 z "
    'id="path2164" />
    '</g>
    '</svg>
    #end
End



