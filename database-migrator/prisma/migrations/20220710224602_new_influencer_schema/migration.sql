/*
  Warnings:

  - Added the required column `entityType` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `followingCount` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fullName` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isBusiness` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `isVerified` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `mediaCount` to the `Influencer` table without a default value. This is not possible if the table is not empty.
  - Added the required column `socialMedia` to the `Influencer` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Influencer" ADD COLUMN     "biography" TEXT,
ADD COLUMN     "bornDate" TIMESTAMP(3),
ADD COLUMN     "category" TEXT,
ADD COLUMN     "email" TEXT,
ADD COLUMN     "entityType" TEXT NOT NULL,
ADD COLUMN     "externalUrl" TEXT,
ADD COLUMN     "followingCount" INTEGER NOT NULL,
ADD COLUMN     "fullName" TEXT NOT NULL,
ADD COLUMN     "gender" TEXT,
ADD COLUMN     "isBusiness" BOOLEAN NOT NULL,
ADD COLUMN     "isVerified" BOOLEAN NOT NULL,
ADD COLUMN     "mediaCount" INTEGER NOT NULL,
ADD COLUMN     "mediaSource" TEXT,
ADD COLUMN     "occupation" TEXT,
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "socialMedia" TEXT NOT NULL;
