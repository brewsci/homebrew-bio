class Nextgenmap < Formula
  desc "Sensitive aligner for short reads with high mismatch rate"
  homepage "https://github.com/Cibiv/NextGenMap/wiki"
  url "https://github.com/Cibiv/NextGenMap/archive/v0.5.5.tar.gz"
  sha256 "c205e6cb312d2f495106435f10fb446e6fb073dd1474f4f74ab5980ba9803661"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "acdb87a47abc42331556aafa75815511dc6844173973d50ee54854ec90648138" => :sierra
    sha256 "e7af4a31a9ad956bd07b2c324535da4e973b37e67c4c203acdec728a52e45c58" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
    end
    bin.install Dir["bin/ngm-#{version}/ngm*"]
    # Linux - install bundled libOpenCL.so
    # MacOS - comes with OpenCL Framework
    lib.install Dir["bin/ngm-#{version}/opencl/lib/libOpenCL*"] unless OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngm -h 2>&1", 1)
    assert_match "count", shell_output("#{bin}/ngm-utils 2>&1", 1)
  end
end
