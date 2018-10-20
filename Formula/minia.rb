class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler based on a de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v3.2.0/minia-v3.2.0-Source.tar.gz"
  sha256 "1e0fca9687002d776490234abe95e9516ff43fa43a16ab41d18807c129c02881"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "4183bbc45311722a4cfecf65b62c107f75bb16dc2405432e5d60083e1334a55c" => :sierra_or_later
    sha256 "72e47109b9109726481d75da6353e243f4b413e1ad4d7377723a0c346f147447" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  needs :cxx11

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DSKIP_DOC=1"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
    # Installing non-libraries to "lib" is discouraged.
    rm lib/"libhdf5.settings"
    # remove test folder as 250MB is too big for bottles
    rm_r prefix/"test"
  end

  test do
    assert_match "options", shell_output("#{bin}/minia")
  end
end
