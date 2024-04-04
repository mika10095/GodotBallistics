using Godot;
using System;
[GlobalClass]
public partial class NCBSHitRes : Resource
{

	//Storing hit information
	[Export]
	public int HitCode = 0;
	[Export]
	public Godot.Collections.Dictionary HitDict;
	[Export]
	public float HitPowerJoules;
	public NCBSHitRes()
	{
		HitCode = 0;
		HitDict = null;
		HitPowerJoules = 0;
	}
	public NCBSHitRes(int hit_code, Godot.Collections.Dictionary hit_dict, float hit_power)
	{
		HitCode = hit_code;
		HitDict = hit_dict;
		HitPowerJoules = hit_power;
	}
}
