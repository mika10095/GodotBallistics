using Godot;
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Threading;
using System.Linq;

namespace NCBS
{
	public partial class NCBS : Node
	{
		Node debugTools;
		public ulong CurrentTime;
		public uint TimeStepTime = 1;
		public uint PreCalcSteps = 40;
		public ulong CatchUpTime = 100;
		public NCBSWorldRes WorldRes;
		private List<NCBSBullet> bullets = new List<NCBSBullet>();
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
			//Debug.Print(bullets.Count() + " bullets");

			foreach (var bullet in bullets)
			{
				if (bullet.Hit) { Debug.Print("Implement hitting stuff!"); }
				else if (bullet.Initialized)
				{
					if (CurrentTime > bullet.CurrentTime)
					{
						Debug.Print("CurrentTime is over bullet max time! " + CurrentTime + "\t" + bullet.CurrentTime);
						while (CurrentTime + CatchUpTime > bullet.CurrentTime)
						{
							BulletState NewState = new BulletState(0, bullet.StartPosition.Origin, bullet.CurrentVelocity);
							bullet.LastDelta += TimeStepTime;
							Vector3 oldpos = bullet.CurrentPosition.Origin;
							bullet.CurrentVelocity.Y += -9.8f / 1000 / TimeStepTime;
							bullet.CurrentPosition.Origin = bullet.CurrentPosition.Origin + bullet.CurrentPosition.Basis.X * bullet.CurrentVelocity.X / 1000 / TimeStepTime + bullet.CurrentPosition.Basis.Y * bullet.CurrentVelocity.Y / 1000 / TimeStepTime;
							//debugTools.Call("draw_line",oldpos,bullet.CurrentPosition.Origin);
							NewState = new BulletState(bullet.LastDelta, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
							bullet.Positions.Enqueue(NewState);
						}
						Debug.Print(CurrentTime + "\t" + bullet.CurrentTime);
					}

					else if (bullet.CurrentTime - CurrentTime < 20)
					{
						for (int i = 0; i < PreCalcSteps; i++)
						{
							BulletState NewState = new BulletState(0, bullet.StartPosition.Origin, bullet.CurrentVelocity);
							bullet.LastDelta += TimeStepTime;
							Vector3 oldpos = bullet.CurrentPosition.Origin;
							bullet.CurrentVelocity.Y += -9.8f / 1000 / TimeStepTime;
							bullet.CurrentPosition.Origin = bullet.CurrentPosition.Origin + bullet.CurrentPosition.Basis.X * bullet.CurrentVelocity.X / 1000 / TimeStepTime + bullet.CurrentPosition.Basis.Y * bullet.CurrentVelocity.Y / 1000 / TimeStepTime;
							//debugTools.Call("draw_line",oldpos,bullet.CurrentPosition.Origin);
							NewState = new BulletState(bullet.LastDelta, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
							bullet.Positions.Enqueue(NewState);
							/*if (i == 0 || i == PreCalcSteps)
							{
								Debug.Print(CurrentTime + "\t" + bullet.LastDelta.ToString() + "\t" + NewState.Position.ToString() + "\t" + NewState.Velocity.ToString());
							}*/
						}
					}
				}
				else
				{
					
					bullet.StartPhysicsStep = Engine.GetPhysicsFrames();
					bullet.CurrentVelocity = new Vector3(bullet.Data.MuzzleVelocity, 0, 0);
					bullet.StartTime = CurrentTime;
					bullet.CurrentPosition = bullet.StartPosition;
					BulletState NewState = new BulletState(0, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
					bullet.Positions.Enqueue(NewState);
					Debug.Print(NewState.Position.ToString() + " " + NewState.Velocity.ToString());
					bullet.LastDelta = 0;
					bullet.BulletNode = new Node3D();
					bullet.BulletNode.AddChild(new MeshInstance3D());
					bullet.BulletNode.GetChild(0).Set("mesh",new BoxMesh());
					bullet.BulletNode.Set("scale", new Vector3(0.01f,0.01f,0.01f));
					bullet.BulletNode.Set("global_position",NewState.Position);
					for (int i = 0; i < 100; i++)
					{
						bullet.LastDelta += TimeStepTime;
						Vector3 oldpos = bullet.CurrentPosition.Origin;
						bullet.CurrentVelocity.Y += -9.8f / 1000 / TimeStepTime;
						bullet.CurrentPosition.Origin = bullet.CurrentPosition.Origin + bullet.CurrentPosition.Basis.X * bullet.CurrentVelocity.X / 1000 / TimeStepTime + bullet.CurrentPosition.Basis.Y * bullet.CurrentVelocity.Y / 1000 / TimeStepTime;
						//debugTools.Call("draw_line",oldpos,bullet.CurrentPosition.Origin);
						NewState = new BulletState(bullet.LastDelta, bullet.CurrentPosition.Origin, bullet.CurrentVelocity);
						bullet.Positions.Enqueue(NewState);
						Debug.Print(bullet.LastDelta.ToString() + "\t" + NewState.Position.ToString() + "\t" + NewState.Velocity.ToString());
					}

					bullet.Initialized = true;
				}
				//Bullet must be ready by now

			}
		}
		public void AddBullet(Transform3D firepoint, Vector3 rotation_offset, float rotation_amount, NCBSBulletRes bulletres)
		{
			firepoint.Basis = firepoint.Basis.Rotated(rotation_offset, rotation_amount);
			bullets.Add(new NCBSBullet(firepoint, bulletres));
		}
		public void AddBullet(Transform3D firepoint, NCBSBulletRes bulletres)
		{
			bullets.Add(new NCBSBullet(firepoint, bulletres));
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
