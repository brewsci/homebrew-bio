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
    sha256 "9baeabcd51652cf9e0c985daaf617162587cdf3c16ec199b47b19d6cbc5e5ab3" => :sierra
    sha256 "fe32ec27cad2f1a61406c1ada23504745090668158e9d61b2f1f5cf23d965eeb" => :x86_64_linux
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
