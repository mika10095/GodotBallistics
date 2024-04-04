using Godot;
using System;

namespace NCBS
{
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
		[Export]
		public Transform3D LastBulletPos;
		[Export]
		public NCBSBulletRes BulletRes;
		public NCBSHitRes()
		{
			HitCode = 0;
			HitDict = null;
			HitPowerJoules = 0;
			LastBulletPos = new Transform3D();
			BulletRes = new NCBSBulletRes();

		}
		public NCBSHitRes(int hit_code, Godot.Collections.Dictionary hit_dict, float hit_power, Transform3D last_pos, NCBSBulletRes bulletRes)
		{
			HitCode = hit_code;
			HitDict = hit_dict;
			HitPowerJoules = hit_power;
			LastBulletPos = last_pos;
			BulletRes = bulletRes;
		}
	}
  }
