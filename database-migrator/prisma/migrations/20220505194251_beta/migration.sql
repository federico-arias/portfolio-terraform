/*
  Warnings:

  - You are about to drop the column `data` on the `Benchmark` table. All the data in the column will be lost.
  - You are about to drop the column `data_source` on the `Benchmark` table. All the data in the column will be lost.
  - You are about to alter the column `followersCount` on the `Influencer` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to alter the column `followersCount` on the `InfluencerFacts` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to drop the column `organizationId` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `surname` on the `User` table. All the data in the column will be lost.
  - Added the required column `type` to the `Benchmark` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Benchmark` table without a default value. This is not possible if the table is not empty.
  - Made the column `influencerId` on table `Post` required. This step will fail if there are existing NULL values in that column.
  - Added the required column `userId` to the `Report` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('pending', 'fulfilled');

-- DropForeignKey
ALTER TABLE "Benchmark" DROP CONSTRAINT "Benchmark_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "User" DROP CONSTRAINT "User_organizationId_fkey";

-- AlterTable
ALTER TABLE "Benchmark" DROP COLUMN "data",
DROP COLUMN "data_source",
ADD COLUMN     "dataSources" JSON,
ADD COLUMN     "type" "data_source_type" NOT NULL,
ADD COLUMN     "userId" INTEGER NOT NULL,
ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Influencer" ALTER COLUMN "followersCount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "InfluencerFacts" ALTER COLUMN "followersCount" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "Post" ADD COLUMN     "commentsCount" INTEGER,
ADD COLUMN     "likesCount" INTEGER,
ADD COLUMN     "viewsCount" INTEGER,
ALTER COLUMN "influencerId" SET NOT NULL;

-- AlterTable
ALTER TABLE "Report" ADD COLUMN     "userId" INTEGER NOT NULL,
ALTER COLUMN "organizationId" DROP NOT NULL;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "organizationId",
DROP COLUMN "surname";

-- CreateTable
CREATE TABLE "UserSubscription" (
    "id" SERIAL NOT NULL,
    "userUid" TEXT NOT NULL,
    "subscriptionId" TEXT NOT NULL,

    CONSTRAINT "UserSubscription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" SERIAL NOT NULL,
    "transbankToken" TEXT NOT NULL,
    "status" "PaymentStatus" NOT NULL DEFAULT E'pending',
    "userId" INTEGER NOT NULL,
    "planId" INTEGER NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Payment_transbankToken_key" ON "Payment"("transbankToken");

-- AddForeignKey
ALTER TABLE "Benchmark" ADD CONSTRAINT "Benchmark_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Benchmark" ADD CONSTRAINT "Benchmark_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "Influencer"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_planId_fkey" FOREIGN KEY ("planId") REFERENCES "Plan"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;
