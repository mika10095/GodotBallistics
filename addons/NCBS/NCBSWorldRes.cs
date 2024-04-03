using Godot;
using System;
[GlobalClass]
public partial class NCBSWorldRes : Resource
{
    [Export]
    public float GravityConstant { get; set; }
    [Export]
    public float AirDensity { get; set; }
    [Export]
    public float SpeedOfSound { get; set; }

    public NCBSWorldRes()
    {
        GravityConstant = 0;
        AirDensity = 0;
        SpeedOfSound = 0;
    }
    public NCBSWorldRes(float gravity_constant, float air_density, float speed_sound)
    {
        GravityConstant = gravity_constant;
        AirDensity = air_density;
        SpeedOfSound = speed_sound;
    }
}
