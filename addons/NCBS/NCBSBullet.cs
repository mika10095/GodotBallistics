using Godot;
using NCBS;
using System;
using System.Collections.Generic;

public partial class NCBSBullet : Node
{
	public Node3D BulletNode;
	public NCBSBulletRes Data;
	public Transform3D StartPosition;
	public Transform3D CurrentPosition;
	public Vector3 CurrentVelocity;
	public uint LastDelta;
	public ulong StartTime;
	public ulong CurrentTime{get {return StartTime + LastDelta;}}
	public ulong StartPhysicsStep;
	public Queue<BulletState> Positions = new Queue<BulletState>();
	public bool Hit = false;
	public bool Initialized = false;
	public override void _Ready()
	{
		
	}
	public NCBSBullet(Transform3D start_position, NCBSBulletRes bullet_data)
	{
		StartPosition = start_position;
		Data = bullet_data;
	}
}
public class BulletState{
	public BulletState(uint delta, Vector3 position, Vector3 velocity){
		Delta = delta;
		Position = position;
		Velocity = velocity;
	}
	public uint Delta;
	public Vector3 Position {get; set; }
	public Vector3 Velocity {get; set; }
}
