using Godot;
using System.Collections.Generic;

public partial class Ballisti : Node3D
{
    private readonly Vector3 Forward = new Vector3(0, -1, 0);

    // Called when the node enters the scene tree for the first time.
    private List<StepData> SimulationSteps = new List<StepData>();

    private struct StepData
    {
        public int time;
        public Transform3D pos;
        public float velocity;
        public float spinRate;
        public void StepDataSet()
        {

        }
    }

    public override void _Ready()
    {
    }

    public void Setup(float Velocity, float Diameter, float Mass, float SpinRate)
    {
        //this.Velocity.X = Velocity;
        SimulationSteps.Add(new StepData());
    }

    public void Setup(float Velocity)
    {
    }

    public void CalculateStep(int numberOfSteps, int timestep)
    {
        int tempTime = SimulationSteps[SimulationSteps.Count].time;
        for (int i = 0; i < numberOfSteps; i++)
        {
            SimulationSteps.Add(new StepData {time = 0});
        }
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        var forward_dir = Basis * Forward;
        GD.Print();
        /*Position += (float)delta * Velocity.X* forward_dir;
		Velocity.Y -= 9.8f*(float)delta;
		Position += new Vector3(0, (float)delta * Velocity.Y,0);*/
    }
}