import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { InjuryHistories } from "./injuryHistories";

@Index("injury_restrictions_pkey", ["id"], { unique: true })
@Index("idx_injury_restrictions_injury_id", ["injuryId"], {})
@Index("idx_injury_restrictions_category", ["restrictedCategory"], {})
@Entity("injury_restrictions", { schema: "public" })
export class InjuryRestrictions {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "injury_id" })
  injuryId: string;

  @Column("enum", {
    name: "restricted_category",
    enum: ["STRENGTH", "CARDIO", "ENDURANCE", "BODY", "STABILITY"],
  })
  restrictedCategory:
    | "STRENGTH"
    | "CARDIO"
    | "ENDURANCE"
    | "BODY"
    | "STABILITY";

  @Column("timestamp without time zone", {
    name: "created_at",
    default: () => "CURRENT_TIMESTAMP",
  })
  createdAt: Date;

  @ManyToOne(
    () => InjuryHistories,
    (injuryHistories) => injuryHistories.injuryRestrictions,
    { onDelete: "CASCADE" }
  )
  @JoinColumn([{ name: "injury_id", referencedColumnName: "id" }])
  injury: InjuryHistories;
}
