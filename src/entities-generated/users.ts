import { Column, Entity, Index } from "typeorm";

@Index("idx_users_deleted_at", ["deletedAt"], {})
@Index("idx_users_email", ["email"], {})
@Index("users_email_key", ["email"], { unique: true })
@Index("users_pkey", ["id"], { unique: true })
@Entity("users", { schema: "public" })
export class Users {
  @Column("uuid", {
    primary: true,
    name: "id",
    default: () => "gen_random_uuid()",
  })
  id: string;

  @Column("character varying", { name: "email", unique: true, length: 255 })
  email: string;

  @Column("character varying", { name: "password", length: 255 })
  password: string;

  @Column("character varying", { name: "name", length: 255 })
  name: string;

  @Column("enum", {
    name: "role",
    enum: ["ADMIN", "TRAINER", "MEMBER"],
    default: () => "'MEMBER'",
  })
  role: "ADMIN" | "TRAINER" | "MEMBER";

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
}
