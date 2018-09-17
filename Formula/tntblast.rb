class Tntblast < Formula
  # cite Gans_2008: "https://doi.org/10.1093/nar/gkn301"
  desc "Assay specific, hybridization-based, parallel DNA search"
  homepage "https://public.lanl.gov/jgans/tntblast"
  url "https://public.lanl.gov/jgans/tntblast/tntblast-2.04.tar.gz"
  sha256 "28d1ce564fbbd7cf3ac6e755d394c85777ac5c0d5d952553f13695c81e275c49"

  fails_with :clang # needs openmp

  depends_on "gcc" if OS.mac? # # needs openmp

  # error: no match for 'operator==' (operand types are 'std::basic_istream<char>::__istream_type' {aka 'std::basic_istream<char>'} and 'bool')
  fails_with :gcc => "8"

  needs :cxx11

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-openmp"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tntblast -h 2>&1", 1)
  end
end
