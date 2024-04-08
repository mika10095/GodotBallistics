using Godot;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Threading;
using System.Linq;
using Godot.Collections;


namespace NCBS
{

	public partial class NCBS : Node3D
	{
		bool debugLines = true;
		int CurrentHitID = 1;
		Node debugTools;
		Node settings; 
		public ulong CurrentTime;
		public uint TimeStepTime = 1;
		public uint TimeStepTimeSeconds { get { return TimeStepTime * 1000; } }
		public uint PreCalcSteps = 40;
		public ulong CatchUpTime = 100;
		public NCBSWorldRes WorldRes;
		private List<NCBSBullet> Bullets = new List<NCBSBullet>();
		bool hit_pending = false;

		public List<NCBSBullet> Hits = new List<NCBSBullet>();
		public List<NCBSBullet> Saved = new List<NCBSBullet>();
		public override void _Ready()
		{
			debugTools = GetNode("/root/DebugTools");
			settings = GetNode("/root/SettingsManager");
			GD.Print("Its alive!");
			debugLines = (bool)settings.Call("get_var","debug_lines");
			GD.Print("debug lines? " + (bool)settings.Call("get_var","debug_lines"));
		}
		

		public override void _PhysicsProcess(double delta)
		{
			base._PhysicsProcess(delta);
			CurrentTime = Engine.GetPhysicsFrames() * 16;
			PhysicsDirectSpaceState3D Space = GetWorld3D().DirectSpaceState;
			//GD.Print((Engine.GetPhysicsFrames() * 16).ToString());
			//GD.Print(Bullets.Count() + " bullets");

			foreach (var bullet in Bullets)
			{
				if (!bullet.Initialized)
				{
					Initialize(bullet);
					Debug.Print("Bullet Initialized!");
				}
				if (CurrentTime > bullet.CurrentTime)
				{
					//GD.Print("CurrentTime is over bullet max time! " + CurrentTime + "\t" + bullet.CurrentTime);
					BulletState NewState = new BulletState(bullet.LastDelta, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
					while (CurrentTime + CatchUpTime > bullet.CurrentTime)
					{
						bullet.CalculateStep(TimeStepTimeSeconds);
					}
					bullet.LastPosition = NewState;
					//GD.Print(CurrentTime + "\t" + bullet.CurrentTime);
				}

				else if (bullet.CurrentTime - CurrentTime < 20)
				{
					for (int i = 0; i < PreCalcSteps; i++)
					{
						bullet.CalculateStep(TimeStepTimeSeconds);
					}
				}


				//Bullet must be ready by now


				int skipped = 0;

				do { bullet.CurrentState = bullet.Positions.Dequeue(); skipped++; }
				while (bullet.CurrentState.Delta + bullet.StartTime != CurrentTime);
				//if (skipped != 16) { GD.Print("Found the current one! Skipped: " + skipped); }
				//Raycast!
				Vector3 Start = bullet.LastPosition.Position;
				Vector3 End = bullet.CurrentState.Position;

				Dictionary hit = Space.IntersectRay(PhysicsRayQueryParameters3D.Create(Start, End));
				if (hit.Count != 0)
				{
					bullet.HitRes = new NCBSHitRes(CurrentHitID, 1, hit, bullet.getJoules, new Transform3D(bullet.Basis, bullet.LastPosition.Position), bullet.Data);
					CurrentHitID++;
					if(debugLines)
					{
						debugTools.Call("draw_line_color", bullet.CurrentState.Position, hit["position"], Color.FromHtml("FF0000"));
					}
					
					bullet.BulletNode.Set("global_position", hit["position"]);
					Node3D hitnode = hit["collider"].Obj as Node3D;
					if (hitnode.HasMethod("handle_hit") && bullet.HitRes.HitCode != 0)
					{
						bullet.HitRes.HitCode = 3;
						hitnode.Call("handle_hit", bullet.HitRes);
						
						
					}
					bullet.HitRes.HitCode = 2;
					bullet.Clear();
					hit_pending = true;
					//Hits.Add(bullet);
					//Bullets.Remove(bullet);
				}
				else
				{
					if(debugLines)
					{
					debugTools.Call("draw_line_color", Start, End, Color.FromHtml("0000FF"));
					}
					//GD.Print(current.Position);
					//debugTools.Call("draw_line_color", bullet.CurrentState.Position, bullet.Positions.Peek().Position, Color.FromHtml("FFFF66"));
					//debugTools.Call("draw_line", current.Position, bullet.LastPosition.Position);
					bullet.LastPosition = bullet.CurrentState;
					bullet.BulletNode.Set("global_position", bullet.CurrentState.Position);
					if (bullet.CurrentState.Position.Y <= -100)
					{
						bullet.HitRes = new NCBSHitRes(0,0, null, 0, bullet.CurrentPosition, bullet.Data);
						bullet.HitRes.HitCode = 1;
						bullet.Clear();
						hit_pending = true;
						//Hits.Add(bullet);
						//Bullets.Remove(bullet);

					}
					//GD.Print(bullet.BulletNode.Position.ToString());
				}
				


			}
			if (hit_pending)
			{
				GD.Print("Hit pending");
			for (int i = 0; i < Bullets.Count; i++)
			{
				if (Bullets[i].HitRes.HitCode != 0)
					{Bullets.Remove(Bullets[i]);}
			}
			hit_pending = false;
			}
			
		}
		public float getJoules(NCBSBullet bullet, BulletState current)
		{
			return 0.5f * bullet.Data.BulletMass * (float)Math.Pow(current.Velocity.X + current.Velocity.Z, 2);
		}
		public void Initialize(NCBSBullet bullet)
		{
			PackedScene bulletscene = GD.Load<PackedScene>("addons/NCBS/bullet_node.tscn");
			if(bullet.Data.BulletMesh != null)
			{
				 bullet.BulletNode = bullet.Data.BulletMesh.Instantiate<Node3D>();
			}
			else{
			bullet.BulletNode = bulletscene.Instantiate<Node3D>();
			}
			bullet.BulletNode.Basis = bullet.StartPosition.Basis.Orthonormalized();
			GetTree().Root.AddChild(bullet.BulletNode);

			bullet.LastDelta = 0;
			bullet.StartPhysicsStep = Engine.GetPhysicsFrames();
			bullet.CurrentVelocity = new Vector3(bullet.Data.MuzzleVelocity, 0, 0);
			bullet.StartTime = CurrentTime;
			bullet.CurrentPosition = bullet.StartPosition;
			BulletState NewState = new BulletState(0, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
			bullet.Positions.Enqueue(NewState);
			GD.Print(NewState.Position.ToString() + " " + NewState.Velocity.ToString());
			
			
			
			
			for (int i = 0; i < PreCalcSteps; i++)
			{
				bullet.CalculateStep(TimeStepTimeSeconds);
			}
			bullet.LastPosition = NewState;
			bullet.Initialized = true;
			
			
		}
		public void AddBullet(Transform3D firepoint, Vector3 rotation_offset, float rotation_amount, NCBSBulletRes bulletres)
		{
			firepoint.Basis = firepoint.Basis.Rotated(rotation_offset, rotation_amount);
			Bullets.Add(new NCBSBullet(firepoint, bulletres, WorldRes));
			debugLines = (bool)settings.Call("get_var","debug_lines");
		}
		public void AddBullet(Transform3D firepoint, NCBSBulletRes bulletres)
		{
			Bullets.Add(new NCBSBullet(firepoint, bulletres, WorldRes));
			debugLines = (bool)settings.Call("get_var","debug_lines");

		}
		public void SetTimeStepTime(uint step_time)
		{
			TimeStepTime = step_time;
		}
		public void SetWorld(NCBSWorldRes world_res)
		{
			WorldRes = world_res;
		}
		public void SetPreCalcSteps(uint steps)
		{
			PreCalcSteps = steps;
		}
	}
}
