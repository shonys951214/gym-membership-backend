import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Assessments } from "./assessments";

@Index("idx_assessment_items_assessment_id", ["assessmentId"], {})
@Index("idx_assessment_items_category", ["category"], {})
@Index("assessment_items_pkey", ["id"], { unique: true })
@Entity("assessment_items", { schema: "public" })
export class AssessmentItems {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "assessment_id" })
  assessmentId: string;

  @Column("enum", {
    name: "category",
    enum: ["STRENGTH", "CARDIO", "ENDURANCE", "BODY", "STABILITY"],
  })
  category: "STRENGTH" | "CARDIO" | "ENDURANCE" | "BODY" | "STABILITY";

  @Column("character varying", { name: "name", length: 255 })
  name: string;

  @Column("real", { name: "value", precision: 24 })
  value: number;

  @Column("character varying", { name: "unit", length: 50 })
  unit: string;

  @Column("real", { name: "score", precision: 24 })
  score: number;

  @Column("timestamp without time zone", {
    name: "created_at",
    default: () => "CURRENT_TIMESTAMP",
  })
  createdAt: Date;

  @ManyToOne(() => Assessments, (assessments) => assessments.assessmentItems, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "assessment_id", referencedColumnName: "id" }])
  assessment: Assessments;
}
