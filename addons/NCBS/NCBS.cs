using Godot;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Threading;
using System.Linq;


namespace NCBS
{
	public partial class NCBS : Node3D
	{
		Node debugTools;
		public ulong CurrentTime;
		public uint TimeStepTime = 1;
		public uint TimeStepTimeSeconds {get {return TimeStepTime * 1000;}}
		public uint PreCalcSteps = 40;
		public ulong CatchUpTime = 100;
		public NCBSWorldRes WorldRes;
		private List<NCBSBullet> bullets = new List<NCBSBullet>();

		public List<NCBSBullet> hits = new List<NCBSBullet>();
		public override void _Ready()
		{
			Debug.Print("Its alive!");
		}

		public override void _Process(double delta)
		{
			debugTools = GetNode("/root/DebugTools");
		}
		public override void _PhysicsProcess(double delta)
		{
			base._PhysicsProcess(delta);
			CurrentTime = Engine.GetPhysicsFrames() * 16;
			PhysicsDirectSpaceState3D Space = GetWorld3D().DirectSpaceState;
			//Debug.Print((Engine.GetPhysicsFrames() * 16).ToString());
			//Debug.Print(bullets.Count() + " bullets");

			foreach (var bullet in bullets)
			{

				if (bullet.Hit) { Debug.Print("Implement hitting stuff!"); hits.Add(bullet); bullets.Remove(bullet); }
				if (!bullet.Initialized)
				{
					Initialize(bullet);
				}
				if (CurrentTime > bullet.CurrentTime)
				{
					Debug.Print("CurrentTime is over bullet max time! " + CurrentTime + "\t" + bullet.CurrentTime);
					BulletState NewState = new BulletState(bullet.LastDelta, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
					while (CurrentTime + CatchUpTime > bullet.CurrentTime)
					{
						bullet.CalculateStep(TimeStepTimeSeconds);
					}
					bullet.LastPosition = NewState;
					Debug.Print(CurrentTime + "\t" + bullet.CurrentTime);
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
				BulletState current;
				do { current = bullet.Positions.Dequeue(); skipped++; }
				while (current.Delta + bullet.StartTime != CurrentTime);
				if (skipped != 16) { Debug.Print("Found the current one! Skipped: " + skipped); }
				GD.Print($"{current.Velocity}\t{0.5f*bullet.Data.BulletMass*Math.Pow(current.Velocity.X+current.Velocity.Z,2)} Joules of energy\t{bullet.TestString}");
				//Raycast!
				Vector3 Start = bullet.LastPosition.Position;
				Vector3 End = current.Position;
				debugTools.Call("draw_line_color", Start, End, Color.FromHtml("0000FF"));
				Godot.Collections.Dictionary hit = Space.IntersectRay(PhysicsRayQueryParameters3D.Create(Start, End));
				if (hit.Count != 0)
				{
					bullet.HitDict = hit;
					GD.Print(hit["position"]);
					debugTools.Call("draw_line_color", current.Position, hit["position"], Color.FromHtml("FF0000"));
					bullet.BulletNode.Set("global_position", hit["position"]);
					bullet.Hit = true;
					bullet.HitCode = 1;
				}
				else
				{

					//GD.Print(current.Position);
					debugTools.Call("draw_line_color", current.Position, bullet.Positions.Peek().Position, Color.FromHtml("FFFF66"));
					//debugTools.Call("draw_line", current.Position, bullet.LastPosition.Position);
					bullet.LastPosition = current;
					bullet.BulletNode.Set("global_position", current.Position);
					if (current.Position.Y <= -100)
					{	
						GD.Print("Bullet out of bounds " + current.Position);
						bullet.Hit = true;
						bullet.HitCode = 0;
					}
					//Debug.Print(bullet.BulletNode.Position.ToString());
				}
				


			}
		}
		public void Initialize(NCBSBullet bullet)
		{
			bullet.LastDelta = 0;
			bullet.StartPhysicsStep = Engine.GetPhysicsFrames();
			bullet.CurrentVelocity = new Vector3(bullet.Data.MuzzleVelocity, 0, 0);
			bullet.StartTime = CurrentTime;
			bullet.CurrentPosition = bullet.StartPosition;
			BulletState NewState = new BulletState(0, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
			bullet.Positions.Enqueue(NewState);
			GD.Print(NewState.Position.ToString() + " " + NewState.Velocity.ToString());
			PackedScene bulletscene = GD.Load<PackedScene>("addons/NCBS/bullet_node.tscn");
			bullet.BulletNode = bulletscene.Instantiate<Node3D>();
			GetTree().Root.AddChild(bullet.BulletNode);
			bullet.BulletNode.Set("global_transform", bullet.CurrentPosition);
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
			bullets.Add(new NCBSBullet(firepoint, bulletres, WorldRes));

		}
		public void AddBullet(Transform3D firepoint, NCBSBulletRes bulletres)
		{
			bullets.Add(new NCBSBullet(firepoint, bulletres, WorldRes));

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
