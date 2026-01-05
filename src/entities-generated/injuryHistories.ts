import {
  Column,
  Entity,
  Index,
  JoinColumn,
  ManyToOne,
  OneToMany,
} from "typeorm";
import { Members } from "./members";
import { InjuryRestrictions } from "./injuryRestrictions";

@Index("idx_injury_histories_deleted_at", ["deletedAt"], {})
@Index("injury_histories_pkey", ["id"], { unique: true })
@Index("idx_injury_histories_member_id", ["memberId"], {})
@Index("idx_injury_histories_recovery_status", ["recoveryStatus"], {})
@Entity("injury_histories", { schema: "public" })
export class InjuryHistories {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "member_id" })
  memberId: string;

  @Column("character varying", { name: "injury_type", length: 255 })
  injuryType: string;

  @Column("character varying", { name: "body_part", length: 255 })
  bodyPart: string;

  @Column("date", { name: "date" })
  date: string;

  @Column("enum", { name: "severity", enum: ["MILD", "MODERATE", "SEVERE"] })
  severity: "MILD" | "MODERATE" | "SEVERE";

  @Column("text", { name: "description", nullable: true })
  description: string | null;

  @Column("enum", {
    name: "recovery_status",
    enum: ["RECOVERED", "RECOVERING", "CHRONIC"],
  })
  recoveryStatus: "RECOVERED" | "RECOVERING" | "CHRONIC";

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

  @ManyToOne(() => Members, (members) => members.injuryHistories, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "member_id", referencedColumnName: "id" }])
  member: Members;

  @OneToMany(
    () => InjuryRestrictions,
    (injuryRestrictions) => injuryRestrictions.injury
  )
  injuryRestrictions: InjuryRestrictions[];
}
