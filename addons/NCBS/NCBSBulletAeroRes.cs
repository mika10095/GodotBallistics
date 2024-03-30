using Godot;
using System;
namespace NCBS
{
    [GlobalClass]
    public partial class NCBSBulletAeroRes : Resource
    {
        [Export]
        public float MuzzleVelocity {get; set;}
        [Export]
        public float MuzzleTwist {get; set;}
        [Export]
        public float BulletMass {get; set;}
        [Export]
        public float Diameter {get; set;}
        [Export]
        public float Intertia {get; set;}
        public NCBSBulletAeroRes() {
            MuzzleVelocity = 1000f;
            MuzzleTwist = 0f;
            BulletMass = 15f;
            Diameter = 10f;
            Intertia = 0f;

        }
        public NCBSBulletAeroRes(float muzzle_velocity, float muzzle_twist, float bullet_mass, float diameter, float inertia)
        {
            MuzzleVelocity = muzzle_velocity;
            MuzzleTwist = muzzle_twist;   
            BulletMass = bullet_mass;   
            Diameter = diameter;   
            Intertia = inertia;     

        }
    }
}