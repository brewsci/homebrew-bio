class FastqPair < Formula
  # cite Edwards_2019: "https://doi.org/10.1101/552885"
  desc "Fast efficient re-pairing of FASTQ files"
  homepage "https://github.com/linsalrob/fastq-pair"
  url "https://github.com/linsalrob/fastq-pair/archive/v1.0.tar.gz"
  sha256 "74fd5bae4d85cc02245ff1b03f31fa3788c50966d829b107076a806ae061da3b"
  head "https://github.com/linsalrob/fastq-pair.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b609dc9f34d8be8cbf3fa6d988b2746518120ab4b409278b39a354e9c0d683d" => :sierra
    sha256 "a3874d7eaa8e115e16114b904d55b9cf5119ebc3189c3ed791a050a7dc35aeb7" => :x86_64_linux
  end

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
