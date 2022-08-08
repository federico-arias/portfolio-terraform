/*
  Warnings:

  - You are about to drop the `_PostToTag` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[userId,influencerId]` on the table `Favorite` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tag]` on the table `Tag` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "_PostToTag" DROP CONSTRAINT "_PostToTag_A_fkey";

-- DropForeignKey
ALTER TABLE "_PostToTag" DROP CONSTRAINT "_PostToTag_B_fkey";

-- AlterTable
ALTER TABLE "InfluencerFacts" ALTER COLUMN "obtainedAt" SET DEFAULT CURRENT_TIMESTAMP;

-- DropTable
DROP TABLE "_PostToTag";

-- CreateTable
CREATE TABLE "TagsOnInfluencers" (
    "id" SERIAL NOT NULL,
    "influencerId" INTEGER NOT NULL,
    "tagId" INTEGER NOT NULL,

    CONSTRAINT "TagsOnInfluencers_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Favorite_userId_influencerId_key" ON "Favorite"("userId", "influencerId");

-- CreateIndex
CREATE UNIQUE INDEX "Tag_tag_key" ON "Tag"("tag");

-- AddForeignKey
ALTER TABLE "TagsOnInfluencers" ADD CONSTRAINT "TagsOnInfluencers_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "Influencer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TagsOnInfluencers" ADD CONSTRAINT "TagsOnInfluencers_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "Tag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
