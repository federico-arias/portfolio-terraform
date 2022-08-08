/*
  Warnings:

  - You are about to drop the column `organizationId` on the `Benchmark` table. All the data in the column will be lost.
  - You are about to drop the column `organizationId` on the `Report` table. All the data in the column will be lost.
  - You are about to drop the column `userId` on the `Report` table. All the data in the column will be lost.
  - Changed the type of `type` on the `Benchmark` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Made the column `url` on table `Report` required. This step will fail if there are existing NULL values in that column.

*/
-- CreateEnum
CREATE TYPE "DataSourceType" AS ENUM ('ecommerce', 'socialnetwork');

-- DropForeignKey
ALTER TABLE "Benchmark" DROP CONSTRAINT "Benchmark_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_organizationId_fkey";

-- DropForeignKey
ALTER TABLE "Report" DROP CONSTRAINT "Report_userId_fkey";

-- AlterTable
ALTER TABLE "Benchmark" DROP COLUMN "organizationId",
DROP COLUMN "type",
ADD COLUMN     "type" "DataSourceType" NOT NULL;

-- AlterTable
ALTER TABLE "Influencer" ALTER COLUMN "commentsAvg" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "likesAvg" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "InfluencerFacts" ALTER COLUMN "commentsAvg" SET DATA TYPE DOUBLE PRECISION,
ALTER COLUMN "likesAvg" SET DATA TYPE DOUBLE PRECISION;

-- AlterTable
ALTER TABLE "Payment" ADD COLUMN     "insertedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "Report" DROP COLUMN "organizationId",
DROP COLUMN "userId",
ALTER COLUMN "url" SET NOT NULL;

-- DropEnum
DROP TYPE "data_source_type";
