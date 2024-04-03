using Godot;
using Godot.Collections;
using NCBS;
using System;
using System.Collections.Generic;

namespace NCBS
{
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
        public NCBSWorldRes WorldRes;
        public Dictionary HitDict;
        public Transform3D RootBasis;
        public override void _Ready()
        {

        }

        public void CalculateStep(uint TimeStepTimeSeconds)
        {

            LastDelta += TimeStepTimeSeconds / 1000;
            CurrentVelocity.Y += WorldRes.GravityConstant / TimeStepTimeSeconds;
            float DragForceNewtons = 0.5f * WorldRes.AirDensity * (float)Math.Pow(Data.Diameter, 2f) * (float)Math.PI * 1 * Data.DragCurve.SampleBaked(CurrentVelocity.X + CurrentVelocity.Z / WorldRes.SpeedOfSound / 10) * CurrentVelocity.X;
            CurrentVelocity.X -= DragForceNewtons / Data.BulletMass / TimeStepTimeSeconds;
            CurrentPosition.Origin = CurrentPosition.Origin + CurrentPosition.Basis.X * CurrentVelocity.X / TimeStepTimeSeconds + this.Transform.Basis.Y * CurrentVelocity.Y / TimeStepTimeSeconds + CurrentPosition.Basis.X * CurrentVelocity.Z / TimeStepTimeSeconds;
            BulletState NewState = new BulletState(LastDelta, CurrentPosition.Origin, CurrentVelocity);
            Positions.Enqueue(NewState);
        }

        public NCBSBullet(Transform3D start_position, NCBSBulletRes bullet_data, NCBSWorldRes world_res)
        {
            StartPosition = start_position;
            Data = bullet_data;
            WorldRes = world_res;

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
}
