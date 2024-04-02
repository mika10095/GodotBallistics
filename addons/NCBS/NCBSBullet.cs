using Godot;
using Godot.Collections;
using NCBS;
using System;
using System.Collections.Generic;

public partial class NCBSBullet : Node3D
{
	public Node3D BulletNode;
	public NCBSBulletRes Data;
	public Transform3D StartPosition;
	public Transform3D CurrentPosition;
	public Vector3 CurrentVelocity;
	public uint LastDelta;
	public ulong StartTime;
	public ulong CurrentTime { get { return StartTime + LastDelta; } }
	public ulong StartPhysicsStep;
	public Queue<BulletState> Positions = new Queue<BulletState>();
	public BulletState LastPosition;
	public bool Hit = false;
	public int HitCode = 0;
	public bool Initialized = false;

	public Dictionary HitDict;

	public Transform3D RootBasis;
	public override void _Ready()
	{

	}
	public void CalculateStep(uint TimeStepTime)
	{
		LastDelta += TimeStepTime;
		CurrentVelocity.Y += -9.8f / 1000 / TimeStepTime;
		CurrentPosition.Origin = CurrentPosition.Origin + CurrentPosition.Basis.X * CurrentVelocity.X / 1000 / TimeStepTime + this.Transform.Basis.Y * CurrentVelocity.Y / 1000 / TimeStepTime;
		BulletState NewState = new BulletState(LastDelta, CurrentPosition.Origin, CurrentVelocity);
		Positions.Enqueue(NewState);
		//GD.Print(CurrentPosition.Origin);
	}
	
	public NCBSBullet(Transform3D start_position, NCBSBulletRes bullet_data, uint TimeStepTime, uint CalcSteps)
	{
		StartPosition = start_position;
		Data = bullet_data;
		
		
	}
}
public class BulletState
{
	public BulletState(uint delta, Vector3 position, Vector3 velocity)
	{
		Delta = delta;
		Position = position;
		Velocity = velocity;
	}
	public uint Delta;
	public Vector3 Position { get; set; }
	public Vector3 Velocity { get; set; }
}
