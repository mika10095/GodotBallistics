using Godot;
using System;
[GlobalClass]
public partial class NCBSWorldRes : Resource
{
	[Export]
	public float GravityConstant { get; set; }

	public NCBSWorldRes()
	{
		
	}
	public NCBSWorldRes(float gravity_constant)
	{
		GravityConstant = gravity_constant;
	}
}
