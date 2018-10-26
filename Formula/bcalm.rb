class Bcalm < Formula
  # cite Chikhi_2016: "https://doi.org/10.1093/bioinformatics/btw279"
  desc "De Bruijn graph compaction in low memory"
  homepage "https://github.com/GATB/bcalm"
  url "https://github.com/GATB/bcalm.git",
      :tag => "v2.2.0",
      :revision => "c8ac60252fa0b2abf511f7363cff7c4342dac2ee"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "6943db20f24e6ae8e904d5cc0c023c9f03fac05ba8e6ff6c45951fd75144c024" => :sierra
    sha256 "c13588ca561bc31e073857f2d27c0afc66e465c03358c52c9711f2af64e54f7c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

  def install
    # Reduce memory usage for CircleCI.
    ENV["MAKEFLAGS"] = "-j4" if ENV["CIRCLECI"]

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install "bcalm"
    end
  end

  test do
    assert_match "options", shell_output("#{bin}/bcalm")
  end
end
