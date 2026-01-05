import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToOne, JoinColumn, Index } from "typeorm";
import { Assessment } from "./assessment.entity";
import { Member } from "./member.entity";

@Index("idx_ability_snapshots_assessment_id", ["assessmentId"])
@Index("idx_ability_snapshots_member_id", ["memberId"])
@Index("idx_ability_snapshots_assessed_at", ["assessedAt"])
@Entity("ability_snapshots")
export class AbilitySnapshot {
	@PrimaryGeneratedColumn("uuid")
	id: string;

	@Column({ name: "assessment_id", unique: true })
	assessmentId: string;

	@OneToOne(() => Assessment, (assessment) => assessment.snapshot, {
		onDelete: "CASCADE",
	})
	@JoinColumn({ name: "assessment_id" })
	assessment: Assessment;

	@Column({ name: "member_id" })
	memberId: string;

	@ManyToOne(() => Member, (member) => member.abilitySnapshots, {
		onDelete: "CASCADE",
	})
	@JoinColumn({ name: "member_id" })
	member: Member;

	@Column({ type: "timestamp", name: "assessed_at" })
	assessedAt: Date;

	@Column({ length: 50 })
	version: string;

	@Column({ type: "float", name: "strength_score", nullable: true })
	strengthScore?: number;

	@Column({ type: "float", name: "cardio_score", nullable: true })
	cardioScore?: number;

	@Column({ type: "float", name: "endurance_score", nullable: true })
	enduranceScore?: number;

	@Column({ type: "float", name: "body_score", nullable: true })
	bodyScore?: number;

	@Column({ type: "float", name: "stability_score", nullable: true })
	stabilityScore?: number;

	@Column({ type: "float", name: "total_score" })
	totalScore: number;

	@CreateDateColumn({ name: "created_at" })
	createdAt: Date;
}
