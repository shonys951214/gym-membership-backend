import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Members } from "./members";

@Index("pt_usages_pkey", ["id"], { unique: true })
@Index("idx_pt_usages_member_id", ["memberId"], {})
@Entity("pt_usages", { schema: "public" })
export class PtUsages {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "member_id" })
  memberId: string;

  @Column("integer", { name: "total_count", default: () => "0" })
  totalCount: number;

  @Column("integer", { name: "remaining_count", default: () => "0" })
  remainingCount: number;

  @Column("integer", { name: "used_count", default: () => "0" })
  usedCount: number;

  @Column("date", { name: "last_used_date", nullable: true })
  lastUsedDate: string | null;

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

  @ManyToOne(() => Members, (members) => members.ptUsages, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "member_id", referencedColumnName: "id" }])
  member: Members;
}
