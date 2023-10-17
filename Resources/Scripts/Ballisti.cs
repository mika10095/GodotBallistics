using Godot;
using System;

public partial class Ballisti : Node3D
{
	float Velocity;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	   
	}
	public void Setup(float Velocity)
	{
		Velocity = this.Velocity;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	
			
	}
}
