class Minia < Formula
  # cite Chikhi_2013: "https://doi.org/10.1186/1748-7188-8-22"
  desc "Short-read assembler based on a de Bruijn graph"
  homepage "http://minia.genouest.org/"
  url "https://github.com/GATB/minia/releases/download/v3.2.1/minia-v3.2.1-Source.tar.gz"
  sha256 "c431915f034bc58887f9a14f6f65be2c83e0faae312ef330c3a11c6ba131162c"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "0aa4268b6671d25ab642c61e5c848708c65385f28424096a2c16e8a25e1882c5" => :sierra
    sha256 "987ae35c73a400c072f82b5e801fc660eb14c5c9c25ac3b82f5df6c7614c2ce7" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "zlib" unless OS.mac?

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
