import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
} from "typeorm";
import { AbilitySnapshots } from "./abilitySnapshots";
import { AssessmentItems } from "./assessmentItems";
import { Members } from "./members";

@Index("idx_assessments_assessed_at", ["assessedAt"], {})
@Index("idx_assessments_deleted_at", ["deletedAt"], {})
@Index("assessments_pkey", ["id"], { unique: true })
@Index("idx_assessments_is_initial", ["isInitial"], {})
@Index("idx_assessments_member_id", ["memberId"], {})
@Entity("assessments", { schema: "public" })
export class Assessments {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "member_id" })
  memberId: string;

  @Column("enum", { name: "assessment_type", enum: ["INITIAL", "PERIODIC"] })
  assessmentType: "INITIAL" | "PERIODIC";

  @Column("boolean", { name: "is_initial", default: () => "false" })
  isInitial: boolean;

  @Column("date", { name: "assessed_at" })
  assessedAt: string;

  @Column("text", { name: "trainer_comment", nullable: true })
  trainerComment: string | null;

  @Column("real", { name: "body_weight", nullable: true, precision: 24 })
  bodyWeight: number | null;

  @Column("enum", {
    name: "condition",
    nullable: true,
    enum: ["EXCELLENT", "GOOD", "NORMAL", "POOR"],
  })
  condition: "EXCELLENT" | "GOOD" | "NORMAL" | "POOR" | null;

  @Column("timestamp without time zone", {
    name: "created_at",
    default: () => "CURRENT_TIMESTAMP",
  })
  createdAt: Date;

  @Column("timestamp without time zone", {
    name: "updated_at",
    default: () => "CURRENT_TIMESTAMP",
  })
  updatedAt: Date;

  @Column("timestamp without time zone", { name: "deleted_at", nullable: true })
  deletedAt: Date | null;

  @OneToOne(
    () => AbilitySnapshots,
    (abilitySnapshots) => abilitySnapshots.assessment
  )
  abilitySnapshots: AbilitySnapshots;

  @OneToMany(
    () => AssessmentItems,
    (assessmentItems) => assessmentItems.assessment
  )
  assessmentItems: AssessmentItems[];

  @ManyToOne(() => Members, (members) => members.assessments, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "member_id", referencedColumnName: "id" }])
  member: Members;
}
