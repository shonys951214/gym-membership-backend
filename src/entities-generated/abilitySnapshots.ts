import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToOne,
} from "typeorm";
import { Assessments } from "./assessments";
import { Members } from "./members";

@Index("idx_ability_snapshots_assessed_at", ["assessedAt"], {})
@Index("idx_ability_snapshots_assessment_id", ["assessmentId"], {})
@Index("ability_snapshots_assessment_id_key", ["assessmentId"], {
  unique: true,
})
@Index("ability_snapshots_pkey", ["id"], { unique: true })
@Index("idx_ability_snapshots_member_id", ["memberId"], {})
@Entity("ability_snapshots", { schema: "public" })
export class AbilitySnapshots {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "assessment_id", unique: true })
  assessmentId: string;

  @Column("uuid", { name: "member_id" })
  memberId: string;

  @Column("timestamp without time zone", { name: "assessed_at" })
  assessedAt: Date;

  @Column("character varying", { name: "version", length: 50 })
  version: string;

  @Column("real", { name: "strength_score", nullable: true, precision: 24 })
  strengthScore: number | null;

  @Column("real", { name: "cardio_score", nullable: true, precision: 24 })
  cardioScore: number | null;

  @Column("real", { name: "endurance_score", nullable: true, precision: 24 })
  enduranceScore: number | null;

  @Column("real", { name: "body_score", nullable: true, precision: 24 })
  bodyScore: number | null;

  @Column("real", { name: "stability_score", nullable: true, precision: 24 })
  stabilityScore: number | null;

  @Column("real", { name: "total_score", precision: 24 })
  totalScore: number;

  @Column("timestamp without time zone", {
    name: "created_at",
    default: () => "CURRENT_TIMESTAMP",
  })
  createdAt: Date;

  @OneToOne(() => Assessments, (assessments) => assessments.abilitySnapshots, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "assessment_id", referencedColumnName: "id" }])
  assessment: Assessments;

  @ManyToOne(() => Members, (members) => members.abilitySnapshots, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "member_id", referencedColumnName: "id" }])
  member: Members;
}
