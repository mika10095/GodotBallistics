using Godot;
using System;

public partial class Ballisti : Node3D
{
	Vector3 Velocity;
	Vector3 Forward;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		 Forward = new Vector3(0, -1, 0);

	}
	public void Setup(float Velocity)
	{
		this.Velocity.X = Velocity;

	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		var forward_dir = Basis * Forward;
       
        Position += (float)delta * Velocity.X* forward_dir;
		Velocity.Y -= 9.8f*(float)delta;
		Position += new Vector3(0, (float)delta * Velocity.Y,0);


    }
	
}
