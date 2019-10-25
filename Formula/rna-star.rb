class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  # cite "https://doi.org/10.1093/bioinformatics/bts635"

  url "https://github.com/alexdobin/STAR/archive/2.7.3a.tar.gz"
  version "2.7.3a"
  sha256 "de204175351dc5f5ecc40cf458f224617654bdb8e00df55f0bb03a5727bf26f9"
  head "https://github.com/alexdobin/STAR.git"

  # Fix error: 'omp.h' file not found
  depends_on "gcc"
  depends_on "libomp" if OS.mac? # openMP

  def install
    ENV.cxx11
    if OS.mac?
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version_suffix}"
    end
    cd "source" do
      progs = %w[STAR STARlong]
      targets = OS.mac? ? %w[STARforMacStatic STARlongForMacStatic] : progs
      system "make", *targets
      bin.install progs
    end
    pkgshare.install "extras"
    doc.install (buildpath/"doc").children
    mv "RELEASEnotes.md", "NOTES.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/STAR --version")
    assert_match version.to_s, shell_output("#{bin}/STARlong --version")
  end
end
