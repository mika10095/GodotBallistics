using Godot;
using Godot.Collections;
using NCBS;
using System;
using System.Collections.Generic;

namespace NCBS
{

    public partial class NCBSBullet : Node3D
    {
        public bool Initialized = false;
        public Transform3D StartPosition;
        public ulong StartPhysicsStep;

        public ulong StartTime;
        public uint LastDelta;
        public ulong CurrentTime { get { return StartTime + LastDelta; } }

        public NCBSBulletRes Data;
        public NCBSWorldRes WorldRes;

        public Queue<BulletState> Positions = new Queue<BulletState>();
        public BulletState LastPosition;
        public Node3D BulletNode;

        public Transform3D CurrentPosition;
        public Vector3 CurrentVelocity;
        public BulletState CurrentState;
        public NCBSHitRes HitRes = new NCBSHitRes(0,0, null, 0, Transform3D.Identity, new NCBSBulletRes());

        public float getJoules
        {
            get
            {
                float joules = 0.5f * Data.BulletMass * (float)Math.Pow(CurrentState.Velocity.X + CurrentState.Velocity.Z + CurrentState.Velocity.Y, 2);
                GD.Print(joules);
                return joules;
            }

        }

        public override void _Ready()
        {

        }

        public void CalculateStep(uint TimeStepTimeSeconds)
        {

            LastDelta += TimeStepTimeSeconds / 1000;
            CurrentVelocity.Y += WorldRes.GravityConstant / TimeStepTimeSeconds;
            float DragForceNewtons = 0.5f * WorldRes.AirDensity * (float)Math.Pow(Data.Diameter, 2f) * (float)Math.PI * 1 * Data.DragCurve.SampleBaked((CurrentVelocity.X + CurrentVelocity.Z) / WorldRes.SpeedOfSound / 10) * CurrentVelocity.X;
			//GD.Print((CurrentVelocity.X + CurrentVelocity.Z) / WorldRes.SpeedOfSound / 10 + "\t" + Data.DragCurve.Sample((CurrentVelocity.X + CurrentVelocity.Z) / WorldRes.SpeedOfSound / 10));
		    CurrentVelocity.X -= DragForceNewtons / Data.BulletMass / TimeStepTimeSeconds;
            CurrentPosition.Origin = CurrentPosition.Origin + CurrentPosition.Basis.X * CurrentVelocity.X / TimeStepTimeSeconds + this.Transform.Basis.Y * CurrentVelocity.Y / TimeStepTimeSeconds + CurrentPosition.Basis.X * CurrentVelocity.Z / TimeStepTimeSeconds;
            BulletState NewState = new BulletState(LastDelta, CurrentPosition.Origin, CurrentVelocity);
            Positions.Enqueue(NewState);
        }
        public void Clear()
        {
            Initialized = false;
            Positions.Clear();
            BulletNode.QueueFree();
        }

        public NCBSBullet(Transform3D start_position, NCBSBulletRes bullet_data, NCBSWorldRes world_res)
        {
            StartPosition = start_position;
            Data = bullet_data;
            WorldRes = world_res;
        }
    }
    public struct BulletState
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
