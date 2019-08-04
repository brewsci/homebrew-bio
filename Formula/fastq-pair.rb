class FastqPair < Formula
  # cite Edwards_2019: "https://doi.org/10.1101/552885"
  desc "Fast efficient re-pairing of FASTQ files"
  homepage "https://github.com/linsalrob/fastq-pair"
  url "https://github.com/linsalrob/fastq-pair/archive/v1.0.tar.gz"
  sha256 "74fd5bae4d85cc02245ff1b03f31fa3788c50966d829b107076a806ae061da3b"
  head "https://github.com/linsalrob/fastq-pair.git"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match "bucket", shell_output("#{bin}/fastq_pair 2>&1")
  end
end
