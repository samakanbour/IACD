// inspired by NateTG 

maxlevel = 3;
size = 30;
thickness = 10;

difference()  {
	color("MediumOrchid") sierpinski(side=size,maxlevel=maxlevel);
	middle(size - thickness);
	cylinder(r = 3/maxlevel, h = 50, center=true);
	rotate([90]) cylinder(r = 3/maxlevel, h = 50, center=true);
	rotate([0, 90]) cylinder(r = 3/maxlevel, h = 50, center=true);
}

module triangle(side, maxlevel=3) {
	difference() {
	polyhedron(points=[[side,0,0],[0,side,0],[0,0,side],[-side,0,0],[0,-side,0],[0,0,-side]], 
	triangles=[[0,2,1],[0,4,2],[0,5,4],[0,1,5],[3,1,2],[3,2,4],[3,4,5],[3,5,1]]);	
	rotate([45]) cylinder(r = 2/maxlevel, h = 50, center=true);
	rotate([-45]) cylinder(r = 2/maxlevel, h = 50, center=true);
	rotate([0, -45]) cylinder(r = 2/maxlevel, h = 50, center=true);
	rotate([0, 45]) cylinder(r = 2/maxlevel, h = 50, center=true);
	}
}

module middle(side) {
polyhedron(points=[[side,0,0],[0,side,0],[0,0,side],[-side,0,0],[0,-side,0],[0,0,-side]], triangles=[[0,2,1],[0,4,2],[0,5,4],[0,1,5],[3,1,2],[3,2,4],[3,4,5],[3,5,1]]);	
	
}

module sierpinski(side=1,maxlevel=3,level=1) {
	for(i =[[side*sqrt(2)/4,0,0],[0,side*sqrt(2)/4,0],[0,0,side*sqrt(2)/4],[-side*sqrt(2)/4,0,0],[0,-side*sqrt(2)/4,0],	[0,0,-side*sqrt(2)/4]]) {
		if(level<maxlevel) {
			translate(i) sierpinski(side=side/2,maxlevel=maxlevel,level=level+1);
		} else {
			translate(i) triangle(side=side*sqrt(2)/4, maxlevel=maxlevel);
		}
	}
}