using Godot;
using System;
namespace NCBS
{
    [GlobalClass]
    public partial class NCBSBulletRes : Resource
    {
        [Export]
        public float MuzzleVelocity { get; set; }
        [Export]
        public float MuzzleTwist { get; set; }
        [Export]
        public float BulletMass { get; set; }
        [Export]
        public float Diameter { get; set; }
        [Export]
        public float Intertia { get; set; }
        [Export]
        public PackedScene BulletMesh { get; set; }
        [Export]
        public Curve DragCurve { get; set; }

        public NCBSBulletRes()
        {
            MuzzleVelocity = 0f;
            MuzzleTwist = 0f;
            BulletMass = 0f;
            Diameter = 0f;
            Intertia = 0f;
            BulletMesh = null;
            DragCurve = null;
        }
        public NCBSBulletRes(float muzzle_velocity, float muzzle_twist, float bullet_mass, float diameter, float inertia, PackedScene bullet_mesh, Curve drag_curve)
        {
            MuzzleVelocity = muzzle_velocity;
            MuzzleTwist = muzzle_twist;
            BulletMass = bullet_mass;
            Diameter = diameter;
            Intertia = inertia;
            BulletMesh = bullet_mesh;
            DragCurve = drag_curve;
        }
    }
}