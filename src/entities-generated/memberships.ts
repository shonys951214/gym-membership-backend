import { Column, Entity, Index, JoinColumn, ManyToOne } from "typeorm";
import { Members } from "./members";

@Index("idx_memberships_expiry_date", ["expiryDate"], {})
@Index("memberships_pkey", ["id"], { unique: true })
@Index("idx_memberships_member_id", ["memberId"], {})
@Index("idx_memberships_status", ["status"], {})
@Entity("memberships", { schema: "public" })
export class Memberships {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("uuid", { name: "member_id" })
  memberId: string;

  @Column("enum", {
    name: "membership_type",
    enum: ["MONTHLY", "QUARTERLY", "YEARLY", "LIFETIME"],
  })
  membershipType: "MONTHLY" | "QUARTERLY" | "YEARLY" | "LIFETIME";

  @Column("date", { name: "purchase_date" })
  purchaseDate: string;

  @Column("date", { name: "expiry_date" })
  expiryDate: string;

  @Column("enum", {
    name: "status",
    enum: ["ACTIVE", "EXPIRED", "SUSPENDED"],
    default: () => "'ACTIVE'",
  })
  status: "ACTIVE" | "EXPIRED" | "SUSPENDED";

  @Column("numeric", { name: "price", precision: 10, scale: 2 })
  price: string;

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

  @ManyToOne(() => Members, (members) => members.memberships, {
    onDelete: "CASCADE",
  })
  @JoinColumn([{ name: "member_id", referencedColumnName: "id" }])
  member: Members;
}
