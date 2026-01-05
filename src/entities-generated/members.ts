import { Column, Entity, Index, OneToMany } from "typeorm";
import { AbilitySnapshots } from "./abilitySnapshots";
import { Assessments } from "./assessments";
import { InjuryHistories } from "./injuryHistories";
import { Memberships } from "./memberships";
import { PtUsages } from "./ptUsages";

@Index("idx_members_deleted_at", ["deletedAt"], {})
@Index("idx_members_email", ["email"], {})
@Index("members_pkey", ["id"], { unique: true })
@Index("idx_members_status", ["status"], {})
@Entity("members", { schema: "public" })
export class Members {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("character varying", { name: "name", length: 255 })
  name: string;

  @Column("character varying", { name: "phone", length: 50 })
  phone: string;

  @Column("character varying", { name: "email", length: 255 })
  email: string;

  @Column("date", { name: "join_date" })
  joinDate: string;

  @Column("enum", {
    name: "status",
    enum: ["ACTIVE", "INACTIVE", "SUSPENDED"],
    default: () => "'ACTIVE'",
  })
  status: "ACTIVE" | "INACTIVE" | "SUSPENDED";

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

  @OneToMany(
    () => AbilitySnapshots,
    (abilitySnapshots) => abilitySnapshots.member
  )
  abilitySnapshots: AbilitySnapshots[];

  @OneToMany(() => Assessments, (assessments) => assessments.member)
  assessments: Assessments[];

  @OneToMany(() => InjuryHistories, (injuryHistories) => injuryHistories.member)
  injuryHistories: InjuryHistories[];

  @OneToMany(() => Memberships, (memberships) => memberships.member)
  memberships: Memberships[];

  @OneToMany(() => PtUsages, (ptUsages) => ptUsages.member)
  ptUsages: PtUsages[];
}
