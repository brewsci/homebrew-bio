class Paml < Formula
  # cite Yang_2007: "https://doi.org/10.1093/molbev/msm088"
  desc "Phylogenetic analysis by maximum likelihood"
  homepage "http://abacus.gene.ucl.ac.uk/software/paml.html"
  url "http://abacus.gene.ucl.ac.uk/software/paml4.9g.tgz"
  version "4.9g"
  sha256 "30092007a105324e4fdd5b5a4737098531269839cc561f7bab3acfaf0ea1b3cf"

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
