class Tmalign < Formula
  # cite Zhang_2005: "https://doi.org/10.1093/nar/gki524"
  desc "Protein structure alignment algorithm based on the TM-score"
  homepage "https://zhanglab.ccmb.med.umich.edu/TM-align/"
  url "https://zhanglab.ccmb.med.umich.edu/TM-align/TMalign.cpp"
  version "20190822"
  sha256 "d5a8f21fc66a8d006b4c2f7e9e609809acdc3a17cb157616809e954d75c73871"
  license "MIT"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-bio"
    sha256 cellar: :any_skip_relocation, catalina:     "3b1b24110784030937f12d3943b57a096f3c88573972597d0bd105f1a9690ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bcdbb8bef4985e3ce2efb7c1fea4e0222db5f7203cacad9d92ff29f2dc0cfb80"
  end

  def install
    # install cpp version
    if OS.mac?
      inreplace "TMalign.cpp" do |s|
        s.gsub! "#include <malloc.h>", ""
      end
    end
    system ENV.cxx, "-O3", "-ffast-math", "-lm", "-o", "TMalign", "TMalign.cpp"
    bin.install "TMalign"
  end

  test do
    assert_match "usage", shell_output("#{bin}/TMalign -h 2>&1")
  end
end
