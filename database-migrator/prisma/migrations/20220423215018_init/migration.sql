-- CreateEnum
CREATE TYPE "data_source_type" AS ENUM ('ecommerce', 'socialnetwork');

-- CreateEnum
CREATE TYPE "events" AS ENUM ('influencer.favorited', 'profile.accessed', 'tag.searched', 'filter.applied');

-- CreateTable
CREATE TABLE "Example" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "address" TEXT NOT NULL,

    CONSTRAINT "Example_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Benchmark" (
    "id" SERIAL NOT NULL,
    "benchmark" TEXT NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "data" JSON,
    "data_source" "data_source_type" NOT NULL,

    CONSTRAINT "Benchmark_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "InfluencerFacts" (
    "id" SERIAL NOT NULL,
    "followersCount" BIGINT,
    "commentsAvg" INTEGER,
    "likesAvg" INTEGER,
    "obtainedAt" TIMESTAMP(6),
    "influencerId" INTEGER NOT NULL,

    CONSTRAINT "InfluencerFacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Favorite" (
    "id" SERIAL NOT NULL,
    "influencerId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "insertedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(6),

    CONSTRAINT "Favorite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Influencer" (
    "id" SERIAL NOT NULL,
    "account" TEXT NOT NULL,
    "profileUrl" TEXT,
    "usertagsCount" INTEGER,
    "followersCount" BIGINT,
    "commentsAvg" INTEGER,
    "likesAvg" INTEGER,

    CONSTRAINT "Influencer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" SERIAL NOT NULL,
    "organization" TEXT NOT NULL,
    "planId" INTEGER,
    "processed" BOOLEAN,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Plan" (
    "id" SERIAL NOT NULL,
    "plan" TEXT NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "maxBenchmarks" INTEGER NOT NULL DEFAULT 1,
    "maxBrands" INTEGER NOT NULL DEFAULT 10,
    "maxSource" INTEGER NOT NULL DEFAULT 2,
    "hasInfluencers" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Plan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" SERIAL NOT NULL,
    "photoUrl" TEXT,
    "description" TEXT,
    "influencerId" INTEGER,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tag" (
    "id" SERIAL NOT NULL,
    "tag" TEXT NOT NULL,

    CONSTRAINT "Tag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" SERIAL NOT NULL,
    "benchmarkId" INTEGER NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "url" TEXT,
    "insertedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "firebaseId" TEXT NOT NULL,
    "name" TEXT,
    "surname" TEXT,
    "organizationId" INTEGER NOT NULL,
    "email" TEXT NOT NULL,
    "options" JSONB,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" SERIAL NOT NULL,
    "event" "events",
    "meta" JSONB,
    "userId" INTEGER,
    "insertedAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_PostToTag" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Example_email_key" ON "Example"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "_PostToTag_AB_unique" ON "_PostToTag"("A", "B");

-- CreateIndex
CREATE INDEX "_PostToTag_B_index" ON "_PostToTag"("B");

-- AddForeignKey
ALTER TABLE "Benchmark" ADD CONSTRAINT "Benchmark_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "InfluencerFacts" ADD CONSTRAINT "InfluencerFacts_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "Influencer"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_influencerId_fkey" FOREIGN KEY ("influencerId") REFERENCES "Influencer"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_planId_fkey" FOREIGN KEY ("planId") REFERENCES "Plan"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_benchmarkId_fkey" FOREIGN KEY ("benchmarkId") REFERENCES "Benchmark"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "_PostToTag" ADD FOREIGN KEY ("A") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PostToTag" ADD FOREIGN KEY ("B") REFERENCES "Tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;
