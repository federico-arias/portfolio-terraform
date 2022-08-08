-- DropForeignKey
ALTER TABLE "TagsOnInfluencers" DROP CONSTRAINT "TagsOnInfluencers_influencerId_fkey";

-- AddForeignKey
ALTER TABLE "TagsOnInfluencers" ADD CONSTRAINT "TagsOnInfluencers_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "Influencer"("id") ON DELETE CASCADE ON UPDATE CASCADE;
