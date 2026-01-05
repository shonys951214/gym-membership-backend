import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Member } from '../../entities/member.entity';
import { Membership } from '../../entities/membership.entity';
import { MembershipType, MembershipStatus, MemberStatus } from '../../common/enums';
import { PTUsage } from '../../entities/pt-usage.entity';
import { CreateMemberDto } from './dto/create-member.dto';
import { UpdateMemberDto } from './dto/update-member.dto';
import { CreateMembershipDto } from './dto/create-membership.dto';
import { UpdatePTUsageDto } from './dto/update-pt-usage.dto';
import { ErrorCodes } from '../../common/utils/error-codes';

@Injectable()
export class MembersService {
  constructor(
    @InjectRepository(Member)
    private memberRepository: Repository<Member>,
    @InjectRepository(Membership)
    private membershipRepository: Repository<Membership>,
    @InjectRepository(PTUsage)
    private ptUsageRepository: Repository<PTUsage>,
  ) {}

  async findAll(): Promise<Member[]> {
    return this.memberRepository.find({
      relations: ['memberships', 'ptUsages'],
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string): Promise<Member> {
    const member = await this.memberRepository.findOne({
      where: { id },
      relations: ['memberships', 'ptUsages', 'assessments', 'injuries'],
    });

    if (!member) {
      throw new NotFoundException('회원을 찾을 수 없습니다.');
    }

    return member;
  }

  async create(createMemberDto: CreateMemberDto): Promise<Member> {
    const existingMember = await this.memberRepository.findOne({
      where: { email: createMemberDto.email },
    });

    if (existingMember) {
      throw new BadRequestException('이미 등록된 이메일입니다.');
    }

    const member = this.memberRepository.create({
      ...createMemberDto,
      joinDate: new Date(createMemberDto.joinDate),
      status: createMemberDto.status || MemberStatus.ACTIVE,
    });

    return this.memberRepository.save(member);
  }

  async update(id: string, updateMemberDto: UpdateMemberDto): Promise<Member> {
    const member = await this.findOne(id);

    Object.assign(member, updateMemberDto);

    return this.memberRepository.save(member);
  }

  async remove(id: string): Promise<void> {
    const member = await this.findOne(id);
    await this.memberRepository.softDelete(id);
  }

  // 회원권 관리
  async getMembership(memberId: string): Promise<Membership | null> {
    return this.membershipRepository.findOne({
      where: { memberId, status: MembershipStatus.ACTIVE },
      order: { createdAt: 'DESC' },
    });
  }

  async createMembership(
    memberId: string,
    createMembershipDto: CreateMembershipDto,
  ): Promise<Membership> {
    await this.findOne(memberId); // 회원 존재 확인

    const membership = this.membershipRepository.create({
      memberId,
      ...createMembershipDto,
      purchaseDate: new Date(createMembershipDto.purchaseDate),
      expiryDate: new Date(createMembershipDto.expiryDate),
    });

    return this.membershipRepository.save(membership);
  }

  async updateMembership(
    memberId: string,
    membershipId: string,
    updateData: Partial<CreateMembershipDto>,
  ): Promise<Membership> {
    const membership = await this.membershipRepository.findOne({
      where: { id: membershipId, memberId },
    });

    if (!membership) {
      throw new NotFoundException('회원권을 찾을 수 없습니다.');
    }

    Object.assign(membership, updateData);
    if (updateData.purchaseDate) {
      membership.purchaseDate = new Date(updateData.purchaseDate);
    }
    if (updateData.expiryDate) {
      membership.expiryDate = new Date(updateData.expiryDate);
    }

    return this.membershipRepository.save(membership);
  }

  // PT 횟수 관리
  async getPTUsage(memberId: string): Promise<PTUsage | null> {
    return this.ptUsageRepository.findOne({
      where: { memberId },
      order: { createdAt: 'DESC' },
    });
  }

  async createOrUpdatePTUsage(
    memberId: string,
    updatePTUsageDto: UpdatePTUsageDto,
  ): Promise<PTUsage> {
    await this.findOne(memberId); // 회원 존재 확인

    let ptUsage = await this.getPTUsage(memberId);

    if (!ptUsage) {
      ptUsage = this.ptUsageRepository.create({
        memberId,
        totalCount: updatePTUsageDto.totalCount || 0,
        remainingCount: updatePTUsageDto.remainingCount || 0,
        usedCount: updatePTUsageDto.usedCount || 0,
      });
    } else {
      Object.assign(ptUsage, updatePTUsageDto);
      if (updatePTUsageDto.usedCount !== undefined) {
        ptUsage.lastUsedDate = new Date();
      }
    }

		return this.ptUsageRepository.save(ptUsage);
	}

	async deleteMembership(memberId: string, membershipId: string): Promise<void> {
		const membership = await this.membershipRepository.findOne({
			where: { id: membershipId, memberId },
		});

		if (!membership) {
			throw new NotFoundException("회원권을 찾을 수 없습니다.");
		}

		await this.membershipRepository.remove(membership);
	}
}

