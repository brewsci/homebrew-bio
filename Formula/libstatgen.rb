class Libstatgen < Formula
  desc "Useful set of classes for creating statistical genetic programs"
  homepage "https://github.com/statgen/libStatGen"
  url "https://github.com/statgen/libStatGen/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "075dcd891409c48d76c0c66186c0cc479bc3cd50bba093e7f318e1d1d19961ff"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/brewsci/bio"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "233ed2d61e2848a3f7107b023726d31bc04acadbfdf8ed8c4ac5e028f6544acf"
    sha256 cellar: :any_skip_relocation, ventura:      "c37d8e369f6fbfb56e1ac300dd40c1243fd26dec20d7afa4a4d46ce9ef6f5019"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ccac0a756beeea2bbce670411a46e4fb9a5a20f690636dd5099638bc9742032f"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "make"
    prefix.install "Makefiles"
    lib.install "libStatGen.a"
    # source header files are symlinks, so install manually
    include.mkdir
    cp Dir["include/*"], include
  end

  test do
    resource "testbam" do
      url "https://github.com/statgen/bamUtil/raw/d751cb1b092fb3211810239d0e4417e0bd9e42ee/test/testFiles/sortedBam1.bam"
      sha256 "5077dc2631c31f304094cc0db2bb0cdd5d69c196d43a9c95cd1e5607aedee198"
    end
    (testpath/"test.cpp").write <<~'EOS'
      #include "SamFile.h"
      #include "Parameters.h"
      #include "BgzfFileType.h"
      #include "SamValidation.h"

      int main(int argc, char *argv[])
      {
          String inFile = "sortedBam1.bam";

          // Determine the sort type for validation based on the parameters.
          SamFile::SortedType sortType = SamFile::COORDINATE;

          // Since we want to accumulate multiple errors, use RETURN rather
          // than throwing exceptions.
          SamFile samIn(ErrorHandler::RETURN);
          // Open the file for reading.
          if(!samIn.OpenForRead(inFile))
          {
              fprintf(stderr, "Failed opening the SAM/BAM file, returning: %d (%s)\n",
                      samIn.GetStatus(),
                      SamStatus::getStatusString(samIn.GetStatus()));
              fprintf(stderr, "%s\n", samIn.GetStatusMessage());
              return(samIn.GetStatus());
          }

          // Set the sorting validation type.
          samIn.setSortedValidation(sortType);

          // Set that statistics should be generated.
          samIn.GenerateStatistics(true);

          // Read the sam header.
          SamFileHeader samHeader;
          if(!samIn.ReadHeader(samHeader))
          {
              fprintf(stderr, "Failed header validation, returning: %d (%s)\n",
                      samIn.GetStatus(),
                      SamStatus::getStatusString(samIn.GetStatus()));
              fprintf(stderr, "%s\n", samIn.GetStatusMessage());
              return(samIn.GetStatus());
          }

          // Read the sam records.
          SamRecord samRecord(ErrorHandler::RETURN);

          // Track the status.
          SamStatus::Status status = SamStatus::SUCCESS;

          // Keep reading records until the end of the file is reached.
          int numValidRecords = 0;
          int numRecords = 0;

          std::map<SamStatus::Status, uint64_t> errorStats;
          std::map<SamValidationError::Type, uint64_t> invalidStats;

          SamValidationErrors invalidSamErrors;

          // Keep reading records from the file until SamFile::ReadRecord
          // indicates to stop (returns false).
          while( (samIn.ReadRecord(samHeader, samRecord)) || (SamStatus::isContinuableStatus(samIn.GetStatus())) )
          {
              ++numRecords;
              if(samIn.GetStatus() == SamStatus::SUCCESS)
              {
                  // Successfully set the record, so check to see if it is valid.
                  // Clear any errors in the list.
                  invalidSamErrors.clear();
                  if(!SamValidator::isValid(samHeader, samRecord, invalidSamErrors))
                  {
                      // The record is not valid.
                      // Update the statistics for all validation errors found in this record.
                      invalidSamErrors.resetErrorIter();
                      const SamValidationError* errorPtr = invalidSamErrors.getNextError();
                      while(errorPtr != NULL)
                      {
                          ++invalidStats[errorPtr->getType()];
                          errorPtr = invalidSamErrors.getNextError();
                      }

                      // If the status is not yet set, set it.
                      if(status == SamStatus::SUCCESS)
                      {
                          status = SamStatus::INVALID;
                      }
                  }
                  else
                  {
                      // Valid record, so increment the counter.
                      ++numValidRecords;
                  }
              }
              else
              {
                  // Error reading the record.
                  // Increment the statistics
                  ++errorStats[samIn.GetStatus()];

                  // If the status is not yet set, set it.
                  if(status == SamStatus::SUCCESS)
                  {
                      status = samIn.GetStatus();
                  }
              }
          }

          if( (samIn.GetStatus() != SamStatus::NO_MORE_RECS) )
          {
              // The last read call had a failure, so report it.
              std::cerr << "Record " << numRecords << ": ";
              std::cerr << std::endl << samIn.GetStatusMessage() << std::endl;

              // Increment the statistics
              ++errorStats[samIn.GetStatus()];

              if(status == SamStatus::SUCCESS)
              {
                  status = samIn.GetStatus();
              }
          }

          fprintf(stderr, "\nNumber of records read = %d\n", numRecords);
          fprintf(stderr, "Number of valid records = %d\n", numValidRecords);

          std::cerr << std::endl;
          if(numRecords != numValidRecords)
          {
              std::cerr << "Error Counts:\n";

              // Loop through the non-validation errors.
              std::map<SamStatus::Status, uint64_t>::iterator statusIter;
              for(statusIter = errorStats.begin(); statusIter != errorStats.end(); statusIter++)
              {
                  std::cerr << "\t" << SamStatus::getStatusString(statusIter->first) << ": "
                            << statusIter->second << std::endl;
              }

              std::map<SamValidationError::Type, uint64_t>::iterator invalidIter;
              for(invalidIter = invalidStats.begin(); invalidIter != invalidStats.end(); invalidIter++)
              {
                  std::cerr << "\t" << SamValidationError::getTypeString(invalidIter->first) << ": "
                            << invalidIter->second << std::endl;
              }

              std::cerr << std::endl;
          }
          samIn.PrintStatistics();

          fprintf(stderr, "Returning: %d (%s)\n", status, SamStatus::getStatusString(status));
          return(status);
      }
    EOS
    resource("testbam").stage testpath
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lStatGen", "-lz"
    test_output = shell_output("./test 2>&1")
    assert_match "TotalBases\t48.00", test_output
    assert_match "BasesInMappedReads\t40.00", test_output
    assert_match "Returning: 0 (SUCCESS)", test_output
  end
end
