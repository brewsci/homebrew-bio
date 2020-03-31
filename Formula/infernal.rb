class Infernal < Formula
  # cite Nawrocki_2009: "https://doi.org/10.1093/bioinformatics/btp157"
  desc "Search DNA databases for RNA structure and sequence similarities"
  homepage "http://eddylab.org/infernal/"
  url "http://eddylab.org/software/infernal/infernal-1.1.3.tar.gz"
  sha256 "3b98a6a3a0e7b01aa077a0caf1e958223c4d8f80a69a4eb602ca59a3475da85e"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    cellar :any_skip_relocation
    sha256 "90dde134e8db249856e3432376d4d5f8658f2a8abc2390beed3030908de03d49" => :catalina
    sha256 "01baed72ace481f680194bec8c1df2e7f90282f8ba731412e92e8dcfc0ed17ad" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    pkgshare.install "tutorial", "matrices"
    doc.install Dir["documentation/*"]
  end

  test do
    assert_match version.to_s,
      shell_output("#{bin}/cmsearch #{pkgshare}/tutorial/minifam.cm #{pkgshare}/tutorial/mrum-tRNAs10.fa")
  end
end
