class Paml < Formula
  # cite Yang_2007: "https://doi.org/10.1093/molbev/msm088"
  desc "Phylogenetic analysis by maximum likelihood"
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.9h.tgz"
  version "4.9h"
  sha256 "623bf6cf4a018a4e7b4dbba189c41d6c0c25fdca3a0ae24703b82965c772edb3"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "a405e3b54cbb5f2a9ad8296c68500d83723a420ba6a3f47cecfad7c459a8a0b4" => :sierra
    sha256 "de947f72f5e61e42f15a75f874daa62161ca6f1a462529c9fdd4fbb47a437b75" => :x86_64_linux
  end

  def install
    # Restore permissions, as some are wrong in the tarball archives
    chmod_R "u+rw", "."

    cd "src" do
      system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
      bin.install %w[baseml basemlg chi2 codeml evolver infinitesites mcmctree pamp yn00]
    end

    pkgshare.install "dat"
    pkgshare.install Dir["*.ctl"]
    doc.install Dir["doc/*"]
    doc.install "examples"
  end

  def caveats
    <<~EOS
      Documentation and examples:
        #{HOMEBREW_PREFIX}/share/doc/paml
      Dat and ctl files:
        #{HOMEBREW_PREFIX}/share/paml
    EOS
  end

  test do
    cp Dir[doc/"examples/DatingSoftBound/*.*"], testpath
    system "#{bin}/infinitesites"
  end
end
