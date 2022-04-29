class Tabixpp < Formula
  desc "C++ wrapper to tabix indexer"
  homepage "https://github.com/vcflib/tabixpp"
  url "https://github.com/vcflib/tabixpp.git",
    tag: "v1.1.1", revision: "6c5860e778f11aed98c3a906cace543f3b9f4734"

  depends_on "htslib"

  patch do
    # https://github.com/vcflib/tabixpp/pull/26
    url "https://github.com/vcflib/tabixpp/commit/4cebc981b35c67486e7454064c54cddf547fd58a.patch?full_index=1"
    sha256 "d08f2eb62fb7be5457adb4615c7fbda587993899e8d18a9b8ed0647144c8f3f9"
  end

  def install
    system "make", "install", "HTS_HEADERS=", "HTS_LIB=", "DESTDIR=#{prefix}", "PREFIX="

    prefix.install "test"
  end

  test do
    system opt_bin/"tabix++", prefix/"test/vcf_file.vcf.gz"
  end
end
